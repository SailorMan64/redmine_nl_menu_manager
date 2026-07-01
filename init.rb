require 'redmine'

REDMINE_NL_MENU_MANAGER_VERSION = '1.0.0'

Redmine::Plugin.register :redmine_nl_menu_manager do
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
    'top_menu'         => {}
  }, partial: 'settings/nl_menu_manager/settings'
end

require_relative 'after_init'
