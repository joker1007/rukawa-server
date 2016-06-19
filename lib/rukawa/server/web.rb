require 'roda'
require 'haml'
require 'json'

module Rukawa
  module Server
    class Web < Roda
      opts[:root] = File.expand_path('../../../../app', __FILE__)
      plugin :path
      plugin :static, %w(/js /css /bower_components)
      plugin :render, engine: 'haml', views: File.expand_path('../../../../app/views', __FILE__)
      plugin :partials, views: File.expand_path('../../../../app/views', __FILE__)

      path :job_net do |name|
        "/job_nets/#{name}"
      end

      path :job do |name|
        "/jobs/#{name}"
      end

      route do |r|
        r.root do
          @job_nets = Rukawa::JobNet.descendants.sort_by { |jn| jn.name }.map { |jn| jn.new(nil, {}) }
          view('index')
        end

        r.on "job_nets" do
          r.on ":name" do |name|
            job_net_class = Rukawa::JobNet.descendants.find { |jn| jn.name == name }
            @job_net = job_net_class.new(nil, {})

            r.get do
              view('job_net')
            end
          end
        end

        r.on "jobs" do
          r.on ":name" do |name|
            @job_class = Rukawa::Job.descendants.find { |jn| jn.name == name }

            r.get do
              @job_definition = Rukawa::Server::JobDefinition.new(@job_class)
              @job_definition.search_source_code
              @source_code = @job_definition.source_code

              if @source_code.nil? && @job_definition.file
                @source_code = File.read(@job_definition.file)
              end

              view('job')
            end
          end
        end
      end
    end
  end
end
