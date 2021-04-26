resource "newrelic_synthetics_monitor" "api_test_platform2" {
  name = "foo"
  type = "SCRIPT_API"
  frequency = 5
  status = "ENABLED"
  locations = ["AWS_US_EAST_1"]
}

resource "newrelic_synthetics_monitor_script" "foo_script" {
  monitor_id = newrelic_synthetics_monitor.api_test_platform2.id
  text = file("${path.module}/script.js")
}