#!/usr/bin/env ruby

require 'digest/md5'
require 'net/http'
require 'uri'
require 'fileutils'

require 'lib/ebook'

Dir.chdir ENV['HOME']

ebooks = [
  {
    :author   => "Mark McGuinness",
    :title    => "Time Management for Creative People",
    :category => "Productivity",
    :url      => "http://wishful.fileburst.com/creativetime.pdf",
    :md5sum   => "3b68f71cd322fcaad7ec8ac4c0df540f"
  },
  {
    :author   => "Chris Brogan",
    :title    => "Using the Social Web to Find Work",
    :category => "Freelance",
    :url      => "http://www.chrisbrogan.com/img/socialwebforwork.pdf",
    :md5sum   => "db543aab97b45f0a2f34619b75915c76"
  },
  {
    :author   => "Chris Brogan",
    :title    => "Personal Branding",
    :category => "Freelance",
    :url      => "http://www.chrisbrogan.com/img/broganbranding.pdf",
    :md5sum   => "e01081b23f3f989a30d5890e2c5c4d15"
  },
  {
    :author   => "Seth Godin",
    :title    => "What Matters Now",
    :category => "Freelance",
    :url      => "http://sethgodin.typepad.com/files/what-matters-now-1.pdf",
    :md5sum   => "b19b5ebdb27450d69d9b16718530cd6c"
  },
  {
    :author   => "Sharon Hurley Hall",
    :title    => "Getting Started in Blogging",
    :category => "Blogging",
    :url      => "http://www.getpaidtowriteonline.com/Ebooks/GSIB%20Ebook.pdf",
    :md5sum   => "45ce82b1802c4de2f8f62f48f1be0e07"
  },
  {
    :author   => "Dave Navarro",
    :title    => "More Time Now: Time Management Made Simple Again",
    :category => "Productivity",
    :url      => "http://www.rockyourday.com/manifesto/MoreTimeNow.pdf",
    :md5sum   => "955a2141628c968af5c7e3b743504824"
  },
  {
    :author   => "Robert Schifreen",
    :title    => "The Web Book",
    :category => "Web Development",
    :url      => "http://www.the-web-book.com/index.php?a=xdl",
    :md5sum   => "90ae18a42e216f246e62c980c52d3c1e"
  },
  #{
    #:author   => "Mike Smith",
    #:title    => "Guide to Guerilla Freelancing",
    #:category => "Freelance",
    #:url      => "http://www.guerrillafreelancing.com/download/1"
  #},
  {
    :author   => "Michael Stelzner",
    :title    => "2010 Social Media Marketing Industry Report",
    :category => "Social Media",
    :url      => "http://marketingwhitepapers.s3.amazonaws.com/SocialMediaMarketingReport2010.pdf",
    :md5sum   => "f8453506d562ceee0598313f679ad1d8"
  },
  {
    :author   => "Peter Shallard",
    :title    => "Seek and Destroy",
    :category => "Freelance",
    :url      => "http://www.petershallard.com/downloads/SeekAndDestroy.pdf",
    :md5sum   => "081189643a4256ae8d57c6ac5377db7e"
  },
  {
    :author   => "Leo Babauta",
    :title    => "focus : a simplicity manifesto in the age of distraction",
    :category => "Minimalism",
    :url      => "http://focusmanifesto.s3.amazonaws.com/FocusFree.pdf",
    :md5sum   => "12f8edde36f001f2077b4c5ebf19c638"
  },
  {
    :author   => "growwithstacy.com",
    :title    => "Powerful Thinking, Successful Living",
    :category => "Motivation",
    :url      => "http://growwithstacy.com/wp-content/uploads/2010/12/PowerfulThinking.pdf",
    :md5sum   => "adfd08aa121f67b95a4fb65316dbe5cc"
  },
  {
    :author   => "growwithstacy.com",
    :title    => "Blogging Basics",
    :category => "Blogging",
    :url      => "http://growwithstacy.com/wp-content/uploads/2010/08/Blogging-Basics.pdf",
    :md5sum   => "d3ef394e050e6476fe3dfcf108e2ed81"
  }
]

Dir.mkdir("EbooksAssimilated") unless File.directory?("EbooksAssimilated")
Dir.chdir("EbooksAssimilated")

ebooks.each do |ebook|
  ebook = Ebook.download_verbose!(ebook)
end

