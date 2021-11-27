class RegistrationsController < Devise::RegistrationsController

  def admin
    current_user.admin == TRUE
  end

  def regular_user
    current_user.admin == FALSE
  end

  protected

  def after_sign_up_path_for(resource)
    '/role'
  end


end
