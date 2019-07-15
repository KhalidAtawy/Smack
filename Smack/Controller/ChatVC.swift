//
//  ChatVC.swift
//  Smack
//
//  Created by Khalid Saleh Elatawy on 7/6/19.
//  Copyright © 2019 Khalid Saleh Elatawy. All rights reserved.
//

import UIKit

class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    

    //Outlets
    
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var channelNameLbl: UILabel!
    @IBOutlet weak var messageTxtBox: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendBtn: UIButton!
    
    //Variables
    var isTyping = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        //handle the keyboard and dismissing it
        view.bindToKeyboard()
        let tap = UITapGestureRecognizer(target: self, action: #selector(ChatVC.handletap))
        view.addGestureRecognizer(tap)
        
        //cell size
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        
        sendBtn.isHidden = true
        
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer((self.revealViewController()?.panGestureRecognizer())!)
        self.view.addGestureRecognizer((self.revealViewController()?.tapGestureRecognizer())!)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.channelSelected(_:)), name: NOTIF_CHANNEL_SELECTED, object: nil)
        

        SocketService.instance.getMessage { (success) in
            if success {
                self.tableView.reloadData()
                self.scrollToLastMsg(tableView: self.tableView)
            }
        }
        
        
        
        if AuthService.instance.isLoggedIn {
            AuthService.instance.findUserByEmail(completion: { (success) in
                   NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
            })
            }
        MessageService.instance.findAllChannel { (success) in
            
        }
    }
    
    
    func scrollToLastMsg(tableView : UITableView){
        if MessageService.instance.messages.count > 0 {
            let endIndex = IndexPath(row: MessageService.instance.messages.count - 1, section: 0)
            tableView.scrollToRow(at: endIndex, at: .bottom, animated: false)
        }
    }
    
    @objc func userDataDidChange(_ notif: Notification) {
        if AuthService.instance.isLoggedIn {
            onLoginGetMessages()
            
        } else {
            channelNameLbl.text = "Please Log In"
            tableView.reloadData()
        }
    }

    
    @objc func channelSelected (_ notif: Notification){
        updateWithChannel()
    }
    
    @objc func handletap() {
        view.endEditing(true)
    }
    
    func updateWithChannel() {
        let channelName = MessageService.instance.selectedChannel?.channelTitle ?? ""
        channelNameLbl.text = "#\(channelName)"
        getMessages()
    }
    
    @IBAction func messageBoxEditing(_ sender: Any) {
        if messageTxtBox.text == "" {
            isTyping = false
            sendBtn.isHidden = true
        } else {
            if isTyping == false {
                sendBtn.isHidden = false
            }
            isTyping = true
        }
        
    }
    
    
    @IBAction func sendMsgPressed(_ sender: Any) {
        if AuthService.instance.isLoggedIn && messageTxtBox.text != "" {
            guard let channelId = MessageService.instance.selectedChannel?.id else {return}
            guard let message = messageTxtBox.text else {return}
            
            SocketService.instance.addMessage(messageBody: message, userId: UserDataService.instance.id, channelId: channelId) { (success) in
                if success {
                    self.messageTxtBox.text = ""
                    self.sendBtn.isHidden = true
                   // self.view.endEditing(true)
                   // self.messageTxtBox.resignFirstResponder()
                }
            }
        }
    }
    
    
    func onLoginGetMessages() {
        MessageService.instance.findAllChannel { (success) in
            if success {
                if MessageService.instance.channels.count > 0 {
                    MessageService.instance.selectedChannel = MessageService.instance.channels[0]
                    self.updateWithChannel()
                } else {
                    self.channelNameLbl.text = "No channels yet!"
                }
            }
        }
    }
    
    
    func getMessages() {
        guard let channelId = MessageService.instance.selectedChannel?.id else {return}
        MessageService.instance.findAllMessageForChannel(channelId: channelId) { (success) in
            if success {
                self.tableView.reloadData()
                self.scrollToLastMsg(tableView: self.tableView)
            }
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as? MessageCell {
            let message = MessageService.instance.messages[indexPath.row]
            cell.configureCell(message: message)
            return cell
        } else {
            return UITableViewCell()
        }
    }

}
    
