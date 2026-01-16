load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

_rules_nixpkgs_version = "0.13.0"
_rules_nixpkgs_sha256 = "0dfbc718e8a6e4b376b9445a1f8dce9330d395dd1a53de6e32ca9b6c6ea56860"

def rules_nixpkgs_dependencies():
    # N.B. rules_nixpkgs was split into separate components, which need to be loaded separately
    #
    # See https://github.com/tweag/rules_nixpkgs/issues/182 for the rational

    strip_prefix = "rules_nixpkgs-%s" % _rules_nixpkgs_version

    rules_nixpkgs_url = \
        "https://github.com/tweag/rules_nixpkgs/archive/v{version}.tar.gz".format(
            version = _rules_nixpkgs_version
        )

    http_archive(
        name = "io_tweag_rules_nixpkgs",
        strip_prefix = strip_prefix,
        urls = [rules_nixpkgs_url],
        sha256 = _rules_nixpkgs_sha256,
    )

    # required by rules_nixpkgs
    http_archive(
        name = "rules_nodejs",
        sha256 = "764a3b3757bb8c3c6a02ba3344731a3d71e558220adcb0cf7e43c9bba2c37ba8",
        urls = ["https://github.com/bazelbuild/rules_nodejs/releases/download/5.8.2/rules_nodejs-core-5.8.2.tar.gz"],
    )

    http_archive(
        name = "rules_nixpkgs_core",
        strip_prefix = strip_prefix + "/core",
        urls = [rules_nixpkgs_url],
        sha256 = _rules_nixpkgs_sha256,
    )

    for toolchain in ["cc", "java", "python", "go", "rust", "posix", "nodejs"]:
        http_archive(
            name = "rules_nixpkgs_" + toolchain,
            strip_prefix = strip_prefix + "/toolchains/" + toolchain,
            urls = [rules_nixpkgs_url],
            sha256 = _rules_nixpkgs_sha256,
        )
