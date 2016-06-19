Rukawa.configure do |c|
  c.job_dirs.concat([File.expand_path("../jobs", __FILE__), File.expand_path("../job_nets", __FILE__)])
  c.graph.concentrate = true
  c.graph.nodesep = 0.8
end
