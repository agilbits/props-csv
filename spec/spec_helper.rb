$:.unshift File.expand_path('..', __FILE__)
$:.unshift File.expand_path('../../lib', __FILE__)

require 'rubygems'
require 'rspec'
require 'props-csv'

Dir["#{File.expand_path('../../lib/props-csv', __FILE__)}/*.rb"].each do |file|
  require file
end

