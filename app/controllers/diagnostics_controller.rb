class DiagnosticsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_diagnostic, only: %i[show edit update destroy]

  # GET /diagnostics
  def index
    @diagnostics = current_user.diagnostic_responses.order(created_at: :desc)
  end

  # GET /diagnostics/1
  def show
  end

  # POST /start_new_diagnostic
  def start_new_diagnostic
    diagnostic = current_user.diagnostic_responses.create!
    redirect_to diagnostic_wizard_path(diagnostic, :cycle)
  end

  # GET /diagnostics/new (not used now, but keeping)
  def new
    @diagnostic = current_user.diagnostic_responses.build
  end

  # GET /diagnostics/1/edit
  def edit
  end

  # POST /diagnostics
  def create
    @diagnostic = current_user.diagnostic_responses.build(diagnostic_params)

    respond_to do |format|
      if @diagnostic.save
        format.html { redirect_to @diagnostic, notice: "Diagnostic was successfully created." }
        format.json { render :show, status: :created, location: @diagnostic }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @diagnostic.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /diagnostics/1
  def update
    respond_to do |format|
      if @diagnostic.update(diagnostic_params)
        format.html { redirect_to @diagnostic, notice: "Diagnostic was successfully updated." }
        format.json { render :show, status: :ok, location: @diagnostic }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @diagnostic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /diagnostics/1
  def destroy
    @diagnostic.destroy
    respond_to do |format|
      format.html { redirect_to diagnostics_url, notice: "Diagnostic was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # NOTE: This method could go into the report model as well
  def report
    @diagnostic = if params[:id].present?
        current_user.diagnostic_responses.find_by(id: params[:id])
      else
        current_user.diagnostic_responses.order(created_at: :desc).first
      end

    unless @diagnostic
      redirect_to diagnostics_path, alert: "Diagnostic not found." and return
    end

    @recent_logs = current_user.calendar_entries
      .where("date >= ?", 2.months.ago)
      .order(date: :desc)
      .limit(10)

    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "HerHealthHub_Report_#{@diagnostic.id}",
               template: "diagnostics/report",
               layout: "pdf",
               formats: [:html]
      end
    end
  end

  private

  def set_diagnostic
    @diagnostic = current_user.diagnostic_responses.find(params[:id])
  end

  def diagnostic_params
    params.require(:diagnostic).permit(:raw_input, :gpt_response, :risk_level)
  end
end
