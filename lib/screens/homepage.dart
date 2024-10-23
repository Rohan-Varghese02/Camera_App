import 'dart:io';
import 'package:camera_app/screens/fullscreen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<File> _images = [];
  final imagePicker = ImagePicker();

  Future getImage() async {
    final image = await imagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String appDirPath = appDir.path;
      final String folderPath = '$appDirPath/MyImages';
      // Create the custom folder if it doesn't exist
      final Directory customDir = Directory(folderPath);
      if (!customDir.existsSync()) {
        customDir.createSync();
      }
      // Create a new image file in the custom directory
      final String newPath =
          '$folderPath/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final File newImage = await File(image.path).copy(newPath);

      setState(() {
        _images.add(newImage);
      });
    }
  }

  Future<void> loadImages() async {
    final Directory appDir = await getApplicationDocumentsDirectory();
    final String folderPath = '${appDir.path}/MyImages';
    final Directory customDir = Directory(folderPath);

    // List all the files in the directory
    final List<FileSystemEntity> files = customDir.listSync();

    // Filter the files to include only image files (jpg, png)
    final List<File> images = files
        .where(
            (file) => file.path.endsWith('.jpg') || file.path.endsWith('.png'))
        .map((file) => File(file.path))
        .toList();

    setState(() {
      _images = images;
    });
  }

  Future<void> deleteImage(File image) async {
    if (image.existsSync()) {
      await image.delete();
    }
    setState(() {
      _images.remove(image);
    });
  }

  @override
  void initState() {
    super.initState();
    loadImages(); // Load images when the app starts
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Photos'),
      ),
      body: _images.isEmpty
          ? const Center(child: Text('No images available'))
          : GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, 
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
              ),
              itemCount: _images.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    _showFullScreenImage(_images[index]);
                  },
                  onLongPress: () {
                    _showDeleteDialog(_images[index]);
                  },
                  child: Image.file(
                    _images[index],
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.camera_alt),
      ),
    );
  }

  void _showDeleteDialog(File image) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Image'),
          content: const Text('Are you sure you want to delete this image?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                deleteImage(image);
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showFullScreenImage(File image) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImageView(image: image),
      ),
    );
  }
}
