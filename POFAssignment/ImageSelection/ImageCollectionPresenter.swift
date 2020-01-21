//
//  ImageCollectionPresenter.swift
//  POFAssignment
//
//  Created by Parisa on 2020-01-09.
//  Copyright © 2020 Parisa. All rights reserved.
//

import UIKit

protocol ImageCollectionPresenterConfig {
    // To be implemented - opportunity to pass application theme or anything regarding view displaying
}


protocol ImageCollectionPresenter {
    func present(model: ImageCollectionPresenterModel)
    func updateUI(at indexPath: IndexPath, with item: ImageCollectionItemPresenterModel)
}

class ImageCollectionPresenterImp: ImageCollectionPresenter {
    private let output: ImageCollectionOutput
    var model: ImageCollectionPresenterModel?
    
    init(output: ImageCollectionOutput,
         config: ImageCollectionPresenterConfig) {
        self.output = output
    }
    
    func present(model: ImageCollectionPresenterModel) {
        self.model = model
        let outputModels = model.list.map({ self.convertToOutputModel(model: $0)})
        output.display(model: ImageCollectionOutputModel(imageList: outputModels))
    }
    
    func updateUI(at indexPath: IndexPath, with item: ImageCollectionItemPresenterModel) {
        output.updateUI(at: indexPath, with: OutputModel(image: item.image, title: item.title))
    }
    private func convertToOutputModel(model: ImageCollectionItemPresenterModel) -> OutputModel {
        return OutputModel(image: model.image, title: model.title)
    }
}
