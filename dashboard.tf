resource "newrelic_one_dashboard" "golden_template" {
  name = "Golden Template Dashboard"

  page {
    name = "Golden Signals"

    # Throughput
    widget_billboard {
      title = "Requests per minute"
      row = 1
      column = 1

      nrql_query {
        query       = "FROM Transaction SELECT rate(count(*), 1 minute)"
      }
    }

    # Error rate
    widget_billboard {
        title = "Error Rate"
        row = 1
        column = 5

        nrql_query {
          query    = "SELECT count(apm.service.error.count) / count(apm.service.transaction.duration) AS 'All errors' FROM Metric WHERE (entity.guid = '${data.newrelic_entity.platform2.guid}') SINCE 1800 seconds AGO TIMESERIES"
        }
    }

    # Latency
    widget_billboard {
      title = "Average latency"
      row = 1
      column = 9

      nrql_query {
        query       = "FROM Transaction SELECT average(duration) FACET appName"
      }
    }

    widget_markdown {
      title = "Dashboard Note"
      row    = 2
      column = 1

      text = "### Helpful Links\n\n* [New Relic One](https://one.newrelic.com)\n* [Developer Portal](https://developer.newrelic.com)"
    }
  }

  page {
    name = "Placeholder"

    widget_billboard {
        title = "Placeholder"
        row = 1
        column = 1

        nrql_query {
          query      = "FROM Transaction SELECT average(duration)"
        }
    }
  }
}