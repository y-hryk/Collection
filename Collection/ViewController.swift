//
//  ViewController.swift
//  Collection
//
//  Created by h.yamguchi on 2018/04/22.
//  Copyright © 2018年 h.yamguchi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collection: Collection!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newScale = 0.9
        self.collection.itemSize = self.collection.frame.size.applying(CGAffineTransform(scaleX: CGFloat(newScale), y: CGFloat(newScale)))
    }

}

