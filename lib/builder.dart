import 'dart:async';

import 'package:build/build.dart';
import 'package:yaml/yaml.dart';

import 'build_executor.dart';
import 'config.dart';

Builder buildStarterBuilder(BuilderOptions options) {
  final Map<String, dynamic> p = options.config.map((String k, dynamic v) {
    if (v is YamlMap) {
      return MapEntry<String, dynamic>(
        k,
        v.map((dynamic k, dynamic v) => MapEntry<String, dynamic>(k, v)),
      );
    } else {
      return MapEntry<String, dynamic>(k, v);
    }
  });

  log.info('build_starter: config is=$p');

  return BuildStarterBuilder(p);
}

const String _m = '.dart_tool/generated/.build_starter_trigger_cache.dart';

class BuildStarterBuilder implements Builder {
  BuildStarterBuilder(this.params) {
    builders = params.entries.map((MapEntry<String, dynamic> entry) {
      final Config config = Config(params: entry.value, type: entry.key)
        ..refresh();
      return BuildExecutor(config);
    }).toList();

    if (builders.isEmpty) {
      log.info('build_starter: params is empty, set a default builder.');
      builders = <BuildExecutor>[
        BuildExecutor(Config(params: <String, dynamic>{})..refresh()),
      ];
    }
  }

  /// 做了分类
  final Map<String, dynamic> params;
  late List<BuildExecutor> builders;

  static int _buildCount = 0;

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    _buildCount++;
    print('🏗️  build-count: $_buildCount');

    final String timestamp = DateTime.now().toIso8601String();
    final String buildId =
        '${_buildCount}_${DateTime.now().millisecondsSinceEpoch}';

    // 生成构建信息
    final AssetId output = AssetId(buildStep.inputId.package, _m);

    await buildStep.writeAsString(output, '''
// GENERATED - Build #$_buildCount
// Build ID: $buildId
// Timestamp: $timestamp

class BuildInfo {
  static const int count = $_buildCount;
  static const String id = '$buildId';
  static const String timestamp = '$timestamp';
}
    ''');

    builders.map((BuildExecutor builder) {
      builder.start();
    }).toList();
    // return Future.delayed(Duration(seconds: 10));
    return Future<void>.value();
  }

  @override
  Map<String, List<String>> get buildExtensions => <String, List<String>>{
        'pubspec.yaml': <String>[_m],
      };
}
