@JS()
library main;

import 'package:js/js.dart';

@JS('classifyImage')
external List<Object> imageClassifier(String url);