require 'rubygems'
require 'bundler/setup'
require 'rack'
require 'sinatra'
$stdout.sync = true if development?
require 'sinatra/reloader' if development?
require 'sinatra/content_for'
require 'yaml'
require 'json'
require 'haml'
require 'sass'
require 'rss'
require 'tmp_cache'
require File.dirname(__FILE__)+'/bootstrap'
Bootstrap.init :libs, :helpers, :controllers

set :haml, :escape_html => true

run Sinatra::Application
