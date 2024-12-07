SELECT
    -- Tính tổng TOTAL_TASK dựa trên ASSIGNED và DEFERRED
    (MAX(CASE WHEN "TASK_TYPE" = 'ASSIGNED' THEN "TASK_COUNT" ELSE 0 END) +
     MAX(CASE WHEN "TASK_TYPE" = 'DEFERRED' THEN "TASK_COUNT" ELSE 0 END)) AS "TOTAL_TASK",

    -- Tổng số nhiệm vụ ASSIGNED
    MAX(CASE WHEN "TASK_TYPE" = 'ASSIGNED' THEN "TASK_COUNT" ELSE 0 END) AS "ASSIGNED_TASK_TOTAL",

    -- Tổng số nhiệm vụ DEFERRED
    MAX(CASE WHEN "TASK_TYPE" = 'DEFERRED' THEN "TASK_COUNT" ELSE 0 END) AS "DEFERRED_TOTAL",

    -- Tổng số nhiệm vụ CLOSED
    MAX(CASE WHEN "TASK_TYPE" = 'CLOSED' THEN "TASK_COUNT" ELSE 0 END) AS "CLOSED_TOTAL"

FROM (
    -- Query cho ASSIGNED_TASK_TOTAL
    SELECT COUNT(wp_assignment.wpno_i) AS "TASK_COUNT", 'ASSIGNED' AS "TASK_TYPE"
    FROM wp_assignment
    JOIN wp_header ON wp_header.wpno_i = wp_assignment.wpno_i
    WHERE wp_assignment.wpno_i IN (@VAR.WP@)


    UNION ALL

    -- Query cho DEFERRED_TOTAL
    SELECT COUNT(wp_content.wpno_i) AS "TASK_COUNT", 'DEFERRED' AS "TASK_TYPE"
    FROM wp_content
    JOIN wp_header ON wp_header.wpno_i = wp_content.wpno_i
    WHERE wp_content.wpno_i IN (@VAR.WP@)


    UNION ALL

    -- Query cho CLOSED_TOTAL
    SELECT COUNT(wp_assignment.wpno_i) AS "TASK_COUNT", 'CLOSED' AS "TASK_TYPE"
    FROM wp_assignment
    JOIN wp_header ON wp_header.wpno_i = wp_assignment.wpno_i
    JOIN wo_header ON wo_header.event_perfno_i = wp_assignment.event_perfno_i
    WHERE wp_assignment.wpno_i IN (@VAR.WP@)
    AND wo_header.state = 'C'

) AS task_counts
