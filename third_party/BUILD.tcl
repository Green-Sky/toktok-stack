load("@rules_cc//cc:defs.bzl", "cc_binary", "cc_library")

filegroup(
    name = "library",
    srcs = ["library/init.tcl"],
    visibility = ["//visibility:public"],
)

cc_library(
    name = "inc_files",
    hdrs = [
        "generic/tcl.decls",
        "generic/tclTomMath.decls",
        "generic/tclOO.decls",
        "generic/tclInt.decls",
        "generic/tclUniData.c",
        "unix/tclUnixNotfy.c",
    ] + glob(["generic/reg*.c"]),
)

genrule(
    name = "tclMainW",
    srcs = ["generic/tclMain.c"],
    outs = ["generic/tclMainW.c"],
    cmd = " ".join([
        "echo '#define UNICODE' > $@;",
        "echo '#define _UNICODE' >> $@;",
        "cat $< >> $@",
    ]),
)

UNIX_SRCS = [
    "unix/tclEpollNotfy.c",
    "unix/tclKqueueNotfy.c",
    "unix/tclSelectNotfy.c",
    "unix/tclLoadDl.c",
] + glob(
    [
        "unix/*.h",
        "unix/tclUnix*.c",
    ],
    exclude = ["unix/tclUnixNotfy.c"],
)

