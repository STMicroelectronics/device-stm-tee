# auto-generated TEE configuration file
# TEE version cc9262d
set(CFG_AES_GCM_TABLE_BASED y)
set(CFG_ARM32_core y)
set(CFG_ARM32_ldelf y)
set(CFG_ARM32_ta_arm32 y)
# CFG_ARM64_core is not set 
set(CFG_ARM_GIC_PM y)
set(CFG_BOOT_SECONDARY_REQUEST y)
set(CFG_CC_OPTIMIZE_FOR_SIZE y)
# CFG_CORE_ASLR is not set 
set(CFG_CORE_BGET_BESTFIT y)
set(CFG_CORE_BIGNUM_MAX_BITS 4096)
set(CFG_CORE_CLUSTER_SHIFT 2)
# CFG_CORE_DUMP_OOM is not set 
set(CFG_CORE_DYN_SHM y)
set(CFG_CORE_HEAP_SIZE 57344)
set(CFG_CORE_HUK_SUBKEY_COMPAT y)
# CFG_CORE_LARGE_PHYS_ADDR is not set 
set(CFG_CORE_MBEDTLS_MPI y)
set(CFG_CORE_NEX_HEAP_SIZE 16384)
set(CFG_CORE_RESERVED_SHM y)
# CFG_CORE_RODATA_NOEXEC is not set 
set(CFG_CORE_RWDATA_NOEXEC y)
# CFG_CORE_SANITIZE_KADDRESS is not set 
# CFG_CORE_SANITIZE_UNDEFINED is not set 
set(CFG_CORE_THREAD_SHIFT 0)
# CFG_CORE_TPM_EVENT_LOG is not set 
set(CFG_CORE_TZSRAM_EMUL_SIZE 458752)
set(CFG_CORE_UNMAP_CORE_AT_EL0 y)
set(CFG_CORE_WORKAROUND_NSITR_CACHE_PRIME y)
set(CFG_CORE_WORKAROUND_SPECTRE_BP y)
set(CFG_CORE_WORKAROUND_SPECTRE_BP_SEC y)
set(CFG_CRYPTO y)
set(CFG_CRYPTOLIB_DIR core/lib/libtomcrypt)
set(CFG_CRYPTOLIB_NAME tomcrypt)
set(CFG_CRYPTOLIB_NAME_tomcrypt y)
set(CFG_CRYPTO_AES y)
# CFG_CRYPTO_AES_GCM_FROM_CRYPTOLIB is not set 
set(CFG_CRYPTO_CBC y)
set(CFG_CRYPTO_CBC_MAC y)
set(CFG_CRYPTO_CCM y)
set(CFG_CRYPTO_CMAC y)
set(CFG_CRYPTO_CONCAT_KDF y)
set(CFG_CRYPTO_CTR y)
set(CFG_CRYPTO_CTS y)
set(CFG_CRYPTO_DES y)
set(CFG_CRYPTO_DH y)
set(CFG_CRYPTO_DSA y)
set(CFG_CRYPTO_ECB y)
set(CFG_CRYPTO_ECC y)
set(CFG_CRYPTO_GCM y)
set(CFG_CRYPTO_HKDF y)
set(CFG_CRYPTO_HMAC y)
set(CFG_CRYPTO_MD5 y)
set(CFG_CRYPTO_PBKDF2 y)
set(CFG_CRYPTO_RSA y)
set(CFG_CRYPTO_RSASSA_NA1 y)
set(CFG_CRYPTO_SHA1 y)
set(CFG_CRYPTO_SHA224 y)
set(CFG_CRYPTO_SHA256 y)
set(CFG_CRYPTO_SHA384 y)
set(CFG_CRYPTO_SHA512 y)
set(CFG_CRYPTO_SHA512_256 y)
set(CFG_CRYPTO_SIZE_OPTIMIZATION y)
set(CFG_CRYPTO_SM2_DSA y)
set(CFG_CRYPTO_SM2_KEP y)
set(CFG_CRYPTO_SM2_PKE y)
set(CFG_CRYPTO_SM3 y)
set(CFG_CRYPTO_SM4 y)
set(CFG_CRYPTO_XTS y)
set(CFG_DEBUG_INFO y)
set(CFG_DEVICE_ENUM_PTA y)
set(CFG_DRAM_SIZE 0x40000000)
set(CFG_DT y)
set(CFG_DTB_MAX_SIZE 0x10000)
set(CFG_EARLY_TA y)
# CFG_EARLY_TA_COMPRESS is not set 
set(CFG_EMBED_DTB y)
set(CFG_EMBED_DTB_SOURCE_FILE stm32mp157c-ev1.dts)
# CFG_ENABLE_SCTLR_Z is not set 
# CFG_EXTERNAL_DTB_OVERLAY is not set 
set(CFG_FTRACE_BUF_WHEN_FULL shift)
# CFG_FTRACE_SUPPORT is not set 
set(CFG_FTRACE_US_MS 10000)
set(CFG_GENERIC_BOOT y)
set(CFG_GIC y)
set(CFG_GP_SOCKETS y)
set(CFG_HWSUPP_MEM_PERM_PXN y)
set(CFG_HWSUPP_MEM_PERM_WXN y)
set(CFG_INIT_CNTVOFF y)
set(CFG_IN_TREE_EARLY_TAS avb/023f8f1a-292a-432b-8fc4-de8471358067)
set(CFG_KERN_LINKER_ARCH arm)
set(CFG_KERN_LINKER_FORMAT elf32-littlearm)
set(CFG_LIBUTILS_WITH_ISOC y)
# CFG_LOCKDEP is not set 
set(CFG_LOCKDEP_RECORD_STACK y)
set(CFG_LPAE_ADDR_SPACE_SIZE (1ull << 32))
set(CFG_LTC_OPTEE_THREAD y)
set(CFG_MMAP_REGIONS 30)
set(CFG_MSG_LONG_PREFIX_MASK 0x1a)
set(CFG_NUM_THREADS 2)
set(CFG_OPTEE_REVISION_MAJOR 3)
set(CFG_OPTEE_REVISION_MINOR 9)
set(CFG_OS_REV_REPORTS_GIT_SHA1 y)
set(CFG_PAGED_USER_TA y)
set(CFG_PM y)
set(CFG_PM_ARM32 y)
set(CFG_PM_STUBS y)
set(CFG_PSCI_ARM32 y)
# CFG_REE_FS is not set 
set(CFG_REE_FS_TA y)
# CFG_REE_FS_TA_BUFFERED is not set 
set(CFG_RESERVED_VASPACE_SIZE (1024 * 1024 * 10))
set(CFG_RPMB_FS y)
set(CFG_RPMB_FS_CACHE_ENTRIES 0)
set(CFG_RPMB_FS_DEV_ID 1)
set(CFG_RPMB_FS_RD_ENTRIES 8)
set(CFG_RPMB_TESTKEY y)
set(CFG_RPMB_WRITE_KEY y)
# CFG_RPROC_PTA is not set 
set(CFG_RPROC_SIGN_KEY keys/default_rproc.pem)
set(CFG_SCMI_MSG_CLOCK y)
set(CFG_SCMI_MSG_DRIVERS y)
set(CFG_SCMI_MSG_RESET_DOMAIN y)
set(CFG_SCMI_MSG_SMT y)
set(CFG_SCMI_MSG_SMT_FASTCALL_ENTRY y)
set(CFG_SCTLR_ALIGNMENT_CHECK y)
set(CFG_SECONDARY_INIT_CNTFRQ y)
# CFG_SECSTOR_TA is not set 
# CFG_SECSTOR_TA_MGMT_PTA is not set 
# CFG_SECURE_DATA_PATH is not set 
set(CFG_SECURE_TIME_SOURCE_CNTPCT y)
set(CFG_SHMEM_SIZE 0x00200000)
set(CFG_SHMEM_START 0xffe00000)
# CFG_SHOW_CONF_ON_BOOT is not set 
set(CFG_SM_NO_CYCLE_COUNTING y)
set(CFG_SM_PLATFORM_HANDLER y)
set(CFG_STM32MP15_PM_CONTEX_VERSION 2)
set(CFG_STM32MP1_SCMI_SHM_BASE 0x2ffff000)
set(CFG_STM32MP1_SCMI_SHM_SIZE 0x00001000)
set(CFG_STM32MP_PANIC_ON_TZC_PERM_VIOLATION y)
set(CFG_STM32_BSEC y)
set(CFG_STM32_BSEC_SIP y)
set(CFG_STM32_CLKCALIB y)
set(CFG_STM32_CLKCALIB_SIP y)
set(CFG_STM32_CRYP y)
set(CFG_STM32_EARLY_CONSOLE_UART 4)
set(CFG_STM32_ETZPC y)
set(CFG_STM32_GPIO y)
set(CFG_STM32_I2C y)
set(CFG_STM32_IWDG y)
set(CFG_STM32_LOWPOWER_SIP y)
set(CFG_STM32_PWR_SIP y)
set(CFG_STM32_RCC_SIP y)
set(CFG_STM32_RNG y)
set(CFG_STM32_RTC y)
set(CFG_STM32_TIM y)
set(CFG_STM32_UART y)
set(CFG_STPMIC1 y)
# CFG_SYSCALL_FTRACE is not set 
# CFG_SYSCALL_WRAPPERS_MCOUNT is not set 
set(CFG_SYSTEM_PTA y)
set(CFG_TA_ASLR y)
set(CFG_TA_ASLR_MAX_OFFSET_PAGES 128)
set(CFG_TA_ASLR_MIN_OFFSET_PAGES 0)
set(CFG_TA_BIGNUM_MAX_BITS 2048)
set(CFG_TA_DYNLINK y)
set(CFG_TA_FLOAT_SUPPORT y)
# CFG_TA_GPROF_SUPPORT is not set 
set(CFG_TA_MBEDTLS y)
set(CFG_TA_MBEDTLS_MPI y)
set(CFG_TA_MBEDTLS_SELF_TEST y)
set(CFG_TEE_API_VERSION GPD-1.1-dev)
# CFG_TEE_CORE_DEBUG is not set 
set(CFG_TEE_CORE_EMBED_INTERNAL_TESTS y)
set(CFG_TEE_CORE_LOG_LEVEL 2)
# CFG_TEE_CORE_MALLOC_DEBUG is not set 
set(CFG_TEE_CORE_NB_CORE 2)
set(CFG_TEE_CORE_TA_TRACE y)
set(CFG_TEE_FW_IMPL_VERSION FW_IMPL_UNDEF)
set(CFG_TEE_FW_MANUFACTURER FW_MAN_UNDEF)
set(CFG_TEE_IMPL_DESCR OPTEE)
set(CFG_TEE_MANUFACTURER LINARO)
set(CFG_TEE_TA_LOG_LEVEL 1)
# CFG_TEE_TA_MALLOC_DEBUG is not set 
set(CFG_TZC400 y)
set(CFG_TZDRAM_SIZE 0x01e00000)
set(CFG_TZDRAM_START 0xfe000000)
set(CFG_TZSRAM_SIZE 0x0003f000)
set(CFG_TZSRAM_START 0x2ffc0000)
# CFG_ULIBS_MCOUNT is not set 
# CFG_ULIBS_SHARED is not set 
# CFG_UNWIND is not set 
# CFG_VIRTUALIZATION is not set 
set(CFG_WERROR y)
set(CFG_WITH_LPAE y)
set(CFG_WITH_NSEC_GPIOS y)
set(CFG_WITH_NSEC_UARTS y)
set(CFG_WITH_PAGER y)
set(CFG_WITH_SOFTWARE_PRNG y)
set(CFG_WITH_STACK_CANARIES y)
set(CFG_WITH_STATS y)
set(CFG_WITH_USER_TA y)
set(CFG_WITH_VFP y)
set(CFG_ZLIB y)
set(PLATFORM_FLAVOR_ y)
set(PLATFORM_stm32mp1 y)
set(_CFG_CORE_LTC_ACIPHER y)
set(_CFG_CORE_LTC_AES y)
# _CFG_CORE_LTC_AES_ACCEL is not set 
set(_CFG_CORE_LTC_AES_DESC y)
set(_CFG_CORE_LTC_ASN1 y)
set(_CFG_CORE_LTC_AUTHENC y)
set(_CFG_CORE_LTC_BIGNUM_MAX_BITS 4096)
set(_CFG_CORE_LTC_CBC y)
set(_CFG_CORE_LTC_CBC_MAC y)
set(_CFG_CORE_LTC_CCM y)
# _CFG_CORE_LTC_CE is not set 
set(_CFG_CORE_LTC_CIPHER y)
set(_CFG_CORE_LTC_CMAC y)
set(_CFG_CORE_LTC_CTR y)
set(_CFG_CORE_LTC_CTS y)
set(_CFG_CORE_LTC_DES y)
set(_CFG_CORE_LTC_DH y)
set(_CFG_CORE_LTC_DSA y)
set(_CFG_CORE_LTC_ECB y)
set(_CFG_CORE_LTC_ECC y)
set(_CFG_CORE_LTC_HASH y)
set(_CFG_CORE_LTC_HMAC y)
# _CFG_CORE_LTC_HWSUPP_PMULL is not set 
set(_CFG_CORE_LTC_MAC y)
set(_CFG_CORE_LTC_MD5 y)
set(_CFG_CORE_LTC_MPI y)
set(_CFG_CORE_LTC_OPTEE_THREAD y)
set(_CFG_CORE_LTC_PAGER y)
set(_CFG_CORE_LTC_RSA y)
set(_CFG_CORE_LTC_SHA1 y)
# _CFG_CORE_LTC_SHA1_ACCEL is not set 
set(_CFG_CORE_LTC_SHA224 y)
set(_CFG_CORE_LTC_SHA256 y)
# _CFG_CORE_LTC_SHA256_ACCEL is not set 
set(_CFG_CORE_LTC_SHA256_DESC y)
set(_CFG_CORE_LTC_SHA384 y)
set(_CFG_CORE_LTC_SHA384_DESC y)
set(_CFG_CORE_LTC_SHA512 y)
set(_CFG_CORE_LTC_SHA512_256 y)
set(_CFG_CORE_LTC_SHA512_DESC y)
set(_CFG_CORE_LTC_SIZE_OPTIMIZATION y)
set(_CFG_CORE_LTC_SM2_DSA y)
set(_CFG_CORE_LTC_SM2_KEP y)
set(_CFG_CORE_LTC_SM2_PKE y)
set(_CFG_CORE_LTC_VFP y)
set(_CFG_CORE_LTC_XTS y)
set(_CFG_FTRACE_BUF_WHEN_FULL_shift y)
