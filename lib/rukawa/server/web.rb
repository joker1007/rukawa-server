require 'roda'
require 'haml'
require 'json'

class Rukawa::Server::Web < Roda
  opts[:root] = File.expand_path('../../../../app', __FILE__)
  plugin :path
  plugin :static, %w(/js /css /bower_components)
  plugin :render, engine: 'haml', views: File.expand_path('../../../../app/views', __FILE__)

  path :job_net do |name|
    "/job_nets/#{name}"
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
  end
end
