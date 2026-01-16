load("@rules_python//python:defs.bzl", "py_library")

py_library(
    name = "requests",
    data = glob(["stubs/requests/requests/*.pyi"]),
    visibility = ["//visibility:public"],
)

exports_files([
    "stubs/requests/requests/__init__.pyi",
])

filegroup(
    name = "typeshed",
    srcs = [
        ":requests",
    ],
    visibility = ["//visibility:public"],
)
