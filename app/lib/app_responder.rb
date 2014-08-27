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
    render layout: 'ajax_layout', formats: [:html], locals: {ijax_request_id: ijax_request_id}
  end

  private

  def ijax_request_id
    controller.params[:i_req_id] || '0'
  end
end
