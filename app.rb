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
    [200,
     {"Content-Type" => "text/plain"},
     [""]]
  end

  private
  def valid_params?(params)
    params.has_key?("action")
  end

  def activity_from(params)
    if params.has_key?("pull_request")
      PullRequestActivity.new params
    else
      IssueActivity.new params
    end
  end

  def bad_request(body = "Bad Request")
    [400,
     { 'Content-Type' => 'text/plain', 'Content-Length' => body.size.to_s },
     [body]]
  end
end

Application = Rack::PostBodyContentTypeParser.new GithubActivityStationProxy.new
