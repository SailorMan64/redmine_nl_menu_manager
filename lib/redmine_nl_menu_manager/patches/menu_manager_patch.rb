# Next Level™ Menu Manager — MenuManagerPatch
# Patches Redmine::MenuManager::MenuHelper#menu_items_for to apply
# global and per-project menu ordering and visibility.
#
# Priority:
#   1. Per-project enabled_modules.position / enabled_modules.visible
#   2. Global plugin settings (project_menu / application_menu / top_menu)
#   3. Registration order (fallback for items not in any saved config)

module RedmineNlMenuManager
  module Patches
    module MenuManagerPatch
      def self.included(base)
        base.alias_method :menu_items_for_without_nl, :menu_items_for
        base.alias_method :menu_items_for, :menu_items_for_with_nl
      end

      def menu_items_for_with_nl(menu, project = nil)
        items = []
        menu_children = Redmine::MenuManager.items(menu).root.children

        setting_key = menu.to_s  # 'project_menu', 'application_menu', 'top_menu'
        global_cfg  = NlMenuManager.global_config(setting_key)

        # Sort and filter
        menu_children = NlMenuManager.sort_and_filter(menu_children, global_cfg, menu, project)

        menu_children.each do |node|
          if node.allowed?(User.current, project)
            if block_given?
              yield node
            else
              items << node
            end
          end
        end

        return block_given? ? nil : items
      end
    end
  end
end
