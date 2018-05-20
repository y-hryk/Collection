//
//  UIView+AnchorPoint.swift
//  Collection
//
//  Created by h.yamguchi on 2018/05/20.
//  Copyright © 2018年 h.yamguchi. All rights reserved.
//

import UIKit

extension UIView {
    func setAnchorPoint(_ anchorPoint: CGPoint = CGPoint(x: 0.5, y: 0.5)) {
        var newPoint = CGPoint(x: bounds.size.width * anchorPoint.x, y: bounds.size.height * anchorPoint.y)
        var oldPoint = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y)
        
        newPoint = newPoint.applying(transform)
        oldPoint = oldPoint.applying(transform)
        
        var position = layer.position
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        layer.position    = position
        layer.anchorPoint = anchorPoint
    }
}
