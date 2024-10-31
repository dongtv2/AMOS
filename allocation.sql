SELECT
    aircraft.ac_registr AS "REG",
    moc_daily_records.rep_station AS "STATION",
    moc_daily_records.event_type AS "STATUS"
FROM aircraft
LEFT JOIN moc_daily_records ON aircraft.ac_registr = moc_daily_records.ac_registr
WHERE
    aircraft.ac_registr LIKE 'A%'
    AND aircraft.non_managed = 'N'
             AND moc_daily_records.closed <> 'Y'
              AND moc_daily_records.event_type IN ('C_CHK', 'A_CHK', 'O_CHK', 'COA', 'PK_MT', 'ST_MT')
              AND DATE '1971-12-31' + moc_daily_records.occurance_date < CURRENT_DATE
UNION ALL
SELECT
    aircraft.ac_registr AS "REG",
    '' AS "STATION",
    'ACTIVE' AS event_type
FROM aircraft
WHERE
    aircraft.ac_registr LIKE 'A%'
    AND aircraft.non_managed = 'N'
    AND NOT EXISTS (
        SELECT 1
        FROM moc_daily_records
        WHERE aircraft.ac_registr = moc_daily_records.ac_registr
            AND moc_daily_records.closed <> 'Y'
            AND moc_daily_records.event_type IN ('C_CHK', 'A_CHK', 'O_CHK', 'COA', 'PK_MT', 'ST_MT')
            AND DATE '1971-12-31' + moc_daily_records.occurance_date < CURRENT_DATE
    )


/*
- Lấy danh sách ac_future_flight

*/

SELECT ac_utilization.departure_date,
       ac_utilization.departure_time,
       ac_utilization.departure,
       leg_additional.departure_stand,
       ac_utilization.validity,
       ac_utilization.arrival_time,
       ac_utilization.arrival,
       leg_additional.arrival_stand,
       ac_utilization.legno_i,
       leg_additional.parking_stand,
       CONCAT (
          ac_utilization.leg_number,
          ac_utilization.fn_suffix
       ),
       ac_utilization.sched_departure_date,
       ac_utilization.sched_departure_time,
       ac_utilization.sched_departure_airport,
       ac_utilization.sched_arrival_date,
       ac_utilization.sched_arrival_time,
       ac_utilization.sched_arrival_airport
FROM ac_utilization
JOIN leg_additional ON ac_utilization.legno_i = leg_additional.legno_i
WHERE ac_utilization.ac_registr = 'A691'
      AND ac_utilization.validity >= 19294
      AND ac_utilization.departure_date <= 19300

UNION
SELECT ac_utilization.departure_date,
       ac_utilization.departure_time,
       ac_utilization.departure,
       leg_additional.departure_stand,
       ac_utilization.validity,
       ac_utilization.arrival_time,
       ac_utilization.arrival,
       leg_additional.arrival_stand,
       ac_utilization.legno_i,
       leg_additional.parking_stand,
       CONCAT (
          ac_utilization.leg_number,
          ac_utilization.fn_suffix
       ),
       ac_utilization.sched_departure_date,
       ac_utilization.sched_departure_time,
       ac_utilization.sched_departure_airport,
       ac_utilization.sched_arrival_date,
       ac_utilization.sched_arrival_time,
       ac_utilization.sched_arrival_airport
FROM ac_utilization
JOIN leg_additional ON ac_utilization.legno_i = leg_additional.legno_i
WHERE ac_utilization.ac_registr = 'A691'
      AND ac_utilization.validity = (
         SELECT MAX (ac_utilization.validity)
         FROM ac_utilization
         WHERE ac_utilization.ac_registr = 'A691'
               AND ac_utilization.validity < 19294
               AND ac_utilization.validity > 19294 - 100
      )
UNION



SSELECT 
       ac_future_flights.legno_i,
       ac_future_flights.ac_registr AS "REG",

       ac_future_flights.fn_number AS "FLTNO",
    
    
       ac_future_flights.sched_departure_date,
       ac_future_flights.sched_departure_time,
       ac_future_flights.sched_departure_airport,
       ac_future_flights.sched_arrival_date,
       ac_future_flights.sched_arrival_time,




       ac_future_flights.sched_arrival_airport,

 

       ac_future_flights.leg_cycles,


       ac_future_flights.status


FROM ac_future_flights
WHERE ac_future_flights.ac_registr = 'A691'
        AND ac_future_flights.sched_departure_date = 19298
ORDER BY ac_future_flights.legno_i
UNION ALL
SELECT 
       ac_future_flights.legno_i,
       ac_future_flights.ac_registr AS "REG",

       ac_future_flights.fn_number AS "FLTNO",
    
    
       ac_future_flights.sched_departure_date,
       ac_future_flights.sched_departure_time,
       ac_future_flights.sched_departure_airport,
       ac_future_flights.sched_arrival_date,
       ac_future_flights.sched_arrival_time,




       ac_future_flights.sched_arrival_airport,

 

       ac_future_flights.leg_cycles,


       ac_future_flights.status


FROM ac_future_flights
WHERE ac_future_flights.ac_registr = 'A691'
        AND ac_future_flights.sched_departure_date = 19299
ORDER BY ac_future_flights.legno_i