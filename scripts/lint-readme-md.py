import sys
from pathlib import Path
from ruamel.yaml import YAML

yaml = YAML(typ="safe")

with Path(".access.yml").open() as f:
    access_yaml = yaml.load(f)
resources = [resource["resource"] for resource in access_yaml["access_control"]]

for path in sys.argv[1:]:
    if not path.endswith("README.md"):
        raise ValueError("This script only lints markdown files")
    missing = []
    path = Path(path)
    readme = path.read_text()
    for resource in resources:
        if resource not in readme:
            missing.append(resource)
    if missing:
        raise ValueError(
            f"Some resources are not documented: {missing}. "
            f"Please edit '{path.resolve()}' accordingly."
        )

sys.exit(0)
