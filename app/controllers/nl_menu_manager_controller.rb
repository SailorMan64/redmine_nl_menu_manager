# Next Level™ Menu Manager — Controller
# Handles per-project menu order saves.
# Global order is saved through the standard plugin settings path
# (Administration > Plugins > Next Level Menu Manager > Settings).

class NlMenuManagerController < ApplicationController
  before_action :require_login
  before_action :find_project_by_project_id
  before_action :require_manager

  def save_project_order
    items_param = params[:nl_menu_items]

    unless items_param.is_a?(Array)
      render json: { error: 'Invalid params' }, status: :unprocessable_entity
      return
    end

    # Save position and visibility per enabled_module record
    items_param.each_with_index do |item, index|
      name    = item[:name].to_s
      visible = item[:visible].to_s != '0'
      em = @project.enabled_modules.find_by(name: name)
      next unless em
      em.update_columns(position: index + 1, visible: visible)
    end

    respond_to do |format|
      format.js   { render plain: 'ok' }
      format.html { redirect_to settings_project_path(@project, tab: 'modules') }
    end
  end

  private

  def require_manager
    render_403 unless User.current.allowed_to?(:manage_members, @project) ||
                      User.current.admin?
  end
end
