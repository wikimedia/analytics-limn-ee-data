-- daily edits
SELECT
    DATE('{from_timestamp}') AS date,
    SUM(revisions) AS {wiki_db}
FROM (
    SELECT
        COUNT(*) AS revisions
    FROM {wiki_db}.revision
    WHERE
        rev_timestamp >= '{from_timestamp}' AND
        rev_timestamp < '{to_timestamp}'
    UNION ALL
    SELECT
        COUNT(*) as revisions
    FROM {wiki_db}.archive
    WHERE
        ar_timestamp >= '{from_timestamp}' AND
        ar_timestamp < '{to_timestamp}'
) AS all_revisions;
