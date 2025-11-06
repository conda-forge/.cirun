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
    readme_words = readme.split()
    for resource in resources:
        if f"`{resource}`" not in readme_words:
            missing.append(resource)
    if missing:
        raise ValueError(
            f"Some resources are not documented:\n\n{missing}\n\n"
            f"Please edit '{path.resolve()}' accordingly. "
            "Final result must mention each resource in backticks; e.g. `resource-name`."
        )

sys.exit(0)
