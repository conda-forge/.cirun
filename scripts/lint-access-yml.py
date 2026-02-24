import sys
from ruamel.yaml import YAML

yaml = YAML(typ="safe")

srv = "cirun-openstack"
gpu = [f"{srv}-gpu-{x}" for x in ["large", "xlarge", "2xlarge", "4xlarge"]]
cpu = [f"{srv}-cpu-{x}" for x in ["medium", "large", "xlarge", "2xlarge", "4xlarge"]]
win = [f"cirun-azure-windows-{x}large{y}" for x in ["2x", "4x"] for y in ["", "-ng"]]
expected_resources = gpu + cpu + win + ["cirun-macos-m4-large"]

for path in sys.argv[1:]:
    with open(path, "r") as f:
        access_yaml = yaml.load(f)
    # check policies are defined alphabetically
    policies = [x["id"] for x in access_yaml["policies"]]
    assert policies == sorted(policies)
    # check resources (and their order) match expectations
    assert [x["resource"] for x in access_yaml["access_control"]] == expected_resources
    # check policies within a resource are ordered
    for x in access_yaml["access_control"]:
        assert x["policies"] == sorted(x["policies"])

sys.exit(0)
