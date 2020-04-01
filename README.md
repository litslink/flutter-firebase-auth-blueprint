## Overview
It is a blueprint application. This application should be used as an example for your future projects. We are open for new ideas and proposals. If you want to add new features or modify existing components then just make a PR.

Application contains following features:
* Sign in/up using email + password, phone number or Google account. Application uses Firebase authentication service as BE.
* User profile with edit mode. You can change username or photo. Firebase is used as remote storage. 
* Each user has a remote config which is stored inside Firebase DB. Only one field is implemented now (notification on/off) but you can easily extend config.
* Application can store users notes inside Firebase DB. CRUD operations are already implemented. You can reuse it. Just change the data model.
## Repository structure
Repository contains two different architecture approaches. There are `Provider state management` and `BLoC`. It was done to compare them. Each approach located inside separate package. Also `common` package contains common logic for each of them.
## Getting started
Before run project you should:
1. Create Firebase project which support DB, Storage and Auth services. 
2. Generate `google-services.json` and `GoogleService-Info.plist`. 
3. Move `google-services.json` to `/android/app` folder.
4. Move `GoogleService-Info.plist` to `/ios/Runner` folders.

**Note:** Repository contains two Flutter projects. It is required for each of them.
## Provider state management
The core of concept is combination of [Provider DI library](https://pub.dev/packages/provider) and [ChangeNotifier mechanism](https://flutter.dev/docs/development/data-and-backend/state-mgmt/simple). Model is the main component which connect UI and data. Model instance should be independent to UI rebuild. Model lifecycle is equal to widget state. Use `ChangeNotifierProvider` which save model instance during rebuild process.

![Provider architecture](diagrams/provider_diagram.png)
* **(1) Changes notification**. Your model class extends `ChangeNotifier`. If you want to change UI from model than you should update model fields and call `notifyListeners()` method which rebuild your UI using updated model data.

* **(2) Call of method**. You have access to model methods from UI. Use `Consumer` widget to tie up your model and UI component.

Example of `ChangeNotifierProvider` + `Consumer` combination:
```dart
ChangeNotifierProvider(
  create: (context) => YourModel(),
  child: Consumer<YourModel>(
    builder: (_, model, __) {
      switch (model.state) {
        //return widget related to state type
      }
    },
  ),
)
```
* **(3, 4) Data request/response**. Model is a bridge between your data and UI. Each iteration with data should located inside model. Such as data fetching, data modification or observing of data changes.

**Note:** _Data_ means any data stream such as Networking, DB, Shared preferences or native device components like BLE. Also we recommend to use repository pattern. If needed you can store specific business logic inside components like Services, Use cases, Managers.
* **(5) UI Delegate**. It is component which handle side effects such as Navigation, Snackbars, Toasts, Errors. Please split delegate to interface and implementation classes. Only delegate implementation class contains `BuildContext`.

Delegate example:
```dart
abstract class SignUpDelegate {

  void navigateToHome();

  void navigateToSignIn();

  void showAuthError();
}

class SignUpDelegateImpl extends SignUpDelegate {
  final BuildContext context;

  SignUpDelegateImpl(this.context);

  @override
  void navigateToHome() => Navigator.of(context).popAndPushNamed(HomeWidget.route);

  @override
  void navigateToSignIn() => Navigator.of(context).popAndPushNamed(SignInWidget.route);

  @override
  void showAuthError() => Scaffold.of(context).showSnackBar(
    SnackBar(
      content: Text('Something went wrong. Check your internet connection'),
    )
  );
}
```
## BLoC state management.
BLoC (business logic component) is architecture pattern. BLoC is a simple pipeline with logic inside. It receive event from UI and provide stream of states back to UI.

We recommend to use [BLoC library](https://bloclibrary.dev/#/gettingstarted) which provide set of required widgets and base Bloc class.

![BLoC architecture](diagrams/bloc_diagram.png)
* **(1) States stream**. Use a `BlocBuilder` widget which contains subscription to state changes under the hood.

**Note:** You can use any type as a state. It can be `enum`, `String` or `abstract class`.

* **(2) Events stream**. Add new event from UI to Bloc object. Inside Bloc it event will be mapped to new state or state sequence.

**Note 1:** Use `BlocProvider` to creating new bloc instance. It widget cover lifecycle cases of widget. Be sure what your bloc instance will not be changed during next call of `build()` method.

**Note 2:** Use `BlocListener` to notify UI about side effects. Also you can use `BlocConsumer` which combine `BlocBuilder` and `BlocListener`.

**Note 3:** The same as a state, any type can be your event.

* **(3, 4) Data request/response**. Data management is the same as a `Provider state management` which is described above.

**Note:** You can add new events directly from the block. It will be useful if you want to observe data changes.
## Libraries stack
* **Dependency injection**. Use [Provider](https://pub.dev/packages/provider) library which allow you to implement DI inside your application. It is member of `Flutter favorite`. It mean that package is recommended by official Flutter team.
* [**Equatable**](https://pub.dev/packages/equatable). Forget about overriding of `hashCode` and `==` methods when you need to compare objects.
* [**FlutterFire**](https://github.com/FirebaseExtended/flutterfire). It is list of packages for Firebase integration. Each package cover single Firebase service like Auth or Storage.
* [**Google sign in**](https://pub.dev/packages/google_sign_in). It is extension for `firebase_auth` package from library named above which provide ability to sign in using Google account.

## Code style
We use [Effective Dart](https://dart.dev/guides/language/effective-dart) rules options. Also we use special `string-mode` rules to avoid unexpected issues related to type casting.
```yaml
analyzer:
  exclude: [build/**]
  strong-mode:
    implicit-casts: false
    implicit-dynamic: false
```
