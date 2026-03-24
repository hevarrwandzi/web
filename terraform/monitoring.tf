# AWS CloudWatch Dashboard for Hevar's Portfolio 📊🥊

resource "aws_cloudwatch_dashboard" "portfolio_dashboard" {
  dashboard_name = "HevarPortfolioMetrics"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/CloudFront", "Requests", "Region", "Global", "DistributionId", "E2SKWX0WDEW83O"],
            [".", "4xxErrorRate", ".", ".", ".", "."],
            [".", "5xxErrorRate", ".", ".", ".", "."]
          ]
          period = 300
          stat   = "Sum"
          region = "us-east-1"
          title  = "CloudFront Traffic & Errors"
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/Lambda", "Invocations", "FunctionName", "HevarVisitorCounter"],
            [".", "Errors", ".", "."],
            [".", "Duration", ".", ".", { "stat": "Average" }]
          ]
          period = 300
          stat   = "Sum"
          region = "eu-north-1"
          title  = "Lambda Backend Health"
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 24
        height = 6
        properties = {
          metrics = [
            ["AWS/DynamoDB", "ConsumedReadCapacityUnits", "TableName", "HevarLabData"],
            [".", "ConsumedWriteCapacityUnits", ".", "."]
          ]
          period = 300
          stat   = "Sum"
          region = "eu-north-1"
          title  = "DynamoDB Throughput"
        }
      }
    ]
  })
}

# 4. AWS Budget Alert 💸🛡️🥊
# This ensures Hevar doesn't get a surprise bill!
resource "aws_budgets_budget" "monthly_budget" {
  name              = "Monthly-Lab-Budget"
  budget_type       = "COST"
  limit_amount      = "10" # Alert if we exceed $10
  limit_unit        = "USD"
  time_period_start = "2026-03-01_00:00"
  time_unit         = "MONTHLY"

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 80
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = ["hevarwandzi@gmail.com"] # Using your email from Git
  }
}
