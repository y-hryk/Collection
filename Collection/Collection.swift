//
//  Collection.swift
//  Collection
//
//  Created by h.yamguchi on 2018/04/22.
//  Copyright © 2018年 h.yamguchi. All rights reserved.
//

import UIKit

@IBDesignable
class Collection: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var itemSize: CGSize = .zero {
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
        collectionView.backgroundColor = UIColor.red
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView.register(CollectionCell.self, forCellWithReuseIdentifier: "CollectionCell")
        return collectionView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
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
        return 5;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as? CollectionCell else {
            return CollectionCell()
        }
        cell.backgroundColor = UIColor.orange
        return cell
    }
}
