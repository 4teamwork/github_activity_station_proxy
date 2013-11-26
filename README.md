# Github Activity Station Proxy

This is a tiny [rack](https://github.com/rack/rack) application to proxy Github webhook calls over to an
Activity Station instance.

## Configuration

In order to work correctly you need to provide the proxy with an URL to
a running activity station.

```bash
export ACTIVITY_STATION_URL=http://activity.dev
```

Furthermore you need to configure a custom Github webhook:

```
curl \
  -X POST \
  -H "Content-Type: application/json" \
  -d '{ "name":"web", \
        "events": ["issues", "pull_request"], \
        "active": true, \
        "config": {"url": "https://github-activity.4teamwork.ch/", "content_type": "json"}}' \
  https://api.github.com/repos/OWNER/REPO/hooks\?access_token\=TOKEN
```

*make sure to replace the `OWNER`, `REPO` and `TOKEN` placeholders.*

### Logging

The proxy ships with an optional logger to save every payload received from
Github. The logger is disabled by default. To enable it:

```
export GHASP_REQUEST_LOG_PATH=/var/logs/github_activity.log
```

## Development

This project uses a very lightweight setup. To get started just perform:

```
git clone https://github.com/4teamwork/github_activity_station_proxy.git
cd github_activity_station_proxy
bundle
```

Run all tests to make sure everything worked out:

```
bin/test
```

To start a local server you can use the bundled
[shotgun](https://github.com/rtomayko/shotgun) script:

```
bin/shotgun
```

To simulate webhook calls from Github you can use:

```
bin/fixture_request issue_reopened
```

There are a variety of fixtures available. You'll find them in:

```
ls test/fixtures
```
