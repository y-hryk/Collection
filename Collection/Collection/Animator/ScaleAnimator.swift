//
//  ScaleAnimator.swift
//  Collection
//
//  Created by h.yamguchi on 2018/05/20.
//  Copyright © 2018年 h.yamguchi. All rights reserved.
//

import UIKit

class ScaleAnimator: NSObject {

}

extension ScaleAnimator: CollectionAnimator {
    
    func applyAnimator(attributes: CollectionAttributes) {
        let scale = max(1 - (1-0.65) * abs(attributes.ratio), 0.65)
        let transform = CGAffineTransform(scaleX: scale, y: scale)
        attributes.transform = transform
        attributes.alpha = scale
    }
}
