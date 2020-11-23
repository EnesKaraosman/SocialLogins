//
//  SocialLogins.swift
//  SocialLogins
//
//  Created by Enes Karaosman on 23.11.2020.
//

import Foundation
import UIKit
import GoogleSignIn
import FBSDKLoginKit

public class SocialLogins: NSObject {

    public static let shared = SocialLogins()
    private var clientID: String?
    
    private override init() {
        super.init()
    }
    
    /// Required if you're using Google sign in.
    public func configure(clientID: String? = nil) {
        self.clientID = clientID
    }
    
}

// MARK: - ApplicationDelegate
extension SocialLogins: UIApplicationDelegate {
    
    // didFinishLaunching
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        GIDSignIn.sharedInstance()?.clientID = clientID
        
        // Facebook
        return ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        
    }
    
    // open url
    public func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        return ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        ) || GIDSignIn.sharedInstance()?.handle(url) ?? false
    }
    
}

// MARK: - SceneDelegate
extension SocialLogins: UIWindowSceneDelegate {
    
    public func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }

        ApplicationDelegate.shared.application(
            UIApplication.shared,
            open: url,
            sourceApplication: nil,
            annotation: [UIApplication.OpenURLOptionsKey.annotation]
        )
    }
    
}
