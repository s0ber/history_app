class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

protected

  def render_page
    template = params[:action].to_s

    respond_to do |format|
      format.html
      format.json do
        render json: {
          success: true,
          html: render_to_string(template, layout: false, formats: [:html])
        }
      end
    end
  end

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
