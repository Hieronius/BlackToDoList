# 📝BlackToDoList
An app with custom implementation of Apple passcode and authorisation with faceID and touchID.
Also app able to detect when there is no internet and prevent user for any actions until it will be connected

## 🛠Technologies
- MVC
- GCD
- UIKit
- Keychain
- FirebaseAuth
- LocalAuthorisation
- NetworkMonitor
- Storyboard
- Custom Activity Indicator
- Custom Cleaning Button
- Custom Passcode Screen

## ❗️Info
- iOS Deployment Target - 13.0
- Tested on iphone 6s with ios 15.2
- Tested on iphone 13 mini with ios 16
- Tested on iphone 11 with ios 14.8

## 📺Demo

### Passcode
https://github.com/Hieronius/BlackToDoList/assets/41345907/d3fa452f-0d84-4e47-9d0f-d4de3844a5b4

### NetworkMonitor
https://github.com/Hieronius/BlackToDoList/assets/41345907/49955ee5-10b6-494d-9a0b-43e532b6e33d

## 📌ToDo
- Replace Storyboards with code
- Implement task tracker

## 👱‍♂️Use cases:

1. User Registration -> Redirect to the Login Screen -> Email Verification -> LogIn. ✅
2. User LogIn -> Create passcode -> Repeat passcode -> SavePasscode in Keychain -> Give Permission to use Biometrics -> Redirect to the Main Screen. ✅
3. User LogIn -> Create passcode -> Repeat passcode -> SavePasscode in Keychain -> No permission to use Biometrics -> Redirect to the Main Screen. ✅
4. User LogIn -> Create passcode -> Repeat passcode -> Wrong passcode -> Remove first and "repeat" passcode -> Create passcode -> Repeat passcode -> User LogIn -> Create passcode -> Repeat passcode -> SavePasscode in Keychain -> Give Permission to use Biometrics -> Redirect to the Main Screen. ✅
5. User LogIn -> Create passcode -> Repeat passcode -> Wrong passcode -> Remove first and "repeat" passcode -> Create passcode -> Repeat passcode -> User LogIn -> Create passcode -> Repeat passcode -> SavePasscode in Keychain -> No permission to use Biometrics -> Redirect to the Main Screen. ✅
6. User LogOut -> Redirect to the LogIn Screen. ✅
7. User Reset Password -> Redirect to the Login Screen -> Change password from the email link. ✅
8. User LogIn -> Enter the Passcode / Use Biometrics -> Redirect to the Main Screen. ✅
9. User LogIn -> Enter the Passcode (No Biometrics) -> Redirect to the Main Screen. ✅
10. User LogIn -> Enter the Passcode (No Biometrics) -> Forget the passcode -> Redirect to the LogIn Screen -> Delete passcode from Keychain -> LogIn -> Create passcode -> Repeat passcode -> SavePasscode in Keychain -> Give Permission to use Biometrics -> Redirect to the Main Screen. ✅
11. User LogIn -> Enter the Passcode (No Biometrics) -> Forget the passcode -> Redirect to the LogIn Screen -> Delete passcode from Keychain -> LogIn -> Create passcode -> Repeat passcode -> SavePasscode in Keychain -> No permission to use Biometrics -> Redirect to the Main Screen. ✅
12. User Remove App from Background -> Open the App -> Enter the passcode / use Biometrics -> Redirect to the Main Screen. ❌
13. User Delete App from the phone -> Force LogOut from the App -> Install an App -> LogIn -> Enter passcode / use Biometrics -> Redirect to the Main Screen. ❌
