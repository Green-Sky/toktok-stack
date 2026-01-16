load("@rules_cc//cc:defs.bzl", "cc_library")

REPO_ROOT = package_relative_label(":BUILD.bazel").workspace_root

genrule(
    name = "config",
    outs = ["dummy/config.h"],
    cmd = "touch $@",
)

cc_library(
    name = "libxz",
    srcs = glob(
        [
            "src/common/*.c",
            "src/common/*.h",
            "src/liblzma/**/*.c",
            "src/liblzma/**/*.h",
        ],
        exclude = [
            "**/*_tablegen.c",
            "src/liblzma/check/crc*_small.c",
        ],
    ) + ["dummy/config.h"],
    hdrs = glob(["src/liblzma/api/**/*.h"]),
    copts = [
        "-DHAVE_CONFIG_H",
        "-DHAVE_DECODER_LZMA1",
        "-DHAVE_DECODER_LZMA2",
        "-DHAVE_DECODER_X86",
        "-DHAVE_ENCODER_LZMA1",
        "-DHAVE_ENCODER_LZMA2",
        "-DHAVE_ENCODER_X86",
        "-DHAVE_INTTYPES_H",
        "-DHAVE_LIMITS_H",
        "-DHAVE_MEMORY_H",
        "-DHAVE_STDBOOL_H",
        "-DHAVE_STDINT_H",
        "-DHAVE_STRING_H",
        "-DHAVE_VISIBILITY",
        "-I$(GENDIR)/" + REPO_ROOT + "/dummy",
        "-I" + REPO_ROOT + "/src/common",
        "-I" + REPO_ROOT + "/src/liblzma/check",
        "-I" + REPO_ROOT + "/src/liblzma/common",
        "-I" + REPO_ROOT + "/src/liblzma/delta",
        "-I" + REPO_ROOT + "/src/liblzma/lz",
        "-I" + REPO_ROOT + "/src/liblzma/lzma",
        "-I" + REPO_ROOT + "/src/liblzma/rangecoder",
        "-I" + REPO_ROOT + "/src/liblzma/simple",
    ] + select({
        "@toktok//tools/config:windows": ["-DMYTHREAD_VISTA"],
        "//conditions:default": [
            "-D_POSIX_C_SOURCE=199506L",
            "-DMYTHREAD_POSIX",
            "-Wno-overlength-strings",
            "-Wno-unused-function",
        ],
    }),
    linkopts = select({
        "@toktok//tools/config:windows": [],
        "//conditions:default": ["-lpthread"],
    }),
    strip_include_prefix = "src/liblzma/api",
    visibility = ["//visibility:public"],
)
