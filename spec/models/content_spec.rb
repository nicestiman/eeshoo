# == Schema Information
#
# Table name: contents
#
#  id         :integer          not null, primary key
#  post_id    :integer
#  key        :string(255)
#  value      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Content do
  pending "add some examples to (or delete) #{__FILE__}"
end
