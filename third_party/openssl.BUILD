load("@rules_cc//cc:defs.bzl", "cc_library")

cc_library(
    name = "crypto",
    srcs = ["@openssl.out//:lib"],
    hdrs = glob(["include/openssl/*.h"]),
    strip_include_prefix = "include",
    visibility = ["//visibility:public"],
)

cc_library(
    name = "ssl",
    visibility = ["//visibility:public"],
    deps = [":crypto"],
)

alias(
    name = "openssl",
    actual = ":ssl",
    visibility = ["//visibility:public"],
)
