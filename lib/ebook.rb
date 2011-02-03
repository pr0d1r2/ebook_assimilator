require 'digest/md5'
require 'net/http'
require 'uri'
require 'fileutils'

class Ebook

  attr :author
  attr :title
  attr :category
  attr :url
  attr :md5sum
  attr :suffix

  def initialize(options)
    @author   = options[:author]
    @title    = options[:title]
    @category = options[:category]
    @url      = options[:url]
    @md5sum   = options[:md5sum]
    @suffix   = options[:suffix]
  end

  def download_verbose!
    make_category_dir
    enter_category_dir
    print_information
    download
    warn_about_md5sum
    exit_category_dir
  end

  def self.download_verbose!(ebook)
    Ebook.new(ebook).download_verbose!
  end

  private

    def make_category_dir
      Dir.mkdir(category) unless File.directory?(category)
    end

    def enter_category_dir
      Dir.chdir(category)
    end

    def exit_category_dir
      Dir.chdir('..')
    end

    def uri
      URI.parse(url)
    end

    def suffix_from_path
      uri.path.split('.').last
    end

    def smart_suffix
      return suffix_from_path if suffix.nil?
      suffix
    end

    def output_file
      "#{author} - #{title}.#{smart_suffix}"
    end

    def exist?
      File.exist?(output_file)
    end

    def output_file_body
      File.read(output_file)
    end

    def existing_md5sum
      Digest::MD5.hexdigest(output_file_body)
    end

    def md5sum_ok?
      existing_md5sum == md5sum
    end

    def ok?
      exist? && md5sum_ok?
    end

    def download
      download_raw unless ok?
    end

    def touch_file
      FileUtils.touch(output_file)
    end

    def download_raw
      touch_file
      Net::HTTP.start(uri.host) do |http|
        f = open(output_file, "w")
        begin
          http.request_get(uri.request_uri) do |response|
            response.read_body do |segment|
              f.write(segment)
            end
          end
        ensure
          f.close()
        end
      end
    end

    def warn_about_md5sum
      return if md5sum_ok?
      puts "WARNING: file MD5 sum different from expected. Propably problem with download."
    end

    def print_information
      puts "#{category} / #{author} \"#{title}\" (#{url})"
    end

end
