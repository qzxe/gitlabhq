class Groups::ApplicationController < ApplicationController
  include RoutableActions

  layout 'group'

  skip_before_action :authenticate_user!
  before_action :group

  private

  def group
    @group ||= find_routable!(Group, params[:group_id] || params[:id])
  end

  def group_projects
    @projects ||= GroupProjectsFinder.new(group: group, current_user: current_user).execute
  end

  def authorize_admin_group!
    unless can?(current_user, :admin_group, group)
      return render_404
    end
  end

  def authorize_admin_group_member!
    unless can?(current_user, :admin_group_member, group)
      return render_403
    end
  end

  def build_canonical_path(group)
    params[:group_id] = group.to_param

    url_for(params)
  end
end
