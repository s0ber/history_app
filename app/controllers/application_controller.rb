require 'app_responder'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  self.responder = AppResponder
  respond_to :html, :json

protected

  def render_partial(template, options = {})
    respond_to do |format|
      format.html
      format.json do
        render json: {
          success: true,
          html: render_to_string(partial: template, layout: false, formats: [:html], locals: options)
        }
      end
    end
  end

end
