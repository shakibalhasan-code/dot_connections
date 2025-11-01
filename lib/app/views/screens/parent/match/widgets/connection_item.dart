import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dot_connections/app/data/models/connection_request_model.dart';
import 'package:dot_connections/app/controllers/match_controller.dart';
import 'package:dot_connections/app/controllers/auth_controller.dart';
import 'package:dot_connections/app/core/constants/api_endpoints.dart';

class ConnectionItem extends StatelessWidget {
  final Connection connection;

  const ConnectionItem({super.key, required this.connection});

  ConnectedUser _getOtherUser() {
    final authController = Get.find<AuthController>();
    final currentUserId = authController.currentUser.value?.id;

    return connection.userIds.firstWhere(
      (user) => user.id != currentUserId,
      orElse: () => connection.userIds.first,
    );
  }

  String _getFullImageUrl(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) return '';
    if (imageUrl.startsWith('http')) return imageUrl;
    return '${ApiEndpoints.rootUrl}$imageUrl';
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MatchController>();
    final otherUser = _getOtherUser();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            image: otherUser.image != null
                ? DecorationImage(
                    image: NetworkImage(_getFullImageUrl(otherUser.image)),
                    fit: BoxFit.cover,
                  )
                : null,
            color: Colors.grey[300],
          ),
          child: otherUser.image == null
              ? Icon(Icons.person, color: Colors.grey[600], size: 25)
              : null,
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                otherUser.fullName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (otherUser.verified)
              Icon(Icons.verified, color: Colors.blue, size: 16),
          ],
        ),
        subtitle: Text(
          'Connected on ${_formatDate(connection.createdAt)}',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.pink,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'Chat',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        onTap: () => controller.navigateToChat(otherUser),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
