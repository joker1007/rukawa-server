require 'spec_helper'

describe Rukawa::Server::JobDefinition do
  describe "#search_source_code" do
    it "gets source code of Job definition" do
      job_definition = Rukawa::Server::JobDefinition.new(Dummy::DummyJob)
      job_definition.search_source_code
      expect(job_definition.source_code).to eq(<<-RUBY)
  class DummyJob < SampleJob
    def run
      puts "dummy"
    end
  end
RUBY
      expect(job_definition.lineno).to eq(112)
    end
  end
end
