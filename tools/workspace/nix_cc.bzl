load("@rules_nixpkgs_cc//:cc.bzl", "nixpkgs_cc_configure")

def _nix_cc_impl(ctx):
    nixpkgs_cc_configure(
        name = "nixpkgs_cc_toolchain",
        attribute_path = "clang",
        nix_file_content = "(import <nixpkgs> {})",
        repository = "@nixpkgs",
        register = False,
    )

nix_cc = module_extension(
    implementation = _nix_cc_impl,
)
