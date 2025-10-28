import 'dart:async';
import 'package:dot_connections/app/core/services/location_services.dart';
import 'package:dot_connections/app/core/utils/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LocationSearchField extends StatefulWidget {
  final TextEditingController controller;
  final void Function(Map<String, dynamic>) onPlaceSelected;

  const LocationSearchField({
    super.key,
    required this.controller,
    required this.onPlaceSelected,
  });

  @override
  State<LocationSearchField> createState() => _LocationSearchFieldState();
}

class _LocationSearchFieldState extends State<LocationSearchField> {
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  List<Map<String, dynamic>> _predictions = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _showOverlay();
      } else {
        _hideOverlay();
      }
    });

    widget.controller.addListener(_onSearchChanged);
  }

  // Add debounce timer
  Timer? _debounceTimer;

  void _onSearchChanged() async {
    final query = widget.controller.text;
    if (query.isEmpty) {
      setState(() {
        _predictions = [];
        _isLoading = false;
      });
      _updateOverlay();
      return;
    }

    // Cancel previous timer
    _debounceTimer?.cancel();

    // Set new timer
    _debounceTimer = Timer(const Duration(milliseconds: 300), () async {
      setState(() => _isLoading = true);
      _updateOverlay();

      try {
        _predictions = await LocationServices.getPlacePredictions(query);
      } catch (e) {
        print('Error getting predictions: $e');
        _predictions = [];
      }

      if (mounted) {
        setState(() => _isLoading = false);
        _updateOverlay();
      }
    });
  }

  void _showOverlay() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height + 4,
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height + 4),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8.r),
            child: Container(
              constraints: BoxConstraints(maxHeight: 200.h),
              child: _isLoading
                  ? Padding(
                      padding: EdgeInsets.all(8.r),
                      child: const Center(child: CircularProgressIndicator()),
                    )
                  : _predictions.isEmpty
                  ? const SizedBox.shrink()
                  : ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: _predictions.length,
                      itemBuilder: (context, index) {
                        final prediction = _predictions[index];
                        return ListTile(
                          title: Text(
                            prediction['description'] ?? '',
                            style: AppTextStyle.primaryTextStyle(),
                          ),
                          onTap: () {
                            widget.controller.text =
                                prediction['description'] ?? '';
                            widget.onPlaceSelected(prediction);
                            _hideOverlay();
                          },
                        );
                      },
                    ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _updateOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.markNeedsBuild();
    }
  }

  @override
  void dispose() {
    _hideOverlay();
    _focusNode.dispose();
    _debounceTimer?.cancel();
    widget.controller.removeListener(_onSearchChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextField(
        controller: widget.controller,
        focusNode: _focusNode,
        style: AppTextStyle.primaryTextStyle(),
        decoration: InputDecoration(
          hintText: 'Enter your location',
          hintStyle: AppTextStyle.primaryTextStyle(color: Colors.grey),
          prefixIcon: const Icon(Icons.search),
          suffixIcon: widget.controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    widget.controller.clear();
                    _predictions = [];
                    _updateOverlay();
                  },
                )
              : null,
        ),
      ),
    );
  }
}
