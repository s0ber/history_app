class PagesController < ApplicationController

  def root
    redirect_to dashboard_path
  end

  def dashboard
    @conversation_name = 'Viva la Revolution'
    render_page
  end

  def about
    render_page
  end

end

