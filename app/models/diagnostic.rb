# == Schema Information
#
# Table name: diagnostics
#
#  id           :bigint           not null, primary key
#  gpt_response :text
#  raw_input    :text
#  risk_level   :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :bigint           not null
#
# Indexes
#
#  index_diagnostics_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Diagnostic < ApplicationRecord
  belongs_to :user
  belongs_to :user, required: true, class_name: "User", foreign_key: "user_id"

end
