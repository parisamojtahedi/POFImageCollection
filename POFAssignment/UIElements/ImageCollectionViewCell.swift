//
//  ImageCollectionViewCell.swift
//  POFAssignment
//
//  Created by Parisa on 2020-01-12.
//  Copyright © 2020 Parisa. All rights reserved.
//

import UIKit

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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        contentView.backgroundColor = .white
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0).isActive = true
        imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
    }
    
    func setupCellLayer() {
        self.contentView.layer.cornerRadius = 10.0
        self.contentView.layer.borderWidth = 5.0
        self.contentView.layer.borderColor = UIColor.white.cgColor
        self.contentView.layer.masksToBounds = true
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 5.0
        self.layer.shadowOpacity = 1
        self.layer.masksToBounds = false

    }
}
