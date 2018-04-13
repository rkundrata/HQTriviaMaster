//
//  HQGame.swift
//  HQ Trivia Master
//
//  Created by Ryan Kundrata on 4/2/18.
//  Copyright © 2018 Ryan Kundrata. All rights reserved.
//

import Foundation

struct HQGame
{
    var active: Bool
    var prize: String?
    var broadcast: Broadcast?
    
    init(isActive _active: Bool, gamePrize _prize: String?, gameBroadcast _broadcast: Broadcast)
    {
        active = _active
        prize = _prize
        broadcast = _broadcast
    }
    
    init(_ json: [String: Any])
    {
        active = json["active"] as? Bool ?? false
        prize = json["prize"] as? String
        
        if let gameBroadcast = json["broadcast"] as? [String: Any]
        {
            broadcast = Broadcast(gameBroadcast)
        }
    }
}
