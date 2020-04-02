## Overview
It is a blueprint application. This application should be used as an example for your future projects. We are open for new ideas and proposals. If you want to add new features or modify existing components then just make a PR.

Application contains following features:
* Sign in/up using email + password, phone number or Google account. Application uses Firebase authentication service as BE.
* User profile with edit mode. You can change username or photo. Firebase is used as remote storage. 
* Each user has a remote config which is stored inside Firebase DB. Only one field is implemented now (notification on/off) but you can easily extend config.
* Application can store users notes inside Firebase DB. CRUD operations are already implemented. You can reuse it. Just change the data model.
## Getting started
Before run project you should:
1. Create a Firebase project which supports DB, Storage and Auth services. 
2. Generate `google-services.json` and `GoogleService-Info.plist`. 
3. Move `google-services.json` to `/android/app` folder.
4. Move `GoogleService-Info.plist` to `/ios/Runner` folders.

**Note:** Repository contains two Flutter projects. It is required for each of them.

[Article](https://medium.com/flutterpub/flutter-how-to-do-user-login-with-firebase-a6af760b14d5) with step by step Firebase set up.
## Repository structure
Repository consists of three packages. Two of them contain the same logic but use different architecture approaches. There are `Provider state management`(`provider_approach` package) and `BLoC`(`bloc_approach`). It was done to compare them. Also `common` store common logic for each of them.

## Provider state management
The core of the concept is a combination of [Provider DI library](https://pub.dev/packages/provider) and [ChangeNotifier mechanism](https://flutter.dev/docs/development/data-and-backend/state-mgmt/simple). Model is the main component which connect UI and data. Model instances should be independent to UI rebuild. Model lifecycle is equal to a widget state. Use `ChangeNotifierProvider` which saves model instances during the rebuild process.

![Provider architecture](diagrams/provider_diagram.png)
* **(1) Changes notification**. Your model class extends `ChangeNotifier`. If you want to change the UI from model then you should update model fields and call `notifyListeners()` method which rebuilds your UI using updated model data.

* **(2) Call of method**. You have access to model methods from UI. Use `Consumer` widget to tie up your model and UI component.

Example of `ChangeNotifierProvider` + `Consumer` combination:
```dart
ChangeNotifierProvider(
  create: (context) => YourModel(),
  child: Consumer<YourModel>(
    builder: (_, model, __) {
      switch (model.state) {
        //return widget depend to state type
      }
    },
  ),
)
```
* **(3, 4) Data request/response**. Model is a bridge between your data and UI. Each iteration with data should be located inside the model. Such as data fetching, data modification or observing of data changes.

**Note:** _Data_ means any data stream such as Networking, DB, Shared preferences or native device components like BLE. Also we recommend to use a repository pattern. If needed you can store specific business logic inside components like Services, Use cases, Managers.
* **(5) UI Delegate**. It is a component which handles side effects such as Navigation, Snackbars, Toasts, Errors. Please split delegates to interface and implementation classes. Only the delegate implementation class contains `BuildContext`.

Delegate example:
```dart
abstract class SignUpDelegate {

  void navigateToHome();

  void showAuthError();
}

class SignUpDelegateImpl extends SignUpDelegate {
  final BuildContext context;

  SignUpDelegateImpl(this.context);

  @override
  void navigateToHome() => Navigator.of(context).popAndPushNamed(HomeWidget.route);

  @override
  void showAuthError() => Scaffold.of(context).showSnackBar(
    SnackBar(
      content: Text('Something went wrong. Check your internet connection'),
    )
  );
}
```

**Conclusion.** It is the easiest way to separate state management and UI. But model classes should extend `ChangeNotifier` which is part of Flutter. It can provide problems during testing. Also when the model gets more complex it’s hard to track when you should call `notifyListeners()`.
## BLoC state management.
BLoC (business logic component) is an architecture pattern. BLoC is a simple pipeline with logic inside. It receives events from UI and provides stream of states back to UI.

We recommend using the [BLoC library](https://bloclibrary.dev/#/gettingstarted) which provide a set of required widgets and base Bloc class.

**Note:** Library is not strictly required. You can use a combination of Provider and RxDart. 

![BLoC architecture](diagrams/bloc_diagram.png)
* **(1) States stream**. Use a `BlocBuilder` widget which contains subscriptions to state changes under the hood.

**Note:** You can use any type as a state. It can be `enum`, primitive, `class` or `abstract class`.

* **(2) Events stream**. Add new event from UI to Bloc object. Inside Bloc it event will be mapped to a new state or state sequence.

**Note 1:** Use `BlocProvider` to creating new bloc instance. It widget cover lifecycle cases of widget. Be sure what your bloc instance will not be changed during next call of `build()` method.

**Note 2:** Use `BlocListener` to notify UI about side effects. Also you can use `BlocConsumer` which combines `BlocBuilder` and `BlocListener`.

Example of `BlocConsumer` + `BlocProvider` combination:
```dart
BlocProvider(
 create: (_) => YourBloc(),
 child: BlocConsumer<SignInBloc, SignInState>(
   listener: (context, state) {
     //side effects
   },
   buildWhen: (context, state) => //filter side effects states which do not required widget changes,
   builder: (context, state) {
     //return widget depend to state type
   },
 ),
)
```

**Note 3:** The same as a state, any type can be your event.

* **(3, 4) Data request/response**. Data management is the same as a `Provider state management` which is described above.

**Note:** You can add new events directly from the block. It will be useful if you want to observe data changes.

**Conclusion.** `BLoC` looks like a better choice for your application. It is easy to test and scale. But experience with reactive streams is needed. Also sometimes it required a lot of boilerplate code.
## Libraries stack
* **Dependency injection**. Use a [Provider](https://pub.dev/packages/provider) library which allows you to implement DI inside your application. It is a member of `Flutter favorite`. It means that the package is recommended by the official Flutter team.
* [**Equatable**](https://pub.dev/packages/equatable). Forget about overriding of `hashCode` and `==` methods when you need to compare objects.
* [**FlutterFire**](https://github.com/FirebaseExtended/flutterfire). It is a list of packages for Firebase integration. Each package covers a single Firebase service like Auth or Storage.
* [**Google sign in**](https://pub.dev/packages/google_sign_in). It is an extension for the `firebase_auth` package from the library named above which provides ability to sign in using a Google account.

## Code style
We use [Effective Dart](https://dart.dev/guides/language/effective-dart) rules options. Also we use special `string-mode` rules to avoid unexpected issues related to type casting.
```yaml
analyzer:
  exclude: [build/**]
  strong-mode:
    implicit-casts: false
    implicit-dynamic: false
```
