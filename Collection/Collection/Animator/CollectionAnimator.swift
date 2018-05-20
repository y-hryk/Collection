//
//  CollectionAnimator.swift
//  Collection
//
//  Created by h.yamguchi on 2018/04/30.
//  Copyright © 2018年 h.yamguchi. All rights reserved.
//

import UIKit

protocol CollectionAnimator {
    
    func calculateItemSpacing(itemSize :CGSize) -> CGFloat
    func applyAnimator(attributes :CollectionAttributes)
}

extension CollectionAnimator {

    func calculateItemSpacing(itemSize :CGSize) -> CGFloat {
        return 0.0
    }
    
}
