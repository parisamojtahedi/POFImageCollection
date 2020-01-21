//
//  CustomCollectionViewLayout.swift
//  POFAssignment
//
//  Created by Parisa on 2020-01-18.
//  Copyright © 2020 Parisa. All rights reserved.
//

import UIKit

final class CustomCollectionViewLayout: UICollectionViewFlowLayout {
    var deletedItemsToAnimate: [NSIndexPath] = []

    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attribute = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath)
        if deletedItemsToAnimate.contains(itemIndexPath as NSIndexPath){
            attribute?.transform = CGAffineTransform(scaleX: 2, y: 2)
            attribute?.alpha = 0
        }
        return attribute
    }
    
    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        super.prepare(forCollectionViewUpdates: updateItems)
        for updateItem in updateItems{
            switch updateItem.updateAction{
            case .delete:
                deletedItemsToAnimate.append(updateItem.indexPathBeforeUpdate! as NSIndexPath)
            default: break
            }
        }
    }
    
    override func finalizeCollectionViewUpdates() {
        super.finalizeCollectionViewUpdates()
        deletedItemsToAnimate.removeAll()
    }
}
