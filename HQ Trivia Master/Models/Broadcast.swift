//
//  Broadcast.swift
//  HQ Trivia Master
//
//  Created by Ryan Kundrata on 4/2/18.
//  Copyright © 2018 Ryan Kundrata. All rights reserved.
//

import Foundation

struct Broadcast
{
    var socketUrl: URL?
    
    init(socketUrl urlString: String)
    {
        socketUrl = urlString.webSocketUrl
    }
    
    init(_ json: [String: Any])
    {
        if let urlString = json["socketUrl"] as? String
        {
            socketUrl = urlString.webSocketUrl
        }
    }
}
