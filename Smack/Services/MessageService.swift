//
//  MessageService.swift
//  Smack
//
//  Created by Khalid Saleh Elatawy on 7/14/19.
//  Copyright © 2019 Khalid Saleh Elatawy. All rights reserved.
//

import Foundation

import Foundation
import Alamofire
import SwiftyJSON

class MessageService {
    
    static let instance = MessageService()
    
    var channels = [Channel]()
    var messages = [Message]()
    var selectedChannel : Channel?
    
    func findAllChannel(completion: @escaping CompletionHandler) {
        
        Alamofire.request(URL_GET_CHANNELS, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else { return }
                if let json = try! JSON(data: data).array {
                    for item in json {
                        let name = item["name"].stringValue
                        let channelDescription = item["description"].stringValue
                        let id = item["_id"].stringValue
                        let channel = Channel(channelTitle: name, channelDescription: channelDescription, id: id)
                        self.channels.append(channel)
                    }
                    print("you should stop user input in MessageService till its done----\(self.channels[0].channelTitle)")
                    NotificationCenter.default.post(name: NOTIF_CHANNELS_LOADED, object: nil)
                    completion(true)
                }
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
        
    }
    
    func findAllMessageForChannel(channelId: String, completion: @escaping CompletionHandler){
        Alamofire.request("\(URL_GET_MESSAGES)\(channelId)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            
            if response.result.error == nil {
                self.clearMessages()
                guard let data = response.data else {return}
                if let json = try! JSON(data: data).array {
                    for item in json {
                        let messageBody = item["messageBody"].stringValue
                        let channelId = item["messageBody"].stringValue
                        let id = item["_id"].stringValue
                        let userName = item["userName"].stringValue
                        let userAvatar = item["userAvatar"].stringValue
                        let userAvatarColor = item["userAvatarColor"].stringValue
                        let timeStamp = item["timeStamp"].stringValue
                        
                        let message = Message(message: messageBody, userName: userName, channelId: channelId, userAvatar: userAvatar, userAvatarColor: userAvatarColor, id: id, timeStamp: timeStamp)
                        self.messages.append(message)

                    }
                    print(self.messages)
                    completion(true)
                }
                
            } else {
                debugPrint(response.result.error as Any)
                completion(false)
            }
        }
        
    }
    
    func clearMessages() {
        messages.removeAll()
    }
    
    func clearChannels() {
        channels.removeAll()
    }
    
}
