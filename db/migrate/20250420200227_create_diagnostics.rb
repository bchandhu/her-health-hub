class CreateDiagnostics < ActiveRecord::Migration[7.1]
  def change
    create_table :diagnostics do |t|
      t.references :user, null: false, foreign_key: true
      t.text :raw_input
      t.text :gpt_response
      t.string :risk_level

      t.timestamps
    end
  end
end
