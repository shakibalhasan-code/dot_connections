# 🔗 Potential Matches Integration Guide

## Overview

This guide documents the implementation of the potential matches API integration for the Find screen. The system now properly handles your API response format and displays users with their profile information, photos, and distance.

## 📊 API Response Structure

Your API endpoint `/match/potential` returns data in this format:

```json
{
  "success": true,
  "message": "Potential matches retrieved successfully",
  "meta": {
    "page": 1,
    "limit": 10,
    "total": 6,
    "totalPage": 1
  },
  "data": [
    {
      "_id": "68be7282a0db89cc44e432d6",
      "email": "user8@example.com",
      "image": null,
      "phoneNumber": null,
      "lastLoginAt": "2025-09-08T06:07:23.096Z",
      "dateOfBirth": "2001-03-28T00:00:00.000Z",
      "firstName": "Lina",
      "lastName": "Rahman",
      "profile": {
        "_id": "68be741b610226cf5ddbbbf6",
        "userId": "68be7282a0db89cc44e432d6",
        "bio": "Test user 9",
        "drinkingStatus": "No",
        "gender": "male",
        "height": 177,
        "hometown": "Dhaka",
        "interests": ["fitness", "movies", "travel"],
        "jobTitle": "Developer",
        "location": {
          "type": "Point",
          "coordinates": [90.4125, 23.8103],
          "address": "Dhaka, Bangladesh"
        },
        "lookingFor": "dating",
        "photos": [],
        "religious": "muslim",
        "school": "Tech University",
        "smokingStatus": "No",
        "studyLevel": "preferNotToSay",
        "workplace": "Mohakhali"
      },
      "age": 24,
      "distance": 0
    }
  ]
}
```

## 🏗️ Implementation Details

### 1. New Model Classes

Created `/app/data/models/potential_matches_response.dart` with the following classes:

- `PotentialMatchesResponse` - Main response wrapper
- `PotentialMatchesMeta` - Pagination metadata
- `PotentialMatch` - Individual user data
- `PotentialMatchProfile` - User profile data
- `PotentialMatchLocation` - Location information

### 2. Model Conversion

Added an extension method `PotentialMatchExtension` that converts `PotentialMatch` to `UserModel` for compatibility with existing UI components.

### 3. Updated API Service

Modified `/app/core/services/find_api_serverces.dart`:

- Uses `ApiEndpoints.getPotentialMatches` endpoint
- Parses response using `PotentialMatchesResponse.fromJson()`
- Converts to `UserModel` objects for UI compatibility
- Enhanced logging for debugging

### 4. Enhanced UserModel

Updated `/app/data/models/user_model.dart` to properly map additional fields:

- `profession` → `profile.jobTitle`
- `education` → `profile.school`
- `hometown` → `profile.hometown`
- `religion` → `profile.religious`
- `drinkingStatus` → `profile.drinkingStatus`
- `smokingStatus` → `profile.smokingStatus`
- `interestedIn` → `profile.lookingFor`

## 🎯 Data Flow

1. **Find Screen Initialization**
   - `FindController.onInit()` calls `fetchProfiles()`
   - Controller uses `MatchRepo.fetchMatches()`

2. **API Call**
   - `MatchRepo` calls `FindApiServices.fetchProfiles()`
   - Service makes GET request to `/match/potential`

3. **Response Processing**
   - Parse JSON into `PotentialMatchesResponse`
   - Convert each `PotentialMatch` to `UserModel`
   - Return list of `UserModel` objects

4. **UI Display**
   - `FindScreen` displays cards using `UserProfileWidget`
   - Each card shows: name, age, distance, location, interests, photos

## 🧪 Testing

Created comprehensive tests in `/test/potential_matches_test.dart`:

- JSON parsing validation
- Model conversion accuracy
- Data integrity checks

All tests pass ✅

## 🎨 UI Features

The Find screen now displays:

- **Profile Photos**: Main image + gallery photos
- **Basic Info**: Name, age, gender icon
- **Location**: Address with distance
- **Interests**: Chips showing user interests (up to 5)
- **Bio**: User description
- **Verification Status**: If applicable

## 🔧 Configuration

Make sure your API endpoint is correctly configured:

```dart
// In api_endpoints.dart
static String get getPotentialMatches => '$baseUrl/match/potential';
```

## 🚀 Usage

The implementation is automatic. When users open the Find screen:

1. App fetches potential matches from your API
2. Displays them as swipeable cards
3. Users can swipe left (pass) or right (like)
4. Swipe actions are sent to `/match/action` endpoint

## 📝 Notes

- **Image URLs**: All photo paths are prefixed with `ApiEndpoints.rootUrl`
- **Distance**: Displayed in km as provided by your API
- **Coordinates**: Stored as [longitude, latitude] format
- **Hidden Fields**: Respected based on user privacy settings
- **Error Handling**: Graceful fallbacks for missing data

## 🔄 Future Enhancements

Consider implementing:

- Pagination for loading more matches
- Filter options (age, distance, interests)
- Advanced matching algorithms
- Real-time updates for new matches

## 🐛 Debugging

Enable detailed logging by checking the console for messages starting with:

- `Potential matches API response received`
- `Successfully parsed X profiles`
- `User interests:`, `User photos:`

The system provides comprehensive debugging information to help troubleshoot any issues with the API integration.
