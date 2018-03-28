//
//  ChannelTableViewController.swift
//  EthanChat
//
//  Created by EthanLin on 2018/3/27.
//  Copyright © 2018年 EthanLin. All rights reserved.
//

import UIKit
import Firebase

class ChannelTableViewController: UIViewController {
    
    
    var channelRef: DatabaseReference = Database.database().reference().child("channels")
    //channelRefHandle will hold a handle to the reference so you can remove it later on.
    var channelRefHandle: DatabaseHandle?
    
    //channels空陣列
    var channels = [Channel]()
    
    var senderDisplayName:String?
    
    //讀取資料
    //Use the observe method to listen for new channels being written to the Firebase DB
    func observeChannels(){
        channelRefHandle = channelRef.observe(.childAdded, with: { (snapshot) in
            let channelData = snapshot.value as! [String:AnyObject]
            let id = snapshot.key
            if let name = channelData["name"] as? String, name != ""{
                self.channels.append(Channel(id: id, name: name))
                self.channelTableView.reloadData()
            }else{
                print("Could not decode channel data")
            }
        })
    }
    
    @IBOutlet weak var channelTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        channelTableView.delegate = self
        channelTableView.dataSource = self
       
        
        observeChannels()
    }
    
    deinit{
        if let refHandle = channelRefHandle{
            channelRef.removeObserver(withHandle: refHandle)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//       
//        self.channelTableView.reloadData()
//    }

}
extension ChannelTableViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return channels.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath {
        case [0,0]:
            let addChannelCell = tableView.dequeueReusableCell(withIdentifier: "addChannelCell", for: indexPath) as! AddChannelCell
            return addChannelCell
        default:
            let channelsCell = tableView.dequeueReusableCell(withIdentifier: "showCurrentChannelCell", for: indexPath) as! ShowCurrentChannelCell
            channelsCell.updateUI(model: channels[indexPath.row])
            return channelsCell
        }
    }
    
    
    //delete 資料
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            
            //刪除firebase上的資料
            channelRef.child(channels[indexPath.row].id).removeValue()
            //刪除tableview上的資料
            self.channels.remove(at: indexPath.row)
            DispatchQueue.main.async {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section != 0{
            let selectedChannel = channels[indexPath.row]
            print(selectedChannel.name)
            self.performSegue(withIdentifier: "goChatVC", sender: selectedChannel)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goChatVC"{
            if let chatVC = segue.destination as? ChatViewController{
                print("ok")
                if let channel = sender as? Channel{
                    
                    chatVC.senderDisplayName = senderDisplayName
                    print(channel.name)
                    chatVC.channel = channel
                    chatVC.channelRef = channelRef.child(channel.id)
                }
            }
        }
    }
    
}
