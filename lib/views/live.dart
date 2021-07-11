import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
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
  FlutterTts _tts;
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
      _controller = CameraController(
        widget.cameras[0],
        ResolutionPreset.veryHigh,
        enableAudio: false,
      );
      _initController = _controller.initialize();
    }

    _detector = GoogleMlKit.vision.textDetector();
    _tts = FlutterTts();

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
    _controller.lockCaptureOrientation(DeviceOrientation.portraitUp);

    _controller.startImageStream((CameraImage img) async {
      int time = DateTime.now().millisecondsSinceEpoch;

      if (time < _detecting) {
        return;
      }

      _detecting = time + 10000;
      processImage(img);
    });
  }

  void processImage(CameraImage img) async {
    int width = img.width;
    int height = img.height;

    if (Platform.isIOS) {
      width = img.planes[0].bytesPerRow ~/ 4;
    }

    List<dynamic> recognitions = await Tflite.detectObjectOnFrame(
      bytesList: img.planes.map((plane) => plane.bytes).toList(),
      model: 'SSDMobileNet',
      imageHeight: height,
      imageWidth: width,
      imageMean: 127.5,
      imageStd: 127.5,
      numResultsPerClass: 1,
      threshold: 0.4,
    );

    List<dynamic> elements = recognitions
        .where((element) => element['detectedClass'] == 'bus')
        .toList();

    if (elements.length < 1) {
      _detecting = DateTime.now().millisecondsSinceEpoch + 100;

      setState(() {
        _busNumber = 'Bus Not Found';
      });

      return;
    }

    imglib.Image image = imglib.Image(width, height);

    if (img.format.group == ImageFormatGroup.yuv420) {
      for (int x = 0; x < width; x++) {
        for (int y = 0; y < width * height; y += width) {
          int pixel = img.planes[0].bytes[x + y];
          image.data[x + y] =
              (0xFF << 24) | (pixel << 16) | (pixel << 8) | pixel;
        }
      }

      width = img.height;
      height = img.width;

      image = imglib.copyRotate(image, 90);
    } else if (img.format.group == ImageFormatGroup.bgra8888) {
      image = imglib.Image.fromBytes(
        width,
        height,
        img.planes[0].bytes,
        format: imglib.Format.bgra,
      );
    }

    dynamic element = elements[0]['rect'];
    image = imglib.copyCrop(
      image,
      (element['x'] * width).round(),
      (element['y'] * height).round(),
      (element['w'] * width).round(),
      (element['h'] * height).round(),
    );
    image = imglib.grayscale(image);
    image = imglib.contrast(image, 200);
    image = imglib.gaussianBlur(image, 1);

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

    String busNumber = 'Bus Unknown';

    RegExp regex = RegExp(r'^[A-Z]{0,2}[0-9]{1,3}[A-Za-z]?$');
    for (String text in result.text.replaceAll('\n', ' ').split(' ')) {
      if (regex.hasMatch(text)) {
        busNumber = text;
        break;
      }
    }

    await _tts.setLanguage('en-US');
    await _tts.stop();
    await _tts.speak('Bus $busNumber');

    _detecting = DateTime.now().millisecondsSinceEpoch + 1500;

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

              double scale = MediaQuery.of(context).size.aspectRatio *
                  _controller.value.aspectRatio;

              if (scale < 1) scale = 1 / scale;

              return Container(
                padding: EdgeInsets.only(top: 40),
                width: double.infinity,
                height: double.infinity,
                child: Transform.scale(
                  scale: scale,
                  child: Center(
                    child: CameraPreview(_controller),
                  ),
                ),
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
                  _busNumber,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _busNumber.startsWith('Bus ')
                        ? null
                        : CupertinoColors.systemRed,
                    fontSize: _busNumber.startsWith('Bus ') ? null : 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
