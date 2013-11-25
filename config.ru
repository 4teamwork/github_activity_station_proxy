$: << File.dirname(__FILE__)
require 'bundler/setup'

require "app"
$activity_station = ActivityStation.configure "production"

run Application
