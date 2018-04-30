//
//  ViewController.swift
//  Collection
//
//  Created by h.yamguchi on 2018/04/22.
//  Copyright © 2018年 h.yamguchi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collection: Collection!
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let newScale = 0.9
//        self.collection.itemSize = self.collection.frame.size.applying(CGAffineTransform(scaleX: CGFloat(newScale), y: CGFloat(newScale)))
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.collection.itemSpacing = 10
    }

}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SliderCell
        cell.slider.tag = indexPath.section
        cell.slider.minimumValue = 0.0
        cell.slider.maximumValue = 1.0
        cell.slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        cell.slider.isContinuous = true
        
        switch indexPath.section {
        case 0:
            cell.slider.value = {
                let scale: CGFloat = self.collection.itemSpacing / 10
                return Float(scale)
            }()
        case 1:
            cell.slider.value = {
                let scale: CGFloat = self.collection.itemSize.width/self.collection.frame.width
                let value: CGFloat = (0.5-scale)*2
                return Float(value)
            }()
        default: break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Item Spacing"
        case 1: return "Item Size"
        default: break
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    // MARK: selector
    @objc func sliderValueChanged(_ sender: UISlider) {
        
        switch sender.tag {
        case 0:
            let newScale = CGFloat(sender.value) * 10
            self.collection.itemSpacing = newScale
        case 1:
            let newScale = 0.5+CGFloat(sender.value)*0.5 // [0.5 - 1.0]
            self.collection.itemSize = self.collection.frame.size.applying(CGAffineTransform(scaleX: CGFloat(newScale), y: CGFloat(newScale)))
        default: break
        }
    }
}

extension ViewController: UITableViewDelegate {
    
    
}

