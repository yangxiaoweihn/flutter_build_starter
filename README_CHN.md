# flutter_build_starter

[English](README.md) | 中文文档
首次构建时备份和缓存`pubspec.yaml`文件，主要时是避免在接入资源处理的相关库[flutter_asset_proguard](https://github.com/yangxiaoweihn/flutter_asset_proguard),[flutter_asset_proguard](https://github.com/yangxiaoweihn/flutter_asset_encrypt)后多次构建可能导致的问题。
资源处理相关库在执行后会修改`pubspec.yaml`内容。