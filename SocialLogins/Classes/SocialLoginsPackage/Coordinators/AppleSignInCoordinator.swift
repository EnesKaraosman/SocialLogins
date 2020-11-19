//
//  AppleSignInCoordinator.swift
//  
//
//  Created by Enes Karaosman on 18.11.2020.
//

import Foundation
import AuthenticationServices

public class AppleSignInCoordinator: NSObject {
    
    enum AppleSignInError: Error, LocalizedError {
        case tokenCouldNotBeSerialized
        case unableToFetchIdentifyToken
        
        var errorDescription: String? {
            switch self {
            case .tokenCouldNotBeSerialized:
                return "Unable to serialize token string from data"
            case .unableToFetchIdentifyToken:
                return "Unable to fetch identify token"
            }
        }
    }
    
    private var loginViewModel: LoginViewModel
    private var currentNonce: String?
    
    public init(loginVM: LoginViewModel) {
        self.loginViewModel = loginVM
    }
    
    private func createAppleIDRequest() -> ASAuthorizationAppleIDRequest {
        let appIDProvider = ASAuthorizationAppleIDProvider()
        let request = appIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let nonce = String.randomNonce()
        request.nonce = nonce.sha256()
        currentNonce = nonce
        
        return request
    }
    
}

extension AppleSignInCoordinator: ASAuthorizationControllerDelegate {
    // , ASAuthorizationControllerPresentationContextProviding
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {

        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                loginViewModel.signInPublisher.send(completion: .failure(AppleSignInError.unableToFetchIdentifyToken))
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                loginViewModel.signInPublisher.send(completion: .failure(AppleSignInError.tokenCouldNotBeSerialized))
                return
            }
            
            loginViewModel.signInPublisher.send(
                .init(idToken: idTokenString, providerID: "apple.com", rawNonce: nonce)
            )
        }
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        loginViewModel.signInPublisher.send(completion: .failure(error))
    }
    
}

extension AppleSignInCoordinator: LoginCoordinatorProtocol {
    
    func triggerSignIn() {
        
        let request = createAppleIDRequest()
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
//            authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func logout() {
        #warning("AppleSignInCoordinator.logout()")
    }
    
}
