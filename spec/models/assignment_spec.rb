# == Schema Information
#
# Table name: assignments
#
#  id         :integer          not null, primary key
#  role       :string(255)
#  group_id   :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Assignment do
  pending "add some examples to (or delete) #{__FILE__}"
end
