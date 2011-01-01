#!/usr/bin/env ruby

Dir.chdir ENV['HOME']

ebooks = [
  {
    :author   => "Mark McGuinness",
    :title    => "Time Management for Creative People",
    :category => "Productivity",
    :url      => "http://wishful.fileburst.com/creativetime.pdf"
  },
  {
    :author   => "Chris Brogan",
    :title    => "Using the Social Web to Find Work",
    :category => "Freelance",
    :url      => "http://www.chrisbrogan.com/img/socialwebforwork.pdf"
  },
  {
    :author   => "Chris Brogan",
    :title    => "Personal Branding",
    :category => "Freelance",
    :url      => "http://www.chrisbrogan.com/img/broganbranding.pdf"
  },
  {
    :author   => "Seth Godin",
    :title    => "What Matters Now",
    :category => "Freelance",
    :url      => "http://sethgodin.typepad.com/files/what-matters-now-1.pdf"
  },
  {
    :author   => "Sharon Hurley Hall",
    :title    => "Getting Started in Blogging",
    :category => "Blogging",
    :url      => "http://www.getpaidtowriteonline.com/Ebooks/GSIB%20Ebook.pdf"
  },
  {
    :author   => "Dave Navarro",
    :title    => "More Time Now: Time Management Made Simple Again",
    :category => "Productivity",
    :url      => "http://www.rockyourday.com/manifesto/MoreTimeNow.pdf"
  },
  {
    :author   => "Robert Schifreen",
    :title    => "The Web Book",
    :category => "Web Development",
    :url      => "http://www.the-web-book.com/index.php?a=xdl"
  },
  {
    :author   => "Mike Smith",
    :title    => "Guide to Guerilla Freelancing",
    :category => "Freelance",
    :url      => "http://www.guerrillafreelancing.com/download/1"
  },
  {
    :author   => "Michael Stelzner",
    :title    => "2010 Social Media Marketing Industry Report",
    :category => "Social Media",
    :url      => "http://marketingwhitepapers.s3.amazonaws.com/SocialMediaMarketingReport2010.pdf"
  },
  {
    :author   => "Peter Shallard",
    :title    => "Seek and Destroy",
    :category => "Freelance",
    :url      => "http://www.petershallard.com/downloads/SeekAndDestroy.pdf"
  },
  {
    :author   => "Leo Babauta",
    :title    => "focus : a simplicity manifesto in the age of distraction",
    :category => "Minimalism",
    :url      => "http://focusmanifesto.s3.amazonaws.com/FocusFree.pdf"
  },
  {
    :author   => "growwithstacy.com",
    :title    => "Powerful Thinking, Successful Living",
    :category => "Motivation",
    :url      => "http://growwithstacy.com/wp-content/uploads/2010/12/PowerfulThinking.pdf"
  },
  {
    :author   => "growwithstacy.com",
    :title    => "Blogging Basics",
    :category => "Blogging",
    :url      => "http://growwithstacy.com/wp-content/uploads/2010/08/Blogging-Basics.pdf"
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
