class Species
  attr_reader :details

  def self.all
    @filenames = []

    Dir.entries("./config/post_types/").each do |filename|
      next if filename == "."
      next if filename == ".."

      @filenames.push [filename.chomp(".yml"), filename.chomp(".yml")]
    end

    return @filenames.uniq
  end

  def initialize(type)
    if Species.all.include?(type)
      @details = YAML.load_file("#{Rails.root}/config/post_types/#{type}.yml")
    end
  end
end
