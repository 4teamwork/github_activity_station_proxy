require "rack/contrib"
require "activity_station"
require "json"
require File.expand_path("../model", __FILE__)

class GithubActivityStationProxy
  def call(environment)
    request = Rack::Request.new(environment)
    return bad_request unless valid_params?(request.params)

    activity = activity_from(request.params)
    $activity_station.submit("actor" => activity.actor,
                             "kind" => activity.action_kind,
                             "message" => activity.message,
                             "system" => activity.system,
                             "url" => activity.url,
                             "path" => activity.repo)
    Rack::Response.new([], 200)
  end

  private
  def valid_params?(params)
    params.has_key?("action")
  end

  def activity_from(params)
    if params.has_key?("pull_request")
      if params['action'] == 'closed' && params['pull_request']['merged']
        PullRequestMergedActivity.new params
      else
        PullRequestActivity.new params
      end
    else
      IssueActivity.new params
    end
  end

  def bad_request(body = "Bad Request")
    Rack::Response.new(body, 400)
  end
end

class RequestLogger
  def initialize(app)
    @app = app
    @path = ENV["GHASP_REQUEST_LOG_PATH"]
  end

  def call(env)
    File.open @path, "a" do |f|
      f.puts "\n=================== #{Time.now} ==================="
      f.puts JSON.pretty_generate(env["rack.request.form_hash"])
    end
    @app.call(env)
  end
end
