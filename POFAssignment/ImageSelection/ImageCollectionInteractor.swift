//
//  ImageCollectionInteractor.swift
//  POFAssignment
//
//  Created by Parisa on 2020-01-09.
//  Copyright © 2020 Parisa. All rights reserved.
//

import UIKit

protocol ImageCollectionInteractorConfig {
    var repository: RepositoryManager { get }
    var tasks: [URLSessionTask] { get }
}
protocol ImageCollectionInteractor: class {
    func onViewDidLoad()
    func downloadImage(forItemAtIndex index: Int)
    func cancelDownloadingImage(forItemAtIndex index: Int)
}
class ImageCollectionInteractorImp: ImageCollectionInteractor {
    private let config: ImageCollectionInteractorConfig
    private let presenter: ImageCollectionPresenter
    private var tasks: [URLSessionTask]
    private var items: [InteractorModel] = []
    
    init(config: ImageCollectionInteractorConfig,
         presenter: ImageCollectionPresenter) {
        self.config = config
        self.presenter = presenter
        self.tasks = config.tasks
    }
    
    func onViewDidLoad() {
        // put a waiting/loading state for presenter here while making a network request
        self.presenter.present(model: ImageCollectionPresenterModel(list: []))
        config.repository.getRepository(type: ImageInfo.self, repoURL: NetworkURL.photoURLString) { [weak self] (imageInfo) in
            guard let `self` = self else { return }
            self.items = imageInfo.map({ InteractorModel.init(urlString: $0.thumbnailUrl,
                                                              image: nil,
                                                              title: $0.title)})
            self.presenter.present(model: self.convertToPresenterModel(self.items))
        }
    }
        
    private func convertToPresenterModel(_ model: [InteractorModel]) -> ImageCollectionPresenterModel {
        let model = model.map({ self.convertToPresenterItemModel($0)})
        return ImageCollectionPresenterModel(list: model)
    }
    
    private func convertToPresenterItemModel(_ model: InteractorModel) -> ImageCollectionItemPresenterModel {
        return ImageCollectionItemPresenterModel(image: model.image, title: model.title)
    }
    
    func downloadImage(forItemAtIndex index: Int) {
        guard let url = URL(string: items[index].urlString) else { return }
        let indexPath = IndexPath(row: index, section: 0)
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let image = CacheManager.imageCache.object(forKey: self.items[index].urlString as NSString) {
                self.presenter.updateUI(at: indexPath, with: ImageCollectionItemPresenterModel(image: image,
                                                                                               title: self.items[index].title))
            } else
                if let data = data, let image = UIImage(data: data) {
                self.items[index].image = image
                CacheManager.imageCache.setObject(image, forKey: self.items[index].urlString as NSString)
                self.presenter.updateUI(at: indexPath, with: ImageCollectionItemPresenterModel(image: image,
                                                                                               title: self.items[index].title))
            }
        }
        task.resume()
        tasks.append(task)
    }
    
    func cancelDownloadingImage(forItemAtIndex index: Int) {
        let url = URL(string: items[index].urlString)
        guard let taskIndex = tasks.firstIndex(where: { $0.originalRequest?.url == url }) else {
            return
        }
        let task = tasks[taskIndex]
        task.cancel()
        tasks.remove(at: taskIndex)
    }
}

