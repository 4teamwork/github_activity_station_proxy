require 'rubygems'
require 'bundler/setup'
Bundler.setup(:default, :test)

require "minitest/autorun"
require "rack/test"
require File.expand_path("../../../app", __FILE__)

$activity_station = ActivityStation.configure "test"


class FeatureTest < MiniTest::Test
  include Rack::Test::Methods

  def app
    Rack::PostBodyContentTypeParser.new(GithubActivityStationProxy.new)
  end

  def teardown
    super
    $activity_station.reset!
  end

  def post_json(uri, json)
    post(uri, json, { "CONTENT_TYPE" => "application/json" })
  end
end
