class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  include Pundit

  # Pundit: allow-list approach.
  # Allow-list faz ele bloquear todas as actions de todos os controllers
  # Ele obriga a chamarmos o metodo 'authorize' em todas as actions
  # exceto o index
  after_action :verify_authorized, except: :index, unless: :skip_pundit?
  # Isso obriga a chamarmos o metodo 'policy_scope(Class)'
  # dentro de todas as index actions de todos os controllers
  after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?

  #Uncomment when you *really understand* Pundit!
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(root_path)
  end

  private

  def skip_pundit?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
  end
end
