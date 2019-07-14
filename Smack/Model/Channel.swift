//
//  Channel.swift
//  Smack
//
//  Created by Khalid Saleh Elatawy on 7/14/19.
//  Copyright © 2019 Khalid Saleh Elatawy. All rights reserved.
//

import Foundation


struct Channel : Decodable {
    public private(set) var channelTitle: String!
    public private(set) var channelDescription: String!
    public private(set) var id: String!
}


