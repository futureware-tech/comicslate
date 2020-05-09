fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew cask install fastlane`

# Available Actions
### install_dependencies
```
fastlane install_dependencies
```
Install or upgrade Flutter and Android SDK licenses
### generate
```
fastlane generate
```
Generate files for Intl and built_value and format all files
### lint
```
fastlane lint
```
Run static analysis on Flutter files

----

## Android
### android build
```
fastlane android build
```
Build a debug APK
### android publish
```
fastlane android publish
```
Build a release AAB and publish it (including Store artifacts).

Set "release" lane key to non-empty value to upload to "alpha" track.

----

## iOS
### ios build
```
fastlane ios build
```
Build a debug iOS package
### ios publish
```
fastlane ios publish
```
Build a release iOS package and publish it (including Store artifacts).

Set "release" lane key to non-empty value to upload metadata.

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
