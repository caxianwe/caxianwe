# Overview of log queries in Azure Monito

## Output latest distinct values of specific fields and all other colums

If you only need the maximum date per computer:

```kusto
table
| summarize max(date) by ComputerName
```

Alternatively, if you need the entire records with latest date per computer:

```kusto
table
| summarize arg_max(date, *) by ComputerName
```

## Group by

```kusto
customEvents
| where name == 'Commit.Publish.Complete' or name == 'PullRequest.Publish.Complete' or name == 'PullRequest.Build.Complete'
| extend build_status = tostring(customDimensions.build_status)
| extend build_report_url_ = tostring(customDimensions.build_report_url)
| extend repo_url_ = tostring(parse_json(tostring(customDimensions.JobBasicInfo)).repo_url)
| extend JobBasicInfo_ = tostring(customDimensions.JobBasicInfo)
| summarize failed_count = countif(build_status == "Failed"), success_count = countif(build_status in ("SucceededWithWarning", "Succeeded")), failed_report = anyif(build_report_url_, build_status == "Failed"), JobBasicInfo = anyif(JobBasicInfo_, build_status == "Failed") by repo_url_
| where success_count <= 0 and failed_count > 0
```

## Where !in

- kind=leftanti, kind=leftantisemi

Returns all the records from the left side that don't have matches from the right.

```kusto
customEvents
| extend _telemetry_correlation_id = tostring(parse_json(tostring(customDimensions.JobBasicInfo)).telemetry_correlation_id)
| extend repo_id_ = tostring(parse_json(tostring(customDimensions.JobBasicInfo)).repo_id)
| join kind=leftanti
(
    customEvents
    | extend _telemetry_correlation_id = tostring(parse_json(tostring(customDimensions.JobBasicInfo)).telemetry_correlation_id)
    | where name contains "BuildWorkflow/Microsoft.OpenPublishing.Build/DataAccessorUtility.UnzipCachePackage"
    | project _telemetry_correlation_id
)
on _telemetry_correlation_id
| summarize anyif(repo_id_, true) by _telemetry_correlation_id
```