module Authorization
  extend ActiveSupport::Concern

  SAFE_METHODS = %w[GET HEAD].freeze

  included do
    before_action :authorize_action
    class_attribute :staff_allowed_actions, default: [].freeze
  end

  class_methods do
    def allow_staff_to(*actions) = self.staff_allowed_actions += actions.map(&:to_sym)
  end

  private

  def authorize_action
    return if Current.user.organizer?
    return if SAFE_METHODS.include? request.method
    return if self.class.staff_allowed_actions.include? action_name.to_sym

    deny_access
  end

  def deny_access
    respond_to do |format|
      format.html { redirect_back fallback_location: admin_root_path, alert: "You don't have permission to perform this action." }
      format.any  { head :forbidden }
    end
  end
end
