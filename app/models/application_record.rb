class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.new_filename(image)
    filename_digest(image.original_filename) + extract_extension(image.tempfile.path)
  end

  def self.filename_digest(filename)
    Digest::MD5.hexdigest(filename)[0, 22]
  end

  def self.extract_extension(filepath)
    File.extname(filepath)
  end
end
