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

    process_raw_input_and_gpt if step == steps.last

    render_wizard @diagnostic
  end

  private

  def set_diagnostic
    @diagnostic = current_user.diagnostic_responses.find_or_initialize_by(id: params[:diagnostic_id])
  end

  def diagnostic_params
    # Only require if present (for review step, it's empty)
    return {} unless params[:diagnostic]

    params.require(:diagnostic).permit(
      :irregular_periods, :cycle_length,
      :acne, :weight_gain, :facial_hair,
      :stress_level, :cramp_intensity, :family_history
    )
  end

  def process_raw_input_and_gpt
    answers = [
      "Periods irregular: #{@diagnostic.irregular_periods}",
      "Acne/oily skin: #{@diagnostic.acne}",
      "Weight gain: #{@diagnostic.weight_gain}",
      "Facial hair: #{@diagnostic.facial_hair}",
      "Stress level: #{@diagnostic.stress_level}",
      "Cycle length: #{@diagnostic.cycle_length}",
      "Cramp intensity: #{@diagnostic.cramp_intensity}",
      "Family history: #{@diagnostic.family_history}"
    ]

    @diagnostic.raw_input = answers.join(". ")
    @diagnostic.risk_level = "Medium" # placeholder
    @diagnostic.save!
  end
end
