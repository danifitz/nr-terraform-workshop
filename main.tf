terraform {
  required_version = "~> 0.13.0" # Use tfenv
  required_providers {
    newrelic = {
      source  = "newrelic/newrelic"
      version = "~> 2.21.1"
    }
  }
}

# Configure the New Relic provider
provider "newrelic" {
  account_id = "3136577"
  region = "EU"                    # Valid regions are US and EU
}

# Data Source - Platform2
data "newrelic_entity" "platform2" {
  name = "Platform2" # Note: This must be an exact match of your app name in New Relic (Case sensitive)
  type = "APPLICATION"
  domain = "APM"
}

resource "newrelic_alert_policy" "tf_managed_policy" {
  name = "Terraform managed alert policy"
}

# NRQL alert condition - external response time high for Platform2
resource "newrelic_nrql_alert_condition" "foo" {
  policy_id                    = newrelic_alert_policy.tf_managed_policy.id
  type                         = "static"
  name                         = "External service response time > 5000ms"
  description                  = "Alert when external services are taking too long"
  runbook_url                  = "https://www.example.com"
  enabled                      = true
  value_function               = "single_value"
  violation_time_limit_seconds = 3600

  nrql {
    query             = "SELECT sum(apm.service.external.host.duration) * 1000 FROM Metric where appName = '${data.newrelic_entity.platform2.name}' FACET `external.host`, entity.guid"
    evaluation_offset = 3
  }

  critical {
    operator              = "above"
    threshold             = 5000
    threshold_duration    = 300
    threshold_occurrences = "ALL"
  }
}

# Notification channel
resource "newrelic_alert_channel" "alert_notification_email" {
  name = "danielfitzgerald@newrelic.com"
  type = "email"

  config {
    recipients              = "danielfitzgerald@newrelic.com"
    include_json_attachment = "1"
  }
}

# Link the above notification channel to your policy
resource "newrelic_alert_policy_channel" "alert_policy_email" {
  policy_id  = newrelic_alert_policy.tf_managed_policy.id
  channel_ids = [
    newrelic_alert_channel.alert_notification_email.id
  ]
}