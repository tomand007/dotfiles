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

# One colour per repository, so a workspace and its worktrees read as one group.
GROUP_STYLES = ["cyan", "magenta", "green", "yellow", "blue", "bright_white"]


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

    def group_of(ws_id):
        return (spaces.get(ws_id, {}).get("worktree") or {}).get("repo_key") or ws_id

    def linked(ws_id):
        return bool((spaces.get(ws_id, {}).get("worktree") or {}).get("is_linked_worktree"))

    # Group order follows the lowest workspace number in each group, so a repo's
    # main checkout keeps its place and its worktrees follow it.
    # Only groups that actually hold an agent take a colour, so an idle workspace
    # does not shift the palette.
    with_agents = {a["workspace_id"] for a in agents}
    first_seen = {}
    for ws_id, ws in sorted(spaces.items(), key=lambda kv: kv[1]["number"]):
        if ws_id in with_agents:
            first_seen.setdefault(group_of(ws_id), len(first_seen))
    colour = {g: GROUP_STYLES[i % len(GROUP_STYLES)] for g, i in first_seen.items()}
    roots = {group_of(w) for w in spaces if not linked(w)}

    agents.sort(
        key=lambda a: (
            first_seen.get(group_of(a["workspace_id"]), 0),
            linked(a["workspace_id"]),
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
        ws_id = a["workspace_id"]
        label = spaces.get(ws_id, {}).get("label", ws_id)
        if linked(ws_id) and group_of(ws_id) in roots:
            label = f"  \u2514 {label}"
        table.add_row(
            label,
            tabs.get(a["tab_id"], {}).get("label", a["pane_id"]),
            a["agent"],
            a["agent_status"],
            session,
            a["terminal_title_stripped"],
            style=colour.get(group_of(a["workspace_id"]), ""),
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
