# Deprecated Assets

This directory contains assets that have been deprecated during the production hardening process.

## Contents

### backups/
Contains backup files that were moved here during cleanup:
- `.bak` files from skills directory (original skill versions before enhancement)
- Settings backup file

## Why Deprecated

These files were deprecated because:
1. **Backup files**: Superseded by improved versions of skills
2. **Settings backups**: Routine backups that cluttered the main directory

## Restoration

If you need to restore any of these files, copy them back to their original location.
Files in `backups/` came from:
- `~/.claude/skills/*.bak` → skill backup files
- `~/.claude/settings.json.backup-*` → settings backups

---
*Deprecated: 2026-01-01 during production hardening*
