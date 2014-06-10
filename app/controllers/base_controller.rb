class BaseController < ActionController::Base

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

end
