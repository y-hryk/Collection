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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let newScale = 0.9
//        self.collection.itemSize = self.collection.frame.size.applying(CGAffineTransform(scaleX: CGFloat(newScale), y: CGFloat(newScale)))
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
//        self.collection.itemSpacing = -50
//        self.collection.itemSpacing = 0
        self.collection.animator = CrossFadeAnimator()
        self.collection.dataSource = self
        
        
        self.collection.register(CollectionCell.self, forCellWithReuseIdentifier: "CollectionCell")
        
//        self.collection.inset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
//        self.collection.itemSize = CGSize(width: self.collection.frame.width - 10
//            , height: self.collection.frame.height)
//        self.collection.itemSize = CGSize(width: 180, height: 180)
        
//        let transform = CGAffineTransform(scaleX: 0.6, y: 0.75)
//        self.collection.itemSize = self.collection.frame.size.applying(transform)
        
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.register(UINib(nibName: "SliderCell", bundle: nil), forCellReuseIdentifier: "SliderCell")
    }

    
}

extension ViewController: CollectionDataSource {
    func collection(_ collection: Collection, cellForItemAt indexPath: IndexPath) -> CollectionCell {
        
        let cell = collection.dequeueReusableCell(withReuseIdentifier: "CollectionCell", at: indexPath)
        cell.imageView.image = UIImage(named: "sample0\(indexPath.row + 1)")

        
        return cell
    }
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0: fallthrough
        case 1:
            return 1
        case 2:
            return 3
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SliderCell") as! SliderCell
            cell.slider.tag = indexPath.section
            cell.slider.minimumValue = 0.0
            cell.slider.maximumValue = 1.0
            cell.slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
            cell.slider.isContinuous = true
            cell.slider.value = {
                let scale: CGFloat = self.collection.itemSpacing / 10
                return Float(scale)
            }()
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SliderCell") as! SliderCell
            cell.slider.tag = indexPath.section
            cell.slider.minimumValue = 0.0
            cell.slider.maximumValue = 1.0
            cell.slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
            cell.slider.isContinuous = true
            cell.slider.value = {
                let scale: CGFloat = self.collection.itemSize.width/self.collection.frame.width
                let value: CGFloat = (0.5-scale)*2
                return Float(value)
            }()
            return cell
        case 2:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            
            switch indexPath.row {
            case 0:
                cell?.textLabel?.text = "fade"
                return cell!
            case 1:
                cell?.textLabel?.text = "scale"
                return cell!
            case 2:
                cell?.textLabel?.text = "cube"
                return cell!
            default: break
            }
        default: break
        }
        
        return UITableViewCell()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            
            switch indexPath.row {
            case 0:
                self.collection.animator = CrossFadeAnimator()
            case 1:
                self.collection.animator = ScaleAnimator()
            case 2:
                self.collection.animator = CubeAnimator()
            default: break
            }
            
        }
    }
    
}

