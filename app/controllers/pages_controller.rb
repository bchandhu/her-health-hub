class PagesController < ApplicationController
  before_action :authenticate_user!, only: [:dashboard]

  def home
  
  end

  def dashboard
  @latest_diagnostic = current_user.diagnostic_responses.order(created_at: :desc).first
  @recent_logs = current_user.calendar_entries.order(date: :desc).limit(5)

  @this_month_logs = current_user.calendar_entries.where(date: Time.zone.today.beginning_of_month..Time.zone.today.end_of_month)
  @last_log = current_user.calendar_entries.order(date: :desc).first
end

end
