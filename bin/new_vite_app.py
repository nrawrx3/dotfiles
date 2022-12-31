#!/usr/bin/env python3

import argparse
import os
from pathlib import Path
import subprocess
import json


app_tsx = """
export default function App() {
  return <h1>Hello world!</h1>;
}
"""

tailwind_config_js = """
module.exports = {
  content: [
    "./src/**/*.{html,js,ts,jsx,tsx}",
    "./index.html",
    "../../libs/stories/src/lib/*.tsx"
  ],
  theme: {
    extend: {},
  },
  variants: {},
  plugins: [],
};
"""

index_css = """
@tailwind base;
@tailwind components;
@tailwind utilities;
"""

gitignore = """
# See https://help.github.com/articles/ignoring-files/ for more about ignoring files.

# dependencies
/node_modules
/.pnp
.pnp.js

# testing
/coverage

# production
/build

# misc
.DS_Store
.env.local
.env.development.local
.env.test.local
.env.production.local

npm-debug.log*
yarn-debug.log*
yarn-error.log*
"""


def run_command(*, cmd: list[str], cwd=None, throw_on_error=True):
    completed = subprocess.run(cmd, cwd=cwd, capture_output=True)
    print(f"Output:{completed.stdout.decode('utf-8')}")
    print(
        f"Error?: {'None' if completed.returncode == 0 else 'See below'}\n{completed.stderr.decode('utf-8')}"
    )
    if completed.returncode != 0:
        raise RuntimeError(f"Error while running command: \"{' '.join(cmd)}\"")
    return completed


if __name__ == "__main__":
    ap = argparse.ArgumentParser(
        description="create new react project, with hooks and blackjack"
    )
    ap.add_argument("title", nargs=1, help="name of project directory")
    args = ap.parse_args()

    title = args.title[0]

    run_command(
        cmd=f"npm create vite@latest {title} -- --template react-ts".split(" "),
        cwd=None,
    )
    project_path = Path(title)

    run_command(
        cmd="npm install -D tailwindcss postcss autoprefixer".split(" "),
        cwd=project_path,
    )

    run_command(
        cmd="npx tailwindcss init -p".split(" "),
        cwd=project_path,
    )

    with open(project_path / "src" / "App.tsx", "w") as f:
        f.write(app_tsx)

    with open(project_path / "tailwind.config.cjs", "w") as f:
        f.write(tailwind_config_js)

    with open(project_path / "src" / "index.css", "w") as f:
        f.write(index_css)

    with open(project_path / ".gitignore", "w") as f:
        f.write(gitignore)

    run_command(cmd="npm install".split(" "), cwd=project_path)
