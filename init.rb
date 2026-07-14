require 'redmine'

REDMINE_NL_MENU_MANAGER_VERSION = '1.0.0'

Redmine::Plugin.register :next_level_redmine_menu_manager do
  name        "Next Level™ Menu Manager v#{REDMINE_NL_MENU_MANAGER_VERSION}"
  author      'Manuel Palachuk — Next Level Strategy'
  description 'Global and per-project control over Redmine menu order and ' \
              'visibility for the project menu, application menu, and top menu. ' \
              'Drag-and-drop reordering with per-item on/off toggles. ' \
              'Built on the Next Level™ platform. Shared with the Redmine community.'
  version     REDMINE_NL_MENU_MANAGER_VERSION
  url         'https://github.com/SailorMan64/redmine_nl_menu_manager'
  author_url  'https://www.manuelpalachuk.com'

  requires_redmine version_or_higher: '5.1'

  settings default: {
    'project_menu'     => {},
    'application_menu' => {},
    'top_menu'         => {},
    'account_menu'     => {}
  }, partial: 'settings/nl_menu_manager/settings'
end

# Explicitly require lib files before after_init runs the prepend
require_relative 'lib/redmine_nl_menu_manager'
require_relative 'lib/redmine_nl_menu_manager/patches/menu_manager_patch'
require_relative 'lib/redmine_nl_menu_manager/patches/settings_controller_patch'
require_relative 'lib/redmine_nl_menu_manager/hooks'

require_relative 'after_init'
