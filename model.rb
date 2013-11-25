class Activity
  def initialize(params)
    @params = params
  end

  def system
    "github"
  end

  def action
    @params["action"]
  end

  def action_kind
    "#{kind}_#{action}"
  end

  def message
    "#{repo}##{number}: #{title}"
  end
end

class IssueActivity < Activity
  def kind
    "issue"
  end

  def url
    @params["issue"]["html_url"]
  end

  def repo
    @params["repository"]["full_name"]
  end

  def actor
    @params["sender"]["login"]
  end

  def number
    @params["issue"]["number"]
  end

  def title
    @params["issue"]["title"]
  end
end

class PullRequestActivity < Activity
  def kind
    "pull_request"
  end

  def url
    @params["pull_request"]["html_url"]
  end

  def repo
    @params["pull_request"]["base"]["repo"]["full_name"]
  end

  def actor
    @params["pull_request"]["user"]["login"]
  end

  def number
    @params["pull_request"]["number"]
  end

  def title
    @params["pull_request"]["title"]
  end
end
