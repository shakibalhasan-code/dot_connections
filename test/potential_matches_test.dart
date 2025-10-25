import 'package:flutter_test/flutter_test.dart';
import 'package:dot_connections/app/data/models/potential_matches_response.dart';

void main() {
  group('PotentialMatchesResponse Tests', () {
    test('should parse JSON response correctly', () {
      // Mock JSON response data similar to what you provided
      final mockResponse = {
        "success": true,
        "message": "Potential matches retrieved successfully",
        "meta": {"page": 1, "limit": 10, "total": 6, "totalPage": 1},
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
                "address": "Dhaka, Bangladesh",
              },
              "lookingFor": "dating",
              "photos": [],
              "religious": "muslim",
              "school": "Tech University",
              "smokingStatus": "No",
              "studyLevel": "preferNotToSay",
              "workplace": "Mohakhali",
            },
            "age": 24,
            "distance": 0,
          },
        ],
      };

      // Parse the response
      final response = PotentialMatchesResponse.fromJson(mockResponse);

      // Verify the response was parsed correctly
      expect(response.success, true);
      expect(response.message, "Potential matches retrieved successfully");
      expect(response.meta.total, 6);
      expect(response.data.length, 1);

      // Check the first user
      final firstUser = response.data.first;
      expect(firstUser.id, "68be7282a0db89cc44e432d6");
      expect(firstUser.firstName, "Lina");
      expect(firstUser.lastName, "Rahman");
      expect(firstUser.fullName, "Lina Rahman");
      expect(firstUser.age, 24);
      expect(firstUser.distance, 0);

      // Check profile data
      expect(firstUser.profile.bio, "Test user 9");
      expect(firstUser.profile.gender, "male");
      expect(firstUser.profile.interests.length, 3);
      expect(firstUser.profile.interests, ["fitness", "movies", "travel"]);
      expect(firstUser.profile.jobTitle, "Developer");
      expect(firstUser.profile.location?.address, "Dhaka, Bangladesh");
      expect(firstUser.profile.location?.latitude, 23.8103);
      expect(firstUser.profile.location?.longitude, 90.4125);
    });

    test('should convert PotentialMatch to UserModel correctly', () {
      // Mock data
      final mockUserData = {
        "_id": "68be7282a0db89cc44e432d6",
        "email": "user8@example.com",
        "image": "/images/profile.jpg",
        "phoneNumber": "123456789",
        "lastLoginAt": "2025-09-08T06:07:23.096Z",
        "dateOfBirth": "2001-03-28T00:00:00.000Z",
        "firstName": "Lina",
        "lastName": "Rahman",
        "profile": {
          "_id": "68be741b610226cf5ddbbbf6",
          "userId": "68be7282a0db89cc44e432d6",
          "bio": "Test user 9",
          "drinkingStatus": "No",
          "gender": "female",
          "height": 177,
          "hometown": "Dhaka",
          "interests": ["fitness", "movies", "travel"],
          "jobTitle": "Developer",
          "location": {
            "type": "Point",
            "coordinates": [90.4125, 23.8103],
            "address": "Dhaka, Bangladesh",
          },
          "lookingFor": "dating",
          "photos": ["/images/photo1.jpg", "/images/photo2.jpg"],
          "religious": "muslim",
          "school": "Tech University",
          "smokingStatus": "No",
          "studyLevel": "preferNotToSay",
          "workplace": "Mohakhali",
        },
        "age": 24,
        "distance": 5.2,
      };

      // Parse to PotentialMatch
      final potentialMatch = PotentialMatch.fromJson(mockUserData);

      // Convert to UserModel
      final userModel = potentialMatch.toUserModel();

      // Verify conversion
      expect(userModel.id, "68be7282a0db89cc44e432d6");
      expect(userModel.name, "Lina Rahman");
      expect(userModel.email, "user8@example.com");
      expect(userModel.age, 24);
      expect(userModel.gender, "female");
      expect(userModel.phoneNumber, "123456789");
      expect(userModel.bio, "Test user 9");
      expect(userModel.profilePhotoUrl, "/images/profile.jpg");
      expect(userModel.photoUrls.length, 3); // main image + 2 photos
      expect(userModel.interests, ["fitness", "movies", "travel"]);
      expect(userModel.latitude, 23.8103);
      expect(userModel.longitude, 90.4125);
      expect(userModel.locationName, "Dhaka, Bangladesh");
      expect(userModel.distance, 5.2);
      expect(userModel.profession, "Developer");
      expect(userModel.education, "Tech University");
      expect(userModel.hometown, "Dhaka");
      expect(userModel.religion, "muslim");
      expect(userModel.drinkingStatus, "No");
      expect(userModel.smokingStatus, "No");
      expect(userModel.interestedIn, "dating");
    });
  });
}
