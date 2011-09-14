# coding: utf-8

#!/usr/bin/env ruby

require 'digest/md5'
require 'net/http'
require 'uri'
require 'fileutils'

require_relative 'lib/ebook'

Dir.chdir ENV['HOME']

ebooks = [
  {
    :author    => "Mark McGuinness",
    :title     => "Time Management for Creative People",
    :category  => "Productivity",
    :url       => "http://wishful.fileburst.com/creativetime.pdf",
    :md5sum    => "3b68f71cd322fcaad7ec8ac4c0df540f",
    :file_size => 214
  },
  {
    :author    => "Chris Brogan",
    :title     => "Using the Social Web to Find Work",
    :category  => "Freelance",
    :url       => "http://www.chrisbrogan.com/img/socialwebforwork.pdf",
    :md5sum    => "db543aab97b45f0a2f34619b75915c76",
    :file_size => 1088318
  },
  {
    :author    => "Chris Brogan",
    :title     => "Personal Branding",
    :category  => "Freelance",
    :url       => "http://www.chrisbrogan.com/img/broganbranding.pdf",
    :md5sum    => "e01081b23f3f989a30d5890e2c5c4d15",
    :file_size => 225117
  },
  {
    :author    => "Seth Godin",
    :title     => "What Matters Now",
    :category  => "Freelance",
    :url       => "http://sethgodin.typepad.com/files/what-matters-now-1.pdf",
    :md5sum    => "b19b5ebdb27450d69d9b16718530cd6c",
    :file_size => 3243224
  },
  {
    :author    => "Sharon Hurley Hall",
    :title     => "Getting Started in Blogging",
    :category  => "Blogging",
    :url       => "http://www.getpaidtowriteonline.com/Ebooks/GSIB%20Ebook.pdf",
    :md5sum    => "45ce82b1802c4de2f8f62f48f1be0e07",
    :file_size => 625038
  },
  {
    :author    => "Dave Navarro",
    :title     => "More Time Now: Time Management Made Simple Again",
    :category  => "Productivity",
    :url       => "http://www.rockyourday.com/manifesto/MoreTimeNow.pdf",
    :md5sum    => "955a2141628c968af5c7e3b743504824",
    :file_size => 431351
  },
  {
    :author    => "Robert Schifreen",
    :title     => "The Web Book",
    :category  => "Web Development",
    :url       => "http://www.the-web-book.com/index.php?a=xdl",
    :md5sum    => "90ae18a42e216f246e62c980c52d3c1e",
    :suffix    => "pdf",
    :file_size => 11661482
  },
  {
    :author    => "Mike Smith",
    :title     => "Guide to Guerilla Freelancing",
    :category  => "Freelance",
    :url       => "http://www.guerrillafreelancing.com/download/1",
    :md5sum    => "fa476cef9e4309b500567de9b95db8bc",
    :suffix    => "pdf",
    :file_size => 158554
  },
  {
    :author    => "Michael Stelzner",
    :title     => "2010 Social Media Marketing Industry Report",
    :category  => "Social Media",
    :url       => "http://marketingwhitepapers.s3.amazonaws.com/SocialMediaMarketingReport2010.pdf",
    :md5sum    => "f8453506d562ceee0598313f679ad1d8",
    :file_size => 10118525
  },
  {
    :author    => "Peter Shallard",
    :title     => "Seek and Destroy",
    :category  => "Freelance",
    :url       => "http://www.petershallard.com/downloads/SeekAndDestroy.pdf",
    :md5sum    => "081189643a4256ae8d57c6ac5377db7e",
    :file_size => 832929
  },
  {
    :author    => "Leo Babauta",
    :title     => "focus : a simplicity manifesto in the age of distraction",
    :category  => "Minimalism",
    :url       => "http://focusmanifesto.s3.amazonaws.com/FocusFree.pdf",
    :md5sum    => "12f8edde36f001f2077b4c5ebf19c638",
    :file_size => 461240
  },
  {
    :author    => "growwithstacy.com",
    :title     => "Powerful Thinking, Successful Living",
    :category  => "Motivation",
    :url       => "http://growwithstacy.com/wp-content/uploads/2010/12/PowerfulThinking.pdf",
    :md5sum    => "adfd08aa121f67b95a4fb65316dbe5cc",
    :file_size => 183738
  },
  {
    :author    => "growwithstacy.com",
    :title     => "Blogging Basics",
    :category  => "Blogging",
    :url       => "http://growwithstacy.com/wp-content/uploads/2010/08/Blogging-Basics.pdf",
    :md5sum    => "d3ef394e050e6476fe3dfcf108e2ed81",
    :file_size => 161225
  },
  {
    :author    => "Simon Black",
    :title     => "Network Infiltration",
    :category  => "Networking",
    :url       => "http://sovereignman.com/Network%20Infiltration.pdf",
    :md5sum    => "0046fd66575ae653fd10684eece71ad8",
    :file_size => 150574
  },
  {
    :author    => "Mark Smith",
    :title     => "50 Guerrilla Marketing Tactics For Freelancers",
    :category  => "Freelance",
    :url       => "http://www.guerrillafreelancing.com/download/2",
    :md5sum    => "73541e4a4dea97cebfcabb77db352df9",
    :suffix    => "pdf",
    :file_size => 134170
  },
  {
    :author    => "Ramit Sethi",
    :title     => "Earn More Money - earn1k-1.2-Pick-Your-Field-worksheet-form",
    :category  => "Freelance",
    :url       => "http://earn1k.com/members/wp-content/uploads/earn1k-1.2-Pick-Your-Field-worksheet-form.pdf",
    :md5sum    => "10c910f5f09fdf83ae8cb9fb31ded92c",
    :file_size => 871655
  },
  {
    :author    => "Ramit Sethi",
    :title     => "Earn More Money - earn1k-1.2-worksheet2",
    :category  => "Freelance",
    :url       => "http://earn1k.com/members/wp-content/uploads/earn1k-1.2-worksheet2.pdf",
    :md5sum    => "94b2ce3889d0842fb16f3840a4f034d8",
    :file_size => 1249271
  },
  {
    :author    => "Ramit Sethi",
    :title     => "Earn More Money - earn1k-1.2-audio",
    :category  => "Freelance",
    :url       => "http://earn1k.s3.amazonaws.com/audio/earn1k-1.2-audio.mp3",
    :md5sum    => "018194197d116b749ae07809202bdc05",
    :file_size => 7532617
  },
  {
    :author    => "Ramit Sethi",
    :title     => "Earn1K Bonus PDF: Get Inside Their Heads",
    :category  => "Freelance",
    :url       => "http://earn1k.s3.amazonaws.com/GetInsideTheirHeads.pdf",
    :md5sum    => "e82c4348ac305841b5553bb6a46eca74",
    :file_size => 151601
  },
  {
    :author    => "Ramit Sethi",
    :title     => "Earn1K Bonus Video: Unlocking side income case study",
    :category  => "Freelance",
    :url       => "http://earn1k.com/privatelist/case-study-jackie-schmidt/",
    :md5sum    => "d3eb8b7e07ff21f06cda39599fee98e7",
    :suffix    => "html",
    :file_size => 8559
  },
  {
    :author    => "Derek Sivers",
    :title     => "How to Call Attention to Your Music",
    :category  => "Music",
    :url       => "http://sivers.org/DerekSivers.pdf",
    :md5sum    => "2476b5b0fc8cf21be32c9bb15284ba62",
    :file_size => 2375417
  },
  {
    :author    => "BJ Fogg",
    :title     => "Master Class - Psychology Of Persuasion",
    :category  => "Psychology",
    :url       => "http://cdn.earn1k.com.s3.amazonaws.com/audio/BJFogg_PsychologyOfPersuasion.mp3",
    :md5sum    => "200b7660b53515e231cd03d7c3ac7f65",
    :file_size => 149555651
  },
  {
    :author    => "BJ Fogg",
    :title     => "Master Class - Psychology Of Persuasion",
    :category  => "Psychology",
    :url       => "http://earn1k.s3.amazonaws.com/FoggTranscript.pdf",
    :md5sum    => "8793a8798e4123917c3a1254cf6e6766",
    :file_size => 179650
  },
  {
    :author    => "Ramit Sethi",
    :title     => "30-day Hustling Course - Week 1 – Invisible Scripts - 1 Flipping The Script",
    :category  => "Freelance",
    :url       => "http://earn1k.s3.amazonaws.com/ScriptAutomationReport.pdf",
    :md5sum    => "b4f29c3621c66798110ae7462528b53a",
    :file_size => 142890
  },
  {
    :author    => "Ramit Sethi",
    :title     => "30-day Hustling Course - Week 1 – Invisible Scripts - 2 Master Class Sneak Peek with Tim Ferriss",
    :category  => "Freelance",
    :url       => "http://earn1k.s3.amazonaws.com/bonus/tim-ramit-bonus-video.zip",
    :md5sum    => "2e939b8f526d0113841ff8cdc8844580",
    :file_size => 40782718
  },
  {
    :author    => "Ramit Sethi",
    :title     => "30-day Hustling Course - Week 1 – Invisible Scripts - 3 - 25 Hours A Day 8 Days A Week",
    :category  => "Freelance",
    :url       => "http://earn1k.s3.amazonaws.com/time-clinic.zip",
    :md5sum    => "02d5fda3a059466c36af25b57dd01cc5",
    :file_size => 33509889
  },
  {
    :author    => "Ramit Sethi",
    :title     => "30-day Hustling Course - Week 2 – Psychological Techniques to Dominate - 1 Bonus Psychology Study",
    :category  => "Freelance",
    :url       => "http://earn1k.s3.amazonaws.com/BonusPsychologyCaseStudy.pdf",
    :md5sum    => "60056d91f69ec600f2b88a17467ce72a",
    :file_size => 312437
  },
  {
    :author    => "Ramit Sethi",
    :title     => "30-day Hustling Course - Week 2 – Psychological Techniques to Dominate - 2 Earn1K Bonus Material",
    :category  => "Freelance",
    :url       => "http://earn1k.s3.amazonaws.com/GetInsideTheirHeads.pdf",
    :md5sum    => "e82c4348ac305841b5553bb6a46eca74",
    :file_size => 151601
  },
  {
    :author    => "Ramit Sethi",
    :title     => "30-day Hustling Course - Week 2 – Psychological Techniques to Dominate - 3 BJ Fogg Master Class",
    :category  => "Freelance",
    :url       => "http://cdn.earn1k.com.s3.amazonaws.com/audio/BJFogg_PsychologyOfPersuasion.mp3",
    :md5sum    => "200b7660b53515e231cd03d7c3ac7f65",
    :file_size => 149555651
  },
  {
    :author    => "Ramit Sethi",
    :title     => "30-day Hustling Course - Week 2 – Psychological Techniques to Dominate - 3 BJ Fogg Master Class",
    :category  => "Freelance",
    :url       => "http://earn1k.s3.amazonaws.com/FoggTranscript.pdf",
    :md5sum    => "8793a8798e4123917c3a1254cf6e6766",
    :file_size => 179650
  },
  {
    :author    => "Ramit Sethi",
    :title     => "30-day Hustling Course - Week 3 – Negotiation - 1 Earn1K Bonus Material: From Free to Fee",
    :category  => "Freelance",
    :url       => "http://cdn.earn1k.com/PDF/FreeToFee.pdf",
    :md5sum    => "7474b017f3ee43db6ce37afcb832d611",
    :file_size => 35220406
  },
  {
    :author    => "Ramit Sethi",
    :title     => "30-day Hustling Course - Week 3 – Negotiation - 2 - 4 Negotiation Case Studies",
    :category  => "Freelance",
    :url       => "http://earn1k.com/privatelist/4-negotiation-case-studies/",
    :md5sum    => "973a0a93eeb5df824f03257089b0941d",
    :suffix    => "html",
    :file_size => 14316
  },
  {
    :author    => "Ramit Sethi",
    :title     => "30-day Hustling Course - Week 3 – Negotiation - 3 Derek Sivers Master Class",
    :category  => "Freelance",
    :url       => "http://cdn.earn1k.com/audio/DerekSivers_CDBaby100Million.mp3",
    :md5sum    => "dbd15e5a68ed2cf30fedba7c2700f522",
    :file_size => 152430868
  },
  {
    :author    => "Ramit Sethi",
    :title     => "30-day Hustling Course - Week 3 – Negotiation - 3 Derek Sivers Master Class",
    :category  => "Freelance",
    :url       => "http://cdn.earn1k.com/PDF/SiversTranscript.pdf",
    :md5sum    => "3a4a7a210188dbbd26ac67c2b20f6fb9",
    :file_size => 188979
  },
  {
    :author    => "Ramit Sethi",
    :title     => "30-day Hustling Course - Week 3 – Negotiation - 4 My 69-min interview with a pickup artist",
    :category  => "Freelance",
    :url       => "http://cdn.earn1k.com/audio/PickUpPodcast_RamitSethi.mp3",
    :md5sum    => "7d61c7bbc35359fb3219fafccf289cd9",
    :file_size => 146225336
  },
  {
    :author    => "Ramit Sethi",
    :title     => "30-day Hustling Course - Week 3 – Negotiation - 4 My 69-min interview with a pickup artist",
    :category  => "Freelance",
    :url       => "http://cdn.earn1k.com/PDF/PickUpPodcastTranscript.pdf",
    :md5sum    => "6077f3c9021a69986634743dcf1ed907",
    :file_size => 321677
  },
  {
    :author    => "Ramit Sethi",
    :title     => "30-day Hustling Course - Week 4 – How to be awesome - 1 Earn1K Bonus Material: Unlocking Side Income",
    :category  => "Freelance",
    :url       => "http://cdn.earn1k.com/PDF/EarnMoreCaseStudy.pdf",
    :md5sum    => "364c7d9d4e643410f6e6f92a4b9fa82e",
    :file_size => 16340314
  },
  {
    :author    => "Ramit Sethi",
    :title     => "30-day Hustling Course - Week 4 – How to be awesome - 2 Tim Ferris Interview",
    :category  => "Freelance",
    :url       => "http://cdn.earn1k.com/audio/Tim-Ferriss-Psychology-of-Testing.mp3",
    :md5sum    => "89d1ed6c9c329ed8fa9ee29b17c9aa5d",
    :file_size => 20861888
  },
  {
    :author    => "Ramit Sethi",
    :title     => "30-day Hustling Course - Week 4 – How to be awesome - 2 Tim Ferris Interview",
    :category  => "Freelance",
    :url       => "http://cdn.earn1k.com/PDF/TimFerris-The-Psychology-of-Testing.pdf",
    :md5sum    => "c909f96334be030ddf046ad9a3e6f79b",
    :file_size => 262760
  },
  {
    :author    => "Intel",
    :title     => "Dual-Channel DDR Memory Architecture White Paper",
    :category  => "Hardware",
    :url       => "http://www.kingston.com/newtech/mkf_520ddrwhitepaper.pdf",
    :md5sum    => "6deffff46cc820f40b245037880a73fe",
    :file_size => 1046101
  },
  {
    :author    => "Ramit Sethi",
    :title     => "7-day Private Course Day 1 - How To Maximize Motiviation and Optimize Your Time",
    :category  => "Freelance",
    :url       => "http://earn1k.com/preview/how-to-maximize-motiviation-and-optimize-your-time/",
    :md5sum    => "b0c1220c64992071d112a88715063cf9",
    :suffix    => "html",
    :file_size => 17905
  },
  {
    :author    => "Ramit Sethi",
    :title     => "7-day Private Course Day 1 - 12 Month Goals Worksheet",
    :category  => "Freelance",
    :url       => "http://earn1k.com/members/wp-content/uploads/12-Month-Goals-Worksheet1.pdf",
    :md5sum    => "24a669c3d7449176f7388c0e594d1cf4",
    :file_size => 52032
  },
  {
    :author    => "Ramit Sethi",
    :title     => "7-day Private Course Day 1 - Time Clinic Video",
    :category  => "Freelance",
    :url       => "http://earn1k.s3.amazonaws.com/time-clinic.zip",
    :md5sum    => "02d5fda3a059466c36af25b57dd01cc5",
    :file_size => 33509889
  },
  {
    :author    => "Ramit Sethi",
    :title     => "Webcast: Multiple streams of income on 5 hours a week",
    :category  => "Freelance",
    :url       => "http://cdn.earn1k.com.s3.amazonaws.com/webinars/MultipleStreamsOfIncome.mov",
    :md5sum    => "9156d82559b39961c79d8bf428c65a7b",
    :file_size => 84523638
  },
  {
    :author    => "App Sumo",
    :title     => "Action Video Google Analytics",
    :category  => "Web Development",
    :url       => "http://sumobucket.s3.amazonaws.com/actionvid/ActionVideoGoogleAnalytics.mov",
    :md5sum    => "679f9dda6f46781dc7b06f74989a6ea1",
    :file_size => 785727113
  },
  {
    :author    => "iMagazine",
    :title     => "2011-07_i_08",
    :category  => "Magazines",
    :url       => "http://imagazine.enewsletter.pl/k/283/7l0/8e8b8fffbad1b",
    :md5sum    => "67778a1c3dceea108742326c6f79c808",
    :suffix    => "pdf",
    :method    => "curl",
    :file_size => 26698954
  },
  {
    :author    => "iMagazine",
    :title     => "2011-06",
    :category  => "Magazines",
    :url       => "http://imagazine.enewsletter.pl/k/283/7gb/9505b9f4f47c3",
    :md5sum    => "1e08cc3b1435d173f2588c721e8c0427",
    :suffix    => "pdf",
    :method    => "curl",
    :file_size => 24914452
  },
  {
    :author    => "iMagazine",
    :title     => "2011-05",
    :category  => "Magazines",
    :url       => "http://imagazine.enewsletter.pl/k/283/7ds/e38821379ff6e",
    :md5sum    => "f1f65fb5c9d831190c9243ac11319d29",
    :suffix    => "pdf",
    :method    => "curl",
    :file_size => 19602282
  },
  {
    :author    => "iMagazine",
    :title     => "2011-04",
    :category  => "Magazines",
    :url       => "http://imagazine.enewsletter.pl/k/283/7aw/916498ed6ad67",
    :md5sum    => "07ae5eacb733297d0e3ddfb133aea0b5",
    :suffix    => "pdf",
    :method    => "curl",
    :file_size => 13067623
  },
  {
    :author    => "iMagazine",
    :title     => "2011-03",
    :category  => "Magazines",
    :url       => "http://imagazine.enewsletter.pl/k/283/71i/52c3b8e418d1a",
    :md5sum    => "cd177f858b16723806a005bd51a0a7ef",
    :suffix    => "pdf",
    :method    => "curl",
    :file_size => 22426089
  },
  {
    :author    => "iMagazine",
    :title     => "2011-02",
    :category  => "Magazines",
    :url       => "http://imagazine.enewsletter.pl/k/283/6yz/48d582708c36e",
    :md5sum    => "b1454cd389e73d0e72c7ea67bb239872",
    :suffix    => "pdf",
    :method    => "curl",
    :file_size => 20185940
  },
  {
    :author    => "iMagazine",
    :title     => "2011-01",
    :category  => "Magazines",
    :url       => "http://imagazine.enewsletter.pl/k/283/6wg/ac2703eb996a4",
    :md5sum    => "13f570d20e4eac9641319542e50442b2",
    :suffix    => "pdf",
    :method    => "curl",
    :file_size => 20667572
  },
  {
    :author    => "iMagazine",
    :title     => "2010-12",
    :category  => "Magazines",
    :url       => "http://imagazine.enewsletter.pl/k/283/6tx/e843a63d0743b",
    :md5sum    => "54f6fe9bd0c3659b8f7151ac8bbad292",
    :suffix    => "pdf",
    :method    => "curl",
    :file_size => 43210240
  },
  {
    :author    => "iMagazine",
    :title     => "2010-11",
    :category  => "Magazines",
    :url       => "http://imagazine.enewsletter.pl/k/283/6n2/066c52cad77c3",
    :md5sum    => "a6487b35eea7edb600dd6596aeaaeab3",
    :suffix    => "pdf",
    :method    => "curl",
    :file_size => 20298822
  },
  {
    :author    => "Doomtrooper",
    :title     => "Zasady",
    :category  => "Games",
    :url       => "http://doomtrooperfaq.republika.pl/zasady.pdf",
    :md5sum    => "1e5eb36b6b4de5fe3b715bb76180f13b",
    :suffix    => "pdf",
    :file_size => 295124
  },
  {
    :author    => "Bruce Momjia",
    :title     => "PostgreSQL Hardware Performance Tuning",
    :category  => "Databases",
    :url       => "http://www.postgresql.org/files/documentation/books/aw_pgsql/hw_performance.pdf",
    :md5sum    => "28a4f4bfa93dfdd1e60d1b2bc264c4e8",
    :suffix    => "pdf",
    :file_size => 139525
  },
  {
    :author    => "Simon Black",
    :title     => "Six Pillars Of Self Reliance",
    :category  => "Independence",
    :url       => "http://sovereignman.com/aot/SixPillarsOfSelfReliance.pdf",
    :md5sum    => "041a2b52d308804b025d6f0684cc5898",
    :suffix    => "pdf",
    :file_size => 536866
  },
  {
    :author    => "Craig Ballantyne",
    :title     => "Internet Independence Report II",
    :category  => "Independence",
    :url       => "http://internetindependence.com/Build%20a%20Website%20Business_II_Report.pdf",
    :md5sum    => "a1451de1b78ca4aafc2637d1ef683405",
    :suffix    => "pdf",
    :file_size => 542228
  },
  {
    :author    => "Eric Ries",
    :title     => "The Lean Startup",
    :category  => "Startup",
    :url       => "http://s3.appsumo.com/action-videos/LeanStartup/Eric%20Ries%20The%20Lean%20Startup%20full.mov",
    :md5sum    => "280e290a01ebe6726aa7141908c9d1e8",
    :suffix    => "mov",
    :file_size => 962536604
  },
  {
    :author    => "Eric Ries",
    :title     => "The Lean Startup",
    :category  => "Startup",
    :url       => "http://s3.appsumo.com/action-videos/LeanStartup/Eric%20Ries%20Lean%20Startup.mp3",
    :md5sum    => "6faea0ffbc24ee8d168d452d90f026e9",
    :suffix    => "mp3",
    :file_size => 69675884
  },
  {
    :author    => "Eric Ries",
    :title     => "The Lean Startup",
    :category  => "Startup",
    :url       => "http://s3.appsumo.com/action-videos/LeanStartup/Lean%20Startup%20with%20Eric%20Ries.pdf",
    :md5sum    => "427b74c3bba4b1390ef52745a5f07c7b",
    :suffix    => "pdf",
    :file_size => 206563
  },
  {
    :author    => "Justin Cutroni",
    :title     => "New Google Analytics for iOS + Android",
    :category  => "Web Development",
    :url       => "http://s3.appsumo.com/action-videos/Google%20Analytics%20Pt%20II/Google%20Analytics%20Pt%20II%20Justin%20Cutroni.mov",
    :md5sum    => "42bf4800c76882de3e559a3287578cda",
    :suffix    => "mov",
    :file_size => 1027779179
  },
  {
    :author    => "Justin Cutroni",
    :title     => "New Google Analytics for iOS + Android",
    :category  => "Web Development",
    :url       => "http://s3.appsumo.com/action-videos/Google%20Analytics%20Pt%20II/New%20Google%20Analytics%20for%20Mobile%20Justin%20Cutroni.mp3",
    :md5sum    => "864730122a5693759b5235361189bf03",
    :suffix    => "mp3",
    :file_size => 59087726
  },
  {
    :author    => "Justin Cutroni",
    :title     => "New Google Analytics for iOS + Android",
    :category  => "Web Development",
    :url       => "http://s3.appsumo.com/action-videos/Google%20Analytics%20Pt%20II/New%20Google%20Analytics%20for%20Mobile.pdf",
    :md5sum    => "506efc25f0898022e9d172fbb6f3e41c",
    :suffix    => "pdf",
    :file_size => 260931
  },
  {
    :author    => "Tom Critchlow",
    :title     => "Google Docs",
    :category  => "Freelance",
    :url       => "http://s3.appsumo.com.s3.amazonaws.com/action-videos/GoogleDocs/Google_Docs_w_Tom_Critchlow_Full_Download.mov",
    :md5sum    => "62fd8f0bbfecb2f4832e9e8e4ac674f4",
    :suffix    => "mov",
    :file_size => 1696996824
  },
  {
    :author    => "Tom Critchlow",
    :title     => "Google Docs",
    :category  => "Freelance",
    :url       => "http://s3.appsumo.com.s3.amazonaws.com/action-videos/GoogleDocs/Google%20Docs%20Unleashed%20w%20Tom%20Critchlow.mp3",
    :md5sum    => "22068df3f1b421f8608b55736600f645",
    :suffix    => "mp3",
    :file_size => 55215752
  },
  {
    :author    => "Tom Critchlow",
    :title     => "Google Docs",
    :category  => "Freelance",
    :url       => "http://s3.appsumo.com.s3.amazonaws.com/action-videos/GoogleDocs/Google%20Docs%20Unleashed%20w%20Tom%20Critchlow.pdf",
    :md5sum    => "371bb73ca6dd6bf39088a2dee4b2e636",
    :suffix    => "pdf",
    :file_size => 258627
  },
  {
    :author    => "Derek Sivers",
    :title     => "Uncommon Sense",
    :category  => "Freelance",
    :url       => "http://s3.appsumo.com/action-videos/Uncommon%20Sense/Uncommon%20Sense.mov",
    :md5sum    => "e241b86b11466093104cce4f9be0afff",
    :suffix    => "mov",
    :file_size => 1270354615
  },
  {
    :author    => "Derek Sivers",
    :title     => "Uncommon Sense",
    :category  => "Freelance",
    :url       => "http://s3.appsumo.com/action-videos/Uncommon%20Sense/Uncommon%20Sense.mp3",
    :md5sum    => "d5b3d162b6e763d50807f6bffd6af242",
    :suffix    => "mp3",
    :file_size => 45351915
  },
  {
    :author    => "Derek Sivers",
    :title     => "Uncommon Sense",
    :category  => "Freelance",
    :url       => "http://s3.appsumo.com/action-videos/Uncommon%20Sense/Uncommon%20Sense%20with%20Derek%20Sivers.pdf",
    :md5sum    => "056641d81b26f9324c05d1b81def73bb",
    :suffix    => "pdf",
    :file_size => 246037
  },
  {
    :author    => "Scribd",
    :title     => "The Handbook of Epictetus",
    :category  => "Philosophy",
    :url       => "http://www.scribd.com/mobile/documents/61566577",
    :md5sum    => "4646ee23a2a6f6c54ac7a8f22e8fc862",
    :suffix    => "pdf",
    :file_size => 8225688
  },
]

Dir.mkdir("EbooksAssimilated") unless File.directory?("EbooksAssimilated")
Dir.chdir("EbooksAssimilated")

ebooks.each do |ebook|
  ebook = Ebook.download_verbose!(ebook)
end
