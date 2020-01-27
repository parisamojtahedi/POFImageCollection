//
//  ImageCollectionViewCell.swift
//  POFAssignment
//
//  Created by Parisa on 2020-01-12.
//  Copyright © 2020 Parisa. All rights reserved.
//

import UIKit

struct ImageCollectionCellModel {
    let image: UIImage
    let title: String
}
class ImageCollectionViewCell: UICollectionViewCell {
    
    lazy var imageView: UIImageView = {
        var imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        var label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.sizeToFit()
        label.transform = CGAffineTransform(rotationAngle:  -CGFloat(Double.pi / 4))
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func prepareForReuse() {
        imageView.image = nil
        titleLabel.text = nil
    }

    func setup() {
        contentView.addSubview(imageView)
        imageView.addSubview(titleLabel)
        
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 0).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -8).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: imageView.rightAnchor, constant: -8).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: imageView.leftAnchor, constant: 8).isActive = true
    }
}
