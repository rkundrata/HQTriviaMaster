//
//  AppDelegate.swift
//  HQ Trivia Master
//
//  Created by Ryan Kundrata on 4/2/18.
//  Copyright © 2018 Ryan Kundrata. All rights reserved.
//

import Cocoa

@NSApplicationMain
class HQTriviaMaster : NSObject, NSApplicationDelegate
{
    static private(set) var debug = true
    
    @IBOutlet var loggingMenuItem : NSMenuItem!
    
    func applicationDidFinishLaunching(_ notification: Notification)
    {
        loggingMenuItem.title = "Toggle Logging (\(HQTriviaMaster.debug ? "Enabled" : "Disabled"))"
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool
    {
        return true
    }
    
    ///Shows the Google CSE edit window
    @IBAction func showPreferences(sender: Any)
    {
        (NSApplication.shared.keyWindow?.contentViewController as? ViewController)?.showGoogleAPIChangeWindow(sender: sender)
    }
    
    @IBAction func toggleLogging(sender: NSMenuItem)
    {
        HQTriviaMaster.debug = !HQTriviaMaster.debug
        sender.title = "Toggle Logging (\(HQTriviaMaster.debug ? "Enabled" : "Disabled"))"
    }
}

