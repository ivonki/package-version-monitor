from pathlib import Path
import json
from datetime import datetime, timezone, timedelta

INCOMING = Path("data/incoming")
CURRENT = Path("data/current")
HISTORY = Path("data/history")

def load(file):
    with open(file) as f:
        return json.load(f)

for file in INCOMING.iterdir():
    if file.suffix != ".json":
        continue

    incoming = load(file)
    host = incoming["hostname"]

    current_file = CURRENT / f"{host}.json"
    history_file = HISTORY / f"{host}.log"

    if not current_file.exists():
        with open(current_file, "w") as f:
            json.dump(incoming, f, indent=4)
        file.unlink()
        continue

    current = load(current_file)

    changes = []

    for pkg, new_v in incoming["packages"].items():
        old_v = current["packages"].get(pkg)

        if old_v != new_v:
            changes.append((pkg, old_v, new_v))

    if changes:
        with open(history_file, "a") as log:
            log.write(f"\n[{datetime.now(timezone(timedelta(hours=3))).strftime('%d.%m.%Y %H:%M %Z')}]\n")
            for pkg, old, new in changes:
                log.write(f"{pkg}: {old} -> {new}\n")
        with open(current_file, "w") as f:
            json.dump(incoming, f, indent=4)

    file.unlink()
