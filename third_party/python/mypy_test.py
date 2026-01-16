import os
import sys

from mypy.main import main

if __name__ == "__main__":
    mypy_path = set()
    args = []
    for arg in sys.argv[1:]:
        if arg.startswith("--mypy-path="):
            p = arg[len("--mypy-path="):]
            if not p:
                continue
            if os.path.exists(p):
                if os.path.isfile(p):
                    # We want the directory containing the package.
                    # e.g. .../stubs/requests/requests/__init__.pyi -> .../stubs/requests
                    d = os.path.dirname(p)
                    # If it's a package, the directory name matches the package name.
                    # We want the parent of the package directory.
                    if os.path.exists(os.path.join(d, "__init__.pyi")):
                        d = os.path.dirname(d)
                    mypy_path.add(d)
                else:
                    mypy_path.add(p)
            else:
                mypy_path.add(p)
        else:
            args.append(arg)

    if mypy_path:
        orig = os.environ.get("MYPYPATH")
        if orig:
            mypy_path.update(orig.split(":"))
        os.environ["MYPYPATH"] = ":".join(sorted(mypy_path))

    sys.argv = [sys.argv[0]] + args
    main()
