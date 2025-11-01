import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserAvatarWidget extends StatelessWidget {
  final String? imageUrl;
  final String? userName;
  final double radius;
  final Color? backgroundColor;
  final Color? textColor;

  const UserAvatarWidget({
    super.key,
    this.imageUrl,
    this.userName,
    this.radius = 20,
    this.backgroundColor,
    this.textColor,
  });

  String _getInitials(String? name) {
    if (name == null || name.isEmpty) return '??';

    final words = name.trim().split(' ');
    if (words.length == 1) {
      return words[0].substring(0, words[0].length >= 2 ? 2 : 1).toUpperCase();
    } else {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    }
  }

  bool _isValidNetworkImage(String? url) {
    if (url == null || url.isEmpty) return false;
    // Only allow network URLs, no asset images
    return url.startsWith('http://') || url.startsWith('https://');
  }

  @override
  Widget build(BuildContext context) {
    final initials = _getInitials(userName);
    final isValidImage = _isValidNetworkImage(imageUrl);

    return CircleAvatar(
      radius: radius.r,
      backgroundColor: backgroundColor ?? Colors.grey[300],
      backgroundImage: isValidImage ? NetworkImage(imageUrl!) : null,
      onBackgroundImageError: isValidImage
          ? (exception, stackTrace) {
              debugPrint('Failed to load avatar image: $imageUrl');
            }
          : null,
      child: !isValidImage
          ? Text(
              initials,
              style: TextStyle(
                color: textColor ?? Colors.grey[700],
                fontSize: (radius * 0.6).sp,
                fontWeight: FontWeight.w600,
              ),
            )
          : null,
    );
  }
}

// Widget for handling image loading with fallback to initials
class SafeAvatarWidget extends StatefulWidget {
  final String? imageUrl;
  final String? userName;
  final double radius;
  final Color? backgroundColor;
  final Color? textColor;

  const SafeAvatarWidget({
    super.key,
    this.imageUrl,
    this.userName,
    this.radius = 20,
    this.backgroundColor,
    this.textColor,
  });

  @override
  State<SafeAvatarWidget> createState() => _SafeAvatarWidgetState();
}

class _SafeAvatarWidgetState extends State<SafeAvatarWidget> {
  bool _hasImageError = false;

  String _getInitials(String? name) {
    if (name == null || name.isEmpty) return '??';

    final words = name.trim().split(' ');
    if (words.length == 1) {
      return words[0].substring(0, words[0].length >= 2 ? 2 : 1).toUpperCase();
    } else {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    }
  }

  bool _isValidNetworkImage(String? url) {
    if (url == null || url.isEmpty) return false;
    // Only allow network URLs, no asset images
    return url.startsWith('http://') || url.startsWith('https://');
  }

  @override
  Widget build(BuildContext context) {
    final initials = _getInitials(widget.userName);
    final isValidImage =
        _isValidNetworkImage(widget.imageUrl) && !_hasImageError;

    return CircleAvatar(
      radius: widget.radius.r,
      backgroundColor: widget.backgroundColor ?? Colors.grey[300],
      child: isValidImage
          ? ClipOval(
              child: Image.network(
                widget.imageUrl!,
                width: (widget.radius * 2).r,
                height: (widget.radius * 2).r,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      setState(() {
                        _hasImageError = true;
                      });
                    }
                  });
                  return _buildInitialsWidget(initials);
                },
              ),
            )
          : _buildInitialsWidget(initials),
    );
  }

  Widget _buildInitialsWidget(String initials) {
    return Text(
      initials,
      style: TextStyle(
        color: widget.textColor ?? Colors.grey[700],
        fontSize: (widget.radius * 0.6).sp,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
