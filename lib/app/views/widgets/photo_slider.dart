import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dot_connections/app/core/constants/api_endpoints.dart';

class PhotoSlider extends StatefulWidget {
  final List<String> photos;
  final double height;
  final double borderRadius;

  const PhotoSlider({
    Key? key,
    required this.photos,
    this.height = 400,
    this.borderRadius = 16,
  }) : super(key: key);

  @override
  State<PhotoSlider> createState() => _PhotoSliderState();
}

class _PhotoSliderState extends State<PhotoSlider> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPhoto() {
    if (_currentIndex < widget.photos.length - 1) {
      setState(() {
        _currentIndex++;
      });
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPhoto() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.photos.isEmpty) {
      return _buildPlaceholder();
    }

    return Container(
      height: widget.height.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius.r),
        color: Colors.grey[200],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius.r),
        child: Stack(
          children: [
            // Photo PageView
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemCount: widget.photos.length,
              itemBuilder: (context, index) {
                return _buildPhotoItem(widget.photos[index]);
              },
            ),

            // Story-style progress indicators at the top
            Positioned(
              top: 12.h,
              left: 12.w,
              right: 12.w,
              child: _buildProgressIndicators(),
            ),

            // Navigation areas (invisible tap areas)
            if (widget.photos.length > 1) ...[
              // Left tap area
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: MediaQuery.of(context).size.width * 0.3,
                child: GestureDetector(
                  onTap: _previousPhoto,
                  child: Container(color: Colors.transparent),
                ),
              ),
              // Right tap area
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                width: MediaQuery.of(context).size.width * 0.3,
                child: GestureDetector(
                  onTap: _nextPhoto,
                  child: Container(color: Colors.transparent),
                ),
              ),
            ],

            // Photo counter
            if (widget.photos.length > 1)
              Positioned(
                bottom: 12.h,
                right: 12.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    '${_currentIndex + 1}/${widget.photos.length}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Construct full URL if the photoUrl is a relative path
  String _getFullImageUrl(String photoUrl) {
    if (photoUrl.startsWith('/')) {
      return '${ApiEndpoints.rootUrl}$photoUrl';
    }
    return photoUrl;
  }

  Widget _buildPhotoItem(String photoUrl) {
    final fullUrl = _getFullImageUrl(photoUrl);

    // Debug print for troubleshooting
    debugPrint('PhotoSlider: Loading image from: $fullUrl');

    return CachedNetworkImage(
      imageUrl: fullUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        color: Colors.grey[300],
        child: Center(
          child: CircularProgressIndicator(
            color: Colors.purple,
            strokeWidth: 2.w,
          ),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        color: Colors.grey[300],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_not_supported,
              size: 48.h,
              color: Colors.grey[600],
            ),
            SizedBox(height: 8.h),
            Text(
              'Image not available',
              style: TextStyle(color: Colors.grey[600], fontSize: 14.sp),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicators() {
    return Row(
      children: List.generate(
        widget.photos.length,
        (index) => Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 2.w),
            height: 3.h,
            decoration: BoxDecoration(
              color: index <= _currentIndex
                  ? Colors.white
                  : Colors.white.withOpacity(0.4),
              borderRadius: BorderRadius.circular(1.5.r),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      height: widget.height.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius.r),
        color: Colors.grey[300],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person, size: 64.h, color: Colors.grey[600]),
          SizedBox(height: 8.h),
          Text(
            'No photos available',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
