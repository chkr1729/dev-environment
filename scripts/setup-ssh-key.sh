#!/usr/bin/env bash
# New ed25519 SSH key: Keychain-backed passphrase, uploaded to GitHub for auth + commit signing.
# Interactive (passphrase prompt, GitHub browser re-auth). Safe to re-run.
set -euo pipefail
KEY="$HOME/.ssh/id_ed25519"
EMAIL="$(git config user.email)"
GITCONFIG="$HOME/dev-environment/git/.gitconfig"

if [ ! -f "$KEY" ]; then
  ssh-keygen -t ed25519 -C "$EMAIL" -f "$KEY"
fi
ssh-add --apple-use-keychain "$KEY"

# Load the key from Keychain automatically (OrbStack's Include must stay first, so append)
if ! grep -q "UseKeychain" "$HOME/.ssh/config"; then
  cat >> "$HOME/.ssh/config" <<'CFG'

Host *
    AddKeysToAgent yes
    UseKeychain yes
    IdentityFile ~/.ssh/id_ed25519
CFG
fi

# GitHub: auth + signing key (needs extra token scopes; opens the browser once)
gh auth refresh -h github.com -s admin:public_key,admin:ssh_signing_key
TITLE="$(scutil --get ComputerName) $(date +%Y-%m)"
gh ssh-key add "$KEY.pub" --title "$TITLE" --type authentication || true
gh ssh-key add "$KEY.pub" --title "$TITLE" --type signing || true

# Sign commits with this key (stored in the dotfiles gitconfig)
mkdir -p "$HOME/.config/git"
echo "$EMAIL $(cat "$KEY.pub")" > "$HOME/.config/git/allowed_signers"
git config --file "$GITCONFIG" gpg.format ssh
git config --file "$GITCONFIG" user.signingkey "$KEY.pub"
git config --file "$GITCONFIG" gpg.ssh.allowedSignersFile "$HOME/.config/git/allowed_signers"
git config --file "$GITCONFIG" commit.gpgsign true
git config --file "$GITCONFIG" tag.gpgsign true

ssh -T git@github.com 2>&1 | head -1 || true
echo "Done. Old ~/.ssh/id_rsa left in place; remove it from GitHub/servers when nothing uses it."
