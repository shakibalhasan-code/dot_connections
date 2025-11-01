import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dot_connections/app/data/models/connection_request_model.dart';
import 'package:dot_connections/app/controllers/match_controller.dart';
import 'package:dot_connections/app/core/constants/api_endpoints.dart';

class ConnectionRequestItem extends StatelessWidget {
  final ConnectionRequest request;

  const ConnectionRequestItem({super.key, required this.request});

  String _getFullImageUrl(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) return '';
    if (imageUrl.startsWith('http')) return imageUrl;
    return '${ApiEndpoints.rootUrl}$imageUrl';
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MatchController>();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    image: request.profile.photos.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(
                              _getFullImageUrl(request.profile.photos.first),
                            ),
                            fit: BoxFit.cover,
                          )
                        : null,
                    color: Colors.grey[300],
                  ),
                  child: request.profile.photos.isEmpty
                      ? Icon(Icons.person, color: Colors.grey[600], size: 30)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${request.profile.jobTitle.isNotEmpty ? request.profile.jobTitle : 'Profile'}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(Icons.verified, color: Colors.blue, size: 16),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Age: ${request.age} • ${request.distance.toStringAsFixed(1)}km away',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      if (request.profile.workplace.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          'Works at ${request.profile.workplace}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            if (request.profile.bio.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                request.profile.bio,
                style: const TextStyle(fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            if (request.profile.interests.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: request.profile.interests.take(3).map((interest) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue[200]!),
                    ),
                    child: Text(
                      interest,
                      style: TextStyle(fontSize: 12, color: Colors.blue[700]),
                    ),
                  );
                }).toList(),
              ),
            ],
            const SizedBox(height: 16),
            Obx(
              () => Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: controller.isRespondingToRequest.value
                          ? null
                          : () => controller.respondToConnectionRequest(
                              request.id,
                              'reject',
                            ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[100],
                        foregroundColor: Colors.black,
                        elevation: 0,
                      ),
                      child: controller.isRespondingToRequest.value
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Decline'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: controller.isRespondingToRequest.value
                          ? null
                          : () => controller.respondToConnectionRequest(
                              request.id,
                              'accept',
                            ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        foregroundColor: Colors.white,
                      ),
                      child: controller.isRespondingToRequest.value
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text('Accept'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
