//
//  Constants.swift
//  Smack
//
//  Created by Khalid Saleh Elatawy on 7/6/19.
//  Copyright © 2019 Khalid Saleh Elatawy. All rights reserved.
//

import Foundation

typealias CompletionHandler = (_ Success : Bool) -> ()

//URL constants
let BASE_URL =  "https://chattychatjb.herokuapp.com/v1/" //"https://chrpchattychat.herokuapp.com/v1" 
let URL_REGISTER = "\(BASE_URL)account/register"
let URL_LOGIN = "\(BASE_URL)account/login"
let URL_USER_ADD = "\(BASE_URL)user/add"

//Colors
let smackPurplePlaceHolder = #colorLiteral(red: 0.3254901961, green: 0.4196078431, blue: 0.7764705882, alpha: 0.5)

//Notification Constants
let NOTIF_USER_DATA_DID_CHANGE = Notification.Name("notifUserDataChange")

//Segues
let TO_LOGIN = "toLogin"
let TO_CREAT_ACCOUNT = "toCreatAccount"
let UNWIND = "unwindToChannel"
let TO_AVATAR_PICKER = "toAvatarPicker"

//User Defaults
let TOKEN_KEY = "token"
let LOGGED_IN_KEY = "loggedIn"
let USER_EMAIL = "userEmail"

//Headers
let HEADER = ["Content-Type": "application/json; charset=utf-8"]
