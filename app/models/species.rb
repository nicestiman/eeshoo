class Species
  attr_reader :details, :type

  def self.all(options = {})
    @filenames = []

    Dir.entries("./config/post_types/").each do |filename|
      next if filename == "."
      next if filename == ".."

      if options[:selectable] == true
        @filenames.push [filename.chomp(".yml"), filename.chomp(".yml")]
      else
        @filenames.push filename.chomp(".yml")
      end
    end

    return @filenames.uniq
  end

  def initialize(type)
    @type = type.to_s
    if Species.all.include?(@type)
      @details = YAML.load_file("#{Rails.root}/config/post_types/#{@type}.yml")
    else
      return false
    end
  end
end
