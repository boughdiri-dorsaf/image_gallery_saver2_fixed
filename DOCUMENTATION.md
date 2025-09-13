# image_gallery_saver2_fixed Documentation

## Table of Contents
1. [Overview](#overview)
2. [Installation](#installation)
3. [Platform Setup](#platform-setup)
4. [API Reference](#api-reference)
5. [Usage Examples](#usage-examples)
6. [Troubleshooting](#troubleshooting)
7. [Migration Guide](#migration-guide)
8. [Contributing](#contributing)

## Overview

`image_gallery_saver2_fixed` is a Flutter plugin that allows you to save images and files to the device's gallery/photos app. This package is a fixed version of `image_gallery_saver2` that resolves compatibility issues with modern Flutter projects.

### What This Package Fixes

- **Registrar Error**: Fixes the "Unresolved reference: Registrar" error that occurs with modern Flutter projects
- **AGP 7.3+ Compatibility**: Resolves Android namespace issues for Android Gradle Plugin 7.3+
- **Modern Flutter Support**: Ensures compatibility with the latest Flutter versions

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  image_gallery_saver2_fixed: ^2.0.6
```

Then run:
```bash
flutter pub get
```

## Platform Setup

### iOS Setup

1. **Swift Support**: Your iOS project must be created with Swift support.

2. **Info.plist Configuration**: Add the following key to your `Info.plist` file located at `<project_root>/ios/Runner/Info.plist`:

```xml
<key>NSPhotoLibraryAddUsageDescription</key>
<string>This app needs access to photo library to save images</string>
```

Or in the visual editor, add:
- **Key**: Privacy - Photo Library Additions Usage Description
- **Value**: This app needs access to photo library to save images

### Android Setup

1. **Permissions**: Add storage permission to your `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
```

2. **Legacy Storage (Android 10+)**: For Android 10 and above, add this to your application tag in `AndroidManifest.xml`:

```xml
<application
    android:requestLegacyExternalStorage="true"
    ...>
```

3. **Permission Handling**: Use a permission handler plugin like `permission_handler` to request permissions at runtime:

```dart
import 'package:permission_handler/permission_handler.dart';

// Request storage permission
await Permission.storage.request();
```

## API Reference

### ImageGallerySaver Class

#### Methods

##### `saveImage(Uint8List imageBytes, {int quality = 80, String? name, bool isReturnImagePathOfIOS = false})`

Saves an image to the device gallery.

**Parameters:**
- `imageBytes` (Uint8List, required): The image data as bytes
- `quality` (int, optional): Image quality (1-100), default: 80
- `name` (String?, optional): Custom name for the saved image
- `isReturnImagePathOfIOS` (bool, optional): Whether to return the file path on iOS, default: false

**Returns:** `Future<dynamic>` - A map containing:
```dart
{
  "isSuccess": bool,
  "filePath": String? // Only if isReturnImagePathOfIOS is true
}
```

##### `saveFile(String file, {String? name, bool isReturnPathOfIOS = false})`

Saves a file (image, video, gif, etc.) to the device gallery.

**Parameters:**
- `file` (String, required): Path to the file to save
- `name` (String?, optional): Custom name for the saved file
- `isReturnPathOfIOS` (bool, optional): Whether to return the file path on iOS, default: false

**Returns:** `Future<dynamic>` - A map containing:
```dart
{
  "isSuccess": bool,
  "filePath": String? // Only if isReturnPathOfIOS is true
}
```

## Usage Examples

### Basic Image Saving

```dart
import 'dart:typed_data';
import 'package:image_gallery_saver2_fixed/image_gallery_saver2_fixed.dart';

// Save image from bytes
Future<void> saveImage() async {
  Uint8List imageBytes = // your image data
  final result = await ImageGallerySaver.saveImage(imageBytes);
  print('Save result: $result');
}
```

### Save Image with Custom Quality and Name

```dart
Future<void> saveImageWithOptions() async {
  Uint8List imageBytes = // your image data
  
  final result = await ImageGallerySaver.saveImage(
    imageBytes,
    quality: 90,
    name: "my_custom_image",
  );
  
  if (result['isSuccess']) {
    print('Image saved successfully!');
  } else {
    print('Failed to save image');
  }
}
```

### Save Image from Network

```dart
import 'package:dio/dio.dart';

Future<void> saveNetworkImage() async {
  try {
    final dio = Dio();
    final response = await dio.get(
      'https://example.com/image.jpg',
      options: Options(responseType: ResponseType.bytes),
    );
    
    final result = await ImageGallerySaver.saveImage(
      Uint8List.fromList(response.data),
      quality: 85,
      name: "network_image",
    );
    
    print('Network image save result: $result');
  } catch (e) {
    print('Error saving network image: $e');
  }
}
```

### Save File (Video, GIF, etc.)

```dart
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

Future<void> saveVideoFile() async {
  try {
    // Download file first
    final dio = Dio();
    final tempDir = await getTemporaryDirectory();
    final filePath = '${tempDir.path}/video.mp4';
    
    await dio.download(
      'https://example.com/video.mp4',
      filePath,
      onReceiveProgress: (received, total) {
        print('Download progress: ${(received / total * 100).toStringAsFixed(0)}%');
      },
    );
    
    // Save to gallery
    final result = await ImageGallerySaver.saveFile(
      filePath,
      name: "my_video",
    );
    
    print('Video save result: $result');
  } catch (e) {
    print('Error saving video: $e');
  }
}
```

### Save Widget as Image

```dart
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';

class MyWidget extends StatelessWidget {
  final GlobalKey _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: _globalKey,
      child: Container(
        width: 200,
        height: 200,
        color: Colors.blue,
        child: Center(
          child: Text('Save me!'),
        ),
      ),
    );
  }

  Future<void> saveWidgetAsImage() async {
    try {
      RenderRepaintBoundary boundary = _globalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      
      ui.Image image = await boundary.toImage();
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      
      if (byteData != null) {
        final result = await ImageGallerySaver.saveImage(
          byteData.buffer.asUint8List(),
          name: "widget_screenshot",
        );
        print('Widget save result: $result');
      }
    } catch (e) {
      print('Error saving widget: $e');
    }
  }
}
```

## Troubleshooting

### Common Issues

#### 1. Permission Denied (Android)
**Problem**: App crashes or fails to save images
**Solution**: 
- Ensure storage permissions are granted
- Use `permission_handler` to request permissions at runtime
- Check if `requestLegacyExternalStorage` is set for Android 10+

#### 2. iOS Build Errors
**Problem**: Build fails on iOS
**Solution**:
- Ensure your iOS project uses Swift
- Add `NSPhotoLibraryAddUsageDescription` to Info.plist
- Clean and rebuild the project

#### 3. Registrar Error (Fixed in this package)
**Problem**: "Unresolved reference: Registrar" error
**Solution**: This package fixes this issue. If you still see it, ensure you're using `image_gallery_saver2_fixed` instead of the original package.

#### 4. File Not Found (iOS)
**Problem**: File path not found when saving
**Solution**:
- Ensure the file exists before calling `saveFile`
- Use absolute paths
- Check file permissions

### Debug Tips

1. **Check Permissions**: Always verify permissions are granted before saving
2. **Validate File Paths**: Ensure file paths are correct and files exist
3. **Handle Errors**: Wrap save operations in try-catch blocks
4. **Test on Real Devices**: Some features may not work in simulators

## Migration Guide

### From image_gallery_saver2

1. **Update pubspec.yaml**:
   ```yaml
   dependencies:
     # Remove this
     # image_gallery_saver2: ^2.0.5
     
     # Add this
     image_gallery_saver2_fixed: ^2.0.6
   ```

2. **Update imports**:
   ```dart
   // Change this
   import 'package:image_gallery_saver2/image_gallery_saver.dart';
   
   // To this
   import 'package:image_gallery_saver2_fixed/image_gallery_saver2_fixed.dart';
   ```

3. **No API Changes**: The API remains exactly the same, so no code changes are needed beyond the import.

### From image_gallery_saver (original)

1. **Update pubspec.yaml**:
   ```yaml
   dependencies:
     image_gallery_saver2_fixed: ^2.0.6
   ```

2. **Update imports**:
   ```dart
   import 'package:image_gallery_saver2_fixed/image_gallery_saver2_fixed.dart';
   ```

3. **API Changes**: The API is similar but check the method signatures for any differences.

## Contributing

This package is a fork of `image_gallery_saver2` with fixes for modern Flutter compatibility. If you find issues or want to contribute:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This package is licensed under the MIT License, preserving the original license from the parent project.

## Support

For issues related to this specific package, please check:
1. This documentation
2. The package's GitHub repository
3. Flutter's official documentation for plugin development

---

**Note**: This package fixes compatibility issues with modern Flutter projects. If you're experiencing build errors with the original `image_gallery_saver2`, this package should resolve them.
