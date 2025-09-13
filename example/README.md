# Image Gallery Saver Example

This example demonstrates how to use the `image_gallery_saver2_fixed` plugin to save images and files to the device's gallery.

## Features

This example app includes the following functionality:

- **Save Local Image**: Convert a Flutter widget to an image and save it to the gallery
- **Save Network Image**: Download an image from a URL and save it with custom quality and name
- **Save Network GIF**: Download an animated GIF file and save it to the gallery
- **Save Network Video**: Download a video file with progress tracking and save it to the gallery
- **Permission Handling**: Automatic permission requests for storage access
- **User Feedback**: Toast notifications to show save results

## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Android Studio / Xcode (for mobile development)
- A physical device or emulator

### Running the Example

1. **Navigate to the example directory**:
   ```bash
   cd example
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the example**:
   ```bash
   flutter run
   ```

### Platform Setup

#### Android
- Storage permissions are automatically requested
- The app handles Android 10+ scoped storage requirements

#### iOS
- Photo library access permission is required
- The app will prompt for permission when needed

## Code Examples

### Save Local Image
Converts a Flutter widget (RepaintBoundary) to an image and saves it to the gallery:

```dart
_saveLocalImage() async {
  RenderRepaintBoundary boundary =
      _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
  ui.Image image = await boundary.toImage();
  ByteData? byteData =
      await (image.toByteData(format: ui.ImageByteFormat.png));
  if (byteData != null) {
    final result =
        await ImageGallerySaver.saveImage(byteData.buffer.asUint8List());
    print(result);
    Utils.toast(result.toString());
  }
}
```

### Save Network Image
Downloads an image from a URL and saves it with custom quality and name:

```dart
_saveNetworkImage() async {
  var response = await Dio().get(
      "https://example.com/image.jpg",
      options: Options(responseType: ResponseType.bytes));
  final result = await ImageGallerySaver.saveImage(
      Uint8List.fromList(response.data),
      quality: 60,
      name: "hello");
  print(result);
  Utils.toast("$result");
}
```

### Save Network GIF
Downloads an animated GIF file and saves it to the gallery:

```dart
_saveNetworkGifFile() async {
  var appDocDir = await getTemporaryDirectory();
  String savePath = appDocDir.path + "/temp.gif";
  String fileUrl = "https://example.com/animation.gif";
  await Dio().download(fileUrl, savePath);
  final result =
      await ImageGallerySaver.saveFile(savePath, isReturnPathOfIOS: true);
  print(result);
  Utils.toast("$result");
}
```

### Save Network Video
Downloads a video file with progress tracking and saves it to the gallery:

```dart
_saveNetworkVideoFile() async {
  var appDocDir = await getTemporaryDirectory();
  String savePath = appDocDir.path + "/temp.mp4";
  String fileUrl = "https://example.com/video.mp4";
  await Dio().download(fileUrl, savePath, onReceiveProgress: (count, total) {
    print((count / total * 100).toStringAsFixed(0) + "%");
  });
  final result = await ImageGallerySaver.saveFile(savePath);
  print(result);
  Utils.toast("$result");
}
```

## Dependencies

The example uses these packages:

- `image_gallery_saver2_fixed`: The main plugin for saving to gallery
- `permission_handler`: For handling storage permissions
- `fluttertoast`: For showing user feedback
- `path_provider`: For accessing temporary directories
- `dio`: For downloading files from URLs

## Project Structure

```
lib/
├── main.dart          # Main application with UI and functionality
├── utils.dart         # Utility functions for permissions and toasts
└── dialog.dart        # Custom dialog components
```

## Troubleshooting

### Common Issues

1. **Permission Denied**: Make sure storage permissions are granted
2. **Network Errors**: Check your internet connection and URL validity
3. **File Not Found**: Ensure the file path exists before saving

### Debug Tips

- Check the console output for detailed error messages
- Use the toast notifications to see save results
- Test on a physical device for best results

## Learning More

This example demonstrates best practices for:
- Permission handling in Flutter
- Network file downloading
- Error handling and user feedback
- Widget to image conversion
- File management in Flutter

For more information about the plugin, see the main package documentation.
