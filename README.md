

# Flutter Chat App README

**Table of Contents:**

1. [Introduction](#introduction)
2. [Features](#features)
3. [Installation](#installation)
4. [Dependencies](#dependencies)
5. [Code Snippets](#code-snippets)
    - [1. main.dart](#1-maindart)
    - [2. widgets.dart](#2-widgetsdart)
    - [3. helper_function.dart](#3-helper_functiondart)
    - [4. home_page.dart](#4-home_pagedart)
    - [5. database_service.dart](#5-database_servicedart)
    - [6. login_page.dart](#6-login_pagedart)
    - [7. register_page.dart](#7-register_pagedart)
    - [8. search_page.dart](#8-search_pagedart)
    - [9. profile_page.dart](#9-profile_pagedart)
    - [10. requests.dart](#10-requestsdart)
    - [11. auth_service.dart](#11-auth_servicedart)
6. [Contributing](#contributing)
7. [License](#license)

## Introduction

This README provides an overview of a Flutter-based chat application's code components and their functionalities. The code snippets provided encompass various parts of the app, including UI, data handling, and authentication.

The app offers a chat platform, enabling users to log in, register, view their profiles, send and receive friend requests, and interact with friends.

## Features

- User registration and login.
- User profile management.
- Friend requests handling.
- User-friendly chat interface.
- Simple and intuitive navigation.

## Installation

1. Install Flutter: Follow the official [Flutter installation guide](https://flutter.dev/docs/get-started/install) to set up your development environment.

2. Clone the repository:
   ```bash
   git clone https://github.com/your/repository.git
   ```

3. Navigate to the project directory:
   ```bash
   cd your_project_directory
   ```

4. Install dependencies:
   ```bash
   flutter pub get
   ```

5. Run the app:
   ```bash
   flutter run
   ```

## Dependencies

The application relies on several dependencies, including:

- `firebase_auth` for user authentication.
- `cloud_firestore` for the Firestore database.
- `flutter` for building the app's UI.

Make sure to add these dependencies to your project's `pubspec.yaml` file. You can find the specific versions in the Flutter documentation.

## Code Snippets

### 1. `main.dart`

[View `main.dart` code here](#1-maindart)

This is the entry point of the app, where the `main` function runs the app.

### 2. `widgets.dart`

[View `widgets.dart` code here](#2-widgetsdart)

This file contains shared widgets, making it easy to maintain a consistent look and feel throughout the app.

### 3. `helper_function.dart`

[View `helper_function.dart` code here](#3-helper_functiondart)

Helper functions are used to manage shared preferences for user sessions and data storage.

### 4. `home_page.dart`

[View `home_page.dart` code here](#4-home_pagedart)

This file is the primary home page of the app, serving as the main chat interface.

### 5. `database_service.dart`

[View `database_service.dart` code here](#5-database_servicedart)

The database service manages user data stored in Firestore and provides functions for retrieving user details.

### 6. `login_page.dart`

[View `login_page.dart` code here](#6-login_pagedart)

This file contains the login page UI and the logic for user login. Users can enter their email and password to access the app.

### 7. `register_page.dart`

[View `register_page.dart` code here](#7-register_pagedart)

The registration page UI and logic are found here. Users can create a new account by providing a username, email, and password.

### 8. `search_page.dart`

[View `search_page.dart` code here](#8-search_pagedart)

The search page UI is minimal and provides a search feature to find other users.

### 9. `profile_page.dart`

[View `profile_page.dart` code here](#9-profile_pagedart)

This file contains the user profile page. Users can view their own profiles and perform actions such as logging out.

### 10. `requests.dart`

[View `requests.dart` code here](#10-requestsdart)

This file handles received friend requests. It allows users to accept or reject incoming requests.

### 11. `auth_service.dart`

[View `auth_service.dart` code here](#11-auth_servicedart)

The authentication service manages user authentication, including login, registration, and sign-out operations.

