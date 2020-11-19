//
//  LoginViewModel.swift
//
//  Created by Enes Karaosman on 18.11.2020.
//

import Foundation
import Combine

open class LoginViewModel: ObservableObject {
    
    public enum SignInMethod: String, CaseIterable {
        case apple
        case google
        case facebook
    }
    
    private lazy var appleSignInCoordinator = AppleSignInCoordinator(loginVM: self)
    private lazy var googleSignInCoordinator = GoogleSignInCoordinator(loginVM: self)
    private lazy var facebookSignInCoordinator = FacebookSignInCoordinator(loginVM: self)
    
    private var currentSignInCoordinator: LoginCoordinatorProtocol {
        switch selectedSignInMethod {
        case .apple: return appleSignInCoordinator
        case .google: return googleSignInCoordinator
        case .facebook: return facebookSignInCoordinator
        case .none: fatalError("SignIn Method not selected")
        }
    }
    
    @Published public var signInSucceeded = false
    @Published public var signInError: Error?
    
    public var selectedSignInMethod: SignInMethod!
    
    private var cancelable = Set<AnyCancellable>()
    public var signInPublisher = PassthroughSubject<AuthResult, Error>()
    
    public init() {
        signInPublisher
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                switch completion {
                case .failure(let error):
                    self.signInSucceeded = false
                    self.signInError = error
                case .finished: break // No action needed, receiveValue handles.
                }
            } receiveValue: { (result) in
                self.completeSignIn(with: result)
            }
            .store(in: &cancelable)
    }
    
    deinit {
        cancelable.forEach { $0.cancel() }
        print("☠️ LoginViewModel deinit")
    }
    
    /// Triggered when authentication succeeded from related provider.
    open func completeSignIn(with authResult: AuthResult) { }
    
    /// Trigger this method (from related provider's button action) to start process.
    open func startSignInProcess(with method: SignInMethod) {
        switch method {
        case .apple: selectedSignInMethod = .apple
        case .google: selectedSignInMethod = .google
        case .facebook: selectedSignInMethod = .facebook
        }
        currentSignInCoordinator.triggerSignIn()
    }
    
    open func logout() {
        signInSucceeded = false
        currentSignInCoordinator.logout()
    }
    
}
