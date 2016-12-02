-- daily unique registered non-bot editors
SELECT
    DATE('{from_timestamp}') AS date,
    COUNT(*) {wiki_db}
FROM (
    SELECT
        rev_user,
        SUM(revisions) AS revisions
    FROM (
        SELECT
            rev_user,
            COUNT(*) AS revisions
        FROM {wiki_db}.revision
        WHERE
            rev_timestamp >= '{from_timestamp}' AND
            rev_timestamp < '{to_timestamp}' AND
            rev_user > 0
        GROUP BY 1
        UNION ALL
        SELECT
            ar_user AS rev_user,
            COUNT(*) AS revisions
        FROM {wiki_db}.archive
        WHERE
            ar_timestamp >= '{from_timestamp}' AND
            ar_timestamp < '{to_timestamp}' AND
            ar_user > 0
        GROUP BY 1
    ) AS user_revisions
    GROUP BY 1
) AS editors
LEFT JOIN user_groups ON
    ug_user = rev_user AND
    ug_group = "bot"
WHERE ug_group IS NULL
AND revisions >= 1;
