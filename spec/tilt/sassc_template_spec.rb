require 'spec_helper'
require 'tilt/sassc'

RSpec.describe Tilt::SassCTemplate do
  let(:template_file) { File.join('spec', 'support', 'test.sass') }

  it "should be registered for '.sass' files" do
    expect(Tilt['test.sass']).to eq Tilt::SassCTemplate
  end

  it "contains information about source file when error in .sass file" do
    template = Tilt::SassCTemplate.new(File.join('spec', 'support', 'invalid.sass'))
    expect { template.render }.to raise_error(SassC::SyntaxError)
    begin
      template.render
    rescue => e
      expect(e.backtrace.join).to include 'invalid.sass:4' # we should see error on line 2 in file invalid.sass in stacktrace
    end
  end

  it "should evaluate the template on #render" do
    template = Tilt::SassCTemplate.new(template_file)
    expect(template.render).to eq <<~CSS
    body {
      font: 100% Helvetica, sans-serif;
      color: #333; }
    CSS
  end

  it "can be rendered more than once" do
    template = Tilt::SassCTemplate.new(template_file)
    3.times do
      expect(template.render).to eq <<~CSS
      body {
        font: 100% Helvetica, sans-serif;
        color: #333; }
      CSS
    end
  end
end
