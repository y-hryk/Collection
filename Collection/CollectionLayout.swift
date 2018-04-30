//
//  CollectionLayout.swift
//  Collection
//
//  Created by h.yamguchi on 2018/04/26.
//  Copyright © 2018年 h.yamguchi. All rights reserved.
//

import UIKit

class CollectionAttributes :UICollectionViewLayoutAttributes {
    
}

class CollectionLayout: UICollectionViewLayout {
    
    fileprivate var contentSize: CGSize = .zero
    fileprivate var numberOfSections = 1
    fileprivate var cacheAttributes = [CollectionAttributes]()
    
    fileprivate var itemSize: CGSize = .zero
    fileprivate var leadingSpacing: CGFloat = 0
    fileprivate var itemSpacing: CGFloat = 0
    
    fileprivate var collection: Collection? {
        return self.collectionView?.superview as? Collection
    }
    
    // Calculate the layout in advance
    override func prepare() {
        
        super.prepare()
        self.cacheAttributes.removeAll()
        guard let collectionView = self.collectionView, let collection = self.collection else {
            return
        }
        
        // collectionViewSize contents size
        self.itemSize = {
            var size = collection.itemSize
            if size == .zero {
                size = collectionView.frame.size
            }
            return size
        }()
        
        self.itemSpacing = collection.itemSpacing
        
        
        let leadingSpacing = (collection.frame.width - self.itemSize.width) * 0.5
        let rows = collectionView.numberOfItems(inSection: 0);
        var cellWidth = self.itemSize.width * CGFloat(rows)
        cellWidth += CGFloat(rows - 1) * self.itemSpacing
        cellWidth += leadingSpacing * 2
        self.contentSize = CGSize(width: cellWidth, height: self.itemSize.height)
        
        
        for index in 0 ..< rows {
            
            let indexPath = IndexPath(item: index, section: 0)
            let attributes = CollectionAttributes(forCellWith: indexPath)
        
            let frame = CGRect(x: self.itemSize.width * CGFloat(index) + (CGFloat(index) * self.itemSpacing) + leadingSpacing, y: 0, width: self.itemSize.width, height: self.itemSize.height)
//            let center = CGPoint(x: collection.center.x, y: collection.center.y)
            let center = CGPoint(x: frame.midX, y: collection.center.y)
            attributes.center = center
            attributes.size = self.itemSize
            self.cacheAttributes.append(attributes)
            
//            NSLog("\(NSStringFromCGRect(attributes.frame))")
//            NSLog("\(NSStringFromCGPoint(center))")
        }
    }
    
    override open var collectionViewContentSize: CGSize {
        return self.contentSize
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return false
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes in self.cacheAttributes {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return self.cacheAttributes[indexPath.row]
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        let currentPage = (self.collectionView?.contentOffset.x)! / self.pageWidth()
        
        if fabs(velocity.x) > 0.1 {
            
            let nextPage = velocity.x > 0.0 ? ceil(currentPage) : floor(currentPage)
            return CGPoint(x: nextPage * self.pageWidth(), y: proposedContentOffset.y)
        } else {
            
            return CGPoint(x: round(currentPage) * self.pageWidth(), y: proposedContentOffset.y)
        }
    }
    
    private func pageWidth() -> CGFloat {
        return self.itemSize.width + self.itemSpacing
    }

}
