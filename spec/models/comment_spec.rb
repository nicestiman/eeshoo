# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  message    :string(255)
#  post_id    :integer
#  author_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Comment do
  pending "add some examples to (or delete) #{__FILE__}"
end
