# Profile Gallery Image Upload

This guide explains how to use the image upload functionality in the Dot Connections app.

## Single Image Upload

You can upload a single image to the user's profile gallery using the `AuthController`:

```dart
// Get the AuthController instance
final authController = Get.find<AuthController>();

// Upload a single image
await authController.uploadProfileGalleryImage(imagePath: '/path/to/image.jpg');
```

## Multiple Image Upload

For uploading multiple images, you can use either:

1. The `AuthController` directly:

```dart
// Get the AuthController instance
final authController = Get.find<AuthController>();

// Upload multiple images
await authController.uploadMultipleProfileGalleryImages(
  imagePaths: [
    '/path/to/image1.jpg',
    '/path/to/image2.jpg',
    '/path/to/image3.jpg',
  ],
);
```

2. Or the more powerful `GalleryController`:

```dart
// Get the GalleryController instance
final galleryController = Get.find<GalleryController>();
// Or create a new instance if not registered yet
// final galleryController = Get.put(GalleryController());

// Add images to the selection
galleryController.addSelectedImage('/path/to/image1.jpg');
galleryController.addSelectedImage('/path/to/image2.jpg');
galleryController.addSelectedImage('/path/to/image3.jpg');

// Upload all selected images
await galleryController.uploadMultipleGalleryImages();
```

## Example Implementation

We've provided an example view in `lib/app/views/examples/gallery_upload_example.dart` that demonstrates:

1. Selecting a single image from the gallery
2. Selecting multiple images from the gallery
3. Displaying selected images in a grid
4. Removing images from the selection
5. Uploading images to the server

To use this example:

```dart
// Navigate to the example screen
Get.to(() => GalleryUploadExample());
```

## Technical Details

The images are uploaded using a PATCH request with multipart/form-data format. The API endpoint expects:

- Field name: `data[photos]` for gallery images
- Multiple files can be uploaded with the same field name

The `ApiServices.patchFormDataWithFile` method is used to handle this type of request.

## Tips

- Images are compressed by default to optimize upload size (quality set to 80%)
- The first uploaded image will automatically be set as profile picture if the user doesn't have one
- The GalleryController provides more advanced features like tracking selected images, handling multiple uploads, and deleting images
