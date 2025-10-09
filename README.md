# Dot Connections

(Only UI is visible to you, because this is an real project and you can get more in depth by switching to another branch)
A modern dating app built with Flutter that helps users find meaningful connections based on their preferences, interests, and lifestyle choices.

## Project Overview

Dot Connections is a comprehensive dating application that guides users through a detailed profile creation process, allowing them to specify their preferences, share personal details, and connect with potential matches. The app features a user-friendly interface with smooth navigation and interactive elements.

### Key Features

- **Detailed Profile Creation**: Multi-step onboarding process to collect user information
- **Preference Settings**: Users can specify who they want to date and their preferences
- **Messaging System**: Real-time chat functionality for matched users
- **Photo Gallery**: Users can upload and manage their photos
- **User Management**: Account management, personal details editing, and subscription options
- **Location Integration**: Google Maps integration for location-based matching
- **Rich Media Support**: Audio messages, image sharing, and more

### Tech Stack

- **Framework**: Flutter
- **State Management**: GetX
- **UI Scaling**: ScreenUtil for responsive design
- **Maps Integration**: Google Maps Flutter
- **Media**: Audio players, image pickers, and media handling
- **Storage**: SQLite with SQFlite for local data persistence
- **Environment**: Flutter dotenv for environment variable management
- **Animations**: Lottie for rich animations

## Screenshots

Here are some screenshots showcasing the app's UI and functionality:

### Onboarding and Profile Setup

<div style="display: flex; flex-wrap: wrap; gap: 10px; justify-content: center;">
  <img src="assets/screenshots/Simulator Screenshot - iPhone 17 Pro Max - 2025-09-21 at 16.27.06.png" width="200" alt="Onboarding Screen">
  <img src="assets/screenshots/Simulator Screenshot - iPhone 17 Pro Max - 2025-09-21 at 16.27.22.png" width="200" alt="Profile Setup">
  <img src="assets/screenshots/Simulator Screenshot - iPhone 17 Pro Max - 2025-09-21 at 16.27.33.png" width="200" alt="Personal Details">
  <img src="assets/screenshots/Simulator Screenshot - iPhone 17 Pro Max - 2025-09-21 at 16.27.54.png" width="200" alt="Preferences Screen">
</div>

### Main Application Screens

<div style="display: flex; flex-wrap: wrap; gap: 10px; justify-content: center;">
  <img src="assets/screenshots/Simulator Screenshot - iPhone 17 Pro Max - 2025-09-21 at 16.28.04.png" width="200" alt="Home Screen">
  <img src="assets/screenshots/Simulator Screenshot - iPhone 17 Pro Max - 2025-09-21 at 16.28.19.png" width="200" alt="Chat List">
  <img src="assets/screenshots/Simulator Screenshot - iPhone 17 Pro Max - 2025-09-21 at 16.28.24.png" width="200" alt="Conversation Screen">
  <img src="assets/screenshots/Simulator Screenshot - iPhone 17 Pro Max - 2025-09-21 at 16.28.31.png" width="200" alt="Profile Screen">
  <img src="assets/screenshots/Simulator Screenshot - iPhone 17 Pro Max - 2025-09-21 at 16.28.38.png" width="200" alt="Settings Screen">
</div>

## Getting Started

To run this project locally:

1. Clone the repository
2. Make sure you have Flutter installed and setup
3. Create a `.env` file at the root of the project with your API keys (see `.env.example` for required variables)
4. Run `flutter pub get` to install dependencies
5. Run `flutter run` to start the application

## Environment Setup

The app uses Google Maps and other services that require API keys. Make sure to set up your `.env` file with the following:

```
GOOGLE_MAPS_API_KEY=your_google_maps_api_key
```

## Contributors

- Shakib Al Hasan - Developer
