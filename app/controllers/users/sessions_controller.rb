class Users::SessionsController < DeviseController
  def destroy
    set_flash_message! :notice, :signed_out if sign_out
    respond_to do |format|
      format.all { head :no_content }
      format.any(*navigational_formats) { redirect_to after_sign_out_path_for(resource_name) }
    end
  end
end
