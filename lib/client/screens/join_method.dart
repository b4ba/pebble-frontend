import 'dart:convert';
import 'dart:io';
import 'package:ecclesia_ui/client/screens/join_confirmation.dart';
import 'package:ecclesia_ui/client/widgets/custom_appbar.dart';
import 'package:ecclesia_ui/client/widgets/custom_drawer.dart';
import 'package:ecclesia_ui/data/models/election_model.dart';
import 'package:ecclesia_ui/services/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../data/models/choice_model.dart';

// Screen that allow the user to join an organization/election by
// inpuitting join code or using QR code.

class JoinMethod extends StatefulWidget {
  final bool isElection;
  const JoinMethod({Key? key, required this.isElection}) : super(key: key);

  @override
  State<JoinMethod> createState() => _JoinMethodState();
}

class _JoinMethodState extends State<JoinMethod> {
  XFile? _image;
  String inputCode = '';

  Future getImage(bool isCamera) async {
    XFile? image;

    ImagePicker picker = ImagePicker();

    if (isCamera) {
      image = await picker.pickImage(source: ImageSource.camera);
    } else {
      image = await picker.pickImage(source: ImageSource.gallery);
    }

    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
          back: true, disableBackGuard: true, disableMenu: false),
      endDrawer: const CustomDrawer(),
      bottomNavigationBar: _image == null
          ? null
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      context.go('/register-organization/confirmation');
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                    ),
                    child: const Text('Choose this picture'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _image = null;
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.black),
                    ),
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
          margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                    color: const Color.fromARGB(255, 211, 211, 211)
                        .withOpacity(0.5), //color of shadow
                    spreadRadius: 3, //spread radius
                    blurRadius: 7, // blur radius
                    offset: const Offset(0, 6)),
              ]),
          child: _image != null
              ? Image.file(
                  File(_image!.path),
                  height: 500,
                  width: double.infinity,
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          widget.isElection
                              ? 'Register to an election using a joining link:'
                              : 'Register to an organization by:',
                          textAlign: TextAlign.center,
                        ),
                        Container(
                          height: 60,
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          // Text field to join using join code
                          child: TextField(
                              onChanged: ((value) {
                                setState(() {
                                  inputCode = value;
                                });
                              }),
                              decoration: const InputDecoration(
                                // labelText: 'Input joining link here',
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6)),
                                  borderSide:
                                      BorderSide(width: 0, color: Colors.white),
                                ),
                                fillColor: Color.fromARGB(255, 217, 217, 217),
                                filled: true,
                                labelStyle:
                                    TextStyle(color: Colors.grey, fontSize: 14),
                              )),
                        ),
                        // Button to submit join code
                        ElevatedButton(
                          onPressed: () async {
                            if (widget.isElection) {
                              final response = await http.get(Uri.parse(
                                  'http://localhost:8080/api/election/info/$inputCode'));
                              final data = jsonDecode(response.body);

                              DateFormat format =
                                  DateFormat("yyyy-MM-ddTHH:mm:ssZ");

                              // List<Choice> choices = data['choices']
                              //     .map<Choice>((choice) => Choice(
                              //           title: choice.toString(),
                              //           description: '$choice description',
                              //           numberOfVote: 0,
                              //         ))
                              //     .toList();

                              // final elec = Election(
                              //     title: data['title'],
                              //     description: data['description'],
                              //     organization: 'organization',
                              //     startTime: format.parse((data['castStart'])),
                              //     endTime: format.parse((data['tallyStart'])));

                              // storeSecureJson('electionToJoin', elec.toJson());
                              storeSecure('electionToJoinKey', inputCode);

                              if (response.statusCode == 200) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => JoinConfirmation(
                                        isElection: true, inputCode: inputCode),
                                  ),
                                );
                                // context.go('/register-election/confirmation');
                              } else {
                                throw Exception('Failed to fetch data');
                              }
                            } else {
                              // TODO: This is hard-coded and should be change
                              if (inputCode == 'edinburghuni432') {
                                context
                                    .go('/register-organization/confirmation');
                              }
                            }
                          },
                          child: const Text('Register'),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 70,
                      child: Center(
                        child: Text(
                          'OR',
                          style: TextStyle(fontWeight: FontWeight.w700),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Button to scan QR code using camera
                        ElevatedButton(
                          onPressed: () {
                            if (widget.isElection) {
                              context.go('/register-election/camera');
                            } else {
                              context.go('/register-organization/camera');
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.black),
                          ),
                          child: const Text(
                            'Scan QR code using camera',
                          ),
                        ),

                        // Comment this in to enable scanning from gallery

                        // ElevatedButton(
                        //   onPressed: () {
                        //     debugPrint('Gallery Open');
                        //     getImage(false);
                        //   },
                        //   style: ButtonStyle(
                        //     backgroundColor: MaterialStateProperty.all(Colors.black),
                        //   ),
                        //   child: const Text(
                        //     'Scan QR code using gallery',
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
