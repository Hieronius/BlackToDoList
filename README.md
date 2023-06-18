# BlackToDoList
Simple and fast app to manage your tasks.


# User usecases

1. User Registration -> Redirect to the Login Screen -> Email Verification -> LogIn. ✅
2. User LogIn -> Create passcode -> Repeat passcode -> SavePasscode in Keychain -> Give Permission to use Biometrics -> Redirect to the Main Screen. ✅
3. User LogIn -> Create passcode -> Repeat passcode -> SavePasscode in Keychain -> No permission to use Biometrics -> Redirect to the Main Screen. ✅
4. User LogIn -> Create passcode -> Repeat passcode -> Wrong passcode -> Remove first and "repeat" passcode -> Create passcode -> Repeat passcode -> User LogIn -> Create passcode -> Repeat passcode -> SavePasscode in Keychain -> Give Permission to use Biometrics -> Redirect to the Main Screen. ✅
5. User LogIn -> Create passcode -> Repeat passcode -> Wrong passcode -> Remove first and "repeat" passcode -> Create passcode -> Repeat passcode -> User LogIn -> Create passcode -> Repeat passcode -> SavePasscode in Keychain -> No permission to use Biometrics -> Redirect to the Main Screen. ✅
6. User LogOut -> Redirect to the LogIn Screen. ✅
7. User Reset Password -> Redirect to the Login Screen -> Change password from the email link. ✅
8. User LogIn -> Enter the Passcode / Use Biometrics -> Redirect to the Main Screen. ❌
9. User LogIn -> Enter the Passcode (No Biometrics) -> Forget the passcode -> Redirect to the LogIn Screen -> Delete passcode from Keychain -> LogIn -> Create passcode -> Repeat passcode -> SavePasscode in Keychain -> Give Permission to use Biometrics -> Redirect to the Main Screen. ❌
10. User LogIn -> Enter the Passcode (No Biometrics) -> Forget the passcode -> Redirect to the LogIn Screen -> Delete passcode from Keychain -> LogIn -> Create passcode -> Repeat passcode -> SavePasscode in Keychain -> No permission to use Biometrics -> Redirect to the Main Screen. ❌
11. User Remove App from Background -> Open the App -> Enter the passcode / use Biometrics -> Redirect to the Main Screen. ❌
12. User Delete App from the phone -> Force LogOut from the App -> Install an App -> LogIn -> Enter passcode / use Biometrics -> Redirect to the Main Screen. ❌
