class AppResponder < ActionController::Responder
  def to_json
    render json: {
      success: true,
      html: controller.render_to_string(controller.action_name, layout: false, formats: [:html])
    }
  end
end
