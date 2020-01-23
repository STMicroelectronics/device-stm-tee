# auto-generated TEE configuration file
# TEE version c50f58d
ARCH=arm
PLATFORM=stm32mp1
PLATFORM_FLAVOR=stm32mp157c
CFG_AES_GCM_TABLE_BASED=y
CFG_ARM32_core=y
CFG_ARM32_ta_arm32=y
CFG_ARM64_core=n
CFG_BOOT_SECONDARY_REQUEST=y
CFG_CC_OPTIMIZE_FOR_SIZE=y
CFG_CORE_BGET_BESTFIT=y
CFG_CORE_BIGNUM_MAX_BITS=4096
CFG_CORE_CLUSTER_SHIFT=2
CFG_CORE_HEAP_SIZE=49152
CFG_CORE_LARGE_PHYS_ADDR=n
CFG_CORE_RODATA_NOEXEC=n
CFG_CORE_RWDATA_NOEXEC=y
CFG_CORE_SANITIZE_KADDRESS=n
CFG_CORE_SANITIZE_UNDEFINED=n
CFG_CORE_TZSRAM_EMUL_SIZE=458752
CFG_CORE_UNMAP_CORE_AT_EL0=y
CFG_CORE_WORKAROUND_SPECTRE_BP=y
CFG_CORE_WORKAROUND_SPECTRE_BP_SEC=y
CFG_CRYPTO=y
CFG_CRYPTOLIB_DIR=core/lib/libtomcrypt
CFG_CRYPTOLIB_NAME=tomcrypt
CFG_CRYPTO_AES=y
CFG_CRYPTO_AES_GCM_FROM_CRYPTOLIB=n
CFG_CRYPTO_CBC=y
CFG_CRYPTO_CBC_MAC=y
CFG_CRYPTO_CCM=y
CFG_CRYPTO_CMAC=y
CFG_CRYPTO_CONCAT_KDF=y
CFG_CRYPTO_CTR=y
CFG_CRYPTO_CTS=y
CFG_CRYPTO_DES=y
CFG_CRYPTO_DH=y
CFG_CRYPTO_DSA=y
CFG_CRYPTO_ECB=y
CFG_CRYPTO_ECC=y
CFG_CRYPTO_GCM=y
CFG_CRYPTO_HKDF=y
CFG_CRYPTO_HMAC=y
CFG_CRYPTO_MD5=y
CFG_CRYPTO_PBKDF2=y
CFG_CRYPTO_RSA=y
CFG_CRYPTO_SHA1=y
CFG_CRYPTO_SHA224=y
CFG_CRYPTO_SHA256=y
CFG_CRYPTO_SHA384=y
CFG_CRYPTO_SHA512=y
CFG_CRYPTO_SIZE_OPTIMIZATION=y
CFG_CRYPTO_XTS=y
CFG_DEBUG_INFO=y
CFG_DT=y
CFG_DTB_MAX_SIZE=0x10000
CFG_DYN_SHM_CAP=y
CFG_EARLY_TA=y
CFG_ENABLE_SCTLR_Z=n
CFG_FORCE_CONSOLE_ON_SUSPEND=n
CFG_GENERIC_BOOT=y
CFG_GIC=y
CFG_GP_SOCKETS=y
CFG_HWSUPP_MEM_PERM_PXN=y
CFG_HWSUPP_MEM_PERM_WXN=y
CFG_INIT_CNTVOFF=y
CFG_IN_TREE_EARLY_TAS=avb/023f8f1a-292a-432b-8fc4-de8471358067
CFG_KERN_LINKER_ARCH=arm
CFG_KERN_LINKER_FORMAT=elf32-littlearm
CFG_LIBUTILS_WITH_ISOC=y
CFG_LPAE_ADDR_SPACE_SIZE=(1ull << 32)
CFG_LTC_OPTEE_THREAD=y
CFG_MMAP_REGIONS=23
CFG_MSG_LONG_PREFIX_MASK=0x1a
CFG_NUM_THREADS=2
CFG_OPTEE_REVISION_MAJOR=3
CFG_OPTEE_REVISION_MINOR=3
CFG_OS_REV_REPORTS_GIT_SHA1=y
CFG_PAGED_USER_TA=y
CFG_PM_ARM32=y
CFG_PM_STUBS=y
CFG_PSCI_ARM32=y
CFG_REE_FS=y
CFG_REE_FS_TA=y
CFG_RESERVED_VASPACE_SIZE=(1024 * 1024 * 10)
CFG_RPMB_FS=n
CFG_RPMB_FS_DEV_ID=0
CFG_RPMB_WRITE_KEY=n
CFG_SCTLR_ALIGNMENT_CHECK=y
CFG_SECONDARY_INIT_CNTFRQ=y
CFG_SECSTOR_TA=y
CFG_SECSTOR_TA_MGMT_PTA=y
CFG_SECURE_DATA_PATH=n
CFG_SECURE_DT=stm32mp157c-ev1
CFG_SECURE_TIME_SOURCE_CNTPCT=y
CFG_SHMEM_SIZE=0x00200000
CFG_SHMEM_START=0xffe00000
CFG_SM_NO_CYCLE_COUNTING=y
CFG_SM_PLATFORM_HANDLER=y
CFG_STATIC_SECURE_DT=y
CFG_STM32MP_MAP_NSEC_LOW_DDR=y
CFG_STM32_BSEC=y
CFG_STM32_BSEC_SIP=y
CFG_STM32_CLOCKSRC_CALIB=y
CFG_STM32_CRYP=y
CFG_STM32_EARLY_CONSOLE_UART=4
CFG_STM32_ETZPC=y
CFG_STM32_GPIO=y
CFG_STM32_I2C=y
CFG_STM32_IWDG=y
CFG_STM32_POWER_SERVICES=y
CFG_STM32_PWR_SIP=y
CFG_STM32_RCC_SIP=y
CFG_STM32_RNG=y
CFG_STM32_RTC=y
CFG_STM32_TIMER=y
CFG_STM32_UART=y
CFG_STPMIC1=y
CFG_SYSTEM_PTA=y
CFG_TA_BIGNUM_MAX_BITS=2048
CFG_TA_DYNLINK=y
CFG_TA_FLOAT_SUPPORT=y
CFG_TA_GPROF_SUPPORT=n
CFG_TA_MBEDTLS=y
CFG_TA_MBEDTLS_SELF_TEST=y
CFG_TEE_API_VERSION=GPD-1.1-dev
CFG_TEE_CORE_DEBUG=n
CFG_TEE_CORE_EMBED_INTERNAL_TESTS=y
CFG_TEE_CORE_LOG_LEVEL=2
CFG_TEE_CORE_MALLOC_DEBUG=n
CFG_TEE_CORE_NB_CORE=2
CFG_TEE_CORE_TA_TRACE=y
CFG_TEE_FW_IMPL_VERSION=FW_IMPL_UNDEF
CFG_TEE_FW_MANUFACTURER=FW_MAN_UNDEF
CFG_TEE_IMPL_DESCR=OPTEE
CFG_TEE_MANUFACTURER=LINARO
CFG_TEE_TA_LOG_LEVEL=1
CFG_TEE_TA_MALLOC_DEBUG=n
CFG_TZDRAM_SIZE=0x01e00000
CFG_TZDRAM_START=0xfe000000
CFG_TZSRAM_SIZE=0x00040000
CFG_TZSRAM_START=0x2ffc0000
CFG_ULIBS_GPROF=n
CFG_UNWIND=n
CFG_WITH_LPAE=y
CFG_WITH_NSEC_GPIOS=y
CFG_WITH_NSEC_UARTS=y
CFG_WITH_PAGER=y
CFG_WITH_SOFTWARE_PRNG=y
CFG_WITH_STACK_CANARIES=y
CFG_WITH_STATS=y
CFG_WITH_USER_TA=y
CFG_WITH_VFP=y
CFG_ZLIB=y
