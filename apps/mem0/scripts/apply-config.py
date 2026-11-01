"""Make MEM0_CONFIG_OVERRIDES (JSON) the server's runtime config.

The server merges a `config_overrides` row from its app database over the defaults it builds
from env vars; the dashboard and POST /configure write that row. Replacing it on every start
keeps the deployment's config authoritative. Leave the variable unset to keep whatever the
row already holds.
"""

import json
import os
import sys

raw = os.environ.get("MEM0_CONFIG_OVERRIDES", "").strip()
if not raw:
    sys.exit(0)

overrides = json.loads(raw)
if not isinstance(overrides, dict):
    sys.exit("MEM0_CONFIG_OVERRIDES must be a JSON object")

sys.path.insert(0, "/app")
from db import SessionLocal  # noqa: E402
from models import Settings  # noqa: E402

value = json.dumps(overrides)
with SessionLocal() as session:
    row = session.get(Settings, "config_overrides")
    if row is None:
        session.add(Settings(key="config_overrides", value=value))
    else:
        row.value = value
    session.commit()

print(f"Applied MEM0_CONFIG_OVERRIDES ({', '.join(sorted(overrides))})")
