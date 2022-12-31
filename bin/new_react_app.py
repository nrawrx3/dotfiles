#!/usr/bin/env python3

import argparse
import os
from pathlib import Path
import subprocess
import json

index_html = """
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="utf-8" />
  <title>new react app</title>
  <link href="./index.css" rel="stylesheet">
</head>

<body>
  <div id="app"></div>

  <script type="module" src="index.tsx"></script>
</body>

</html>
""".strip()

index_tsx = """
import React from "react";
import ReactDOM from "react-dom/client";
import { createRoot } from "react-dom/client";
import { App } from "./App";

const container = document.getElementById("app");
const root = createRoot(container!);
root.render(<App />);

""".strip()


app_tsx = """
export function App() {
  return <h1>Hello world!</h1>;
}
"""

postcssrc = """
{
  "plugins": {
    "tailwindcss": {}
  }
}
""".strip()

tailwind_config_js = """
module.exports = {
  content: [
    "./src/**/*.{html,js,ts,jsx,tsx}",
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


def run_command(*, cmd: list[str], cwd, throw_on_error=True):
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
    project_path = Path(title)

    project_path.mkdir(exist_ok=True)
    index_html = index_html.format(title=title)

    src_dir = project_path / "src"
    src_dir.mkdir(exist_ok=True)

    with open(src_dir / "index.html", "w") as f:
        f.write(index_html)

    with open(src_dir / "index.tsx", "w") as f:
        f.write(index_tsx)

    with open(src_dir / "App.tsx", "w") as f:
        f.write(app_tsx)

    run_command(cmd=["yarn", "add", "react", "react-dom"], cwd=project_path)
    run_command(
        cmd=["yarn", "add", "@types/react", "@types/react-dom"], cwd=project_path
    )
    run_command(
        cmd=["yarn", "add", "tailwindcss", "postcss", "autoprefixer", "--dev"],
        cwd=project_path,
    )
    run_command(
        cmd=["yarn", "add", "@parcel/transformer-svg-react", "--dev"], cwd=project_path
    )

    with open(project_path / ".postcssrc", "w") as f:
        f.write(postcssrc)

    with open(project_path / "tailwind.config.js", "w") as f:
        f.write(tailwind_config_js)

    with open(src_dir / "index.css", "w") as f:
      f.write(index_css)

    with open(project_path / ".gitignore", "w") as f:
      f.write(gitignore)
