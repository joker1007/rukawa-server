$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'rukawa/server'

load File.expand_path("../../sample/rukawa.rb", __FILE__)
Rukawa.load_jobs
