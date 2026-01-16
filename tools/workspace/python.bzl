"""Finds Nix Python headers and libraries

Uses python-config to make them available to be used as a C/C++ dependency.

Example:
    WORKSPACE:
        load("//tools/workspace:python.bzl", "python_repository")
        python_repository(
            name = "python3",
            python_config = "@python3_config//:bin/python3-config",
        )

    BUILD:
        cc_library(
            name = "foobar",
            srcs = ["bar.cc"],
            deps = ["@python3//:python"],
        )

Arguments:
    name: A unique name for this rule.
    python_config: The label of the python-config binary.
"""

def _python_config(repository_ctx):
    config = str(repository_ctx.path(repository_ctx.attr.python_config))
    result = repository_ctx.execute([config, "--version"])
    if result.return_code == 0:
        version = result.stdout.strip().split(" ")[1]
        version = ".".join(version.split(".")[:2])
        return [config, "--embed"], version
    return [config, "--embed"], "3"

def _impl(repository_ctx):
    python_config, _version = _python_config(repository_ctx)

    includes_result = repository_ctx.execute(python_config + ["--includes"])
    if includes_result.return_code != 0:
        fail("Could not determine Python includes", attr = includes_result.stderr)

    cflags = includes_result.stdout.strip().split(" ")
    cflags = [cflag for cflag in cflags if cflag]

    root = repository_ctx.path("")
    root_len = len(str(root)) + 1
    base = root.get_child("include")

    includes = []

    for cflag in cflags:
        if cflag.startswith("-I"):
            source = repository_ctx.path(cflag[2:])
            destination = base.get_child(str(source).replace("/", "_"))
            include = str(destination)[root_len:]

            if include not in includes:
                repository_ctx.symlink(source, destination)
                includes.append(include)

    hdrs = ["%s/**" % inc for inc in includes]

    result = repository_ctx.execute(python_config + ["--ldflags"])

    if result.return_code != 0:
        fail("Could NOT determine Python linkopts", attr = result.stderr)

    linkopts = result.stdout.strip().split(" ")
    linkopts = [linkopt for linkopt in linkopts if linkopt]

    for i in reversed(range(len(linkopts))):
        if not linkopts[i].startswith("-"):
            linkopts[i - 1] = " ".join([linkopts[i - 1], linkopts.pop(i)])

    file_content = """
load("@rules_cc//cc:defs.bzl", "cc_library")

cc_library(
    name = "python",
    hdrs = glob({}),
    includes = {},
    linkopts = {},
    visibility = ["//visibility:public"],
)
  """.format(hdrs, includes, linkopts)

    repository_ctx.file(
        "BUILD",
        content = file_content,
        executable = False,
    )

python_repository = repository_rule(
    _impl,
    attrs = {
        "python_config": attr.label(mandatory = True),
    },
    configure = True,
    local = True,
)
