//
//  File.swift
//  
//
//  Created by Enes Karaosman on 18.11.2020.
//

import Foundation
import GoogleSignIn

/**
 https://developers.google.com/identity/sign-in/ios/start-integrating
 Set in AppDelegate.didFinishLaunchingWithOptions
 1) GIDSignIn.sharedInstance()?.clientID
 2) Handle url in AppDelegate.application(
     _ app: UIApplication,
     open url: URL,
     options: [UIApplication.OpenURLOptionsKey : Any] = [:]
 )
 3) Make sure to add URL scheme, TARGETS > Info > URL Types > + (Add)
 */

internal class GoogleSignInCoordinator: NSObject {

    private var loginViewModel: LoginViewModel

    public init(loginVM: LoginViewModel) {
        self.loginViewModel = loginVM
    }

}

extension GoogleSignInCoordinator: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            loginViewModel.signInPublisher.send(completion: .failure(error))
            return
        }
        guard let authentication = user.authentication else { return }
        loginViewModel.signInPublisher.send(
            .init(idToken: authentication.idToken, accessToken: authentication.accessToken)
        )
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        loginViewModel.signInPublisher.send(completion: .failure(error))
    }
    
}

extension GoogleSignInCoordinator: LoginCoordinatorProtocol {
    
    func triggerSignIn() {
        GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.last?.rootViewController
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    func logout() {
        GIDSignIn.sharedInstance()?.signOut()
    }
    
}
