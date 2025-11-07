import re
import sys
from pathlib import Path
from ruamel.yaml import YAML

yaml = YAML(typ="safe")

with Path(".cirun.global.yml").open() as f:
    cirun_yaml = yaml.load(f)
resources = [runner["name"] for runner in cirun_yaml["runners"]]

if not resources:
    raise ValueError("No configured resources?")

for path in sys.argv[1:]:
    if not path.endswith("README.md"):
        raise ValueError("This script only lints markdown files")
    missing = []
    path = Path(path)
    readme = path.read_text()
    for resource in resources:
        if not re.search(rf"\b{re.escape(resource)}\b", readme):
            missing.append(resource)
    if missing:
        raise ValueError(
            f"Some resources are not documented:\n\n{missing}\n\n"
            f"Please edit '{path.resolve()}' accordingly."
        )

sys.exit(0)
