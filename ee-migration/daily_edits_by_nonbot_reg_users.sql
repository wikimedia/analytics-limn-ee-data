-- daily edits by registered non-bot users
SELECT
    DATE('{from_timestamp}') AS date,
    SUM(revisions) AS edits_by_nonbot_reg_users
FROM (
    SELECT
        COUNT(*) AS revisions
    FROM {wiki_db}.revision
    LEFT JOIN user_groups ON
        rev_user = ug_user AND
        ug_group = "bot"
    WHERE
        rev_timestamp >= '{from_timestamp}' AND
        rev_timestamp < '{to_timestamp}' AND
        rev_user > 0 AND
        ug_group IS NULL
    UNION
    SELECT
        COUNT(*) AS revisions
    FROM {wiki_db}.archive
    LEFT JOIN user_groups ON
        ar_user = ug_user AND
        ug_group = "bot"
    WHERE
        ar_timestamp >= '{from_timestamp}' AND
        ar_timestamp < '{to_timestamp}' AND
        ar_user > 0 AND
        ug_group IS NULL
) AS table_revisions;
