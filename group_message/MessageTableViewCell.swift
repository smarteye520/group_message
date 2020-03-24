//
//  MessageTableViewCell.swift
//  group_message
//
//  Created by SmartEye on 3/20/20.
//  Copyright © 2020 personal. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblSender: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
