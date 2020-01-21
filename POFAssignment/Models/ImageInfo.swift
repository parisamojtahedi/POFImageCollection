//
//  ImageInfo.swift
//  POFAssignment
//
//  Created by Parisa on 2020-01-12.
//  Copyright © 2020 Parisa. All rights reserved.
//

import UIKit

// MARK: - Business Model
struct ImageInfo: Codable {
    let albumId: Int
    let id: Int
    let title: String
    let url: String
    let thumbnailUrl: String

    enum CodingKeys: String, CodingKey {
        case albumId = "albumId"
        case id = "id"
        case title = "title"
        case url = "url"
        case thumbnailUrl = "thumbnailUrl"
    }
}

// MARK: - Interactor Model
struct InteractorModel {
    let urlString: String
    var image: UIImage?
    let title: String

    static var empty: InteractorModel {
        return InteractorModel(urlString: "", image: nil, title: "")
    }
}

// MARK: - Output Model
struct OutputModel: Hashable {
    var image: UIImage?
    let title: String
}

struct ImageCollectionOutputModel {
    let imageList: [OutputModel]
}

// MARK: - Presenter Model
struct ImageCollectionPresenterModel {
    let list: [ImageCollectionItemPresenterModel]
}

struct ImageCollectionItemPresenterModel {
    let image: UIImage?
    let title: String
    
    static var empty: ImageCollectionItemPresenterModel {
        return ImageCollectionItemPresenterModel(image: nil, title: "")
    }
}
//MARK: - URLSessionTask Model
struct URLSessionTaskModel {
    let URLSessionTask: URLSessionTask
    var isDownloadInPregress: Bool
}
