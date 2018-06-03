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
    
    fileprivate let factor: CGFloat = 4.0
    fileprivate var contentWidth: CGFloat = 0.0
    weak var dataSource: CollectionDataSource?
    
    @IBInspectable
    open var isInfinite: Bool = false {
        didSet {
//            self.collectionViewLayout.needsReprepare = true
//            self.collectionView.reloadData()
            
            self.flowlayout.farceInvalidateLayout()
        }
    }
    
    var currentIndex: Int = 0
    
    var isPageing: Bool = true {
        didSet {
            self.flowlayout.farceInvalidateLayout()
        }
    }
    
    var flowlayout = CollectionLayout()
    
    var itemSize: CGSize = .zero {
        didSet {
            self.flowlayout.farceInvalidateLayout()
        }
    }
    
    var itemSpacing: CGFloat = 0 {
        didSet {
            self.flowlayout.farceInvalidateLayout()
        }
    }
    
    var animator: CollectionAnimator? {
        didSet {
            self.flowlayout.farceInvalidateLayout()
            self.collectionView.reloadData()
        }
    }
    
    fileprivate var numberOfItems: Int {
        get {
            if let count = self.dataSource?.numberOfItems(in: self) {
                return count
            }
            return 0
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
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
        
        collectionView.collectionViewLayout = flowlayout
        
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
        guard let _ = self.dataSource else {
            return 0
        }
//        print(Int(Int16.max) / numberOfItems)
        return isInfinite ? Int(Int16.max) / 4 : numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let _indexPath = IndexPath(item: indexPath.row, section: indexPath.section)
        
        if let cell = self.dataSource?.collection(self, cellForItemAt: _indexPath) {
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
//        let currentIndex = Int(scrollView.contentOffset.x / itemSize.width)
//        self.currentIndex = currentIndex
//        print(self.currentIndex)
    }
    
    
}
