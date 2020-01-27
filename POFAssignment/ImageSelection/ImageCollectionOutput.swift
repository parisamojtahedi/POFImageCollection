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
        
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        collectionView.backgroundColor = .lightGray
        return collectionView
    }()
    
    lazy var shuffleButton: UIButton = {
        let btn = UIButton(frame: .zero)
        btn.setTitle("Shuffle", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .gray
        btn.titleLabel?.sizeToFit()
        btn.addTarget(self, action: #selector(triggerShuffle), for: .touchUpInside)
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
        view.addSubview(shuffleButton)
        view.addSubview(deleteButton)
        
        imageCollectionView.translatesAutoresizingMaskIntoConstraints = false
        imageCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageCollectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        imageCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2).isActive = true
        
        shuffleButton.translatesAutoresizingMaskIntoConstraints = false
        shuffleButton.topAnchor.constraint(equalTo: imageCollectionView.bottomAnchor, constant: 16).isActive = true
        shuffleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        shuffleButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        shuffleButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05).isActive = true
        
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.bottomAnchor.constraint(equalTo: imageCollectionView.topAnchor, constant: -16).isActive = true
        deleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        deleteButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        deleteButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05).isActive = true
    }
    
    //MARK: - update UI
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
                self.imageCollectionView.reloadItems(at: [IndexPath(row: indexPath.row, section: 0)])
            }
        }

    }
    
    @IBAction func triggerShuffle() {
        var result: [OutputModel] = []
        DispatchQueue.global().async { [weak self] in
            guard let `self` = self else { return }
            self.shuffle(start: 0, end: self.imageList.count - 1, result: &result)
            self.imageList = result
            DispatchQueue.main.async {
                self.imageCollectionView.reloadData()
            }
        }
        
    }

    // MARK: - Recursive shuffle
    private func shuffle(start: Int, end: Int, result: inout [OutputModel]) {
        if start > end { return }
        let randomNumber = Int.random(in: start...end)
        result.append(imageList[randomNumber])
        shuffle(start: start, end: randomNumber - 1, result: &result)
        shuffle(start: randomNumber + 1, end: end, result: &result)
        
    }
    
    // MARK: - Delete entries
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
            cell.imageView.image = image.rounded.shadowAdded
        } else {
            cell.imageView.image = nil
            self.interactor?.downloadImage(forItemAtIndex: indexPath.row)
        }
        cell.titleLabel.text = imageList[indexPath.row].title
        cell.setup()
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
