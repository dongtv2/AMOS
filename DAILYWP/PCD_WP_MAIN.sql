
SELECT
    wpno,
    wpno_i

FROM wp_header

WHERE
    wp_header.wpno IN (@VAR.WP@)