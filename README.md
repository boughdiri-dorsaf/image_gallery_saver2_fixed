# image_gallery_saver

[![Build Status](https://travis-ci.org/hui-z/image_gallery_saver.svg?branch=master)](https://travis-ci.org/hui-z/image_gallery_saver#)
[![pub package](https://img.shields.io/pub/v/image_gallery_saver.svg)](https://pub.dartlang.org/packages/image_gallery_saver)
[![license](https://img.shields.io/github/license/mashape/apistatus.svg)](https://choosealicense.com/licenses/mit/)

## Attribution

Fork of image_gallery_saver2.

Fixed Android namespace issue for AGP 7.3+. Licensed under MIT (original license preserved).

## What This Package Fixes

### ⚠️ Unresolved reference: Registrar Error

The old plugin API (Registrar) was deprecated in Flutter plugins Kotlin v1 embedding.

Flutter now uses the new V2 plugin API, which no longer relies on Registrar.

That's why the original image_gallery_saver2 fails to compile on modern Flutter projects or Kotlin versions.

**Other notes:**
- Some input files use or override a deprecated API.
- Just a warning — nothing critical, but the Registrar error is what breaks the build.

This package fixes the Registrar error and ensures compatibility with modern Flutter projects.

---

We use the `image_picker` plugin to select images from the Android and iOS image library, but it can't save images to the gallery. This plugin can provide this feature.

## Usage

To use this plugin, add `image_gallery_saver2_fixed` as a dependency in your pubspec.yaml file. For example:
```yaml
dependencies:
  image_gallery_saver2_fixed: ^2.0.6
```

## iOS
Your project need create with swift.
Add the following keys to your Info.plist file, located in <project root>/ios/Runner/Info.plist:
 * NSPhotoLibraryAddUsageDescription - describe why your app needs permission for the photo library. This is called Privacy - Photo Library Additions Usage Description in the visual editor
 
 ##  Android
 You need to ask for storage permission to save an image to the gallery. You can handle the storage permission using [flutter_permission_handler](https://github.com/BaseflowIT/flutter-permission-handler).
 In Android version 10, Open the manifest file and add this line to your application tag
 ```
 <application android:requestLegacyExternalStorage="true" .....>
 ```

## Example Project

This package includes a complete example project that demonstrates all the features of the `image_gallery_saver2_fixed` plugin. The example is located in the `/example` directory and provides a working Flutter app with the following features:

### Example Features
- **Save Local Image**: Convert a Flutter widget to an image and save it to the gallery
- **Save Network Image**: Download and save images from URLs with custom quality and naming
- **Save Network GIF**: Download and save animated GIF files to the gallery
- **Save Network Video**: Download and save video files to the gallery
- **Permission Handling**: Automatic permission requests for storage access
- **User Feedback**: Toast notifications to show save results

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

### Example Dependencies

The example project uses these additional packages:
- `permission_handler`: For handling storage permissions
- `fluttertoast`: For showing user feedback
- `path_provider`: For accessing temporary directories
- `dio`: For downloading files from URLs

### Example Code Snippets

Saving an image from the internet, quality and name is option
``` dart
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
    }
  }
  
  _saveNetworkImage() async {
    var response = await Dio().get(
        "https://ss0.baidu.com/94o3dSag_xI4khGko9WTAnF6hhy/image/h%3D300/sign=a62e824376d98d1069d40a31113eb807/838ba61ea8d3fd1fc9c7b6853a4e251f94ca5f46.jpg",
        options: Options(responseType: ResponseType.bytes));
    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
        quality: 60,
        name: "hello");
    print(result);
  }
```

Saving file(ig: video/gif/others) from the internet
``` dart
  _saveNetworkGifFile() async {
    var appDocDir = await getTemporaryDirectory();
    String savePath = appDocDir.path + "/temp.gif";
    String fileUrl =
        "https://hyjdoc.oss-cn-beijing.aliyuncs.com/hyj-doc-flutter-demo-run.gif";
    await Dio().download(fileUrl, savePath);
    final result =
        await ImageGallerySaver.saveFile(savePath, isReturnPathOfIOS: true);
    print(result);
  }

  _saveNetworkVideoFile() async {
    var appDocDir = await getTemporaryDirectory();
    String savePath = appDocDir.path + "/temp.mp4";
    String fileUrl =
        "https://s3.cn-north-1.amazonaws.com.cn/mtab.kezaihui.com/video/ForBiggerBlazes.mp4";
    await Dio().download(fileUrl, savePath, onReceiveProgress: (count, total) {
      print((count / total * 100).toStringAsFixed(0) + "%");
    });
    final result = await ImageGallerySaver.saveFile(savePath);
    print(result);
  }
```
