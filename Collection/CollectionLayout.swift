//
//  CollectionLayout.swift
//  Collection
//
//  Created by h.yamguchi on 2018/04/26.
//  Copyright © 2018年 h.yamguchi. All rights reserved.
//

import UIKit

class CollectionLayout: UICollectionViewLayout {
    
    fileprivate var contentSize: CGSize = .zero
    fileprivate var numberOfSections = 1
    
    // Calculate the layout in advance
    
    
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = self.collectionView else {
            return
        }
        //  calculate cell width
        let cellWidth = collectionView.frame.width
        
        // x position
        var xOffset = [CGFloat]()
        xOffset.append(0)
        
        // y position
    }
    
    override open var collectionViewContentSize: CGSize {
        return self.contentSize
    }
}
