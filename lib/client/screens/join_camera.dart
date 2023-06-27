import 'package:ecclesia_ui/client/widgets/custom_appbar.dart';
import 'package:ecclesia_ui/client/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

// Screen to use camera to scan QR code to
// either join an organization or an election.

class JoinCamera extends StatefulWidget {
  final bool isElection;
  const JoinCamera({super.key, required this.isElection});

  @override
  State<JoinCamera> createState() => _JoinCameraState();
}

class _JoinCameraState extends State<JoinCamera> {
  MobileScannerController cameraController = MobileScannerController();
  final bool _screenOpened = false;

  bool _visible = true;
  bool _fetching = false;
  String _scannedString = "Place QR code in the camera view";

  XFile? _image;

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
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        // Here you can write your code for open new view
        _visible = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(back: true, disableBackGuard: true, disableMenu: false),
      endDrawer: const CustomDrawer(),
      body: Stack(
        alignment: Alignment.center,
        children: [
          MobileScanner(
            allowDuplicates: false,
            controller: cameraController,
            onDetect: (barcode, args) {
              String code = barcode.rawValue ?? "---";

              setState(() {
                _fetching = true;
              });

              if (widget.isElection && code == "joinElection") {
                Future.delayed(const Duration(seconds: 3), () {
                  // TODO: Implementation for joining election
                  context.go('/register-election/confirmation');
                });
              } else if (!widget.isElection && code == "joinOrganization") {
                Future.delayed(const Duration(seconds: 3), () {
                  // TODO: Implementation for joining organization
                  context.go('/register-organization/confirmation');
                });
              } else {
                Future.delayed(const Duration(seconds: 3), () {
                  setState(() {
                    _fetching = false;
                    _scannedString = "Invalid QR code. Please try another one";
                    _visible = true;
                  });

                  Future.delayed(const Duration(seconds: 3), () {
                    setState(() {
                      _visible = false;
                    });
                  });
                });
              }
            },
          ),
          AnimatedOpacity(
            opacity: _fetching ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 100),
            child: Container(
              color: Colors.black87,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
          ),
          Positioned(
            bottom: 20,
            child: AnimatedOpacity(
              opacity: _visible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(10),
                child: Text(_scannedString),
              ),
            ),
          ),
          AnimatedOpacity(
            opacity: _fetching ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 100),
            child: const Positioned(
              child: CircularProgressIndicator(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}

String _foundBarcode(Barcode barcode, MobileScannerArguments? args, BuildContext context) {
  return barcode.rawValue ?? "---";
}
