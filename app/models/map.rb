###
#This model reads and returns data from json topograph fime the
#maps directory
#
###

class Map
  attr_accessor :location

  ###
  # instanchates a map object has args
  #
  #location: the contry code or contry code and state code 
  # eg. BRA, BRARJ
  #
  ###
  def initialize(location = "")
    @location = location
  end

  def topo
    if @location.size == 3
      file = File.join Rails.root, "maps", "world_big.json"
    elsif @location.size > 3
      file = File.join Rails.root, "maps", "world_big.json"
    elsif @location.size == 0
      file = File.join Rails.root, "maps", "world_big.json"
    end

    file = File.read(file) 
    #file.class
    ActiveSupport::JSON.decode(file) 
  end
end
