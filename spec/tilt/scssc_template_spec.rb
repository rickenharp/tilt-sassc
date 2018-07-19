require 'spec_helper'
require 'tilt/sassc'

RSpec.describe Tilt::ScssCTemplate do
  let(:template_file) { File.join('spec', 'support', 'test.scss') }

  it "should be registered for '.scss' files" do
    expect(Tilt['test.scss']).to eq Tilt::ScssCTemplate
  end

  it "contains information about source file when error in .scss file" do
    template = Tilt::ScssCTemplate.new(File.join('spec', 'support', 'invalid.scss'))
    expect { template.render }.to raise_error SassC::SyntaxError
    begin
      template.render
    rescue => e
      expect(e.backtrace.join).to include 'invalid.scss:5' # we should see error on line 2 in file invalid.jbuilder in stacktrace
    end
  end

  it "should evaluate the template on #render" do
    template = Tilt::ScssCTemplate.new(template_file)
    expect(template.render).to eq <<~CSS
    body {
      font: 100% Helvetica, sans-serif;
      color: #333; }
    CSS
  end

  it "can be rendered more than once" do
    template = Tilt::ScssCTemplate.new(template_file)
    3.times do
      expect(template.render).to eq <<~CSS
      body {
        font: 100% Helvetica, sans-serif;
        color: #333; }
      CSS
    end
  end
end
