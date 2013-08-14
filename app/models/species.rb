class Species
  def self.all
    @filenames = []

    Dir.entries("./config/post_types/").each do |filename|
      next if filename == "."
      next if filename == ".."

      @filenames.push [filename.chomp(".yml"), filename.chomp(".yml")]
    end

    return @filenames.uniq
  end
end
