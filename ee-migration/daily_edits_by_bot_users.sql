-- daily edits by bot users
SELECT
    DATE('{from_timestamp}') AS date,
    SUM(revisions) AS edits_by_bot_users
FROM (
    SELECT
        COUNT(*) AS revisions
    FROM {wiki_db}.revision
    INNER JOIN user_groups ON
        ug_user = rev_user AND
        ug_group = "bot"
    WHERE
        rev_timestamp >= '{from_timestamp}' AND
        rev_timestamp < '{to_timestamp}' AND
        rev_user > 0
    UNION ALL
    SELECT
        COUNT(*) AS revisions
    FROM {wiki_db}.archive
    INNER JOIN user_groups ON
        ug_user = ar_user AND
        ug_group = "bot"
    WHERE
        ar_timestamp >= '{from_timestamp}' AND
        ar_timestamp < '{to_timestamp}' AND
        ar_user > 0
) AS bot_user_revisions;
