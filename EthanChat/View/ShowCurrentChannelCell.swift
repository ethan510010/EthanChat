//
//  ShowCurrentChannelCell.swift
//  EthanChat
//
//  Created by EthanLin on 2018/3/27.
//  Copyright © 2018年 EthanLin. All rights reserved.
//

import UIKit

class ShowCurrentChannelCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateUI(model:Channel){
        self.textLabel?.text = model.name
    }

}
