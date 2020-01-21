//
//  ImageCollectionUseCase.swift
//  POFAssignment
//
//  Created by Parisa on 2020-01-09.
//  Copyright © 2020 Parisa. All rights reserved.
//

import UIKit

struct ImageCollectionUseCaseConfig: ImageCollectionInteractorConfig, ImageCollectionPresenterConfig {
    let repository: RepositoryManager
    let tasks: [URLSessionTask]
}

class ImageCollectionUseCase: UINavigationController {
    var viewController: UIViewController { return output }
    private let output: ImageCollectionOutputImp
    private let presenter: ImageCollectionPresenter
    private let interactor: ImageCollectionInteractor
    private let config: ImageCollectionUseCaseConfig
    
    init(config: ImageCollectionUseCaseConfig) {
        self.config = config
        
        output = ImageCollectionOutputImp()
        
        presenter = ImageCollectionPresenterImp(output: output, config: config)
        
        interactor = ImageCollectionInteractorImp(config: config,
                                                  presenter: presenter)
        output.interactor = interactor
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
