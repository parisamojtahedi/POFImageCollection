//
//  CustomCollectionViewLayout.swift
//  POFAssignment
//
//  Created by Parisa on 2020-01-18.
//  Copyright © 2020 Parisa. All rights reserved.
//

import UIKit

final class CustomCollectionViewLayout: UICollectionViewFlowLayout {
    fileprivate var updateIndexPaths: [IndexPath] = []

    
//    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        let attribute = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath)
//        attribute?.transform = CGAffineTransform(scaleX: 2, y: 2)
//        attribute?.alpha = 0.0
//        return attribute
//    }
}
