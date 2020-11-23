//
//  AppDelegate.swift
//  SocialLogins
//
//  Created by eneskaraosman on 11/18/2020.
//  Copyright (c) 2020 eneskaraosman. All rights reserved.
//

import UIKit
import SocialLogins

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        SocialLogins.shared.configure(clientID: "")
        let _ = SocialLogins.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return SocialLogins.shared.application(
            app,
            open: url,
            options: options
        )
    }

}

