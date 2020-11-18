# SocialLogins

[![CI Status](https://img.shields.io/travis/eneskaraosman/SocialLogins.svg?style=flat)](https://travis-ci.org/eneskaraosman/SocialLogins)
[![Version](https://img.shields.io/cocoapods/v/SocialLogins.svg?style=flat)](https://cocoapods.org/pods/SocialLogins)
[![License](https://img.shields.io/cocoapods/l/SocialLogins.svg?style=flat)](https://cocoapods.org/pods/SocialLogins)
[![Platform](https://img.shields.io/cocoapods/p/SocialLogins.svg?style=flat)](https://cocoapods.org/pods/SocialLogins)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

SocialLogins is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SocialLogins'
```
## Usage

### Before performing sign in actions, make sure  you set following;

* Google
https://developers.google.com/identity/sign-in/ios/start-integrating
Set in `AppDelegate.didFinishLaunchingWithOptions`
1) GIDSignIn.sharedInstance()?.clientID
2) Handle url in AppDelegate.application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey : Any] = [:]
)
3) Make sure to add URL scheme, TARGETS > Info > URL Types > + (Add)

### Available Sign In Methods

* Apple
* Google

You can create your own LoginViewModel <br>

```swift
import SocialLogins
import FirebaseAuth // Imagine we'll send provided info to Firebase

class MyLoginViewModel: SocialLogins.LoginViewModel {
    
    override init() {
        super.init()
    }
    
    override func completeSignIn(with authResult: SocialLogins.AuthResult) {
        super.completeSignIn(with: authResult)
        
        // Here you may send credentials to different backend, instead Firebase.
        func signInToFirebase(with credential: AuthCredential) {
            Auth.auth().signIn(with: credential) { (result, error) in
                if let user = result?.user {
                    print("**** \(self.selectedSignInMethod.rawValue) sign in succeeded")
                    self.signInSucceeded = true
                }
            }
        }
        
        switch selectedSignInMethod {
        case .apple:
            let credential = OAuthProvider.credential(
                withProviderID: "apple.com",
                idToken: authResult.idToken!,
                rawNonce: authResult.rawNonce
            )
            signInToFirebase(with: credential)
        case .google:
            let credential = GoogleAuthProvider.credential(
                withIDToken: authResult.idToken!,
                accessToken: authResult.accessToken!
            )
            signInToFirebase(with: credential)
        case .none: break
        }
    }
    
}
```
And create your UI elements (buttons), when they tapped, just trigger related provider;

Just trigger `LoginViewModel.startSignInProcess(with: SignInMethod)`

```swift
AppleSignInButton()
    .frame(height: 50)
    .border(Color.black, width: 1)
    .padding()
    .onTapGesture{ loginViewModel.startSignInProcess(with: .apple) }
    
GoogleSignInButton {
    loginViewModel.startSignInProcess(with: .google)
}
.frame(height: 50)
.border(Color.black, width: 1)
.background(Color.white)
.padding()
```


## Author

eneskaraosman, eneskaraosman53@gmail.com

## License

SocialLogins is available under the MIT license. See the LICENSE file for more info.
