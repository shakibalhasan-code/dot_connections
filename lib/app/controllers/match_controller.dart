import 'package:dot_connections/app/core/utils/app_images.dart';
import 'package:dot_connections/app/data/models/match_model.dart';
import 'package:dot_connections/app/data/models/connection_request_model.dart';
import 'package:dot_connections/app/data/api/match_api_client.dart';
import 'package:dot_connections/app/views/screens/parent/match/widgets/match_profile_details.dart';
import 'package:dot_connections/app/core/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MatchController extends GetxController with GetTickerProviderStateMixin {
  late TabController tabController;

  final MatchApiClient _apiClient = MatchApiClient();

  // Observable lists for different data types
  final RxList<ConnectionRequest> connectionRequests =
      <ConnectionRequest>[].obs;
  final RxList<Connection> connections = <Connection>[].obs;
  final RxList<SentRequest> sentRequests = <SentRequest>[].obs;

  // Loading states
  final RxBool isLoadingRequests = false.obs;
  final RxBool isLoadingConnections = false.obs;
  final RxBool isLoadingSentRequests = false.obs;
  final RxBool isRespondingToRequest = false.obs;

  // Tab index
  final RxInt currentTabIndex = 0.obs;

  // Legacy matches for existing functionality
  final List<MatchProfile> matches = List.generate(
    6,
    (index) => MatchProfile(
      name: 'Lana',
      age: 26,
      distance: 0.5,
      imageUrl: AppImages.eleanorPena,
    ),
  );

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      currentTabIndex.value = tabController.index;
    });
    loadAllData();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  void loadAllData() {
    loadConnectionRequests();
    loadConnections();
  }

  Future<void> loadConnectionRequests() async {
    try {
      isLoadingRequests.value = true;
      final response = await _apiClient.getConnectionRequests();

      if (response['success'] == true) {
        final List<dynamic> data = response['data'] ?? [];
        connectionRequests.value = data
            .map((json) => ConnectionRequest.fromJson(json))
            .toList();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load connection requests: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingRequests.value = false;
    }
  }

  Future<void> loadConnections() async {
    try {
      isLoadingConnections.value = true;
      final response = await _apiClient.getConnections();

      if (response['success'] == true) {
        final List<dynamic> data = response['data'] ?? [];
        connections.value = data
            .map((json) => Connection.fromJson(json))
            .toList();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load connections: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingConnections.value = false;
    }
  }

  Future<void> loadSentRequests() async {
    try {
      isLoadingSentRequests.value = true;
      final response = await _apiClient.getSentRequests();

      if (response['success'] == true) {
        final List<dynamic> data = response['data'] ?? [];
        sentRequests.value = data
            .map((json) => SentRequest.fromJson(json))
            .toList();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load sent requests: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingSentRequests.value = false;
    }
  }

  Future<void> respondToConnectionRequest(
    String requestId,
    String action,
  ) async {
    try {
      isRespondingToRequest.value = true;
      final response = await _apiClient.respondToConnectionRequest(
        requestId,
        action,
      );

      if (response['success'] == true) {
        Get.snackbar(
          'Success',
          response['message'] ?? 'Request $action successfully',
          snackPosition: SnackPosition.BOTTOM,
        );

        // Refresh both lists since accepting creates a new connection
        await loadConnectionRequests();
        await loadConnections();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to $action request: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isRespondingToRequest.value = false;
    }
  }

  void showSentRequestsBottomSheet() {
    loadSentRequests();
    Get.bottomSheet(
      Container(
        height: Get.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Sent Requests',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Obx(() {
                if (isLoadingSentRequests.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (sentRequests.isEmpty) {
                  return const Center(
                    child: Text(
                      'No sent requests found',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: sentRequests.length,
                  itemBuilder: (context, index) {
                    final request = sentRequests[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: request.toUserId.image != null
                              ? NetworkImage(request.toUserId.image!)
                              : null,
                          child: request.toUserId.image == null
                              ? Text(
                                  request.toUserId.firstName
                                      .substring(0, 1)
                                      .toUpperCase(),
                                )
                              : null,
                        ),
                        title: Text(request.toUserId.fullName),
                        subtitle: Text('Status: ${request.status}'),
                        trailing: Icon(
                          request.toUserId.verified
                              ? Icons.verified
                              : Icons.person,
                          color: request.toUserId.verified
                              ? Colors.blue
                              : Colors.grey,
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  void navigateToChat(ConnectedUser user) {
    Get.toNamed(
      AppRoutes.conversation,
      arguments: {
        'partnerId': user.id,
        'partnerName': user.fullName,
        'partnerImage': user.image,
      },
    );
  }

  void onCardTapped(int index, BuildContext context) {
    matches[index].isBlurred = !matches[index].isBlurred;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ProfileDialog();
      },
    );
  }
}
