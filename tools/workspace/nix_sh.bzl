load("@rules_nixpkgs_posix//:posix.bzl", "nixpkgs_sh_posix_configure")

def _nix_sh_impl(ctx):
    nixpkgs_sh_posix_configure(
        name = "nixpkgs_sh_toolchain",
        packages = [
            "bash",
            "coreutils",
            "diffutils",
            "file",
            "findutils",
            "gawk",
            "gnugrep",
            "gnused",
            "gnutar",
            "gzip",
            "patch",
            "unzip",
            "which",
            "zip",
        ],
        repository = "@nixpkgs",
        register = False,
    )

nix_sh = module_extension(
    implementation = _nix_sh_impl,
)
