//
//  ScaleAnimator.swift
//  Collection
//
//  Created by h.yamguchi on 2018/05/20.
//  Copyright © 2018年 h.yamguchi. All rights reserved.
//

import UIKit

class ScaleAnimator: NSObject {

    var minimumScale: CGFloat = 0.80
}

extension ScaleAnimator: CollectionAnimator {
    
    func calculateItemSpacing(itemSize :CGSize) -> CGFloat {
        
        let minimumSpace = itemSize.width - (itemSize.width * minimumScale)
        return -(minimumSpace * 0.5) + 16
    }
    
    func applyAnimator(attributes: CollectionAttributes) {
        let scale = max(1 - (1-minimumScale) * abs(attributes.ratio), minimumScale)
        let transform = CGAffineTransform(scaleX: scale, y: scale)
        attributes.transform = transform
        attributes.alpha = scale
    }
}
