class PagesController < ApplicationController

  def root
    redirect_to dashboard_path
  end

  def dashboard
    @conversation_name = 'Viva la Revolution'
    respond_with(nil)
  end

  def about
    respond_with(nil)
  end

end

