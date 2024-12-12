/*
- From table ac_utilization.
    + cols = validity = integer, DATE_INT
    Real arrival date of the leg. This value is meant to be the landing / 
    touchdown date of the leg (and not the on-block date of the leg)

15.Jul.2024 = 19190 
- Get first row of val
- AND ac_utilization.departure = 'SGN'
- Count total

*/
SELECT
    COUNT(ac_utilization.validity) AS "TOTAL PREF",
    (SELECT validity FROM ac_utilization WHERE departure = 'SGN' AND DATE_INT = 19190 LIMIT 1) AS "FIRST ROW"

FROM ac_utilization

WHERE
    ac_utilization.departure = 'SGN' AND
    ac_utilization.DATE_INT = 19190;


---
SELECT
    wo_header.release_station AS "STATION",
    wo_header.event_perfno_i AS "WO",
    wo_header.ext_workorderno AS "TECHLOG NO",
    wo_header.ac_registr AS "AC REG",
    wo_header.issue_leg AS "ISSUE LEG",
    wo_header.closing_leg AS "CLOSING LEG",
    wo_header.release_sign AS "RELEASE SIGN",
    TO_CHAR(
        DATE '1971-12-31' + wo_header.issue_date,
        'DD.MON.YYYY'
    ) AS "ISSUE_DATE",
    TO_CHAR(
        DATE '1971-12-31' + wo_header.closing_date,
        'DD.MON.YYYY'
    ) AS "CLOSING_DATE"
FROM
    wo_header
    JOIN workstep_link ON wo_header.event_perfno_i = workstep_link.event_perfno_i
    JOIN wo_text_description ON workstep_link.descno_i = wo_text_description.descno_i
WHERE
    wo_header.event_perfno_i > 0
    AND wo_header.workorderno_display IS NOT NULL
    AND (
        wo_header.event_type NOT IN ('Q', 'T')
    )
    AND EXISTS (
        SELECT
            aircraft.ac_registr
        FROM
            aircraft
        WHERE
            wo_header.ac_registr = aircraft.ac_registr
            AND aircraft.ac_registr LIKE 'A%'
    )
    AND wo_header.type IN (
        'P',
        'M',
        'C',
        'S'
    )
    AND wo_header.state = 'C'
    AND wo_header.issue_date BETWEEN 19190 AND 19206
    AND wo_text_description.text LIKE '%PRE-FLIGHT CHECK%'
    AND wo_header.release_station IN ('SGN','HAN','DAD','CXR','HPH','VII','VCA','PQC')
GROUP BY
    wo_header.release_station,
    wo_header.event_perfno_i,
    wo_header.ext_workorderno,
    wo_header.ac_registr,
    wo_header.issue_leg,
    wo_header.closing_leg,
    wo_header.release_sign,
    wo_header.issue_date,
    wo_header.closing_date
    
ORDER BY
    wo_header.release_station,
    wo_header.issue_date ASC


-----


SELECT
    wo_header.release_station AS 'STATION',
    TO_CHAR(
        DATE '1971-12-31' + wo_header.closing_date,
        'DD.MON.YYYY'
    ) AS "CLOSING_DATE",
    COUNT(wo_header.event_perfno_i) AS "TOTAL WO"
FROM
    wo_header
    JOIN workstep_link ON wo_header.event_perfno_i = workstep_link.event_perfno_i
    JOIN wo_text_description ON workstep_link.descno_i = wo_text_description.descno_i
WHERE
    wo_header.event_perfno_i > 0
    AND wo_header.workorderno_display IS NOT NULL
    AND (
        wo_header.event_type NOT IN ('Q', 'T')
    )
    AND EXISTS (
        SELECT
            aircraft.ac_registr
        FROM
            aircraft
        WHERE
            wo_header.ac_registr = aircraft.ac_registr
            AND aircraft.ac_registr LIKE 'A%'
    )
    AND wo_header.type IN (
        'P',
        'M',
        'C',
        'S'
    )
    AND wo_header.state = 'C'
    AND wo_header.issue_date BETWEEN 19190 AND 19206
    AND wo_text_description.text LIKE '%PRE-FLIGHT CHECK%'
    AND wo_header.release_station IN ('SGN','HAN','DAD','CXR','HPH','VII','VCA','PQC')
GROUP BY
    wo_header.release_station,
    wo_header.closing_date
ORDER BY
    wo_header.release_station,
    wo_header.closing_date ASC


