# stm32mp1-tee #

This module is used to provide
* prebuilt images of the OP-TEE OS and Trusted Application (TA) examples for STM32MP1
* scripts to load and build OP-TEE OS and OP-TEE User (client + test) source for STM32MP1

It is part of the STMicroelectronics delivery for Android (see the [delivery][] for more information).

[delivery]: https://wiki.st.com/stm32mpu/wiki/STM32MP15_distribution_for_Android_release_note_-_v1.0.0

## Description ##

This module version is the first version for stm32mp1

Please see the release notes for more details.

## Documentation ##

* The [release notes][] provide information on the release.
* The [distribution package][] provides detailed information on how to use this delivery.

[release notes]: https://wiki.st.com/stm32mpu/wiki/STM32MP15_distribution_for_Android_release_note_-_v1.0.0
[distribution package]: https://wiki.st.com/stm32mpu/wiki/STM32MP1_Distribution_Package_for_Android

## Dependencies ##

This module can't be used alone. It is part of the STMicroelectronics delivery for Android.

## Containing ##

This module contains several files and directories.

**prebuilt**
* `./prebuilt/optee_os`: prebuilt image of the OP-TEE OS
* `./prebuilt/eval/*`: prebuilt Trusted Application (TA) images and TA build environment for evaluation board

**source**
* `./source/load_tee.sh`: script used to load OP-TEE source with required patches for STM32MP1
* `./source/build_tee.sh`: script used to generate/update prebuilt OP-TEE OS images
* `./source/build_ta.sh`: script used to generate/update prebuilt TA images
* `./source/android_teebuild.config`: configuration file used by the build_tee.sh script
* `./source/android_tabuild.config`: configuration file used by the build_ta.sh script
* `./source/patch/*`: OP-TEE OS and USER patches required (not yet up-streamed)

## License ##

This module is distributed under the Apache License, Version 2.0 found in the [Apache-2.0](./LICENSES/Apache-2.0) file.

There are exceptions which are distributed under BSD-2-Clause and BSD-3-Clause Licenses, found in the [BSD-2-Clause](./LICENSES/BSD-2-Clause) and [BSD-3-Clause](./LICENSES/BSD-3-Clause) files:
* all binaries provided in `./prebuilt` directory
* all .patch files provided in `./source/patch` directory
