import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraSCreen extends StatefulWidget {
  @override
  _CameraSCreenState createState() => _CameraSCreenState();
}

class _CameraSCreenState extends State<CameraSCreen> {
  CameraController cameraController;
  List listCameras;
  int cameraIndex;
  @override
  void initState() {
    super.initState();
    availableCameras().then((value) {
      listCameras = value;
      if(listCameras.length>0){}
      setState(() {
        cameraIndex = 0;
      });
       _initCameraController(listCameras[cameraIndex]).then((void v) {});
    });
   
  }

  Future _initCameraController(CameraDescription cameraDescription) async {
    if (cameraController != null) {
      await cameraController.dispose();
    }
    cameraController =
        CameraController(cameraDescription, ResolutionPreset.high);

    cameraController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    try {
      await cameraController.initialize();
    } on Exception catch (exception) {
      print(exception);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _switchCamera() {
    cameraIndex = cameraIndex < listCameras.length - 1 ? cameraIndex + 1 : 0;
    CameraDescription cameraDescription = listCameras[cameraIndex];
    _initCameraController(cameraDescription);
  }

  Widget _cameraPrivew() {
    if (cameraController == null || !cameraController.value.isInitialized) {
      return const Text('IMage HEre');
    }
    return AspectRatio(
      aspectRatio: cameraController.value.aspectRatio,
      child: CameraPreview(cameraController),
    );
  }

  Widget __cameraWidget() {
    return Expanded(
        child: FlatButton(
      onPressed: () {
        _switchCamera();
      },
      child: Icon(Icons.switch_camera),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('CameraApp'),
        ),
        body: Column(
          children: [
            Expanded(
              child: _cameraPrivew(),
            ),
            __cameraWidget()
          ],
        ));
  }
}
