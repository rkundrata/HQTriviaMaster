//
//  SiteEncoding.swift
//  HQ Trivia Master
//
//  Created by Ryan Kundrata on 4/2/18.
//  Copyright © 2018 Ryan Kundrata. All rights reserved.
//

import Foundation
import Cocoa

private let googleSearchAPIKeyConstantCustom = "googleSearchAPIKeyCustom"
private let googleSearchSearchEngineIDConstantCustom = "googleSearchSearchEngineIDCustom"

private let hqUsernameConstantCustom = "hqUsernameCustom"
private let hqTokenConstantCustom = "hqTokenCustom"

/**
 Determines what site will be searched for answers
 
 Contains a pretty name as well as a base URL
 */
struct SiteEncoding : Equatable, CustomStringConvertible, CustomDebugStringConvertible
{
    private static let keychain = KeychainSwift()
    
    private let name : String
    private let url : URL?
    
    var description : String { return name }
    var debugDescription : String { return name + ": \(url?.absoluteString ?? "No URL")" }
    
    static var hqCredentials: (username: String?, token: String?) {
        return (SiteEncoding.keychain.get(hqUsernameConstantCustom), SiteEncoding.keychain.get(hqTokenConstantCustom))
    }
    
    private init(name: String, url: URL?)
    {
        self.name = name
        self.url = url
    }
    
    /**
     This method returns a URL object that includes the given option in the string.
     
     **Programmer Notes:** This method may need to be modified with each new SiteEncoding added
     */
    func url(with option: String) -> URL?
    {
        guard let url = url else { return nil }
        guard let urlEncoded = option.urlEncoded(for: self) else { return nil }
        if self == SiteEncoding.google
        {
            guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return nil }
            var queryItems = (components.queryItems ?? []) + [URLQueryItem(name: "q", value: urlEncoded)]
            var keys = [String]()
            var count = 0
            while let apiKey = SiteEncoding.keychain.get(googleSearchAPIKeyConstantCustom + "\(count == 0 ? "" : "\(count)")")
            {
                keys.append(apiKey)
                count += 1
            }
            for var item in queryItems where item.name == "key"
            {
                guard let index = queryItems.index(of: item) else { continue }
                item.value = keys.random
                queryItems[index] = item
            }
            components.queryItems = queryItems
            return components.url
        }
        return url.appendingPathComponent(urlEncoded)
    }
    
    static func ==(lhs: SiteEncoding, rhs: SiteEncoding) -> Bool
    {
        return lhs.name == rhs.name
    }
    
    static let google : SiteEncoding = {
        guard let apiKey = keychain.get(googleSearchAPIKeyConstantCustom), let searchEngineID = keychain.get(googleSearchSearchEngineIDConstantCustom) else
        {
            return SiteEncoding(name: "Invalid Google Search.  Missing API Key or SearchEngineID", url: nil)
        }
        let url = URL(string: "https://www.googleapis.com/customsearch/v1?key=\(apiKey)&cx=\(searchEngineID)")
        return SiteEncoding(name: "Google - Custom Search", url: url)
    }()
    
    ///Verifies the user has recently inputted Google CSE credentials.  If not, a critical alert is presented prompting for them
    static func checkGoogleAPICredentials(force: Bool = false)
    {
        if keychain.get(googleSearchAPIKeyConstantCustom) == nil || keychain.get(googleSearchSearchEngineIDConstantCustom) == nil || force
        {
            guard let window = (NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "googleAlert")) as? NSWindowController)?.window else { return }
            NSApplication.shared.keyWindow?.beginCriticalSheet(window, completionHandler: nil)
        }
    }
    
    ///Stores the credentials into the user's Secure Keychain
    static func addGoogleAPICredentials(apiKeys: [String], searchEngineID: String)
    {
        var count = 0
        for apiKey in apiKeys where apiKey != ""
        {
            keychain.set(apiKey, forKey: googleSearchAPIKeyConstantCustom + "\(count == 0 ? "" : "\(count)")")
            count += 1
        }
        keychain.set(searchEngineID, forKey: googleSearchSearchEngineIDConstantCustom)
    }
    
    static func addHQCredentials(username: String, token: String) {
        keychain.set(username, forKey: hqUsernameConstantCustom)
        keychain.set(token, forKey: hqTokenConstantCustom)
    }
}
