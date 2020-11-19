//
//  FacebookSignInCoordinator.swift
//  SocialLogins
//
//  Created by Enes Karaosman on 19.11.2020.
//

import Foundation
import FBSDKLoginKit

// https://developers.facebook.com/docs/facebook-login/ios/
public class FacebookSignInCoordinator: NSObject {
    
    enum FacebookLoginError: Error, LocalizedError {
        case unableToGetAccessToken
        
        var errorDescription: String? {
            switch self {
            case .unableToGetAccessToken:
                return "Unable to get access token"
            }
        }
    }
    
    private var loginViewModel: LoginViewModel
    
    public init(loginVM: LoginViewModel) {
        self.loginViewModel = loginVM
    }
    
    private lazy var loginManager = LoginManager()
    
}

extension FacebookSignInCoordinator: LoginCoordinatorProtocol {
    
    public func triggerSignIn() {
        
        loginManager.logIn(
            permissions: ["public_profile", "email"],
            from: UIApplication.shared.windows.first?.rootViewController
        ) { (result, error) in
            
            if let error = error {
                self.loginViewModel.signInPublisher.send(completion: .failure(error))
                return
            }
            guard let accessToken = AccessToken.current else {
                self.loginViewModel.signInPublisher.send(completion: .failure(FacebookLoginError.unableToGetAccessToken))
                return
            }
            self.loginViewModel.signInPublisher.send(
                AuthResult(accessToken: accessToken.tokenString)
            )
        }
    }
    
    public func logout() {
        loginManager.logOut()
    }
    
}
