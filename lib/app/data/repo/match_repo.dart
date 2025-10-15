import 'package:dot_connections/app/core/services/find_serverces.dart';
import 'package:dot_connections/app/data/models/user_model.dart';

class MatchRepo {
  final FindServices _findServices = FindServices();

  MatchRepo();

  /// Fetches a list of matched user profiles
  Future<List<UserModel>> fetchMatches() async {
    return await _findServices.fetchProfiles();
  }
}
