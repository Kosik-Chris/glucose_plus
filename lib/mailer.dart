library glucose_plus;

import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:mime/mime.dart';
import 'package:logging/logging.dart';

import 'mailing_files/util.dart';

part 'mailing_files/address.dart';
part 'mailing_files/envelope.dart';
part 'mailing_files/transport.dart';
part 'mailing_files/attachment.dart';
part 'mailing_files/sendmail_transport.dart';
part 'mailing_files/smtp/helper_options.dart';
part 'mailing_files/smtp/smtp_client.dart';
part 'mailing_files/smtp/smtp_options.dart';
part 'mailing_files/smtp/smtp_transport.dart';

var _logger = new Logger('glucose_plus');

printDebugInformation() {
  _logger.onRecord.listen(print);
}