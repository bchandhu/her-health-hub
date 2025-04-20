# == Schema Information
#
# Table name: logs
#
#  id         :bigint           not null, primary key
#  date       :date
#  note       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_logs_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Log < ApplicationRecord
  belongs_to :user
  belongs_to :user, required: true, class_name: "User", foreign_key: "user_id"

end
