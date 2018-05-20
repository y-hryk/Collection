//
//  CrossFadeAnimator.swift
//  Collection
//
//  Created by h.yamguchi on 2018/05/20.
//  Copyright © 2018年 h.yamguchi. All rights reserved.
//

import UIKit

class CrossFadeAnimator: UIView {

}

extension CrossFadeAnimator: CollectionAnimator {
    
    func applyAnimator(attributes: CollectionAttributes) {
        
        
        let position = attributes.ratio
        
        var transform = CGAffineTransform.identity
        transform.tx = -(attributes.size.width + attributes.itemSpacing) * position
        attributes.transform = transform
        attributes.alpha = 1 - abs(position)
    }
}
