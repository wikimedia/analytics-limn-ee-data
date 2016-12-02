-- daily unique anonymous editors
SELECT
    DATE('{from_timestamp}') AS date,
    COUNT(*) as {wiki_db}
FROM (
    SELECT
        rev_user_text,
        SUM(revisions) AS revisions
    FROM (
        SELECT
            rev_user_text,
            COUNT(*) AS revisions
        FROM {wiki_db}.revision
        WHERE
            rev_timestamp >= '{from_timestamp}' AND
            rev_timestamp < '{to_timestamp}'AND
            rev_user = 0
        GROUP BY 1
        UNION ALL
        SELECT
            ar_user_text AS rev_user_text,
            COUNT(*) AS revisions
        FROM {wiki_db}.archive
        WHERE
            ar_timestamp >= '{from_timestamp}' AND
            ar_timestamp < '{to_timestamp}'AND
            ar_user = 0
        GROUP BY 1
    ) AS user_revisions
    GROUP BY 1
) AS editors
WHERE revisions >= 1;
