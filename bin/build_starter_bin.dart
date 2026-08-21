import 'package:args/args.dart';
import 'package:flutter_build_starter/build_executor.dart';
import 'package:flutter_build_starter/config.dart';
import 'package:flutter_build_starter/logger.dart';

const String _tag = 'build_starter_bin.dart';

void main(List<String> args) {
  print('#_tag -> $args');
  final ArgParser parser = ArgParser();

  const String defaultOutput = Config.defaultOutput;
  parser.addOption(
    'output',
    abbr: 'o',
    help: 'The backup file of pubspec.yaml. \n'
        "It's a relative path, the relative flutter root directory.\n"
        "If you don't specify it, the default path is $defaultOutput.\n",
  );
  parser.addOption(
    'src',
    abbr: 's',
    defaultsTo: '.',
    help: 'Flutter project root path',
  );

  parser.addFlag(
    'help',
    abbr: 'h',
    help: 'Help usage',
    defaultsTo: false,
    negatable: false,
  );

  parser.addFlag(
    'debug',
    abbr: 'd',
    help: 'debug info',
    defaultsTo: false,
    negatable: false,
  );

  final ArgResults results = parser.parse(args);

  Logger().isDebug = results['debug'] as bool;

  if (results.wasParsed('help')) {
    print(parser.usage);
    return;
  }

  final Map<String, Option> options = parser.options;
  final Map<String, dynamic> params = options.map((String key, Option o) {
    return MapEntry<String, dynamic>(key, results[key]);
  });

  final Config config = Config(params: params)..refresh();

  logger.debug('$_tag -> The config is: $config');

  final BuildExecutor builder = BuildExecutor(config);
  builder.start();
}
