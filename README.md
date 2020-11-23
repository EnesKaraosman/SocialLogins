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

**Note: Use SocialLogins shared instance in AppDelegate & SceneDelegate**

Set in `AppDelegate.swift`
```swift
func application(
    _ application: UIApplication, 
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
) -> Bool {

    // Required if you're using GoogleSignIn, otherwise no need to call.
    SocialLogins.shared.configure(clientID: "")
    let _ = SocialLogins.shared.application(
        application,
        didFinishLaunchingWithOptions: launchOptions
    )
    
}

func application(
    _ app: UIApplication, 
    open url: URL, 
    options: [UIApplicationOpenURLOptionsKey : Any] = [:]
) -> Bool {
    return SocialLogins.shared.application(
        app,
        open: url,
        options: options
    )
}
```

Set in `SceneDelegate.swift` (if SceneDelegate exist, otherwise no need to create)
```swift
func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    
    SocialLogins.shared.scene(
        scene,
        openURLContexts: openURLContexts
    )
}
```

If you implement methods above, no need to re implement them while following Google & Facebook instructions. (Just configure URL Schemes & Info.plist) <br>

* Apple <br>
Enable Sign in with Apple from Project's settings, Signing & Capabilities

* Google <br>
[Google Login SDK integration](https://developers.google.com/identity/sign-in/ios/start-integrating)

- Make sure to add URL scheme, TARGETS > Info > URL Types > + (Add)

* Facebook <br>
[Facebook Login SDK integration](https://developers.facebook.com/docs/facebook-login/ios/)
Make sure to follow link; <br>
You'll need to create an app from facebook developer & communicate with your project.
Modify Info.plist & URL Scheme

### Available Sign In Methods

* Apple
* Google
* Facebook

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
        case .facebook:
            let credential = FacebookAuthProvider.credential(
                withAccessToken: authResult.accessToken!
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
    
// Any button that might contain Google's logo and some text
GoogleSignInButton() 
    .frame(height: 50)
    .border(Color.black, width: 1)
    .padding()
    .onTapGesture { loginViewModel.startSignInProcess(with: .google) }

// Any button that might contain Facebook's logo and some text
FacebookSignInButton()
    .frame(height: 50)
    .border(Color.black, width: 1)
    .padding()
    .onTapGesture{ loginViewModel.startSignInProcess(with: .facebook) }
```


## Author

eneskaraosman, eneskaraosman53@gmail.com

## License

SocialLogins is available under the MIT license. See the LICENSE file for more info.
