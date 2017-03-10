//
//  AppDelegate.swift
//  Orbit
//
//  Created by Thomas Barrett on 3/4/17.
//  Copyright © 2017 Thomas Barrett. All rights reserved.
//

import UIKit
import SpriteKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        (window?.rootViewController?.view as! SKView).isPaused = true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        (window?.rootViewController?.view as! SKView).isPaused = false
    }
}

