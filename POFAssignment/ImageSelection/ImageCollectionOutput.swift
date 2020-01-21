//
//  ImageCollectionOutput.swift
//  POFAssignment
//
//  Created by Parisa on 2020-01-09.
//  Copyright © 2020 Parisa. All rights reserved.
//

import UIKit

protocol ImageCollectionOutput: UIViewController {
    func display(model: ImageCollectionOutputModel)
    func updateUI(at indexPath: IndexPath, with item: OutputModel)
}

class ImageCollectionOutputImp: UIViewController, ImageCollectionOutput {
    weak var interactor: ImageCollectionInteractor?
    private var imageList: [OutputModel] = []
    private let cellIdentifier: String = "ImageCollectionViewCell"
    private let collectionViewLayout = CustomCollectionViewLayout()
    private var indexesToDelete: [Int] = []
    lazy var imageCollectionView: UICollectionView = {
        collectionViewLayout.minimumInteritemSpacing = 8
        collectionViewLayout.scrollDirection = .horizontal
        
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        collectionView.backgroundColor = .lightGray
        return collectionView
    }()
    
    lazy var reorderButton: UIButton = {
        let btn = UIButton(frame: .zero)
        btn.setTitle("Shuffle", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .gray
        btn.titleLabel?.sizeToFit()
        btn.addTarget(self, action: #selector(triggerRandomAction), for: .touchUpInside)
        return btn
    }()
    
    lazy var deleteButton: UIButton = {
        let btn = UIButton(frame: .zero)
        btn.setTitle("Delete", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .gray
        btn.titleLabel?.sizeToFit()
        btn.addTarget(self, action: #selector(deleteEntries), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupSubviews()
        interactor?.onViewDidLoad()
    }
    
    private func setupSubviews() {
        view.addSubview(imageCollectionView)
        view.addSubview(reorderButton)
        view.addSubview(deleteButton)
        
        imageCollectionView.translatesAutoresizingMaskIntoConstraints = false
        imageCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageCollectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        imageCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
        
        reorderButton.translatesAutoresizingMaskIntoConstraints = false
        reorderButton.topAnchor.constraint(equalTo: imageCollectionView.bottomAnchor, constant: 8).isActive = true
        reorderButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        reorderButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        reorderButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05).isActive = true
        
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.bottomAnchor.constraint(equalTo: imageCollectionView.topAnchor, constant: -8).isActive = true
        deleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        deleteButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        deleteButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05).isActive = true
    }
    
    func display(model: ImageCollectionOutputModel) {
        imageList = model.imageList
        DispatchQueue.main.async { [weak self] in
            self?.imageCollectionView.reloadData()
        }
    }
    
    func updateUI(at indexPath: IndexPath, with item: OutputModel) {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            self.imageList[indexPath.row].image = item.image
            if self.imageCollectionView.indexPathsForVisibleItems.contains(indexPath) {
                self.imageCollectionView.reloadItems(at: [IndexPath(row: indexPath.row, section: 0)])            }
        }

    }
    
    @IBAction func triggerRandomAction() {
        recursiveShuffle(listToShuffle: &imageList, count: imageList.count)
        DispatchQueue.main.async { [weak self] in
            self?.imageCollectionView.reloadData()
        }
    }
    
    @IBAction func deleteEntries() {
        indexesToDelete = self.imageList.indices.filter({ self.imageList[$0].title.contains("b") ||  self.imageList[$0].title.contains("d")})
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
             self.imageCollectionView.performBatchUpdates({ () -> Void in
                self.imageList = self.imageList.filter({ !$0.title.contains("b") && !$0.title.contains("d")})
                _ = self.indexesToDelete.map({self.imageCollectionView.deleteItems(at: [IndexPath(row: $0, section: 0)])
                })
             }, completion: nil)
        }
    }
    
    private func recursiveShuffle(listToShuffle: inout [OutputModel], count: Int) {
        if count <= 1 { return }
        let randomNumber = Int.random(in: 0..<imageList.count)
        let temp = listToShuffle.last!
        listToShuffle[listToShuffle.count - 1] = listToShuffle[randomNumber]
        listToShuffle[randomNumber] = temp
        
        recursiveShuffle(listToShuffle: &listToShuffle, count: count - 1)
    }
}
// MARK: - Datasource
extension ImageCollectionOutputImp: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? ImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        if let image = imageList[indexPath.row].image {
            cell.imageView.image = image
        } else {
            cell.imageView.image = nil
            self.interactor?.downloadImage(forItemAtIndex: indexPath.row)
        }
        cell.titleLabel.text = imageList[indexPath.row].title
        cell.setupCellLayer()
        return cell
    }
}
// MARK: - Prefetching API
extension ImageCollectionOutputImp: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach({ self.interactor?.downloadImage(forItemAtIndex: $0.row)})
    }

    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { self.interactor?.cancelDownloadingImage(forItemAtIndex: $0.row) }
    }

}
