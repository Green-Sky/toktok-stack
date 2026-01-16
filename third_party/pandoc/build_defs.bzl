"""Pandoc build rules."""

def _pandoc_doc_impl(ctx):
    pandoc = ctx.executable._pandoc
    src = ctx.file.src
    out = ctx.outputs.out
    package_dir = ctx.label.package

    # 1. Write Lua filter to remove Haskell code blocks.
    filter_file = ctx.actions.declare_file(ctx.label.name + ".filter.lua")
    ctx.actions.write(
        output = filter_file,
        content = """
function CodeBlock(el)
  for _, class in ipairs(el.classes) do
    if class == "haskell" or class == "sourceCode" then
      return {}
    end
  end
end
""",
    )

    # 2. Action 1: Convert LaTeX+LHS to GFM and remove code blocks.
    tmp_md = ctx.actions.declare_file(ctx.label.name + ".1.md")
    data_files = depset(direct = [src], transitive = [dep.files for dep in ctx.attr.data])

    ctx.actions.run(
        inputs = depset(direct = [filter_file], transitive = [data_files]),
        outputs = [tmp_md],
        executable = pandoc,
        arguments = [
            src.path,
            "-f",
            "latex+lhs",
            "-t",
            "gfm",
            "--lua-filter",
            filter_file.path,
            "--markdown-headings=atx",
            "--columns=79",
            "-o",
            tmp_md.path,
        ],
        env = {
            "TEXINPUTS": (package_dir if package_dir else ".") + ":",
        },
        mnemonic = "PandocLHS",
        progress_message = "Converting literate Haskell %{label}",
    )

    # 3. Write title file to prepend to the document.
    title_file = ctx.actions.declare_file(ctx.label.name + ".title.txt")
    ctx.actions.write(
        output = title_file,
        content = "% {}\n\n".format(ctx.attr.title),
    )

    # 4. Action 2: Prepend title and normalize GFM.
    ctx.actions.run(
        inputs = [title_file, tmp_md],
        outputs = [out],
        executable = pandoc,
        arguments = [
            title_file.path,
            tmp_md.path,
            "-f",
            "gfm",
            "-t",
            "gfm",
            "--markdown-headings=atx",
            "--columns=79",
            "-o",
            out.path,
        ],
        mnemonic = "PandocFinal",
        progress_message = "Finalizing Markdown %{label}",
    )

pandoc_doc = rule(
    implementation = _pandoc_doc_impl,
    attrs = {
        "src": attr.label(
            allow_single_file = True,
            mandatory = True,
        ),
        "data": attr.label_list(allow_files = True),
        "out": attr.output(mandatory = True),
        "title": attr.string(mandatory = True),
        "_pandoc": attr.label(
            default = Label("@pandoc//:pandoc"),
            executable = True,
            cfg = "exec",
        ),
    },
)
