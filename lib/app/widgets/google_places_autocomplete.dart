import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:dot_connections/app/core/utils/app_utils.dart';
import 'package:dot_connections/app/core/utils/text_style.dart';

class GooglePlacesAutocomplete extends StatefulWidget {
  final TextEditingController controller;
  final Function(Map<String, dynamic>) onPlaceSelected;
  final String? hint;

  const GooglePlacesAutocomplete({
    super.key,
    required this.controller,
    required this.onPlaceSelected,
    this.hint,
  });

  @override
  State<GooglePlacesAutocomplete> createState() =>
      _GooglePlacesAutocompleteState();
}

class _GooglePlacesAutocompleteState extends State<GooglePlacesAutocomplete> {
  final _focusNode = FocusNode();
  final _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  List<Map<String, dynamic>> _predictions = [];
  bool _isLoading = false;
  Timer? _debounceTimer;

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

  void _onSearchChanged() {
    final query = widget.controller.text;
    if (query.isEmpty) {
      _predictions = [];
      _updateOverlay();
      return;
    }

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () async {
      setState(() => _isLoading = true);
      _predictions = await _getPlacePredictions(query);
      setState(() => _isLoading = false);
      _updateOverlay();
    });
  }

  Future<List<Map<String, dynamic>>> _getPlacePredictions(String input) async {
    if (input.isEmpty) return [];

    try {
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json'
        '?input=$input'
        '&key=${AppUtils.googleMapApiKey}'
        '&components=country:bd',
      );

      final response = await http.get(url);
      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        return List<Map<String, dynamic>>.from(data['predictions']);
      }
      return [];
    } catch (e) {
      debugPrint('Error getting predictions: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> _getPlaceDetails(String placeId) async {
    try {
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json'
        '?place_id=$placeId'
        '&key=${AppUtils.googleMapApiKey}',
      );

      final response = await http.get(url);
      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        return data['result'] as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      debugPrint('Error getting place details: $e');
      return null;
    }
  }

  void _showOverlay() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height,
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(12.r),
              bottomRight: Radius.circular(12.r),
            ),
            child: Container(
              constraints: BoxConstraints(maxHeight: 200.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12.r),
                  bottomRight: Radius.circular(12.r),
                ),
              ),
              child: _isLoading
                  ? Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.r),
                        child: const CircularProgressIndicator(),
                      ),
                    )
                  : _predictions.isEmpty
                  ? const SizedBox.shrink()
                  : ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: _predictions.length,
                      itemBuilder: (context, index) {
                        final prediction = _predictions[index];
                        final mainText =
                            prediction['structured_formatting']?['main_text'] ??
                            prediction['description'];
                        final secondaryText =
                            prediction['structured_formatting']?['secondary_text'];

                        return InkWell(
                          onTap: () async {
                            final placeId = prediction['place_id'];
                            final details = await _getPlaceDetails(placeId);
                            if (details != null) {
                              widget.controller.text =
                                  prediction['description'];
                              widget.onPlaceSelected({
                                ...prediction,
                                ...details,
                              });
                              _hideOverlay();
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 20.r,
                                  color: Colors.grey.shade600,
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        mainText,
                                        style: AppTextStyle.primaryTextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      if (secondaryText != null) ...[
                                        SizedBox(height: 2.h),
                                        Text(
                                          secondaryText,
                                          style: AppTextStyle.primaryTextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
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
    _overlayEntry?.markNeedsBuild();
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
          hintText: widget.hint ?? 'Search location',
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
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 12.h,
          ),
        ),
      ),
    );
  }
}
