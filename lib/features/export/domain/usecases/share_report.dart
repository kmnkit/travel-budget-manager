import 'dart:io';

import 'package:share_plus/share_plus.dart';

/// Use case for sharing report files via the native share dialog
class ShareReport {
  /// Shares the given file with optional subject line
  ///
  /// [file] - The file to share
  /// [subject] - Optional subject text for sharing
  Future<void> call(File file, {String? subject}) async {
    await Share.shareXFiles(
      [XFile(file.path)],
      subject: subject,
    );
  }
}
