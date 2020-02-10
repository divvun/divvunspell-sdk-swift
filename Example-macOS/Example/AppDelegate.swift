//
//  AppDelegate.swift
//  Example
//
//  Created by Brendan Molloy on 2019-11-19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Cocoa
import DivvunSpell

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        for (index, word) in "this is some words, ää ä äää ö̂ˆ̂ä̂ Oh".wordBoundIndices() {
            debugPrint(index, word)
        }
        
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

