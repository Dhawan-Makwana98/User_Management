# User Management Demo:-
This is a Flutter application demonstrating user management using Firebase. It allows users to register, store their data in Firestore, and supports offline data storage using SharedPreferences.

*Features
- Store user data in Firebase Firestore
- Offline support using SharedPreferences
- Sync local data to Firebase when internet is available
- Internet connectivity toast notifications

*Project Setup
1. Clone the repository or download the source code.
2. Open the project in your preferred code editor (e.g., VS Code or Android Studio).
3. Run `flutter pub get` to install dependencies.
4. Set up Firebase:
   - Go to [Firebase Console].,
   - Create a project and add an Android app
   - Download `google-services.json` and place it in the `android/app` folder
5. Run the app using:

*Dependencies
- firebase_core
- firebase_auth
- cloud_firestore
- connectivity_plus
- shared_preferences
- fluttertoast

*Project Structure (MVVM)
- `model/` – Contains user model class.
- `services/` – Contains Firebase and local storage service classes.
- `view_model/` – Contains user view model class.
- `view/` – Contains Flutter UI widgets and screens.

Dhavan Makwana  
Email: dhavanmak@gmail.com

