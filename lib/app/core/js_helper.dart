@JS()
library main;

import 'package:js/js_util.dart' as jsutil;
import 'package:js/js.dart';

@JS('classifyImage')
external List<Object> imageClassifier(String url);