# Next Level™ Menu Manager — SettingsController patch
# Intercepts the plugin action to normalize checkbox values before save.
# Unchecked HTML checkboxes send nothing — we must explicitly write
# visible: false for absent keys across all managed menus.

module RedmineNlMenuManager
  module Patches
    module SettingsControllerPatch
      module InstanceMethods
        def plugin
          if params[:id] == 'next_level_redmine_menu_manager' && request.post?
            raw = params[:settings] ? params[:settings].permit!.to_h : {}
            params[:settings] = ActionController::Parameters.new(
              NlMenuManager.normalize_settings(raw)
            )
          end
          super
        end
      end
    end
  end
end
