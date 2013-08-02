require 'spec_helper'

describe Role do
  it {should respond_to(:name)}
  it {should respond_to(:permissions)}
end
