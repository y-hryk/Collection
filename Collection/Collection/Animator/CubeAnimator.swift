//
//  CubeAnimator.swift
//  Collection
//
//  Created by h.yamguchi on 2018/05/20.
//  Copyright © 2018年 h.yamguchi. All rights reserved.
//

import UIKit

class CubeAnimator: NSObject {

}

extension CubeAnimator: CollectionAnimator {
    
    func applyAnimator(attributes: CollectionAttributes) {
        
        let position = attributes.ratio
        if abs(position) >= 1 {
            attributes.alpha = 0
        } else {
            
            attributes.alpha = 1
            var transform = CATransform3DIdentity
            transform.m34 = -0.002
            transform = CATransform3DRotate(transform, (.pi / 2) * position, 0, 1, 0)
            
            attributes.contentView?.layer.transform = transform
            attributes.contentView?.setAnchorPoint(CGPoint(x: position > 0 ? 0 : 1, y: 0.5))
        }
    }
}