cc_library(
    name = "tcl",
    srcs = [
        "generic/regcomp.c",
        "generic/regerror.c",
        "generic/regexec.c",
        "generic/regfree.c",
        "libtommath/bn_mp_add.c",
        "libtommath/bn_mp_add_d.c",
        "libtommath/bn_mp_and.c",
        "libtommath/bn_mp_clamp.c",
        "libtommath/bn_mp_clear.c",
        "libtommath/bn_mp_clear_multi.c",
        "libtommath/bn_mp_cmp.c",
        "libtommath/bn_mp_cmp_d.c",
        "libtommath/bn_mp_cmp_mag.c",
        "libtommath/bn_mp_cnt_lsb.c",
        "libtommath/bn_mp_copy.c",
        "libtommath/bn_mp_count_bits.c",
        "libtommath/bn_mp_div.c",
        "libtommath/bn_mp_div_2.c",
        "libtommath/bn_mp_div_2d.c",
        "libtommath/bn_mp_div_3.c",
        "libtommath/bn_mp_div_d.c",
        "libtommath/bn_mp_exch.c",
        "libtommath/bn_mp_expt_u32.c",
        "libtommath/bn_mp_get_mag_u64.c",
        "libtommath/bn_mp_grow.c",
        "libtommath/bn_mp_init.c",
        "libtommath/bn_mp_init_copy.c",
        "libtommath/bn_mp_init_i64.c",
        "libtommath/bn_mp_init_multi.c",
        "libtommath/bn_mp_init_set.c",
        "libtommath/bn_mp_init_size.c",
        "libtommath/bn_mp_init_u64.c",
        "libtommath/bn_mp_lshd.c",
        "libtommath/bn_mp_mod.c",
        "libtommath/bn_mp_mod_2d.c",
        "libtommath/bn_mp_mul.c",
        "libtommath/bn_mp_mul_2.c",
        "libtommath/bn_mp_mul_2d.c",
        "libtommath/bn_mp_mul_d.c",
        "libtommath/bn_mp_neg.c",
        "libtommath/bn_mp_or.c",
        "libtommath/bn_mp_radix_size.c",
        "libtommath/bn_mp_radix_smap.c",
        "libtommath/bn_mp_read_radix.c",
        "libtommath/bn_mp_rshd.c",
        "libtommath/bn_mp_set_i64.c",
        "libtommath/bn_mp_set_u64.c",
        "libtommath/bn_mp_shrink.c",
        "libtommath/bn_mp_signed_rsh.c",
        "libtommath/bn_mp_sqr.c",
        "libtommath/bn_mp_sqrt.c",
        "libtommath/bn_mp_sub.c",
        "libtommath/bn_mp_sub_d.c",
        "libtommath/bn_mp_to_radix.c",
        "libtommath/bn_mp_to_ubin.c",
        "libtommath/bn_mp_ubin_size.c",
        "libtommath/bn_mp_xor.c",
        "libtommath/bn_mp_zero.c",
        "libtommath/bn_s_mp_add.c",
        "libtommath/bn_s_mp_balance_mul.c",
        "libtommath/bn_s_mp_karatsuba_mul.c",
        "libtommath/bn_s_mp_karatsuba_sqr.c",
        "libtommath/bn_s_mp_mul_digs.c",
        "libtommath/bn_s_mp_mul_digs_fast.c",
        "libtommath/bn_s_mp_reverse.c",
        "libtommath/bn_s_mp_sqr.c",
        "libtommath/bn_s_mp_sqr_fast.c",
        "libtommath/bn_s_mp_sub.c",
        "libtommath/bn_s_mp_toom_mul.c",
        "libtommath/bn_s_mp_toom_sqr.c",
    ] + glob(
        [
            "compat/zlib/contrib/minizip/*.h",
            "generic/*.h",
            "generic/tcl*.c",
            "libtommath/*.h",
        ],
        exclude = [
            "generic/tclLoadNone.c",
            "generic/tclStubLibTbl.c",
            "generic/tclUniData.c",
        ],
    ) + select({
        "@toktok//tools/config:linux": UNIX_SRCS,
        "@toktok//tools/config:osx": UNIX_SRCS + [
            "macosx/tclMacOSXNotify.c",
        ],
        "@toktok//tools/config:windows": [
            "generic/tclMainW.c",
        ] + glob(
            [
                "win/tcl*.h",
                "win/tclWin*.c",
            ],
            exclude = ["win/tclWinTest.c"],
        ),
    }),
    copts = [
        "-DBUILD_tcl",
        "-DCFG_INSTALL_BINDIR='\"CFG_INSTALL_BINDIR\"'",
        "-DCFG_INSTALL_DOCDIR='\"CFG_INSTALL_DOCDIR\"'",
        "-DCFG_INSTALL_INCDIR='\"CFG_INSTALL_INCDIR\"'",
        "-DCFG_INSTALL_LIBDIR='\"CFG_INSTALL_LIBDIR\"'",
        "-DCFG_INSTALL_SCRDIR='\"CFG_INSTALL_SCRDIR\"'",
        "-DCFG_RUNTIME_BINDIR='\"CFG_RUNTIME_BINDIR\"'",
        "-DCFG_RUNTIME_DLLFILE='\"CFG_RUNTIME_DLLFILE\"'",
        "-DCFG_RUNTIME_DOCDIR='\"CFG_RUNTIME_DOCDIR\"'",
        "-DCFG_RUNTIME_INCDIR='\"CFG_RUNTIME_INCDIR\"'",
        "-DCFG_RUNTIME_LIBDIR='\"CFG_RUNTIME_LIBDIR\"'",
        "-DCFG_RUNTIME_SCRDIR='\"CFG_RUNTIME_SCRDIR\"'",
        "-DCFG_RUNTIME_ZIPFILE='\"CFG_RUNTIME_ZIPFILE\"'",
        "-DHAVE_BLKCNT_T=1",
        "-DHAVE_CFMAKERAW=1",
        "-DHAVE_CPUID=1",
        "-DHAVE_DECL_PTHREAD_MUTEX_RECURSIVE=1",
        "-DHAVE_EVENTFD=1",
        "-DHAVE_FREEADDRINFO=1",
        "-DHAVE_FTS=1",
        "-DHAVE_GETADDRINFO=1",
        "-DHAVE_GETCWD=1",
        "-DHAVE_GETGRGID_R=1",
        "-DHAVE_GETGRGID_R_5=1",
        "-DHAVE_GETGRNAM_R=1",
        "-DHAVE_GETGRNAM_R_5=1",
        "-DHAVE_GETNAMEINFO=1",
        "-DHAVE_GETPWNAM_R=1",
        "-DHAVE_GETPWNAM_R_5=1",
        "-DHAVE_GETPWUID_R=1",
        "-DHAVE_GETPWUID_R_5=1",
        "-DHAVE_GMTIME_R=1",
        "-DHAVE_HIDDEN=1",
        "-DHAVE_INTPTR_T=1",
        "-DHAVE_INTTYPES_H=1",
        "-DHAVE_LANGINFO=1",
        "-DHAVE_MKSTEMPS=1",
        "-DHAVE_OPENDIR=1",
        "-DHAVE_PTHREAD_ATFORK=1",
        "-DHAVE_PTHREAD_ATTR_SETSTACKSIZE=1",
        "-DHAVE_STDBOOL_H=1",
        "-DHAVE_STDINT_H=1",
        "-DHAVE_STDLIB_H=1",
        "-DHAVE_STRING_H=1",
        "-DHAVE_STRUCT_ADDRINFO=1",
        "-DHAVE_STRUCT_IN6_ADDR=1",
        "-DHAVE_STRUCT_SOCKADDR_IN6=1",
        "-DHAVE_STRUCT_SOCKADDR_STORAGE=1",
        "-DHAVE_SYS_EVENTFD_H=1",
        "-DHAVE_SYS_IOCTL_H=1",
        "-DHAVE_SYS_IOCTL_H=1",
        "-DHAVE_SYS_STAT_H=1",
        "-DHAVE_SYS_TIME_H=1",
        "-DHAVE_SYS_TYPES_H=1",
        "-DHAVE_TERMIOS_H=1",
        "-DHAVE_TIMEZONE_VAR=1",
        "-DHAVE_TM_GMTOFF=1",
        "-DHAVE_UINTPTR_T=1",
        "-DHAVE_WAITPID=1",
        "-DHAVE_ZLIB=1",
        "-DMP_FIXED_CUTOFFS",
        "-DMP_NO_STDINT",
        "-DMP_PREC=4",
        "-DNO_UNION_WAIT=1",
        "-DTCL_CFG_OPTIMIZED=1",
        "-DTCL_CFGVAL_ENCODING='\"iso8859-1\"'",
        "-DTCL_LIBRARY='\"TCL_LIBRARY\"'",
        "-DTCL_PACKAGE_PATH='\"TCL_PACKAGE_PATH\"'",
        "-DTCL_WIDE_INT_IS_LONG=1",
        "-DTIME_WITH_SYS_TIME=1",
        "-DZIPFS_BUILD=1",
        "-Iexternal/tcl/compat/zlib/contrib/minizip",
        "-Iexternal/tcl/libtommath",
    ] + select({
        "@toktok//tools/config:windows": [
            "-Iexternal/tcl/win",
        ],
        "//conditions:default": [
            "-DHAVE_CAST_TO_UNION=1",
            "-DHAVE_LOCALTIME_R=1",
            "-DHAVE_STRUCT_STAT_ST_BLKSIZE=1",
            "-DHAVE_STRUCT_STAT_ST_BLOCKS=1",
            "-DHAVE_SYS_EPOLL_H=1",
            "-DHAVE_SYS_PARAM_H=1",
            "-DHAVE_UNISTD_H=1",
            "-Iexternal/tcl/unix",
            "-Wno-int-to-void-pointer-cast",
            "-Wno-implicit-int",
            "-Wno-typedef-redefinition",
        ],
    }) + select({
        "@toktok//tools/config:linux": [
            "-D_DEFAULT_SOURCE",
            "-DHAVE_GETHOSTBYADDR_R=1",
            "-DHAVE_GETHOSTBYADDR_R_8=1",
            "-DHAVE_GETHOSTBYNAME_R=1",
            "-DHAVE_GETHOSTBYNAME_R_6=1",
            "-DNOTIFIER_EPOLL=1",
            "-DTCL_SHLIB_EXT='\".so\"'",
        ],
        "@toktok//tools/config:osx": [
            "-DHAVE_WEAK_IMPORT=1",
            "-DHAVE_COREFOUNDATION=1",
            "-DHAVE_LIBKERN_OSATOMIC_H=1",
            "-DHAVE_OSSPINLOCKLOCK=1",
        ],
        "@toktok//tools/config:windows": [],
    }),
    defines = ["STATIC_BUILD"],
    includes = ["generic"],
    linkopts = select({
        "@toktok//tools/config:linux": [
            "-ldl",
            "-lpthread",
        ],
        "@toktok//tools/config:osx": [
        ],
        "@toktok//tools/config:windows": [
            "-DEFAULTLIB:netapi32.lib",
            "-DEFAULTLIB:user32.lib",
        ],
    }),
    visibility = ["@toktok//third_party:__pkg__"],
    deps = [
        ":inc_files",
        "@zlib",
    ],
)

cc_binary(
    name = "tclsh",
    srcs = select({
        "@toktok//tools/config:windows": ["win/tclAppInit.c"],
        "//conditions:default": ["unix/tclAppInit.c"],
    }),
    copts = [
        "-DUNICODE",
        "-D_UNICODE",
        "-DTCL_USE_STATIC_PACKAGES",
    ],
    visibility = ["//visibility:public"],
    deps = [":tcl"],
)
