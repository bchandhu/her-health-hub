class AddQuizFieldsToDiagnostics < ActiveRecord::Migration[7.1]
  def change
    add_column :diagnostics, :irregular_periods, :string
    add_column :diagnostics, :cycle_length, :string
    add_column :diagnostics, :acne, :string
    add_column :diagnostics, :weight_gain, :string
    add_column :diagnostics, :facial_hair, :string
    add_column :diagnostics, :stress_level, :string
    add_column :diagnostics, :cramp_intensity, :string
    add_column :diagnostics, :family_history, :string
  end
end
