//
//  AddChannelCell.swift
//  EthanChat
//
//  Created by EthanLin on 2018/3/27.
//  Copyright © 2018年 EthanLin. All rights reserved.
//

import UIKit
import Firebase

class AddChannelCell: UITableViewCell {
    
    var channelRef: DatabaseReference = Database.database().reference().child("channels")
    //channelRefHandle will hold a handle to the reference so you can remove it later on.
    var channelRefHandle: DatabaseHandle?
    
    @IBOutlet weak var addChannelTextField: UITextField!
    
    @IBOutlet weak var addChannelButton: UIButton!
    
    @IBAction func addChannelAction(_ sender: UIButton) {
        //寫入資料到firebase
            //create channel in firebase
        if let channelName = addChannelTextField.text{
            let newChannelRef = channelRef.childByAutoId()
            let channelItem = ["name":channelName]
            if channelItem["name"] != ""{
                newChannelRef.setValue(channelItem)
            }
            
        }
    }
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
