# stm32mp2-tee #

This module provides prebuilt Trusty images and build scripts for STM32MP2.
It is part of the STMicroelectronics delivery for Android.

## Description ##

This module targets STM32MP25 in OpenSTDroid v6.2.0.
Please see the release notes for more details.

## Documentation ##

* The [release notes][] provide information on the release.
[release notes]: https://wiki.st.com/stm32mpu/wiki/Android-based_OpenSTDroid_ecosystem_release_note_-_v6.2.1

## Dependencies ##

This module cannot be used alone. It is part of the STMicroelectronics delivery for Android.

## Contents ##

This module contains several files and directories.

**Prebuilt**
* `./prebuilt/*`: prebuilt image of Trusty for the STM32MP25 EVAL and DK boards

**Source**
* `./source/build_tee.sh`: script used to generate and update prebuilt images
* `./source/android_teebuild.config`: configuration file used by the build_tee.sh script

## License ##

This module is distributed under the Apache License, Version 2.0 found in the [Apache-2.0](./LICENSES/Apache-2.0) file.
