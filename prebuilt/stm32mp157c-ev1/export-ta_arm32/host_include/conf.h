#ifndef __local_views2_frq09432_st_android_11_0_0_2021_06_01_out_bsp_stm32mp1_TEE_OBJ_stm32mp157c_ev1_include_generated_conf_h_
#define __local_views2_frq09432_st_android_11_0_0_2021_06_01_out_bsp_stm32mp1_TEE_OBJ_stm32mp157c_ev1_include_generated_conf_h_
#define CFG_AES_GCM_TABLE_BASED 1
#define CFG_ARM32_core 1
#define CFG_ARM32_ldelf 1
#define CFG_ARM32_ta_arm32 1
/* CFG_ARM64_core is not set */
#define CFG_ARM_GIC_PM 1
#define CFG_BOOT_SECONDARY_REQUEST 1
#define CFG_CC_OPTIMIZE_FOR_SIZE 1
/* CFG_CORE_ASLR is not set */
#define CFG_CORE_BGET_BESTFIT 1
#define CFG_CORE_BIGNUM_MAX_BITS 4096
#define CFG_CORE_CLUSTER_SHIFT 2
/* CFG_CORE_DUMP_OOM is not set */
#define CFG_CORE_DYN_SHM 1
#define CFG_CORE_HEAP_SIZE 57344
#define CFG_CORE_HUK_SUBKEY_COMPAT 1
/* CFG_CORE_LARGE_PHYS_ADDR is not set */
#define CFG_CORE_MBEDTLS_MPI 1
#define CFG_CORE_NEX_HEAP_SIZE 16384
#define CFG_CORE_RESERVED_SHM 1
/* CFG_CORE_RODATA_NOEXEC is not set */
#define CFG_CORE_RWDATA_NOEXEC 1
/* CFG_CORE_SANITIZE_KADDRESS is not set */
/* CFG_CORE_SANITIZE_UNDEFINED is not set */
#define CFG_CORE_THREAD_SHIFT 0
/* CFG_CORE_TPM_EVENT_LOG is not set */
#define CFG_CORE_TZSRAM_EMUL_SIZE 458752
#define CFG_CORE_UNMAP_CORE_AT_EL0 1
#define CFG_CORE_WORKAROUND_NSITR_CACHE_PRIME 1
#define CFG_CORE_WORKAROUND_SPECTRE_BP 1
#define CFG_CORE_WORKAROUND_SPECTRE_BP_SEC 1
#define CFG_CRYPTO 1
#define CFG_CRYPTOLIB_DIR core/lib/libtomcrypt
#define CFG_CRYPTOLIB_NAME tomcrypt
#define CFG_CRYPTOLIB_NAME_tomcrypt 1
#define CFG_CRYPTO_AES 1
/* CFG_CRYPTO_AES_GCM_FROM_CRYPTOLIB is not set */
#define CFG_CRYPTO_CBC 1
#define CFG_CRYPTO_CBC_MAC 1
#define CFG_CRYPTO_CCM 1
#define CFG_CRYPTO_CMAC 1
#define CFG_CRYPTO_CONCAT_KDF 1
#define CFG_CRYPTO_CTR 1
#define CFG_CRYPTO_CTS 1
#define CFG_CRYPTO_DES 1
#define CFG_CRYPTO_DH 1
#define CFG_CRYPTO_DSA 1
#define CFG_CRYPTO_ECB 1
#define CFG_CRYPTO_ECC 1
#define CFG_CRYPTO_GCM 1
#define CFG_CRYPTO_HKDF 1
#define CFG_CRYPTO_HMAC 1
#define CFG_CRYPTO_MD5 1
#define CFG_CRYPTO_PBKDF2 1
#define CFG_CRYPTO_RSA 1
#define CFG_CRYPTO_RSASSA_NA1 1
#define CFG_CRYPTO_SHA1 1
#define CFG_CRYPTO_SHA224 1
#define CFG_CRYPTO_SHA256 1
#define CFG_CRYPTO_SHA384 1
#define CFG_CRYPTO_SHA512 1
#define CFG_CRYPTO_SHA512_256 1
#define CFG_CRYPTO_SIZE_OPTIMIZATION 1
#define CFG_CRYPTO_SM2_DSA 1
#define CFG_CRYPTO_SM2_KEP 1
#define CFG_CRYPTO_SM2_PKE 1
#define CFG_CRYPTO_SM3 1
#define CFG_CRYPTO_SM4 1
#define CFG_CRYPTO_XTS 1
#define CFG_DEBUG_INFO 1
#define CFG_DEVICE_ENUM_PTA 1
#define CFG_DRAM_SIZE 0x40000000
#define CFG_DT 1
#define CFG_DTB_MAX_SIZE 0x10000
#define CFG_EARLY_TA 1
/* CFG_EARLY_TA_COMPRESS is not set */
#define CFG_EMBED_DTB 1
#define CFG_EMBED_DTB_SOURCE_FILE stm32mp157c-ev1.dts
/* CFG_ENABLE_SCTLR_Z is not set */
/* CFG_EXTERNAL_DTB_OVERLAY is not set */
#define CFG_FTRACE_BUF_WHEN_FULL shift
/* CFG_FTRACE_SUPPORT is not set */
#define CFG_FTRACE_US_MS 10000
#define CFG_GENERIC_BOOT 1
#define CFG_GIC 1
#define CFG_GP_SOCKETS 1
#define CFG_HWSUPP_MEM_PERM_PXN 1
#define CFG_HWSUPP_MEM_PERM_WXN 1
#define CFG_INIT_CNTVOFF 1
#define CFG_IN_TREE_EARLY_TAS avb/023f8f1a-292a-432b-8fc4-de8471358067
#define CFG_KERN_LINKER_ARCH arm
#define CFG_KERN_LINKER_FORMAT elf32-littlearm
#define CFG_LIBUTILS_WITH_ISOC 1
/* CFG_LOCKDEP is not set */
#define CFG_LOCKDEP_RECORD_STACK 1
#define CFG_LPAE_ADDR_SPACE_SIZE (1ull << 32)
#define CFG_LTC_OPTEE_THREAD 1
#define CFG_MMAP_REGIONS 30
#define CFG_MSG_LONG_PREFIX_MASK 0x1a
#define CFG_NUM_THREADS 2
#define CFG_OPTEE_REVISION_MAJOR 3
#define CFG_OPTEE_REVISION_MINOR 9
#define CFG_OS_REV_REPORTS_GIT_SHA1 1
#define CFG_PAGED_USER_TA 1
#define CFG_PM 1
#define CFG_PM_ARM32 1
#define CFG_PM_STUBS 1
#define CFG_PSCI_ARM32 1
/* CFG_REE_FS is not set */
#define CFG_REE_FS_TA 1
/* CFG_REE_FS_TA_BUFFERED is not set */
#define CFG_RESERVED_VASPACE_SIZE (1024 * 1024 * 10)
#define CFG_RPMB_FS 1
#define CFG_RPMB_FS_CACHE_ENTRIES 0
#define CFG_RPMB_FS_DEV_ID 1
#define CFG_RPMB_FS_RD_ENTRIES 8
#define CFG_RPMB_TESTKEY 1
#define CFG_RPMB_WRITE_KEY 1
/* CFG_RPROC_PTA is not set */
#define CFG_RPROC_SIGN_KEY keys/default_rproc.pem
#define CFG_SCMI_MSG_CLOCK 1
#define CFG_SCMI_MSG_DRIVERS 1
#define CFG_SCMI_MSG_RESET_DOMAIN 1
#define CFG_SCMI_MSG_SMT 1
#define CFG_SCMI_MSG_SMT_FASTCALL_ENTRY 1
#define CFG_SCTLR_ALIGNMENT_CHECK 1
#define CFG_SECONDARY_INIT_CNTFRQ 1
/* CFG_SECSTOR_TA is not set */
/* CFG_SECSTOR_TA_MGMT_PTA is not set */
/* CFG_SECURE_DATA_PATH is not set */
#define CFG_SECURE_TIME_SOURCE_CNTPCT 1
#define CFG_SHMEM_SIZE 0x00200000
#define CFG_SHMEM_START 0xffe00000
/* CFG_SHOW_CONF_ON_BOOT is not set */
#define CFG_SM_NO_CYCLE_COUNTING 1
#define CFG_SM_PLATFORM_HANDLER 1
#define CFG_STM32MP15_PM_CONTEX_VERSION 2
#define CFG_STM32MP1_SCMI_SHM_BASE 0x2ffff000
#define CFG_STM32MP1_SCMI_SHM_SIZE 0x00001000
#define CFG_STM32MP_PANIC_ON_TZC_PERM_VIOLATION 1
#define CFG_STM32_BSEC 1
#define CFG_STM32_BSEC_SIP 1
#define CFG_STM32_CLKCALIB 1
#define CFG_STM32_CLKCALIB_SIP 1
#define CFG_STM32_CRYP 1
#define CFG_STM32_EARLY_CONSOLE_UART 4
#define CFG_STM32_ETZPC 1
#define CFG_STM32_GPIO 1
#define CFG_STM32_I2C 1
#define CFG_STM32_IWDG 1
#define CFG_STM32_LOWPOWER_SIP 1
#define CFG_STM32_PWR_SIP 1
#define CFG_STM32_RCC_SIP 1
#define CFG_STM32_RNG 1
#define CFG_STM32_RTC 1
#define CFG_STM32_TIM 1
#define CFG_STM32_UART 1
#define CFG_STPMIC1 1
/* CFG_SYSCALL_FTRACE is not set */
/* CFG_SYSCALL_WRAPPERS_MCOUNT is not set */
#define CFG_SYSTEM_PTA 1
#define CFG_TA_ASLR 1
#define CFG_TA_ASLR_MAX_OFFSET_PAGES 128
#define CFG_TA_ASLR_MIN_OFFSET_PAGES 0
#define CFG_TA_BIGNUM_MAX_BITS 2048
#define CFG_TA_DYNLINK 1
#define CFG_TA_FLOAT_SUPPORT 1
/* CFG_TA_GPROF_SUPPORT is not set */
#define CFG_TA_MBEDTLS 1
#define CFG_TA_MBEDTLS_MPI 1
#define CFG_TA_MBEDTLS_SELF_TEST 1
#define CFG_TEE_API_VERSION GPD-1.1-dev
/* CFG_TEE_CORE_DEBUG is not set */
#define CFG_TEE_CORE_EMBED_INTERNAL_TESTS 1
#define CFG_TEE_CORE_LOG_LEVEL 2
/* CFG_TEE_CORE_MALLOC_DEBUG is not set */
#define CFG_TEE_CORE_NB_CORE 2
#define CFG_TEE_CORE_TA_TRACE 1
#define CFG_TEE_FW_IMPL_VERSION FW_IMPL_UNDEF
#define CFG_TEE_FW_MANUFACTURER FW_MAN_UNDEF
#define CFG_TEE_IMPL_DESCR OPTEE
#define CFG_TEE_MANUFACTURER LINARO
#define CFG_TEE_TA_LOG_LEVEL 1
/* CFG_TEE_TA_MALLOC_DEBUG is not set */
#define CFG_TZC400 1
#define CFG_TZDRAM_SIZE 0x01e00000
#define CFG_TZDRAM_START 0xfe000000
#define CFG_TZSRAM_SIZE 0x0003f000
#define CFG_TZSRAM_START 0x2ffc0000
/* CFG_ULIBS_MCOUNT is not set */
/* CFG_ULIBS_SHARED is not set */
/* CFG_UNWIND is not set */
/* CFG_VIRTUALIZATION is not set */
#define CFG_WERROR 1
#define CFG_WITH_LPAE 1
#define CFG_WITH_NSEC_GPIOS 1
#define CFG_WITH_NSEC_UARTS 1
#define CFG_WITH_PAGER 1
#define CFG_WITH_SOFTWARE_PRNG 1
#define CFG_WITH_STACK_CANARIES 1
#define CFG_WITH_STATS 1
#define CFG_WITH_USER_TA 1
#define CFG_WITH_VFP 1
#define CFG_ZLIB 1
#define PLATFORM_FLAVOR_ 1
#define PLATFORM_stm32mp1 1
#define _CFG_CORE_LTC_ACIPHER 1
#define _CFG_CORE_LTC_AES 1
/* _CFG_CORE_LTC_AES_ACCEL is not set */
#define _CFG_CORE_LTC_AES_DESC 1
#define _CFG_CORE_LTC_ASN1 1
#define _CFG_CORE_LTC_AUTHENC 1
#define _CFG_CORE_LTC_BIGNUM_MAX_BITS 4096
#define _CFG_CORE_LTC_CBC 1
#define _CFG_CORE_LTC_CBC_MAC 1
#define _CFG_CORE_LTC_CCM 1
/* _CFG_CORE_LTC_CE is not set */
#define _CFG_CORE_LTC_CIPHER 1
#define _CFG_CORE_LTC_CMAC 1
#define _CFG_CORE_LTC_CTR 1
#define _CFG_CORE_LTC_CTS 1
#define _CFG_CORE_LTC_DES 1
#define _CFG_CORE_LTC_DH 1
#define _CFG_CORE_LTC_DSA 1
#define _CFG_CORE_LTC_ECB 1
#define _CFG_CORE_LTC_ECC 1
#define _CFG_CORE_LTC_HASH 1
#define _CFG_CORE_LTC_HMAC 1
/* _CFG_CORE_LTC_HWSUPP_PMULL is not set */
#define _CFG_CORE_LTC_MAC 1
#define _CFG_CORE_LTC_MD5 1
#define _CFG_CORE_LTC_MPI 1
#define _CFG_CORE_LTC_OPTEE_THREAD 1
#define _CFG_CORE_LTC_PAGER 1
#define _CFG_CORE_LTC_RSA 1
#define _CFG_CORE_LTC_SHA1 1
/* _CFG_CORE_LTC_SHA1_ACCEL is not set */
#define _CFG_CORE_LTC_SHA224 1
#define _CFG_CORE_LTC_SHA256 1
/* _CFG_CORE_LTC_SHA256_ACCEL is not set */
#define _CFG_CORE_LTC_SHA256_DESC 1
#define _CFG_CORE_LTC_SHA384 1
#define _CFG_CORE_LTC_SHA384_DESC 1
#define _CFG_CORE_LTC_SHA512 1
#define _CFG_CORE_LTC_SHA512_256 1
#define _CFG_CORE_LTC_SHA512_DESC 1
#define _CFG_CORE_LTC_SIZE_OPTIMIZATION 1
#define _CFG_CORE_LTC_SM2_DSA 1
#define _CFG_CORE_LTC_SM2_KEP 1
#define _CFG_CORE_LTC_SM2_PKE 1
#define _CFG_CORE_LTC_VFP 1
#define _CFG_CORE_LTC_XTS 1
#define _CFG_FTRACE_BUF_WHEN_FULL_shift 1
#endif
