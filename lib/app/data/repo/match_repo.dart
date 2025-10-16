import 'package:dot_connections/app/core/services/find_api_serverces.dart';
import 'package:dot_connections/app/data/models/user_model.dart';

class MatchRepo {
  final FindApiServices _findApiServices = FindApiServices();

  MatchRepo();

  /// Fetches a list of matched user profiles
  Future<List<UserModel>> fetchMatches() async {
    return await _findApiServices.fetchProfiles();
  }
}
