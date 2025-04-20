class DiagnosticsController < ApplicationController
  before_action :set_diagnostic, only: %i[ show edit update destroy ]

  # GET /diagnostics or /diagnostics.json
  def index
    @diagnostics = Diagnostic.all
  end

  # GET /diagnostics/1 or /diagnostics/1.json
  def show
  end

  # GET /diagnostics/new
  def new
    @diagnostic = Diagnostic.new
  end

  # GET /diagnostics/1/edit
  def edit
  end

  # POST /diagnostics or /diagnostics.json
  def create
    @diagnostic = Diagnostic.new(diagnostic_params)

    respond_to do |format|
      if @diagnostic.save
        format.html { redirect_to diagnostic_url(@diagnostic), notice: "Diagnostic was successfully created." }
        format.json { render :show, status: :created, location: @diagnostic }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @diagnostic.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /diagnostics/1 or /diagnostics/1.json
  def update
    respond_to do |format|
      if @diagnostic.update(diagnostic_params)
        format.html { redirect_to diagnostic_url(@diagnostic), notice: "Diagnostic was successfully updated." }
        format.json { render :show, status: :ok, location: @diagnostic }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @diagnostic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /diagnostics/1 or /diagnostics/1.json
  def destroy
    @diagnostic.destroy!

    respond_to do |format|
      format.html { redirect_to diagnostics_url, notice: "Diagnostic was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_diagnostic
      @diagnostic = Diagnostic.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def diagnostic_params
      params.require(:diagnostic).permit(:user_id, :raw_input, :gpt_response, :risk_level)
    end
end
