import 'dart:io';

import 'package:camera/camera.dart';
import 'package:image/image.dart' as image_lib;
import 'package:path_provider/path_provider.dart';

/// ImageUtils
class ImageUtils {
  /// Converts a [CameraImage] in YUV420 format to [image_lib.Image] in RGB format
  static image_lib.Image? convertCameraImageToBin(CameraImage cameraImage) {
    if (cameraImage.format.group == ImageFormatGroup.yuv420) {
      return convertRGBToBinImage(convertYUV420ToImage(cameraImage));
    } else if (cameraImage.format.group == ImageFormatGroup.bgra8888) {
      return convertRGBToBinImage(convertBGRA8888ToImage(cameraImage));
    } else {
      return null;
    }
  }

  static image_lib.Image convertRGBToBinImage(image_lib.Image src) {
    final p = src.getBytes();
    for (var i = 0, len = p.length; i < len; i += 4) {
      final grey = image_lib.getLuminanceRgb(p[i], p[i + 1], p[i + 2]);
      final int l = grey > (.45 * 255) ? 255 : 0;
      p[i] = l;
      p[i + 1] = l;
      p[i + 2] = l;
    }
    return image_lib.Image.fromBytes(src.width, src.height, p);
    // return src;
  }

  /// Converts a [CameraImage] in BGRA888 format to [image_lib.Image] in RGB format
  static image_lib.Image convertBGRA8888ToImage(CameraImage cameraImage) {
    image_lib.Image img = image_lib.Image.fromBytes(
        cameraImage.planes[0].width!,
        cameraImage.planes[0].height!,
        cameraImage.planes[0].bytes,
        format: image_lib.Format.bgra);
    return img;
  }

  /// Converts a [CameraImage] in YUV420 format to [image_lib.Image] in RGB format
  static image_lib.Image convertYUV420ToImage(CameraImage cameraImage) {
    final int width = cameraImage.width;
    final int height = cameraImage.height;

    final int uvRowStride = cameraImage.planes[1].bytesPerRow;
    final int uvPixelStride = cameraImage.planes[1].bytesPerPixel!;

    final image = image_lib.Image(width, height);

    for (int w = 0; w < width; w++) {
      for (int h = 0; h < height; h++) {
        final int uvIndex =
            uvPixelStride * (w / 2).floor() + uvRowStride * (h / 2).floor();
        final int index = h * width + w;

        final y = cameraImage.planes[0].bytes[index];
        final u = cameraImage.planes[1].bytes[uvIndex];
        final v = cameraImage.planes[2].bytes[uvIndex];

        image.data[index] = ImageUtils.yuv2rgb(y, u, v);
      }
    }

    return image;
  }

  /// Convert a single YUV pixel to RGB
  static int yuv2rgb(int y, int u, int v) {
    // Convert yuv pixel to rgb
    int r = (y + v * 1436 / 1024 - 179).round();
    int g = (y - u * 46549 / 131072 + 44 - v * 93604 / 131072 + 91).round();
    int b = (y + u * 1814 / 1024 - 227).round();

    // Clipping RGB values to be inside boundaries [ 0 , 255 ]
    r = r.clamp(0, 255);
    g = g.clamp(0, 255);
    b = b.clamp(0, 255);

    return 0xff000000 |
        ((b << 16) & 0xff0000) |
        ((g << 8) & 0xff00) |
        (r & 0xff);
  }

  static Future<String> saveImage(image_lib.Image image, [int i = 0]) async {
    List<int> jpeg = image_lib.JpegEncoder().encodeImage(image);
    final appDir = await getTemporaryDirectory();
    final appPath = appDir.path;
    final fileOnDevice = File('$appPath/out$i.jpg');
    await fileOnDevice.writeAsBytes(jpeg, flush: true);
    return "$appPath/out$i.jpg";
  }
}
