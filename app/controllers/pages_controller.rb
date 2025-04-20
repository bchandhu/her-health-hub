class PagesController < ApplicationController
  before_action :authenticate_user!, only: [:dashboard]

  def home
  
  end

  def dashboard
    @latest_diagnostic = current_user.diagnostic_responses.order(created_at: :desc).first
    @recent_logs = current_user.calendar_entries.order(date: :desc).limit(5)
  end
end
