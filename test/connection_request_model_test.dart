import 'package:flutter_test/flutter_test.dart';
import 'package:dot_connections/app/data/models/connection_request_model.dart';

void main() {
  group('Connection Request Model Tests', () {
    test('UserProfile should parse from JSON correctly', () {
      final json = {
        '_id': 'profile123',
        'userId': 'user123',
        'bio': 'Hello world',
        'gender': 'male',
        'interests': ['music', 'sports'],
        'jobTitle': 'Developer',
        'location': {
          'type': 'Point',
          'coordinates': [-74.0060, 40.7128],
          'address': 'New York, NY',
        },
        'photos': ['photo1.jpg', 'photo2.jpg'],
        'height': 180,
        'workplace': 'Tech Company',
        'hometown': 'Boston',
        'school': 'MIT',
        'studyLevel': 'Masters',
        'lookingFor': 'serious relationship',
      };

      final userProfile = UserProfile.fromJson(json);

      expect(userProfile.id, 'profile123');
      expect(userProfile.userId, 'user123');
      expect(userProfile.bio, 'Hello world');
      expect(userProfile.gender, 'male');
      expect(userProfile.interests, ['music', 'sports']);
      expect(userProfile.jobTitle, 'Developer');
      expect(userProfile.location.coordinates, [-74.0060, 40.7128]);
      expect(userProfile.location.address, 'New York, NY');
      expect(userProfile.photos, ['photo1.jpg', 'photo2.jpg']);
      expect(userProfile.height, 180);
    });

    test('ConnectionRequest should parse from JSON correctly', () {
      final json = {
        '_id': 'request123',
        'fromUserId': 'user123',
        'toUserId': 'user456',
        'status': 'pending',
        'createdAt': '2023-01-15T10:30:00.000Z',
        'updatedAt': '2023-01-15T10:30:00.000Z',
        'profile': {
          '_id': 'profile123',
          'userId': 'user123',
          'bio': 'Hello world',
          'interests': ['music'],
          'location': {
            'type': 'Point',
            'coordinates': [-74.0060, 40.7128],
            'address': 'New York, NY',
          },
        },
        'age': 25,
        'distance': 5.5,
      };

      final connectionRequest = ConnectionRequest.fromJson(json);

      expect(connectionRequest.id, 'request123');
      expect(connectionRequest.fromUserId, 'user123');
      expect(connectionRequest.toUserId, 'user456');
      expect(connectionRequest.status, 'pending');
      expect(connectionRequest.profile.userId, 'user123');
      expect(connectionRequest.age, 25);
      expect(connectionRequest.distance, 5.5);
      expect(
        connectionRequest.createdAt,
        DateTime.parse('2023-01-15T10:30:00.000Z'),
      );
    });

    test('Connection should parse from JSON correctly', () {
      final json = {
        '_id': 'connection123',
        'userIds': [
          {
            '_id': 'user1',
            'firstName': 'John',
            'lastName': 'Doe',
            'fullName': 'John Doe',
            'verified': true,
            'image': 'image1.jpg',
          },
          {
            '_id': 'user2',
            'firstName': 'Jane',
            'lastName': 'Smith',
            'fullName': 'Jane Smith',
            'verified': false,
          },
        ],
        'createdAt': '2023-01-15T10:30:00.000Z',
        'updatedAt': '2023-01-15T10:30:00.000Z',
      };

      final connection = Connection.fromJson(json);

      expect(connection.id, 'connection123');
      expect(connection.userIds.length, 2);
      expect(connection.userIds[0].id, 'user1');
      expect(connection.userIds[0].firstName, 'John');
      expect(connection.userIds[0].lastName, 'Doe');
      expect(connection.userIds[0].verified, true);
      expect(connection.userIds[1].id, 'user2');
      expect(connection.userIds[1].firstName, 'Jane');
      expect(connection.createdAt, DateTime.parse('2023-01-15T10:30:00.000Z'));
    });

    test('SentRequest should parse from JSON correctly', () {
      final json = {
        '_id': 'sent123',
        'fromUserId': 'user123',
        'toUserId': {
          '_id': 'target123',
          'firstName': 'Alice',
          'lastName': 'Johnson',
          'fullName': 'Alice Johnson',
          'verified': true,
        },
        'status': 'pending',
        'createdAt': '2023-01-15T10:30:00.000Z',
        'updatedAt': '2023-01-15T10:30:00.000Z',
      };

      final sentRequest = SentRequest.fromJson(json);

      expect(sentRequest.id, 'sent123');
      expect(sentRequest.fromUserId, 'user123');
      expect(sentRequest.toUserId.id, 'target123');
      expect(sentRequest.toUserId.firstName, 'Alice');
      expect(sentRequest.toUserId.lastName, 'Johnson');
      expect(sentRequest.status, 'pending');
      expect(sentRequest.createdAt, DateTime.parse('2023-01-15T10:30:00.000Z'));
    });

    test('LocationData should parse from JSON correctly', () {
      final json = {
        'type': 'Point',
        'coordinates': [-74.0060, 40.7128],
        'address': 'New York, NY',
      };

      final location = LocationData.fromJson(json);

      expect(location.type, 'Point');
      expect(location.coordinates, [-74.0060, 40.7128]);
      expect(location.address, 'New York, NY');
    });

    test('ConnectedUser should parse from JSON correctly', () {
      final json = {
        '_id': 'user123',
        'firstName': 'John',
        'lastName': 'Doe',
        'fullName': 'John Doe',
        'verified': true,
        'image': 'profile.jpg',
      };

      final connectedUser = ConnectedUser.fromJson(json);

      expect(connectedUser.id, 'user123');
      expect(connectedUser.firstName, 'John');
      expect(connectedUser.lastName, 'Doe');
      expect(connectedUser.fullName, 'John Doe');
      expect(connectedUser.verified, true);
      expect(connectedUser.image, 'profile.jpg');
    });
  });
}
