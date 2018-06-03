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
    public var itemSpacing: CGFloat = 0
    public var contentView: UIView?
}

class CollectionLayout: UICollectionViewLayout {
    
    
    fileprivate var animator: CollectionAnimator?
    fileprivate var contentSize: CGSize = .zero
    fileprivate var cacheAttributes = [CollectionAttributes]()
    
    fileprivate var itemSize: CGSize = .zero
    fileprivate var itemSpacing: CGFloat = 0
    fileprivate var isRePrepare: Bool = true
    
    fileprivate var collection: Collection? {
        return self.collectionView?.superview as? Collection
    }
    
    func farceInvalidateLayout() {
        isRePrepare = true
//        cacheAttributes.forEach {
//            $0.contentView?.layer.transform = CATransform3DIdentity
//            $0.transform = CGAffineTransform.identity
//            $0.alpha = 1.0
//        }
        self.invalidateLayout()
    }
    
    func updateScrollPosition() {
//        guard let collection = self.collection else {
//            return
//        }
//        collectionView?.setContentOffset(CGPoint(x: CGFloat(collection.currentIndex) * self.pageWidth(), y: 0), animated: false)
    }
    
    public override class var layoutAttributesClass: AnyClass { return CollectionAttributes.self }
    
    // Calculate the layout in advance
    override func prepare() {
        super.prepare()
        
        if (!isRePrepare) { return }
        guard let collectionView = self.collectionView, let collection = self.collection else {
            return
        }
        
        self.cacheAttributes.removeAll()
        isRePrepare = false
        
        // load settings
        self.itemSize = {
            var size = collection.itemSize
            if size == .zero {
                size = collectionView.frame.size
            }
            return size
        }()
        
        self.animator = collection.animator
        
        self.itemSpacing = {
            if let animatorItemSpacing = animator?.calculateItemSpacing(itemSize: itemSize) {
                return collection.itemSpacing + animatorItemSpacing
            }
            return collection.itemSpacing
        }()
        
        let leadingSpacing = (collection.frame.width - self.itemSize.width) * 0.5
//        let leadingSpacing = CGFloat(10)
        let rows = collectionView.numberOfItems(inSection: 0);
        var cellWidth = self.itemSize.width * CGFloat(rows)
        cellWidth += CGFloat(rows - 1) * self.itemSpacing
        cellWidth += leadingSpacing * 2
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
        
        updateScrollPosition()
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
                attributes.itemSpacing = self.itemSpacing
                layoutAttributes.append(attributes)
                
                self.animator?.applyAnimator(attributes: attributes)
                
            }
        }
        return layoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return self.cacheAttributes[indexPath.row]
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        guard let collection = self.collection else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        }
        
        if !collection.isPageing {
             return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        }
        
        
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
