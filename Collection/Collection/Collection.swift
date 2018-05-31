//
//  Collection.swift
//  Collection
//
//  Created by h.yamguchi on 2018/04/22.
//  Copyright © 2018年 h.yamguchi. All rights reserved.
//

import UIKit

protocol CollectionDataSource: NSObjectProtocol {
    
    func collection(_ collection: Collection, cellForItemAt indexPath: IndexPath) -> CollectionCell
    func numberOfItems(in collection: Collection) -> Int
}

@IBDesignable
class Collection: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    weak var dataSource: CollectionDataSource?
    
    @IBInspectable
    open var isInfinite: Bool = false {
        didSet {
//            self.collectionViewLayout.needsReprepare = true
//            self.collectionView.reloadData()
        }
    }
    
    var itemSize: CGSize = .zero {
        didSet {
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    var itemSpacing: CGFloat = 0 {
        didSet {
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    var animator: CollectionAnimator? {
        didSet {
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    var inset: UIEdgeInsets = .zero {
        didSet {
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    fileprivate var collectionView: UICollectionView = {
//        let flowlayout = UICollectionViewFlowLayout()
//        flowlayout.scrollDirection = .horizontal
        
        let flowlayout = CollectionLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
        //        collectionView.alwaysBounceVertical = true
        //        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = UIColor.clear
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        return collectionView
    }()
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.lightGray.cgColor
        let label = UILabel(frame: self.bounds)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 23)
        label.text = "Collection"
        self.addSubview(label)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: Public
    open func register(_ cellClass: Swift.AnyClass?, forCellWithReuseIdentifier identifier: String) {
        collectionView.register(cellClass, forCellWithReuseIdentifier: identifier)
    }
    
    open func dequeueReusableCell(withReuseIdentifier identifier: String, at indexPath: IndexPath) -> CollectionCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? CollectionCell else {
            return CollectionCell()
        }
        return cell
    }
    
    // MARK: Private
    func setup() {
        
        self.addSubview(self.collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = self.dataSource?.numberOfItems(in: self) {
            return count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = self.dataSource?.collection(self, cellForItemAt: indexPath) {
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        self.collectionView.visibleCells
            .flatMap{ $0 as? CollectionCell }
            .forEach { [weak self] cell in
                self?.animationCell(cell: cell, scrollView: scrollView)
        }
    }
    
    func animationCell(cell: CollectionCell, scrollView: UIScrollView) {
        
//        guard let layout = collectionView.collectionViewLayout as? CollectionLayout else {
//            return
//        }
        
        let offset = scrollView.contentOffset.x;
        let origin = cell.frame.origin.x;
        
//        print(origin)
        let delta: CGFloat = fabs(origin - offset)
        
        var size = self.itemSize
        if size == .zero {
            size = self.frame.size
        }
        
        let scale = 1.0 - (delta / size.width)
        
//        let scaleText = String.self;(format: "%.2f",scale)
//        let scaleText = String()
//        let scaleText = NSString(format: "%.2f", scale)
//        print("tag:[ \(cell.tag) ] \(scaleText)" )
//        let position = (cell.center.x - collectionView.bounds.midX)
//            / self.itemSize.width

    }
}
