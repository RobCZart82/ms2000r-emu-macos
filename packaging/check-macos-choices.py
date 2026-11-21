"""Check each installer component can be selected on its own without installing."""
import plistlib
import subprocess
import sys
from pathlib import Path
from tempfile import TemporaryDirectory

COMPONENTS = ("vst3", "au", "standalone")


def check_choices(package: Path) -> None:
    with TemporaryDirectory() as directory:
        changes = Path(directory) / "choices.plist"
        for selected in COMPONENTS:
            changes.write_bytes(plistlib.dumps([
                {
                    "choiceIdentifier": component,
                    "choiceAttribute": "selected",
                    "attributeSetting": int(component == selected),
                }
                for component in COMPONENTS
            ]))
            result = subprocess.check_output([
                "/usr/sbin/installer", "-pkg", str(package), "-target", "/",
                "-showChoicesAfterApplyingChangesXML", str(changes),
            ])
            attributes = {
                (entry["choiceIdentifier"], entry["choiceAttribute"]): entry["attributeSetting"]
                for entry in plistlib.loads(result)
            }
            for component in COMPONENTS:
                if (
                    not attributes.get((component, "visible"))
                    or not attributes.get((component, "enabled"))
                    or attributes.get((component, "selected")) != int(component == selected)
                ):
                    raise SystemExit(f"{package.name}: unexpected {component} state with only {selected} requested")
            print(f"{package.name}: {selected} can be selected independently")


if __name__ == "__main__":
    check_choices(Path(sys.argv[1]).resolve(strict=True))
