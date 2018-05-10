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
    
    fileprivate var inset: UIEdgeInsets = .zero
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
        print("prepare")
        guard let collectionView = self.collectionView, let collection = self.collection else {
            return
        }
        
        // load settings
        self.itemSize = {
            var size = collection.itemSize
            if size == .zero {
                size = collectionView.frame.size
            }
            return size
        }()
        self.inset = collection.inset
        self.itemSpacing = collection.itemSpacing
        
        let leadingSpacing = (collection.frame.width - self.itemSize.width) * 0.5
//        let leadingSpacing = CGFloat(10)
        let rows = collectionView.numberOfItems(inSection: 0);
        var cellWidth = self.itemSize.width * CGFloat(rows)
        cellWidth += CGFloat(rows - 1) * self.itemSpacing
        cellWidth += leadingSpacing * 2
//        cellWidth += self.inset.left
//        cellWidth += self.inset.right
        self.contentSize = CGSize(width: cellWidth, height: self.itemSize.height)
        
        
        for index in 0 ..< rows {
            
            let indexPath = IndexPath(item: index, section: 0)
            let attributes = CollectionAttributes(forCellWith: indexPath)

            
            var frame = CGRect(x: self.itemSize.width * CGFloat(index) + (CGFloat(index) * self.itemSpacing)
                , y: 0, width: self.itemSize.width, height: self.itemSize.height)
            
            frame.origin.x += leadingSpacing
//            frame.origin.x += self.inset.left
            
//            let frame = CGRect(x: self.itemSize.width * CGFloat(index) + (CGFloat(index) * self.itemSpacing) + leadingSpacing, y: 0, width: self.itemSize.width, height: self.itemSize.height)
//            let center = CGPoint(x: collection.center.x, y: collection.center.y)
//            let center = CGPoint(x: frame.midX, y: collection.center.y)
//            attributes.center = center
            attributes.frame = frame
            attributes.center.y = collection.center.y
            
//            attributes.size = self.itemSize
            self.cacheAttributes.append(attributes)
            
//            NSLog("\(NSStringFromCGRect(attributes.frame))")
//            NSLog("\(NSStringFromCGPoint(center))")
        }
    }
    
    override open var collectionViewContentSize: CGSize {
        return self.contentSize
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        
        for (index, attributes) in self.cacheAttributes.enumerated() {
            if attributes.frame.intersects(rect) {
//                if (index == 0
//                    || index == 1
//                    ) {
//                    NSLog("\(attributes.center.x)")
                    let offset: CGFloat = fabs(attributes.center.x - self.collectionView!.bounds.midX) / (itemSize.width + self.itemSpacing)
                    let scale = max(1 - (1-0.65) * abs(offset), 0.65)
                    //            print("position \(position)")
                    let transform = CGAffineTransform(scaleX: scale, y: scale)
//                    attributes.transform = transform
//                    attributes.alpha = scale
                
                var transform3D = CATransform3DIdentity
                transform3D.m34 = -0.002
                
                let diff = max(1 - (1-0.65) * abs(offset), 0.65)
                attributes.transform3D = CATransform3DRotate(transform3D, 180 * .pi / 180, 0, 1, 0)
                
                
//                    NSLog("\(scale)")
//                    NSLog("\(self.collectionView!.bounds.midX)")
//                }
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
