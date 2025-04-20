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

  # GET /diagnostics/new
  def new
    @diagnostic = current_user.diagnostic_responses.build
  end

  # GET /diagnostics/1/edit
  def edit
  end

  # POST /diagnostics
  def create
    answers = [
      "Periods irregular: #{params[:irregular_periods]}",
      "Acne/oily skin: #{params[:acne]}",
      "Weight gain: #{params[:weight_gain]}",
      "Facial hair: #{params[:facial_hair]}",
      "Stress level: #{params[:stress_level]}",
      "Cycle length: #{params[:cycle_length]}",
      "Cramp intensity: #{params[:cramp_intensity]}",
      "Family history: #{params[:family_history]}"
    ]
  
    combined_input = answers.join(". ")
  
    @diagnostic = current_user.diagnostic_responses.build(
      raw_input: combined_input
    )
  
    if @diagnostic.raw_input.present?
      chat = OpenAI::Chat.new
      chat.system("You are a women's health assistant. Based on the user's answers, assess the risk level of PCOS as Low, Medium, or High. Respond gently and clearly.")
      chat.user(@diagnostic.raw_input)
      gpt_reply = chat.assistant! # This gives the final response
  
      @diagnostic.gpt_response = gpt_reply
      @diagnostic.risk_level = extract_risk_level(gpt_reply)
    end
  
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

  private

    def set_diagnostic
      @diagnostic = current_user.diagnostic_responses.find(params[:id])
    end

    def diagnostic_params
      params.require(:diagnostic).permit(:raw_input, :gpt_response, :risk_level)
    end

    def extract_risk_level(response)
      response.downcase.include?("high") ? "High" :
      response.downcase.include?("medium") ? "Medium" :
      response.downcase.include?("low") ? "Low" : "Unknown"
    end
    
end
