#!/usr/bin/env ruby

Dir.chdir ENV['HOME']

ebooks = [
  {
    :author   => "Mark McGuinness",
    :title    => "Time Management for Creative People",
    :category => "Productivity",
    :url      => "http://wishful.fileburst.com/creativetime.pdf"
  }
]

Dir.mkdir("EbooksAssimilated") unless File.directory?("EbooksAssimilated")
Dir.chdir("EbooksAssimilated")

ebooks.each do |ebook|
  Dir.mkdir(ebook[:category]) unless File.directory?(ebook[:category])
  Dir.chdir(ebook[:category])

  suffix = ebook[:url].split('.')[-1]

  puts
  puts "#{ebook[:category]} / #{ebook[:author]} \"#{ebook[:title]}\" (#{ebook[:url]})"
  puts
  system("curl -C - #{ebook[:url]} -o \"#{ebook[:author]} - #{ebook[:title]}.#{suffix}\"")
  puts

  Dir.chdir('..')
end
