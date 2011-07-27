require 'ebook'

describe Ebook do

  let(:the_class) { Ebook }
  let(:options) { {
    :author    => 'author',
    :title     => 'title',
    :category  => 'category',
    :url       => 'url',
    :md5sum    => 'md5sum',
    :suffix    => 'suffix',
    :method    => 'method',
    :file_size => 'file_size',
  } }
  let(:the_object) { the_class.new(options) }

  describe 'initialized object' do
    subject { the_object }

    its(:author) { should == 'author' }

    its(:title) { should == 'title' }

    its(:category) { should == 'category' }

    its(:url) { should == 'url' }

    its(:md5sum) { should == 'md5sum' }

    its(:suffix) { should == 'suffix' }

    its(:method) { should == 'method' }

    its(:file_size) { should == 'file_size' }
  end

  describe "#download_verbose!" do
    before do
      the_object.stub!(:make_category_dir)
      the_object.stub!(:enter_category_dir)
      the_object.stub!(:print_information)
      the_object.stub!(:download)
      the_object.stub!(:warn_about_size)
      the_object.stub!(:warn_about_md5sum)
      the_object.stub!(:exit_category_dir)
    end
    after { the_object.download_verbose! }

    it "should call #make_category_dir" do
      the_object.should_receive(:make_category_dir)
    end

    it "should call #enter_category_dir" do
      the_object.should_receive(:enter_category_dir)
    end

    it "should call #print_information" do
      the_object.should_receive(:print_information)
    end

    it "should call #download" do
      the_object.should_receive(:download)
    end

    it "should call #warn_about_size" do
      the_object.should_receive(:warn_about_size)
    end

    it "should call #warn_about_md5sum" do
      the_object.should_receive(:warn_about_md5sum)
    end

    it "should call #exit_category_dir" do
      the_object.should_receive(:exit_category_dir)
    end
  end

  describe ".download_verbose!" do
    let(:ebook) { mock }
    let(:new_object) { mock(:download_verbose! => nil) }
    before { the_class.stub!(:new).with(ebook).and_return(new_object) }
    after { the_class.download_verbose!(ebook) }

    it "should create new object" do
      the_class.should_receive(:new).with(ebook).and_return(new_object)
    end

    it "should call #download_verbose! for new object" do
      new_object.should_receive(:download_verbose!)
    end
  end

  describe "#make_category_dir" do
    let(:category) { mock }
    before { the_object.stub!(:category => category) }
    after { the_object.send(:make_category_dir) }

    context "when directory exists already" do
      before { File.stub!(:directory?).with(category).and_return(true) }

      it "should not create directory" do
        Dir.should_not_receive(:mkdir)
      end

      it "should check that direcory exist" do
        File.should_receive(:directory?).with(category).and_return(true)
      end
    end

    context "when directory does not exists" do
      before do
        File.stub!(:directory?).with(category).and_return(false)
        Dir.stub!(:mkdir).with(category)
      end

      it "should not create directory" do
        Dir.should_receive(:mkdir).with(category)
      end

      it "should check that direcory exist" do
        File.should_receive(:directory?).with(category).and_return(false)
      end
    end
  end

  describe "#enter_category_dir" do
    let(:category) { mock }
    before { the_object.stub!(:category => category) }
    after { the_object.send(:enter_category_dir) }

    it "should enter category directory" do
      Dir.should_receive(:chdir).with(category)
    end
  end

  describe "#exit_category_dir" do
    after { the_object.send(:exit_category_dir) }

    it "should exit category directory" do
      Dir.should_receive(:chdir).with("..")
    end
  end

  describe "#uri" do
    let(:url) { mock }

    describe "behavior" do
      before { the_object.stub!(:url => url) }
      after { the_object.send(:uri) }

      it "should parse uri from url" do
        URI.should_receive(:parse).with(url)
      end
    end

    describe "returns" do
      let(:parsed_uri) { mock }
      subject do
        the_object.stub!(:url => url)
        URI.stub!(:parse).with(url).and_return(parsed_uri)
        the_object.send(:uri)
      end

      it { should == parsed_uri }
    end
  end

  describe "#suffix_from_path" do
    let(:path) { '/example/path/to/ebook.pdf' }
    let(:uri) { mock(:path => path) }

    describe "behavior" do
      before { the_object.stub!(:uri => uri) }
      after { the_object.send(:suffix_from_path) }

      it "should use uri" do
        the_object.should_receive(:uri).and_return(uri)
      end

      it "should use uri path" do
        uri.should_receive(:path).and_return(path)
      end
    end

    describe "returns" do
      subject do
        the_object.stub!(:uri => uri)
        the_object.send(:suffix_from_path)
      end

      it { should == 'pdf' }
    end
  end

  describe "#smart_suffix" do
    before do
      the_object.stub!(:suffix => 'suffix')
      the_object.stub!(:suffix_from_path => 'suffix_from_path')
    end
    subject { the_object.send(:smart_suffix) }

    context "when suffix is nil" do
      before { the_object.stub!(:suffix) }

      it { should == "suffix_from_path" }
    end

    context "when suffix is not blank" do
      it { should == "suffix" }
    end
  end

  describe "#output_file" do
    describe "behavior" do
      before { the_object.stub!(:smart_suffix => 'pdf') }
      after { the_object.send(:output_file) }

      it "should use author" do
        the_object.should_receive(:author)
      end

      it "should use title" do
        the_object.should_receive(:title)
      end

      it "should use suffix" do
        the_object.should_receive(:smart_suffix)
      end
    end

    describe "returns" do
      subject do
        the_object.stub!(:smart_suffix => 'pdf')
        the_object.send(:output_file)
      end

      it { should == "author - title.pdf" }
    end
  end

  describe "#exist?" do
    let(:output_file) { mock }

    describe "behavior" do
      before { the_object.stub!(:output_file => output_file) }
      after { the_object.send(:exist?) }

      it "should exist? exist? from output_file" do
        File.should_receive(:exist?).with(output_file)
      end
    end

    describe "returns" do
      let(:existance_status) { mock }
      subject do
        the_object.stub!(:output_file => output_file)
        File.stub!(:exist?).with(output_file).and_return(existance_status)
        the_object.send(:exist?)
      end

      it { should == existance_status }
    end
  end

  describe "#output_file_size" do
    let(:the_size) { mock }
    let(:output_file) { mock }
    before do
      the_object.stub!(:output_file => output_file)
      File.stub!(:size).with(output_file).and_return(the_size)
    end

    describe "behavior" do
      after { the_object.send(:output_file_size) }

      it "should check file size" do
        File.should_receive(:size).with(output_file)
      end
    end

    describe "returns" do
      subject { the_object.send(:output_file_size) }

      it { should == the_size }
    end
  end

  describe "#output_file_body" do
    let(:output_file) { mock }

    describe "behavior" do
      before { the_object.stub!(:output_file => output_file) }
      after { the_object.send(:output_file_body) }

      it "should output_file_body output_file_body from output_file" do
        File.should_receive(:read).with(output_file)
      end
    end

    describe "returns" do
      let(:file_contents) { mock }
      subject do
        the_object.stub!(:output_file => output_file)
        File.stub!(:read).with(output_file).and_return(file_contents)
        the_object.send(:output_file_body)
      end

      it { should == file_contents }
    end
  end

  describe "#existing_md5sum" do
    let(:output_file) { "README" }
    before { the_object.stub!(:output_file => output_file) }
    subject { the_object.send(:existing_md5sum) }

    it { should == "c20a2fcb7d13754fcdc6dedabaa125ae" }
  end

  describe "#md5sum_ok?" do
    let(:existing_md5sum) { "sum" }

    context "when existing_md5sum and object md5sum equals" do
      let(:md5sum) { "sum" }
      subject do
        the_object.stub!(:existing_md5sum => existing_md5sum)
        the_object.stub!(:md5sum => md5sum)
        the_object.send(:md5sum_ok?)
      end

      it { should be_true }
    end

    context "when existing_md5sum and object md5sum differs" do
      let(:md5sum) { "different" }
      subject do
        the_object.stub!(:existing_md5sum => existing_md5sum)
        the_object.stub!(:md5sum => md5sum)
        the_object.send(:md5sum_ok?)
      end

      it { should be_false }
    end
  end

  describe "#size_ok?" do
    let(:file_size) { 8472 }
    before do
      the_object.stub!(
        :file_size => file_size,
        :output_file_size => output_file_size
      )
    end
    subject { the_object.send(:size_ok?) }

    context "when output_file_size equals file_size" do
      let(:output_file_size) { 8472 }

      it { should be_true }
    end

    context "when output_file_size not equals file_size" do
      let(:output_file_size) { 5618 }

      it { should be_false }
    end
  end

  describe "#ok?" do
    subject { the_object.send(:ok?) }

    context "when file exist" do
      before { the_object.stub!(:exist? => true) }

      context "and its size is ok" do
        before { the_object.stub!(:size_ok? => true) }

        context "and its md5sum is ok" do
          before { the_object.stub!(:md5sum_ok? => true) }

          it { should be_true }
        end

        context "and its md5sum is wrong" do
          before { the_object.stub!(:md5sum_ok? => false) }

          it { should be_false }
        end
      end

      context "and its size is wrong" do
        before { the_object.stub!(:size_ok? => false) }

        it { should be_false }
      end
    end

    context "when file not exist" do
      before { the_object.stub!(:exist? => false) }

      it { should be_false }
    end
  end

  describe "#download" do
    context "when everything is ok" do
      before { the_object.stub!(:ok? => true) }
      after { the_object.send(:download) }

      it "should not download file" do
        the_object.should_not_receive(:download_raw)
      end

      it "should check that everything is ok" do
        the_object.should_receive(:ok?).and_return(true)
      end
    end

    context "when everything is not ok" do
      before do
        the_object.stub!(:download_raw)
        the_object.stub!(:ok? => false)
      end
      after { the_object.send(:download) }

      it "should not download file" do
        the_object.should_receive(:download_raw)
      end

      it "should check that everything is ok" do
        the_object.should_receive(:ok?).and_return(false)
      end
    end
  end

  describe "#touch_file" do
    let(:output_file) { mock }
    before { the_object.stub!(:output_file => output_file) }
    after { the_object.send(:touch_file) }

    it "should touch_file touch_file from output_file" do
      FileUtils.should_receive(:touch).with(output_file)
    end
  end

  describe "#download_raw" do
    let(:file) { mock(:close => nil, :write => nil) }
    let(:output_file) { mock }
    let(:host) { mock }
    let(:request_uri) { mock }
    let(:uri) { mock(:host => host, :request_uri => request_uri) }
    let(:http) { mock }
    let(:response) { mock }
    let(:segment) { mock }
    before do
      the_object.stub!(:touch_file)
      the_object.stub!(:uri => uri)
      the_object.stub!(:output_file => output_file)
      the_object.stub!(:open).with(output_file, "w").and_return(file)
      Net::HTTP.stub!(:start).with(host).and_yield(http)
      http.stub!(:request_get).with(request_uri).and_yield(response)
      response.stub!(:read_body).and_yield(segment)
    end

    context "when everything is ok" do
      after { the_object.send(:download_raw) }

      it "should call #touch_file" do
        the_object.should_receive(:touch_file)
      end

      it "should start http connection" do
        Net::HTTP.should_receive(:start).with(host).and_yield(http)
      end

      it "should open file for write" do
        the_object.should_receive(:open).with(output_file, "w").and_return(file)
      end

      it "should send request_get on http" do
        http.should_receive(:request_get).with(request_uri).and_yield(response)
      end

      it "should read response via segments" do
        response.should_receive(:read_body).and_yield(segment)
      end

      it "should write segments to file" do
        file.should_receive(:write).with(segment)
      end
    end

    context "when any exception occurs" do
      before { http.should_receive(:request_get).and_raise }

      it "should close file" do
        file.should_receive(:close)
        expect {
          the_object.send(:download_raw)
        }.to raise_error
      end
    end

    context "when curl method selected" do
      before do
        the_object.stub!(
          :url => "url",
          :output_file => "output_file",
          :method => "curl"
        )
      end
      after { the_object.send(:download_raw) }

      it "should run system command curl properly" do
        the_object.should_receive(:system).with('curl -L "url" -o "output_file"')
      end
    end
  end

  describe "#warn_about_size" do
    after { the_object.send(:warn_about_size) }
    before do
      the_object.stub!(:puts)
      the_object.stub!(:output_file_size)
    end

    context "when size is ok" do
      before { the_object.stub!(:size_ok? => true) }

      it "should not puts warning" do
        the_object.should_not_receive(:puts)
      end
    end

    context "when size is not ok" do
      before { the_object.stub!(:size_ok? => false) }

      it "should not puts warning" do
        the_object.should_receive(:puts)
      end

      it "should notify about expected file size" do
        the_object.should_receive(:file_size)
      end

      it "should notify about existing file size" do
        the_object.should_receive(:output_file_size)
      end
    end
  end

  describe "#warn_about_md5sum" do
    after { the_object.send(:warn_about_md5sum) }
    before do
      the_object.stub!(:puts)
      the_object.stub!(:existing_md5sum)
    end

    context "when md5sum is ok" do
      before { the_object.stub!(:md5sum_ok? => true) }

      it "should not puts warning" do
        the_object.should_not_receive(:puts)
      end
    end

    context "when md5sum is not ok" do
      before { the_object.stub!(:md5sum_ok? => false) }

      it "should not puts warning" do
        the_object.should_receive(:puts)
      end

      it "should notify about expected file md5sum" do
        the_object.should_receive(:md5sum)
      end

      it "should notify about existing file md5sum" do
        the_object.should_receive(:existing_md5sum)
      end
    end
  end

  describe "#print_information" do
    after { the_object.send(:print_information) }

    it "should puts ebook information" do
      the_object.should_receive(:puts).with("category / author \"title\" (url)")
    end
  end

end
