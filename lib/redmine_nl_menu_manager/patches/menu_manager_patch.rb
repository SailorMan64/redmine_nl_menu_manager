# Next Level™ Menu Manager — MenuManagerPatch
# Uses Module#prepend (Ruby 2.0+) to override menu_items_for cleanly.
# prepend puts this module BEFORE MenuHelper in the method lookup chain,
# so our method runs first and calls super to get the original behavior
# for anything we don't handle.

module RedmineNlMenuManager
  module Patches
    module MenuManagerPatch

      def menu_items_for(menu, project = nil)
        # Load global config for this menu
        setting_key = menu.to_s
        global_cfg  = NlMenuManager.global_config(setting_key)

        # If no config saved yet, fall through to original behavior
        if global_cfg.empty?
          return super
        end

        items = []
        menu_children = Redmine::MenuManager.items(menu).root.children

        # Apply sort and visibility filter
        menu_children = NlMenuManager.sort_and_filter(
          menu_children, global_cfg, menu, project
        )

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
