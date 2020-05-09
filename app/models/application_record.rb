class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.remove_whitelist_like_strings(text)
    text.gsub(/[\u200D\u2060\uFEFF\u180E\u200B\u200C]/, '')
  end

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
