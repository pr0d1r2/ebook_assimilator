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
    :md5sum   => "90ae18a42e216f246e62c980c52d3c1e",
    :suffix   => "pdf"
  },
  {
    :author   => "Mike Smith",
    :title    => "Guide to Guerilla Freelancing",
    :category => "Freelance",
    :url      => "http://www.guerrillafreelancing.com/download/1",
    :md5sum   => "fa476cef9e4309b500567de9b95db8bc",
    :suffix   => "pdf"
  },
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
  },
  {
    :author   => "Simon Black",
    :title    => "Network Infiltration",
    :category => "Networking",
    :url      => "http://sovereignman.com/Network%20Infiltration.pdf",
    :md5sum   => "0046fd66575ae653fd10684eece71ad8"
  },
  {
    :author   => "Mark Smith",
    :title    => "50 Guerrilla Marketing Tactics For Freelancers",
    :category => "Freelance",
    :url      => "http://www.guerrillafreelancing.com/download/2",
    :md5sum   => "73541e4a4dea97cebfcabb77db352df9",
    :suffix   => "pdf"
  },
  {
    :author   => "Ramit Sethi",
    :title    => "Earn More Money - earn1k-1.2-Pick-Your-Field-worksheet-form",
    :category => "Freelance",
    :url      => "http://earn1k.com/members/wp-content/uploads/earn1k-1.2-Pick-Your-Field-worksheet-form.pdf",
    :md5sum   => "10c910f5f09fdf83ae8cb9fb31ded92c"
  },
  {
    :author   => "Ramit Sethi",
    :title    => "Earn More Money - earn1k-1.2-worksheet2",
    :category => "Freelance",
    :url      => "http://earn1k.com/members/wp-content/uploads/earn1k-1.2-worksheet2.pdf",
    :md5sum   => "94b2ce3889d0842fb16f3840a4f034d8"
  },
  {
    :author   => "Ramit Sethi",
    :title    => "Earn More Money - earn1k-1.2-audio",
    :category => "Freelance",
    :url      => "http://earn1k.s3.amazonaws.com/audio/earn1k-1.2-audio.mp3",
    :md5sum   => "018194197d116b749ae07809202bdc05"
  },
  {
    :author   => "Ramit Sethi",
    :title    => "Earn1K Bonus PDF: Get Inside Their Heads",
    :category => "Freelance",
    :url      => "http://earn1k.s3.amazonaws.com/GetInsideTheirHeads.pdf",
    :md5sum   => "e82c4348ac305841b5553bb6a46eca74"
  },
  {
    :author   => "Ramit Sethi",
    :title    => "Earn1K Bonus Video: Unlocking side income case study",
    :category => "Freelance",
    :url      => "http://earn1k.com/privatelist/case-study-jackie-schmidt/",
    :md5sum   => "d3eb8b7e07ff21f06cda39599fee98e7",
    :suffix   => "html"
  },
  {
    :author   => "Derek Sivers",
    :title    => "How to Call Attention to Your Music",
    :category => "Music",
    :url      => "http://sivers.org/DerekSivers.pdf",
    :md5sum   => "2476b5b0fc8cf21be32c9bb15284ba62"
  },
  {
    :author   => "BJ Fogg",
    :title    => "Master Class - Psychology Of Persuasion",
    :category => "Psychology",
    :url      => "http://cdn.earn1k.com.s3.amazonaws.com/audio/BJFogg_PsychologyOfPersuasion.mp3",
    :md5sum   => "200b7660b53515e231cd03d7c3ac7f65"
  },
  {
    :author   => "BJ Fogg",
    :title    => "Master Class - Psychology Of Persuasion",
    :category => "Psychology",
    :url      => "http://earn1k.s3.amazonaws.com/FoggTranscript.pdf",
    :md5sum   => "8793a8798e4123917c3a1254cf6e6766"
  },
  {
    :author   => "Ramit Sethi",
    :title    => "30-day Hustling Course - Week 1 – Invisible Scripts - 1 Flipping The Script",
    :category => "Freelance",
    :url      => "http://earn1k.s3.amazonaws.com/ScriptAutomationReport.pdf",
    :md5sum   => "b4f29c3621c66798110ae7462528b53a"
  },
  {
    :author   => "Ramit Sethi",
    :title    => "30-day Hustling Course - Week 1 – Invisible Scripts - 2 Master Class Sneak Peek with Tim Ferriss",
    :category => "Freelance",
    :url      => "http://earn1k.s3.amazonaws.com/bonus/tim-ramit-bonus-video.zip",
    :md5sum   => "2e939b8f526d0113841ff8cdc8844580"
  },
  {
    :author   => "Ramit Sethi",
    :title    => "30-day Hustling Course - Week 1 – Invisible Scripts - 3 - 25 Hours A Day 8 Days A Week",
    :category => "Freelance",
    :url      => "http://earn1k.s3.amazonaws.com/time-clinic.zip",
    :md5sum   => "02d5fda3a059466c36af25b57dd01cc5"
  },
  {
    :author   => "Ramit Sethi",
    :title    => "30-day Hustling Course - Week 2 – Psychological Techniques to Dominate - 1 Bonus Psychology Study",
    :category => "Freelance",
    :url      => "http://earn1k.s3.amazonaws.com/BonusPsychologyCaseStudy.pdf",
    :md5sum   => "60056d91f69ec600f2b88a17467ce72a"
  },
  {
    :author   => "Ramit Sethi",
    :title    => "30-day Hustling Course - Week 2 – Psychological Techniques to Dominate - 2 Earn1K Bonus Material",
    :category => "Freelance",
    :url      => "http://earn1k.s3.amazonaws.com/GetInsideTheirHeads.pdf",
    :md5sum   => "e82c4348ac305841b5553bb6a46eca74"
  },
  {
    :author   => "Ramit Sethi",
    :title    => "30-day Hustling Course - Week 2 – Psychological Techniques to Dominate - 3 BJ Fogg Master Class",
    :category => "Freelance",
    :url      => "http://cdn.earn1k.com.s3.amazonaws.com/audio/BJFogg_PsychologyOfPersuasion.mp3",
    :md5sum   => "200b7660b53515e231cd03d7c3ac7f65"
  },
  {
    :author   => "Ramit Sethi",
    :title    => "30-day Hustling Course - Week 2 – Psychological Techniques to Dominate - 3 BJ Fogg Master Class",
    :category => "Freelance",
    :url      => "http://earn1k.s3.amazonaws.com/FoggTranscript.pdf",
    :md5sum   => "8793a8798e4123917c3a1254cf6e6766"
  },
  {
    :author   => "Ramit Sethi",
    :title    => "30-day Hustling Course - Week 3 – Negotiation - 1 Earn1K Bonus Material: From Free to Fee",
    :category => "Freelance",
    :url      => "http://cdn.earn1k.com/PDF/FreeToFee.pdf",
    :md5sum   => "7474b017f3ee43db6ce37afcb832d611"
  },
  {
    :author   => "Ramit Sethi",
    :title    => "30-day Hustling Course - Week 3 – Negotiation - 2 - 4 Negotiation Case Studies",
    :category => "Freelance",
    :url      => "http://earn1k.com/privatelist/4-negotiation-case-studies/",
    :md5sum   => "973a0a93eeb5df824f03257089b0941d",
    :suffix   => "html"
  },
  {
    :author   => "Ramit Sethi",
    :title    => "30-day Hustling Course - Week 3 – Negotiation - 3 Derek Sivers Master Class",
    :category => "Freelance",
    :url      => "http://cdn.earn1k.com/audio/DerekSivers_CDBaby100Million.mp3",
    :md5sum   => "dbd15e5a68ed2cf30fedba7c2700f522"
  },
  {
    :author   => "Ramit Sethi",
    :title    => "30-day Hustling Course - Week 3 – Negotiation - 3 Derek Sivers Master Class",
    :category => "Freelance",
    :url      => "http://cdn.earn1k.com/PDF/SiversTranscript.pdf",
    :md5sum   => "3a4a7a210188dbbd26ac67c2b20f6fb9"
  },
  {
    :author   => "Ramit Sethi",
    :title    => "30-day Hustling Course - Week 3 – Negotiation - 4 My 69-min interview with a pickup artist",
    :category => "Freelance",
    :url      => "http://cdn.earn1k.com/audio/PickUpPodcast_RamitSethi.mp3",
    :md5sum   => "7d61c7bbc35359fb3219fafccf289cd9"
  },
  {
    :author   => "Ramit Sethi",
    :title    => "30-day Hustling Course - Week 3 – Negotiation - 4 My 69-min interview with a pickup artist",
    :category => "Freelance",
    :url      => "http://cdn.earn1k.com/PDF/PickUpPodcastTranscript.pdf",
    :md5sum   => "6077f3c9021a69986634743dcf1ed907"
  },
  {
    :author   => "Ramit Sethi",
    :title    => "30-day Hustling Course - Week 4 – How to be awesome - 1 Earn1K Bonus Material: Unlocking Side Income",
    :category => "Freelance",
    :url      => "http://cdn.earn1k.com/PDF/EarnMoreCaseStudy.pdf",
    :md5sum   => "364c7d9d4e643410f6e6f92a4b9fa82e"
  },
  {
    :author   => "Ramit Sethi",
    :title    => "30-day Hustling Course - Week 4 – How to be awesome - 2 Tim Ferris Interview",
    :category => "Freelance",
    :url      => "http://cdn.earn1k.com/audio/Tim-Ferriss-Psychology-of-Testing.mp3",
    :md5sum   => "89d1ed6c9c329ed8fa9ee29b17c9aa5d"
  },
  {
    :author   => "Ramit Sethi",
    :title    => "30-day Hustling Course - Week 4 – How to be awesome - 2 Tim Ferris Interview",
    :category => "Freelance",
    :url      => "http://cdn.earn1k.com/PDF/TimFerris-The-Psychology-of-Testing.pdf",
    :md5sum   => "c909f96334be030ddf046ad9a3e6f79b"
  },
  {
    :author   => "Intel",
    :title    => "Dual-Channel DDR Memory Architecture White Paper",
    :category => "Hardware",
    :url      => "http://www.kingston.com/newtech/mkf_520ddrwhitepaper.pdf",
    :md5sum   => "6deffff46cc820f40b245037880a73fe"
  },
  {
    :author   => "Ramit Sethi",
    :title    => "7-day Private Course Day 1 - How To Maximize Motiviation and Optimize Your Time",
    :category => "Freelance",
    :url      => "http://earn1k.com/preview/how-to-maximize-motiviation-and-optimize-your-time/",
    :md5sum   => "b0c1220c64992071d112a88715063cf9",
    :suffix   => "html"
  },
  {
    :author   => "Ramit Sethi",
    :title    => "7-day Private Course Day 1 - 12 Month Goals Worksheet",
    :category => "Freelance",
    :url      => "http://earn1k.com/members/wp-content/uploads/12-Month-Goals-Worksheet1.pdf",
    :md5sum   => "24a669c3d7449176f7388c0e594d1cf4"
  },
  {
    :author   => "Ramit Sethi",
    :title    => "7-day Private Course Day 1 - Time Clinic Video",
    :category => "Freelance",
    :url      => "http://earn1k.s3.amazonaws.com/time-clinic.zip",
    :md5sum   => "02d5fda3a059466c36af25b57dd01cc5"
  },
  {
    :author   => "Ramit Sethi",
    :title    => "Webcast: Multiple streams of income on 5 hours a week",
    :category => "Freelance",
    :url      => "http://cdn.earn1k.com.s3.amazonaws.com/webinars/MultipleStreamsOfIncome.mov",
    :md5sum   => "9156d82559b39961c79d8bf428c65a7b"
  },
]

Dir.mkdir("EbooksAssimilated") unless File.directory?("EbooksAssimilated")
Dir.chdir("EbooksAssimilated")

ebooks.each do |ebook|
  ebook = Ebook.download_verbose!(ebook)
end
