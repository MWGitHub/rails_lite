require 'rubygems'
require 'bundler'
Bundler.require(:default, :development, :test)

require 'json'
require 'yaml'
require 'active_support/inflector'

Dir["#{File.dirname(__FILE__)}/lib/**/*.rb"].each { |f| load(f) }
Dir["#{File.dirname(__FILE__)}/app/**/*.rb"].each { |f| load(f) }
Dir["#{File.dirname(__FILE__)}/config/**/*.rb"].each { |f| load(f) }
