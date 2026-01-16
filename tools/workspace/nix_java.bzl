load("@rules_nixpkgs_java//:java.bzl", "nixpkgs_java_configure")

def _nix_java_impl(ctx):
    nixpkgs_java_configure(
        name = "nixpkgs_java",
        attribute_path = "jdk21_headless.home",
        repository = "@nixpkgs",
        toolchain = True,
        toolchain_name = "nixpkgs_java",
        toolchain_version = "21",
        register = False,
    )

nix_java = module_extension(
    implementation = _nix_java_impl,
)
