import 'dart:io';

import 'package:path/path.dart';
import 'package:yaml/yaml.dart';

/// config_file= priority low
class Config {
  Config({
    this.type = 'default',
    required this.params,
  });

  // factory Config.fromArgResults(ArgResults results) {
  //   final Config config = Config(params: {});
  //   config.refresh();
  //   return config;
  // }

  static const String defaultOutput = 'pubspec.zygote.yaml';
  static const String defaultConfigFile = 'cfg_build_starter.yaml';

  final String type;
  final Map<String, dynamic> params;
  late String src;

  /// 用来备份 pubspec.yaml
  late String output;

  late YamlMap? configFileOptions;
  late String configFilePath;

  void refresh() {
    String src = params['src'] as String? ?? '.';

    src = absolute(src);
    src = normalize(src);

    final String? cfgFile = params['config_file'];
    configFilePath =
        join(src, (cfgFile?.isEmpty ?? true) ? defaultConfigFile : cfgFile!);
    final File configFile = File(configFilePath);

    String? outputFile;

    YamlMap? yamlMap;
    if (configFile.existsSync()) {
      final String configFileText = configFile.readAsStringSync();
      yamlMap = loadYaml(configFileText) as YamlMap?;

      if (yamlMap != null) {
        outputFile ??= yamlMap['output'] as String?;
      }
    }

    outputFile = params['output'] as String? ?? outputFile;

    this.src = src;
    output = outputFile ?? defaultOutput;
    configFileOptions = yamlMap;
  }

  @override
  String toString() {
    return 'Config{'
        'src: $src, output: $output, config_file: $configFilePath '
        '}';
  }
}
