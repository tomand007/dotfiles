#!/usr/bin/env -S uv run --quiet --script
# /// script
# requires-python = ">=3.11"
# dependencies = ["rich>=13"]
# ///
"""Table of herdr panes and the agent conversation each one holds.

An empty SESSION means herdr has no native session reference for that pane, so a
server restart brings it back as a plain shell instead of resuming the agent.
"""

import json
import subprocess
import sys

from rich.console import Console
from rich.table import Table

# One colour per workspace, cycled in workspace order.
WORKSPACE_STYLES = ["cyan", "magenta", "green", "yellow", "blue", "bright_white"]


def herdr(*args):
    out = subprocess.run(
        ["herdr", *args], capture_output=True, text=True, check=True
    ).stdout
    return json.loads(out)["result"]


def main():
    agents = herdr("agent", "list")["agents"]
    tabs = {t["tab_id"]: t for t in herdr("tab", "list")["tabs"]}
    spaces = {w["workspace_id"]: w for w in herdr("workspace", "list")["workspaces"]}

    table = Table(header_style="bold", expand=True)
    table.add_column("SPACE", no_wrap=True)
    table.add_column("TAB", style="bold", no_wrap=True)
    table.add_column("AGENT", no_wrap=True)
    table.add_column("STATUS", no_wrap=True)
    table.add_column("SESSION", no_wrap=True)
    table.add_column(
        "TITLE", style="dim", no_wrap=True, overflow="ellipsis", ratio=1, min_width=20
    )

    order = sorted(spaces, key=lambda w: spaces[w]["number"])
    colour = {
        w: WORKSPACE_STYLES[i % len(WORKSPACE_STYLES)] for i, w in enumerate(order)
    }
    agents.sort(
        key=lambda a: (
            spaces.get(a["workspace_id"], {}).get("number", 0),
            tabs.get(a["tab_id"], {}).get("number", 0),
        )
    )
    missing = 0
    for a in agents:
        ref = a.get("agent_session", {}).get("value")
        if ref:
            session = ref[:8]
        else:
            session = "[bold red]none[/]"
            missing += 1
        table.add_row(
            spaces.get(a["workspace_id"], {}).get("label", a["workspace_id"]),
            tabs.get(a["tab_id"], {}).get("label", a["pane_id"]),
            a["agent"],
            a["agent_status"],
            session,
            a["terminal_title_stripped"],
            style=colour.get(a["workspace_id"], ""),
        )

    console = Console()
    console.print(table)
    if missing:
        console.print(
            f"[bold red]{missing}[/] pane(s) without a session ref "
            "will restore as a plain shell."
        )


if __name__ == "__main__":
    sys.exit(main())
