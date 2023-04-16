import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfanityCheckerModel extends ChangeNotifier {
  Dio _dio = Dio();
  String _responseText = '';
  bool _isLoading = false;
  String safetyText = "Check";
  File? image = null;
  bool? _iserror = null;
  TextEditingController _textEditingController = TextEditingController();
  bool _isProfanity = false;

  get textEditingController => _textEditingController;

  get isLoading => _isLoading;

  get iserror => _iserror;

  get isProfanity => _isProfanity;

  Future<File> getImage() async {
    final pickedimage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    image = File(pickedimage!.path);
    return File(image!.path);
  }

  Future<void> submitImage() async {
    try {
      final imagePath = await getImage();

      // Create a FormData object containing the image file
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(imagePath.path),
      });

      // Set the request headers, including the RapidAPI key
      final headers = {
        'content-type': 'multipart/form-data',
        'X-RapidAPI-Key': '117956f7fdmshd3ef63433d6e4f9p1cf63ajsnc54bcd05084a',
        'X-RapidAPI-Host':
            'nsfw-images-detection-and-classification.p.rapidapi.com',
      };

      _isLoading = true;
      notifyListeners();

      // Send the request and wait for the response
      final response = await _dio.post(
        'https://nsfw-images-detection-and-classification.p.rapidapi.com/adult-content-file',
        data: formData,
        options: Options(
          headers: headers,
        ),
      );

      if (response.statusCode == 200) {
        // Set the response text
        if (response.data["unsafe"] == false) {
          safetyText = "Nothing Inappropriate ✌️";
        } else {
          safetyText = "Explicit Content 🫢 ";
        }
        _responseText = "Staus OK";
        _isLoading = false;
        _iserror = false;
      } else {
        _iserror = true;
        _isLoading = false;
        safetyText = 'Error: ${response.statusCode}';
      }
      notifyListeners();
    } catch (e) {
      image = null;
      notifyListeners();
    }
  }

  Future<void> checkProfanity() async {
    String input = _textEditingController.text;
    if (input.isNotEmpty) {
      var dio = Dio();
      var response = await dio.get(
        'https://www.purgomalum.com/service/containsprofanity',
        queryParameters: {'text': input},
      );

      if (response.data.toLowerCase() == 'true') {
        _isProfanity = true;
      } else {
        _isProfanity = false;
      }
      notifyListeners();
    }
  }
}
