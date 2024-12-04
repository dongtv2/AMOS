
SELECT
    wpno,
    wpno_i

FROM wp_header

-- Count total WP


-- Count total WP closed


-- Count total WP in-process


WHERE
    wp_header.wpno IN (@VAR.WP@)