//
//  SliderCell.swift
//  Collection
//
//  Created by h.yamaguchi on 2018/05/23.
//  Copyright © 2018年 h.yamguchi. All rights reserved.
//

import UIKit

class SliderCell: UITableViewCell {

    @IBOutlet weak var slider: UISlider!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
