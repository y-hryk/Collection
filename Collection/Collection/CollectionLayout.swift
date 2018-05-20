//
//  CollectionLayout.swift
//  Collection
//
//  Created by h.yamguchi on 2018/04/26.
//  Copyright © 2018年 h.yamguchi. All rights reserved.
//

import UIKit

public class CollectionAttributes :UICollectionViewLayoutAttributes {
    
    public var ratio: CGFloat = 0
    public var contentView: UIView?
    
}

class CollectionLayout: UICollectionViewLayout {
    
    
    fileprivate var animator: CollectionAnimator?
    fileprivate var inset: UIEdgeInsets = .zero
    fileprivate var contentSize: CGSize = .zero
    fileprivate var numberOfSections = 1
    fileprivate var cacheAttributes = [CollectionAttributes]()
    
    fileprivate var itemSize: CGSize = .zero
    fileprivate var itemSpacing: CGFloat = 0
    
    fileprivate var collection: Collection? {
        return self.collectionView?.superview as? Collection
    }
    
    
    public override class var layoutAttributesClass: AnyClass { return CollectionAttributes.self }
    
    // Calculate the layout in advance
    override func prepare() {
        super.prepare()
        self.cacheAttributes.removeAll()
//        print("prepare")
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
        
        self.itemSpacing = {
            if let animatorItemSpacing = animator?.calculateItemSpacing(itemSize: itemSize) {
                return collection.itemSpacing + animatorItemSpacing
            }
            return collection.itemSpacing
        }()
        
        self.inset = collection.inset
        self.animator = collection.animator
        
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
    
        var layoutAttributes = [CollectionAttributes]()
        
        
        for (index, attributes) in self.cacheAttributes.enumerated() {
            
            if attributes.frame.intersects(rect) {
                
                if let cell = collectionView?.cellForItem(at: attributes.indexPath)?.contentView  {
                    attributes.contentView = cell
                }
                
                
                attributes.ratio = (attributes.center.x - self.collectionView!.bounds.midX) / (itemSize.width + self.itemSpacing)
                
                if (index == 0) {
//                    print("index \(index): \(offset)")
//                    NSLog("\(attributes.center.x)")
                    print(attributes.ratio)
                }
                
                self.animator?.applyAnimator(attributes: attributes)
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return self.cacheAttributes[indexPath.row]
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
//        return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        
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
