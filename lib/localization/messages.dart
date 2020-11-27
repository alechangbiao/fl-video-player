// ignore_for_file: non_constant_identifier_names

import 'package:intl/intl.dart';

String get app_name {
  return Intl.message(
    'V2 Player',
    name: 'app_name',
    desc: 'The name of the app',
  );
}
