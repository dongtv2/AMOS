-- PCD_WP_MAIN_COUNTER
/*
 - Count total number of WPs
 - Calculate total number of closed WPs
 - Calculate total number of in-process WPs

 Definitions:
 wp_header.wp_status = -2 => Closed
 wp_header.wp_status = -1 => Open
 */

SELECT
    COUNT(wp_header.wpno) AS "TOTALWP",
    SUM(CASE WHEN wp_header.wp_status = -2 THEN 1 ELSE 0 END) AS "TOTALWP_CLOSED",
    SUM(CASE WHEN wp_header.wp_status = -1 THEN 1 ELSE 0 END) AS "TOTALWP_OPENED"
FROM
    wp_header
WHERE
    wp_header.wpno IN (@VAR.WP@)
