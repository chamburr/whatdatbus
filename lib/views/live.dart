import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image/image.dart' as imglib;
import 'package:tflite/tflite.dart';

import '../constants.dart';

class Live extends StatefulWidget {
  final List<CameraDescription> cameras;

  Live(this.cameras);

  @override
  _LiveState createState() => _LiveState();
}

class _LiveState extends State<Live> {
  CameraController _controller;
  Future<void> _initController;
  TextDetector _detector;
  int _detecting = 0;
  String _busNumber;

  @override
  void setState(state) {
    if (mounted) {
      super.setState(state);
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.cameras != null && widget.cameras.length >= 1) {
      _controller = CameraController(widget.cameras[0], ResolutionPreset.max);
      _initController = _controller.initialize();
    }

    _detector = GoogleMlKit.vision.textDetector();

    setState(() {
      _busNumber = '';
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      asyncInit();
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void asyncInit() async {
    if (widget.cameras == null || widget.cameras.length < 1) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text('Error'),
          content: Container(
            padding: EdgeInsets.only(top: 10),
            child: Text('No camera found'),
          ),
          actions: [
            CupertinoDialogAction(
              child: Text('Close'),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );

      return;
    }

    await Tflite.loadModel(
      model: 'assets/models/ssd_mobilenet.tflite',
      labels: 'assets/models/labels.txt',
    );

    await _initController;

    _controller.startImageStream((CameraImage img) async {
      int time = DateTime.now().millisecondsSinceEpoch;

      if (time - _detecting < 1000) {
        return;
      }

      _detecting = time + 10000;
      processImage(img);
    });
  }

  void processImage(CameraImage img) async {
    List<dynamic> recognitions = await Tflite.detectObjectOnFrame(
      bytesList: img.planes.map((plane) => plane.bytes).toList(),
      model: 'SSDMobileNet',
      imageHeight: img.height,
      imageWidth: img.width,
      imageMean: 127.5,
      imageStd: 127.5,
      numResultsPerClass: 1,
      threshold: 0.4,
    );

    List<dynamic> elements = recognitions
        .where((element) => element['detectedClass'] == 'bus')
        .toList();

    if (elements.length < 1) {
      _detecting = DateTime.now().millisecondsSinceEpoch;

      setState(() {
        _busNumber = 'Not Found';
      });

      return;
    }

    imglib.Image image = imglib.Image(img.width, img.height);

    if (img.format.group == ImageFormatGroup.yuv420) {
      for (int x = 0; x < image.width; x++) {
        for (int y = 0; y < img.height * img.width; y += img.width) {
          int pixel = img.planes[0].bytes[x + y];
          image.data[x + y] =
              (0xFF << 24) | (pixel << 16) | (pixel << 8) | pixel;
        }
      }
    } else if (img.format.group == ImageFormatGroup.bgra8888) {
      image = imglib.Image.fromBytes(
        img.width,
        img.height,
        img.planes[0].bytes,
        format: imglib.Format.bgra,
      );
    }

    dynamic element = elements[0]['rect'];
    image = imglib.copyCrop(
      image,
      (element['x'] * img.width).round(),
      (element['y'] * img.height).round(),
      (element['w'] * img.width).round(),
      (element['h'] * img.height).round(),
    );
    image = imglib.grayscale(image);
    image = imglib.contrast(image, 200);

    InputImage inputImage = InputImage.fromBytes(
      bytes: Uint8List.fromList(
        image.data.map((element) => element & 255).toList(),
      ),
      inputImageData: InputImageData(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        imageRotation: InputImageRotation.Rotation_0deg,
        inputImageFormat: InputImageFormat.YUV420,
        planeData: [
          InputImagePlaneMetadata(
            bytesPerRow: image.width,
            height: image.height,
            width: image.width,
          ),
        ],
      ),
    );

    RecognisedText result = await _detector.processImage(inputImage);

    String busNumber = 'Unknown';

    RegExp regex = RegExp(r'^[A-Z]{0,2}[0-9]{1,3}[A-Za-z]?$');
    for (String text in result.text.replaceAll('\n', ' ').split(' ')) {
      if (regex.hasMatch(text)) {
        busNumber = text;
        break;
      }
    }

    _detecting = DateTime.now().millisecondsSinceEpoch + 1000;

    setState(() {
      _busNumber = busNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(TITLE),
      ),
      child: Stack(
        children: [
          FutureBuilder<void>(
            future: _initController,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return Center(child: CupertinoActivityIndicator());
              }
              return Container(
                padding: EdgeInsets.only(top: 60),
                width: double.infinity,
                height: double.infinity,
                child: CameraPreview(_controller),
              );
            },
          ),
          SafeArea(
            top: false,
            minimum: EdgeInsets.all(40),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: _busNumber == '' ? 0 : double.infinity,
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                constraints: BoxConstraints(maxWidth: 500),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 0.75),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  _busNumber == '' ? '' : 'Bus $_busNumber',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
