class PagesController < ApplicationController

  def root
    redirect_to dashboard_path
  end

  def dashboard
    respond_with(nil)
  end

  def about
    respond_with(nil)
  end

end

