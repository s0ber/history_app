class ApplicationController < BaseController
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def dashboard
    @conversation_name = 'Viva la Revolution'
    render_page
  end

  def search
    render_page
  end

  def about
    render_page
  end

end
