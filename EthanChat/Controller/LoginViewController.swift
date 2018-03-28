//
//  ViewController.swift
//  EthanChat
//
//  Created by EthanLin on 2018/3/27.
//  Copyright © 2018年 EthanLin. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    
    
    
    @IBAction func loginButton(_ sender: UIButton) {
        Auth.auth().signInAnonymously { (user, error) in
            if error != nil{
                print(error!.localizedDescription)
                return
            }else{
               self.performSegue(withIdentifier: "goChannels", sender: nil)
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goChannels"{
            if let nc = segue.destination as? UINavigationController{
                if let channelVC = nc.viewControllers.first as? ChannelTableViewController{
                    
                    channelVC.senderDisplayName = textField.text
//                    print(channelVC.senderDisplayName)
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

