import 'dart:io';
import "package:google_fonts/google_fonts.dart";
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Dio _dio = Dio();
  String _responseText = '';
  bool _isLoading = false;
  String safetyText = "Check";
  File? image = null;
  bool? _iserror = null;

  TextEditingController _textEditingController = TextEditingController();
  bool _isProfanity = false;
  Future<File> getImage() async {
    final pickedimage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    image = File(pickedimage!.path);
    return File(image!.path);
  }

  Future<void> _submitImage() async {
    final imagePath = await getImage();

    // Create a FormData object containing the image file
    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(imagePath.path),
    });

    // Set t he request headers, including the RapidAPI key
    final headers = {
      'content-type': 'multipart/form-data',
      'X-RapidAPI-Key': '117956f7fdmshd3ef63433d6e4f9p1cf63ajsnc54bcd05084a',
      'X-RapidAPI-Host':
          'nsfw-images-detection-and-classification.p.rapidapi.com',
    };

    setState(() {
      _isLoading = true;
    });

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
      setState(() {
        print(response.data);
        if (response.data["unsafe"] == false) {
          safetyText = "Nothing Inappropriate ✌️";
        } else {
          safetyText = "Explicit Content 🫢 ";
        }
        _responseText = "Staus OK";
        _isLoading = false;

        _iserror = false;
      });
    } else {
      setState(() {
        _iserror = true;
        _isLoading = false;

        safetyText = 'Error: ${response.statusCode}';
      });
    }
    print(_responseText);
  }

  Future<void> _checkProfanity() async {
    String input = _textEditingController.text;
    if (input.isNotEmpty) {
      var dio = Dio();
      var response = await dio.get(
          'https://www.purgomalum.com/service/containsprofanity',
          queryParameters: {'text': input});
      if (response.data.toLowerCase() == 'true') {
        setState(() {
          _isProfanity = true;
        });
      } else {
        setState(() {
          _isProfanity = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(4286622940),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // _isLoading
                //     ? CircularProgressIndicator()
                //     : ElevatedButton(
                //         onPressed: _submitImage,
                //         child: Text('Submit Image'),
                //       ),
                // SizedBox(height: 20),
                // Text(
                //   _responseText,
                //   style: TextStyle(
                //     fontSize: 18,
                //     fontWeight: FontWeight.bold,
                //     color: Colors.blue[900],
                //   ),
                // ),
                SizedBox(height: 20),
                Text("Profantiy Checker",
                    style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                      width: MediaQuery.of(context).size.width - 50,
                      height: 200,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: image != null
                                  ? Container(
                                      height: 100,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: DecorationImage(
                                              image: FileImage(image!),
                                              fit: BoxFit.cover)),
                                    )
                                  : const Align(
                                      alignment: Alignment.topLeft,
                                      child:
                                          Text("Click here to pick a image...",
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 102, 97, 97),
                                                fontWeight: FontWeight.w500,
                                              )),
                                    ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            GestureDetector(
                                onTap: () {
                                  _isLoading
                                      ? CircularProgressIndicator()
                                      : _submitImage();
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  width: double.infinity,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      color: const Color(4286622940),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Align(
                                      alignment: Alignment.center,
                                      child: _isLoading == false
                                          ? _iserror == true
                                              ? Text(
                                                  safetyText,
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.red,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )
                                              : Text(
                                                  safetyText,
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )
                                          : const CircularProgressIndicator()),
                                ))
                          ],
                        ),
                      )),
                ),
                SizedBox(
                  height: 100,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                      width: MediaQuery.of(context).size.width - 50,
                      height: 200,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: TextField(
                                controller: _textEditingController,
                                onChanged: (value) {
                                  _checkProfanity();
                                },
                                decoration: const InputDecoration(
                                  labelText:
                                      'Enter text to check for profanity',
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            GestureDetector(
                                onTap: () {
                                  _checkProfanity();
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  width: double.infinity,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      color: const Color(4286622940),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        _isProfanity
                                            ? 'Profanity Detected 🫢'
                                            : 'Input is clean ✌️',
                                        style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      )),
                                )),
                          ],
                        ),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
