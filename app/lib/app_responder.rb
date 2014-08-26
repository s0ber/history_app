class AppResponder < ActionController::Responder
  def to_json
    if @default_response
      @default_response.call(options)
    else
      render json: {
        success: true,
        html: controller.render_to_string(controller.action_name, layout: false, formats: [:html])
      }
    end
  end

  def to_al
    render layout: 'ajax_layout', formats: [:html], stream: true
  end
end
