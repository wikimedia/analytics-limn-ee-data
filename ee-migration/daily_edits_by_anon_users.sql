-- daily edits by anon users
SELECT
    DATE('{from_timestamp}') AS date,
    SUM(revisions) AS edits_by_anon_users
FROM (
    SELECT
        COUNT(*) AS revisions
    FROM {wiki_db}.revision
    WHERE
        rev_timestamp >= '{from_timestamp}' AND
        rev_timestamp < '{to_timestamp}' AND
        rev_user = 0
    UNION ALL
    SELECT
        COUNT(*) AS revisions
    FROM {wiki_db}.archive
    WHERE
        ar_timestamp >= '{from_timestamp}' AND
        ar_timestamp < '{to_timestamp}'AND
        ar_user = 0
) AS user_revisions;
