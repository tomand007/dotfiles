# Which herdr pane holds which agent conversation, across all workspaces.
# An empty SESSION means the pane has no native session ref, so after a server
# restart it comes back as a plain shell instead of resuming the conversation.
hagents() {
  "$HOME/.config/zsh/herdr-agents.py" "$@"
}
