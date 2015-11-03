SELECT
	DATE('{from_timestamp}') AS date,
	SUM(unread_diff > 2592000) / COUNT(*) * 100 AS percentage
FROM
(
	SELECT
		notification.notification_event,
		notification.notification_timestamp,
		# diff in seconds between notification time & read time (or now, if it hasn't been read yet)
		COALESCE(bundle.notification_read_timestamp, notification.notification_read_timestamp, DATE_FORMAT(NOW(), '%Y%m%d%H%i%s')) - notification.notification_timestamp AS unread_diff
	FROM {wiki_db}.echo_notification AS notification
	LEFT JOIN
	(
		SELECT
			notification_read_timestamp,
			notification_bundle_display_hash
		FROM {wiki_db}.echo_notification
		WHERE notification_bundle_base = 1
		GROUP BY notification_bundle_display_hash
	) bundle ON notification.notification_bundle_display_hash = bundle.notification_bundle_display_hash AND notification.notification_bundle_display_hash != ''
	WHERE notification.notification_timestamp BETWEEN '{from_timestamp}' AND '{to_timestamp}'
) AS temp;
