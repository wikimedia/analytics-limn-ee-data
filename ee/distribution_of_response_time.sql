SELECT
	DATE('{from_timestamp}') AS date,
	SUM(notification_read_timestamp IS NOT NULL AND unread_diff < 172801) AS 0_to_2, # <= 2 days
	SUM(notification_read_timestamp IS NOT NULL AND unread_diff BETWEEN 172800 AND 432001) AS 2_to_5, # 2 < x <= 5 days
	SUM(notification_read_timestamp IS NOT NULL AND unread_diff BETWEEN 432000 AND 864001) AS 5_to_10, # 5 < x <= 10 days
	SUM(notification_read_timestamp IS NOT NULL AND unread_diff BETWEEN 864000 AND 1728001) AS 10_to_20, # 10 < x <= 20 days
	SUM(notification_read_timestamp IS NOT NULL AND unread_diff BETWEEN 1728000 AND 2592001) AS 20_to_30, # 20 < x <= 30 days
	SUM(unread_diff > 2592000) AS 30_plus # > 30 days
FROM
(
	SELECT
		notification.notification_event,
		notification.notification_timestamp,
		IFNULL(bundle.notification_read_timestamp, notification.notification_read_timestamp) AS notification_read_timestamp,
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
