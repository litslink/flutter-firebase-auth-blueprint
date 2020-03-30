## Overview
It is a blueprint application. This application should be used as an example for your future projects. We are open for new ideas and proposals. If you want to add new features or modify existing components then just make a PR.

Application contains following features:
1. Sign in/up using email + password, phone number or Google account. Application uses Firebase authentication service as BE.
2. User profile with edit mode. You can change username or photo. Firebase is used as remote storage. 
3. Each user has a remote config which is stored inside Firebase DB. Only one field is implemented now (notification on/off) but you can easily extend config.
4. Application can store users notes inside Firebase DB. CRUD operations are already implemented. You can reuse it. Just change the data model.
## Repository structure
Repository contains two different architecture approaches. There are `Provider state management` and `BLoC`. It was done to compare them. Each approach located inside separate package. Also `common` package contains common logic for each of them.
## Getting started
Before run project you should create Firebase project which support DB, Storage and Auth services. After that generate `google-services.json` and `GoogleService-Info.plist`. Move `google-services.json` to `/android/app` folder. Move `GoogleService-Info.plist` to `/ios/Runner` folders. 
Note: repository contains two Flutter projects. It is required for each of them.
## Provider state management
![Provider architecture](diagrams/provider_diagram.png)