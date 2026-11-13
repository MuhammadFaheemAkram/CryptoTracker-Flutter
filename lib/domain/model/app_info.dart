import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_info.freezed.dart';

/// The app's name and version, read from the platform once at launch (the
/// About section).
@freezed
abstract class AppInfo with _$AppInfo {
  const factory AppInfo({
    required String name,
    required String version,
    required String buildNumber,
  }) = _AppInfo;
}
