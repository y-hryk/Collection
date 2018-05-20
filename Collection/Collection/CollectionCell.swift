//
//  CollectionCell.swift
//  Collection
//
//  Created by h.yamguchi on 2018/04/23.
//  Copyright © 2018年 h.yamguchi. All rights reserved.
//

import UIKit

class CollectionCell: UICollectionViewCell {
    
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.clear
        return imageView;
    }()
    
    let coverView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        
        
        self.contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        self.contentView.layer.shadowColor = UIColor.black.cgColor
        self.contentView.layer.shadowRadius = 5
        self.contentView.layer.shadowOpacity = 0.75
        self.contentView.layer.shadowOffset = .zero
        
        self.contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        imageView.image = UIImage(named: "sample01")

        coverView.backgroundColor = UIColor.clear
        coverView.layer.borderColor = UIColor.orange.cgColor
        coverView.layer.borderWidth = 2.0
        coverView.frame = imageView.bounds
        self.contentView.addSubview(coverView)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
}
