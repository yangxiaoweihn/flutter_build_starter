# flutter_build_starter

English | [中文文档](README_CHN.md)
During the initial build, back up and cache the `pubspec.yaml` file. This is mainly to avoid potential issues that may arise after multiple builds when integrating the asset processing libraries [flutter_asset_proguard](https://github.com/yangxiaoweihn/flutter_asset_proguard) and [flutter_asset_encrypt](https://github.com/yangxiaoweihn/flutter_asset_encrypt). 
These asset processing libraries will modify the content of `pubspec.yaml` after execution.