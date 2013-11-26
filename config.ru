$: << File.dirname(__FILE__)
require 'bundler/setup'

require "app"
$activity_station = ActivityStation.configure "production"

use Rack::PostBodyContentTypeParser
use RequestLogger if ENV.has_key? "GHASP_REQUEST_LOG_PATH"

run GithubActivityStationProxy.new
