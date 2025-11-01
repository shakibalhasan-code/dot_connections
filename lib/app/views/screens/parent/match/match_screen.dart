import 'package:dot_connections/app/controllers/match_controller.dart';
import 'package:dot_connections/app/views/screens/parent/match/widgets/connection_request_item.dart';
import 'package:dot_connections/app/views/screens/parent/match/widgets/connection_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MatchScreen extends StatelessWidget {
  const MatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MatchController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Connections'),
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            leading: const SizedBox(),
            foregroundColor: Colors.black,
            actions: [
              TextButton(
                onPressed: controller.showSentRequestsBottomSheet,
                child: const Text(
                  'Sent',
                  style: TextStyle(
                    color: Colors.pink,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
            bottom: TabBar(
              controller: controller.tabController,
              indicatorColor: Colors.pink,
              labelColor: Colors.pink,
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(text: 'Requests', icon: Icon(Icons.person_add)),
                Tab(text: 'Matches', icon: Icon(Icons.favorite)),
              ],
            ),
          ),
          backgroundColor: Colors.white,
          body: TabBarView(
            controller: controller.tabController,
            children: [
              // Connection Requests Tab
              Obx(() {
                if (controller.isLoadingRequests.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.connectionRequests.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 80,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No connection requests',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'When someone sends you a request, it will appear here',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: controller.loadConnectionRequests,
                  child: ListView.builder(
                    itemCount: controller.connectionRequests.length,
                    itemBuilder: (context, index) {
                      final request = controller.connectionRequests[index];
                      return ConnectionRequestItem(request: request);
                    },
                  ),
                );
              }),

              // Connections Tab
              Obx(() {
                if (controller.isLoadingConnections.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.connections.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.favorite_border,
                          size: 80,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No matches yet',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'When you match with someone, they will appear here',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: controller.loadConnections,
                  child: ListView.builder(
                    itemCount: controller.connections.length,
                    itemBuilder: (context, index) {
                      final connection = controller.connections[index];
                      return ConnectionItem(connection: connection);
                    },
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
