import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class ImageService {
  static final ImagePicker _picker = ImagePicker();

  // Pick image from gallery
  static Future<File?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 800,
      );
      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      print('Error picking image: $e');
      return null;
    }
  }

  // Pick image from camera
  static Future<File?> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 800,
      );
      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      print('Error capturing image: $e');
      return null;
    }
  }

  // Save image to app directory and return file path
  static Future<String?> saveImageToAppDirectory(File imageFile) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final String fileName = 'product_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String path = join(directory.path, 'product_images', fileName);
      
      // Create directory if it doesn't exist
      await Directory(dirname(path)).create(recursive: true);
      
      // Copy the file to app directory
      final File savedImage = await imageFile.copy(path);
      return savedImage.path;
    } catch (e) {
      print('Error saving image: $e');
      return null;
    }
  }

  // Delete image file
  static Future<void> deleteImageFile(String? imagePath) async {
    if (imagePath != null && await File(imagePath).exists()) {
      try {
        await File(imagePath).delete();
      } catch (e) {
        print('Error deleting image file: $e');
      }
    }
  }

  // Check if file exists
  static Future<bool> imageFileExists(String? imagePath) async {
    if (imagePath == null) return false;
    return await File(imagePath).exists();
  }

  // Get image file from path
  static Future<File?> getImageFile(String? imagePath) async {
    if (imagePath == null) return null;
    if (await imageFileExists(imagePath)) {
      return File(imagePath);
    }
    return null;
  }
}