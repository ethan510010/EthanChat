//
//  ChatViewController.swift
//  EthanChat
//
//  Created by EthanLin on 2018/3/27.
//  Copyright © 2018年 EthanLin. All rights reserved.
//

import UIKit
import Firebase
import JSQMessagesViewController

class ChatViewController: JSQMessagesViewController {
    
    
    //存儲JSQmessage中
    var messages = [JSQMessage]()
    
    //與Firebase連動
    var channelRef:DatabaseReference?
    lazy var messageRef: DatabaseReference = self.channelRef!.child("messages")
    var newMessageRefhandle: DatabaseHandle?
    
    
    var channel: Channel?{
        didSet{
            self.navigationItem.title = channel?.name
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.senderId = Auth.auth().currentUser?.uid
        
        
        // 这将告诉布局，当没有 avatars 时，avatar 大小为 CGSize.zero
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        // Do any additional setup after loading the view.
        
        observeMessages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //使發送按鈕送消息至Firebase Database
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        //使用 childByAutoId()，创建一个带有惟一键的子引用。
        let itemRef = messageRef.childByAutoId()
        //创建一个字典来存储消息
        let messageItem = ["senderID":senderId!,"senderName":senderDisplayName!,"text":text!]
        //保存新子位置上的值
        itemRef.setValue(messageItem)
        //然后播放常规的 “消息发送” 声音。
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        //完成 "发送" 操作并将输入框重置为空
        finishSendingMessage()
    }
    
    //讓firebase上的message在UI上顯示
    func observeMessages(){
        messageRef = channelRef!.child("messages")
        //将同步限制到最后 25 条消息
        let messageQuery = messageRef.queryLimited(toLast: 25)
        //使用 .ChildAdded 观察已经添加到和即将添加到 messages 位置每个子 item
        newMessageRefhandle = messageQuery.observe(.childAdded, with: { (snapshot) in
            //从 snapshot 中提取messageData
            let messageData = snapshot.value as! Dictionary<String,String>
            print(messageData)
            if let id = messageData["senderID"] as String!, let name = messageData["senderName"] as String!, let text = messageData["text"] as String!, text.characters.count > 0{
                //使用 addMessage(withId:name:text) 方法添加新消息到数据源
                self.addMessage(withId: id, name: name, text: text)
                //通知 JSQMessagesViewController，已经接收了消息
                self.finishReceivingMessage()
            }else{
                print("Error! Could not decode the message")
            }
        })
    }
    
    //檢測用戶何時在輸入
    
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    //JSQMessagesBubbleImageFactory 有创建聊天泡泡的图片方法,。JSQMessagesViewController 甚至还有一个类别提供创建消息泡沫的颜色。
//    使用 outgoingMessagesBubbleImage (:with) 和incomingMessagesBubbleImage(: with)方法,我们可以创建输入输出图像。
    
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    //設置傳出的消息圖像
    func setupOutgoingBubble() -> JSQMessagesBubbleImage{
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }
    
    //設置傳入的消息圖像
    func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }
    
    //設置氣泡圖像
    //在这里检索消息。
   //如果消息是由本地用户发送的，则返回 outgoing image view。 相反，则返回 incoming image view.
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item]
        if message.senderId == senderId{
            return outgoingBubbleImageView
        }else{
            return incomingBubbleImageView
        }
    }
    
    //移除頭像
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    //創建消息
    func addMessage(withId id: String, name: String, text: String) {
        if let message = JSQMessage(senderId: id, displayName: name, text: text) {
            messages.append(message)
        }
    }
    
    //設置氣泡內文本顏色
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.item]
        //如果消息是由本地用户发送的，设置文本颜色为白色。如果不是本地用户发送的，设置文本颜色为黑色。
        if message.senderId == senderId {
            cell.textView?.textColor = UIColor.white
        } else {
            cell.textView?.textColor = UIColor.black
        }
        return cell
    }
    
}
