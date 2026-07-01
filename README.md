# Next Level™ Menu Manager for Redmine

**Author:** Manuel Palachuk — [Next Level Strategy](https://www.manuelpalachuk.com)
**Version:** 1.0.0
**Compatibility:** Redmine 5.1+
**License:** MIT

---

## What It Does

Gives Redmine administrators full control over menu order and visibility across three menus:

- **Project App Menu** — the horizontal tab bar shown inside each project
- **Application Menu** — the global icon/link bar above the project menu
- **Top Menu** — the very top navigation bar (Home, Projects, My Page, etc.)

### Global defaults (Administration > Plugins > Next Level Menu Manager)
Drag items to reorder. Toggle the checkbox to show or hide each item globally. All projects inherit this order unless overridden.

### Per-project overrides (Project > Settings > Modules tab)
Each project can further reorder and hide menu items independently of the global default.

---

## Installation

```bash
cd /path/to/redmine/plugins
git clone https://github.com/SailorMan64/redmine_nl_menu_manager.git
cd /path/to/redmine
bundle exec rake redmine:plugins:migrate RAILS_ENV=production
touch tmp/restart.txt
```

---

## How It Works

The plugin patches `Redmine::MenuManager::MenuHelper#menu_items_for` — the single method responsible for building every Redmine menu. It applies ordering and visibility in priority order:

1. Per-project `enabled_modules.position` / `enabled_modules.visible` (if set)
2. Global plugin settings
3. Registration order (fallback for items not yet configured)

New plugins appear automatically at the end of each menu list — they are never silently dropped.

---

## Background

This plugin was inspired by [Redmine feature request #6984](https://www.redmine.org/issues/6984), open since 2010. The community patch on that issue is incomplete — it handles global ordering only, has no visibility toggle, and lives in Redmine core files. This plugin implements the full feature properly as a standalone, version-controlled, community-shareable plugin.

Built on the **Next Level™ platform** — the business strategy and coaching platform for IT service providers built by Manuel Palachuk.

---

## License

MIT License. See LICENSE file.
