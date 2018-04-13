//
//  HQWebSocketDelegate.swift
//  HQ Trivia Master
//
//  Created by Ryan Kundrata on 4/2/18.
//  Copyright © 2018 Ryan Kundrata. All rights reserved.
//

import Foundation

protocol HQWebSocketDelegate
{
    func recievedQuestion(hqQuestion: HQQuestion)
    func broadcastStarted()
    func broadcastEnded()
}
