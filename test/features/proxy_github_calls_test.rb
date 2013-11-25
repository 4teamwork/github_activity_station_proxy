require "features/test_helper"

class ProxyGithubCallsTest < FeatureTest
  def test_creates_payload_for_issue_opened_event
    post_json "/", fixture("issue_opened.json")
    assert last_response.ok?
    assert_event("actor" => "senny",
                 "kind" => "issue_opened",
                 "message" => "4teamwork/activity_station#35: webhook testing the 2nd.",
                 "system" => "github",
                 "url" => "https://github.com/4teamwork/activity_station/issues/35",
                 "path" => "4teamwork/activity_station")
  end

  def test_creates_payload_for_issue_closed_event
    post_json "/", fixture("issue_closed.json")
    assert last_response.ok?
    assert_event("actor" => "senny",
                 "kind" => "issue_closed",
                 "message" => "4teamwork/activity_station#34: testing webhooks...",
                 "system" => "github",
                 "url" => "https://github.com/4teamwork/activity_station/issues/34",
                 "path" => "4teamwork/activity_station")
  end

  def test_creates_payload_for_issue_reopened_event
    post_json "/", fixture("issue_reopened.json")
    assert last_response.ok?
    assert_event("actor" => "senny",
                 "kind" => "issue_reopened",
                 "message" => "4teamwork/activity_station#35: webhook testing the 2nd.",
                 "system" => "github",
                 "url" => "https://github.com/4teamwork/activity_station/issues/35",
                 "path" => "4teamwork/activity_station")
  end

  def test_creates_payload_for_pull_request_opened_event
    post_json "/", fixture("pull_request_opened.json")
    assert last_response.ok?
    assert_event("actor" => "lukasgraf",
                 "kind" => "pull_request_opened",
                 "message" => "4teamwork/opengever.core#165: Override livesearch_reply.py to provide correct advanced search link.",
                 "system" => "github",
                 "url" => "https://github.com/4teamwork/opengever.core/pull/165",
                 "path" => "4teamwork/opengever.core")
  end

  def test_creates_payload_for_pull_request_closed_event
    post_json "/", fixture("pull_request_closed.json")
    assert last_response.ok?
    assert_event("actor" => "Tschanzt",
                 "kind" => "pull_request_closed",
                 "message" => "4teamwork/ftwshop.simplelayout#11: show image in shopitemblock",
                 "system" => "github",
                 "url" => "https://github.com/4teamwork/ftwshop.simplelayout/pull/11",
                 "path" => "4teamwork/ftwshop.simplelayout")
  end

  def test_creates_payload_for_pull_request_reopend_event
    post_json "/", fixture("pull_request_reopened.json")
    assert last_response.ok?
    assert_event("actor" => "senny",
                 "kind" => "pull_request_reopened",
                 "message" => "4teamwork/activity_station#36: update the Rails version we are using.",
                 "system" => "github",
                 "url" => "https://github.com/4teamwork/activity_station/pull/36",
                 "path" => "4teamwork/activity_station")
  end

  def test_bad_request_for_blank_payload
    post "/"
    assert_equal 400, last_response.status
    assert_equal "Bad Request", last_response.body
  end

  def assert_event(expected_event)
    assert_equal 1 , $activity_station.sent_events.size

    activity = $activity_station.sent_events.first
    actual_event = activity.dup
    actual_event.delete("payload")
    assert_equal(expected_event, actual_event)
  end

  def fixture(name)
    File.read(File.expand_path("../../fixtures/#{name}", __FILE__))
  end
end
