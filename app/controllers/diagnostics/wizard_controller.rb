require "openai"
require "dotenv/load"
class Diagnostics::WizardController < ApplicationController
  include Wicked::Wizard

  before_action :authenticate_user!
  before_action :set_diagnostic

  steps *%w[cycle symptoms lifestyle review]

  def show
    render_wizard
  end

  def update
    @diagnostic.assign_attributes(diagnostic_params)
    @diagnostic.user = current_user

    if step == steps.last
      process_raw_input_and_gpt
      @diagnostic.save!
      redirect_to diagnostic_path(@diagnostic) and return
    else
      render_wizard @diagnostic
    end
  end

  private

  def set_diagnostic
    @diagnostic = current_user.diagnostic_responses.find_or_initialize_by(id: params[:diagnostic_id])
  end

  def diagnostic_params
    return {} unless params[:diagnostic]

    params.require(:diagnostic).permit(
      :irregular_periods, :cycle_length,
      :acne, :weight_gain, :facial_hair,
      :stress_level, :cramp_intensity, :family_history
    )
  end

  def process_raw_input_and_gpt
    answers = [
      "Irregular periods: #{@diagnostic.irregular_periods}",
      "Cycle length: #{@diagnostic.cycle_length}",
      "Acne/oily skin: #{@diagnostic.acne}",
      "Weight gain: #{@diagnostic.weight_gain}",
      "Facial hair: #{@diagnostic.facial_hair}",
      "Stress level: #{@diagnostic.stress_level}",
      "Cramp intensity: #{@diagnostic.cramp_intensity}",
      "Family history of PCOS: #{@diagnostic.family_history}"
    ]
  
    combined_input = answers.join("\n")
    @diagnostic.raw_input = combined_input
  
    client = OpenAI::Client.new(access_token: ENV.fetch("OPENAI_ACCESS_TOKEN"))
  
    begin
      response = client.chat(
        parameters: {
          model: "gpt-3.5-turbo",
          messages: [
            {
              role: "system",
              content: "You are a compassionate women's health assistant helping users assess their risk for PCOS based on symptoms."
            },
            {
              role: "user",
              content: <<~PROMPT
                Below are the user responses to a PCOS risk quiz:
  
                #{combined_input}
  
                Based on the above, assess the PCOS risk level (Low, Medium, or High) and explain your reasoning clearly in 4–6 lines.
              PROMPT
            }
          ],
          temperature: 0.7
        }
      )
  
      gpt_reply = response.dig("choices", 0, "message", "content")
      @diagnostic.gpt_response = gpt_reply
      @diagnostic.risk_level = extract_risk_level(gpt_reply)
    rescue => e
      @diagnostic.gpt_response = "Sorry, GPT could not process your request."
      @diagnostic.risk_level = "Unknown"
      Rails.logger.error("GPT error: #{e.message}")
    end
  
    @diagnostic.save!
  end
  
  
  
  def extract_risk_level(response)
    case response.downcase
    when /high/ then "High"
    when /medium/ then "Medium"
    when /low/ then "Low"
    else "Unknown"
    end
  end
end
