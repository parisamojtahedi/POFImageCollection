//
//  CustomCollectionViewLayout.swift
//  POFAssignment
//
//  Created by Parisa on 2020-01-18.
//  Copyright © 2020 Parisa. All rights reserved.
//

import UIKit

final class CustomCollectionViewLayout: UICollectionViewLayout {
    var deletedItemsToAnimate: [NSIndexPath] = []
    var cachedAttributes: [UICollectionViewLayoutAttributes] = []
    var itemWidth: CGFloat = 50
    var spacing: CGFloat = 10
    var height: CGFloat = 0
    var numberOfItems = 0
    
    override var collectionViewContentSize: CGSize {
        // This layout only supports one section
        return CGSize(width: CGFloat(self.numberOfItems) * (self.itemWidth + self.spacing),
                      height: height)
    }
    
    override func prepare() {
        super.prepare()
        self.height = (self.collectionView?.bounds.height ?? 0) * 0.5
        self.numberOfItems = self.collectionView?.numberOfItems(inSection: 0) ?? 0
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
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes: [UICollectionViewLayoutAttributes] = (0..<self.numberOfItems).compactMap {
            let indexPath = IndexPath(item: $0, section: 0)
            let frame = self.frame(for: indexPath)
            if !frame.intersects(rect) {
                return nil
            }
            return self.layoutAttributesForItem(at: indexPath)
        }
        return attributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = self.frame(for: indexPath)
        cachedAttributes.append(attributes)
        return attributes
    }
    
    private func frame(for indexPath: IndexPath) -> CGRect {
        return CGRect(
            x: CGFloat(indexPath.item) * (self.itemWidth + self.spacing),
            y: height / 2,
            width: itemWidth,
            height: height)
    }
    
    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attribute = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath)
        if deletedItemsToAnimate.contains(itemIndexPath as NSIndexPath){
            attribute?.transform = CGAffineTransform(scaleX: 2, y: 2)
            attribute?.alpha = 0
        }
        return attribute
    }
    
    override func finalizeCollectionViewUpdates() {
        super.finalizeCollectionViewUpdates()
        deletedItemsToAnimate.removeAll()
    }
}
