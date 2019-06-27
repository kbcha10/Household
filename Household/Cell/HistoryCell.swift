//
//  HistoryCell.swift
//  Household
//
//  Created by 林香穂 on 2019/06/27.
//  Copyright © 2019 林香穂. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {

    @IBOutlet var memoLabel: UILabel!
    @IBOutlet var countLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
