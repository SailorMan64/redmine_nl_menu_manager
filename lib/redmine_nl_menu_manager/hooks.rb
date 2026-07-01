# Next Level™ Menu Manager — View Hooks

module RedmineNlMenuManager
  class Hooks < Redmine::Hook::ViewListener
    # Inject CSS + JS into every page head
    render_on :view_layouts_base_html_head,
              partial: 'hooks/redmine_nl_menu_manager/html_head'

    # Inject per-project menu order UI into project settings
    render_on :view_projects_settings_tab_bottom,
              partial: 'hooks/redmine_nl_menu_manager/project_settings_tab'
  end
end
