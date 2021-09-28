# Todo App | 
Learning Flutter

[![codecov](https://codecov.io/gh/prawana-perera/todos/branch/main/graph/badge.svg?token=MCE0I80Y4U)](https://codecov.io/gh/prawana-perera/todos)

## Tasks
See https://github.com/prawana-perera/todos/projects/1

Other setup todo:

Setup on app stores:
- https://play.google.com/console/about/internal-testing/
- https://developer.apple.com/testflight/

Code lint and analysis
- https://medium.com/geekculture/flutter-static-analysis-linting-5fb050128ead

Flutter CI/CD
- https://flutter.dev/docs/deployment/cd
- https://medium.com/flutter-community/automating-publishing-your-flutter-apps-to-google-play-using-github-actions-2f67ac582032

### Notes:

Set build versioning:
```shell
flutter build appbundle --build-name 1.0.1 --build-number 2 
```

Android Bundle Tool
Use it to test APKs locally. Download and add to make it easy to launc:
```shell
alias bundletool='java -jar <path_to_file>/bundletool-all-1.8.0.jar'
```
Set ANDROID paths
```shell
export ANDROID_HOME=~/Library/Android/sdk
export PATH=$PATH:${ANDROID_HOME}/platform-tools
```

Build apks:
```shell
bundletool build-apks \
--bundle=<path_to_app_bundle> \
--output=<path_to_generate_app_apks> \
--ks=<path_to_jks_keystore_used_to_sign_app_bundle> \
--ks-pass=pass:<ks_pwd> \
--ks-key-alias=<ks_alias_used_to_sign_app_bundle> \
--key-pass=<pwd_for_alias_used_to_sign_app_bundle>
```

Install APK to device:
```shell
bundletool install-apks \
--apks=<path_to_generated_app_apks_from_buildtool>
```

Code coverage - https://app.codecov.io/gh/prawana-perera/todos

### Reference Projects
- https://github.com/Albert221/FastShopping/
- https://github.com/flutter/gallery

- Awesome video with useful tips: https://www.youtube.com/watch?v=5vDq5DXXxss


- GetX + API request
    - https://www.youtube.com/watch?v=V0oxG3tWiwk (TODO: watch)
    - https://www.youtube.com/watch?v=tNGfVp4KY2g (https://github.com/themaaz32/getx_news_app_impl)

- Open source illustrations - https://undraw.co/illustrations
