import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'model/state.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ProfanityCheckerPage(),
    );
  }
}

class ProfanityCheckerPage extends StatelessWidget {
  const ProfanityCheckerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfanityCheckerModel(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color(4286622940),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Consumer<ProfanityCheckerModel>(
                    builder: (context, model, child) {
                      return SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 20),
                            Text("Profantiy Checker",
                                style: GoogleFonts.poppins(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            const SizedBox(
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: model.image != null
                                              ? Container(
                                                  height: 100,
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      image: DecorationImage(
                                                          image: FileImage(
                                                              model.image!),
                                                          fit: BoxFit.cover)),
                                                )
                                              : const Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Text(
                                                      "Click here to pick a image...",
                                                      style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 102, 97, 97),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      )),
                                                ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                              model.isLoading
                                                  ? CircularProgressIndicator()
                                                  : model.submitImage();
                                            },
                                            child: Container(
                                              width: double.infinity,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                  color:
                                                      const Color(4286622940),
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              child: Align(
                                                  alignment: Alignment.center,
                                                  child: model.isLoading ==
                                                          false
                                                      ? model.iserror == true
                                                          ? Text(
                                                              model.safetyText,
                                                              style: GoogleFonts.poppins(
                                                                  color: Colors
                                                                      .red,
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            )
                                                          : Text(
                                                              model.safetyText,
                                                              style: GoogleFonts.poppins(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: TextField(
                                            controller:
                                                model.textEditingController,
                                            onChanged: (value) {
                                              model.checkProfanity();
                                            },
                                            decoration: const InputDecoration(
                                              labelText:
                                                  'Enter text to check for profanity',
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Container(
                                          width: double.infinity,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              color: const Color(4286622940),
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                model.isProfanity
                                                    ? "Profanity Detected !🫢"
                                                    : "All Good ! ✌️",
                                                style: GoogleFonts.poppins(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              )),
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
