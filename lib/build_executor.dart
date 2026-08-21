import 'dart:io';

import 'package:path/path.dart';

import 'config.dart';
import 'logger.dart';

const String _logPrefix = 'Build starter records';

Logger logger = Logger()
  ..isDebug = true
  ..tag = 'BuildStarter';

class BuildExecutor {
  BuildExecutor(this.config);

  final Config config;

  void start() {
    logger.debug('[start] $_logPrefix for project: $projectRootPath');

    final File backPubspec = File(config.output);
    if (!backPubspec.existsSync()) {
      _log('${backPubspec.path} not exist, start backup.');
      _backupPubspecYaml();
    } else {
      if (backPubspec.readAsStringSync().trim().isEmpty) {
        _log(
          '${backPubspec.path} exist, but the content is empty, start backup.',
        );
        _backupPubspecYaml();
      } else {
        _log(
          '${backPubspec.path} exist, and the content is not empty, start rewrite to pubspec.yaml.',
        );
        _pubspecYamlFile().writeAsStringSync(backPubspec.readAsStringSync());
      }
    }
    logger.debug('[finish] $_logPrefix for project: $projectRootPath');
  }

  void _backupPubspecYaml() {
    final File backPubspec = File(config.output);
    backPubspec.writeAsStringSync(_pubspecYamlFile().readAsStringSync());
  }

  File get logFile =>
      File('.dart_tool$separator${config.type}_build_starter_log.txt');

  String get projectRootPath => config.src;

  String get prp => projectRootPath;

  File _pubspecYamlFile() {
    return File('$projectRootPath${separator}pubspec.yaml');
  }

  /// Write logs to the file
  /// Defaults to `.dart_tools/${config.type}_build_starter_log.txt'`
  void writeLog(Object text, {File? file}) {
    file ??= logFile;
    if (!file.existsSync()) {
      file.createSync(recursive: true);
    }
    file
      ..writeAsStringSync(DateTime.now().toString(), mode: FileMode.append)
      ..writeAsStringSync('  : $text', mode: FileMode.append)
      ..writeAsStringSync('\n', mode: FileMode.append);
  }

  void _log(String message, {bool console = true, bool file = true}) {
    if (console) {
      print(message);
    }
    if (file) {
      writeLog(message);
    }
  }
}
