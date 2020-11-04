/*
Ripped from the blog below, with a few modifications
http://elliot.land/post/building-a-date-dimension-table-in-redshift
*/

CREATE OR REPLACE TABLE public.dates (
  -- DATE
  DATE_ID              INTEGER                     NOT NULL,
  FULL_DATE            DATE                        NOT NULL PRIMARY KEY,
  US_FORMAT_DATE       CHAR(10)                    NOT NULL,
  EURO_FORMAT_DATE     CHAR(10)                    NOT NULL,
  CHINE_JP_FORMAT_DATE CHAR(10)                    NOT NULL,

  -- YEAR
  YEAR_NUMBER          SMALLINT                    NOT NULL,
  YEAR_WEEK_NUMBER     SMALLINT                    NOT NULL,
  YEAR_DAY_NUMBER      SMALLINT                    NOT NULL,
  FISCAL_YEAR_NUMBER   SMALLINT                    NOT NULL,

  -- QUARTER
  QTR_NUMBER           SMALLINT                    NOT NULL,
  FISCAL_QTR_NUMBER    SMALLINT                    NOT NULL,

  -- MONTH
  MONTH_NUMBER         SMALLINT                    NOT NULL,
  MONTH_NAME           CHAR(9)                     NOT NULL,
  MONTH_DAY_NUMBER     SMALLINT                    NOT NULL,

  -- WEEK
  WEEK_DAY_NUMBER      SMALLINT                    NOT NULL,

  -- DAY
  DAY_NAME             CHAR(9)                     NOT NULL,
  DAY_IS_WEEKDAY       SMALLINT                    NOT NULL,
  DAY_IS_LAST_OF_MONTH SMALLINT                    NOT NULL
  );

GRANT select on TABLE public.dates to ROLE public;

INSERT INTO public.dates
  SELECT
  -- DATE
  CAST(seq + 1 AS INTEGER)                                      AS DATE_ID,
  datum                                                         AS FULL_DATE,
  TO_CHAR(datum, 'MM/DD/YYYY')                                  AS US_FORMAT_DATE,
  TO_CHAR(datum, 'DD/MM/YYYY')                                  AS EURO_FORMAT_DATE,
  TO_CHAR(datum, 'YYYY/MM/DD')                                  AS CHINE_JP_FORMAT_DATE,

  -- CALENDAR
  YEAR(datum)                                                   AS YEAR_NUMBER,
  WEEK(datum)                                                   AS YEAR_WEEK_NUMBER,
  DAYOFYEAR(datum)                                              AS YEAR_DAY_NUMBER,

  -- FISCAL year
  CASE WHEN DAYOFYEAR(datum) <= 31 THEN YEAR(datum)-1
       ELSE YEAR(datum )
  END                                                           AS FISCAL_YEAR_NUMBER,

  -- QUARTER
  QUARTER(datum)                                                AS QTR_NUMBER,

  -- Fiscal quarter
  CASE WHEN floor((MONTH(datum) -2) /3) +1 = 0
       THEN 4
       ELSE floor((MONTH(datum) -2) /3) +1
  END                                                           AS FISCAL_QTR_NUMBER,

  -- MONTH
  MONTH(datum)                                                  AS MONTH_NUMBER,
  TO_CHAR(datum, 'MMMM')                                        AS MONTH_NAME,
  DAY(datum)                                                    AS MONTH_DAY_NUMBER,

  -- WEEK
  DAYOFWEEK(datum)+1                                            AS WEEK_DAY_NUMBER,

  -- DAY
  -- Snowflake doesn't seem to natively support long weekday names
  decode (DAYNAME(datum),
    'Mon', 'Monday',
    'Tue', 'Tuesday',
    'Wed', 'Wednesday',
    'Thu', 'Thursday',
    'Fri', 'Friday',
    'Sat', 'Saturday',
    'Sun', 'Sunday')                                            AS DAY_NAME,
  CASE
    WHEN DAYOFWEEK(datum)+1 IN ('1', '7')
    THEN 0 ELSE 1
  END                                                    AS DAY_IS_WEEKDAY,
  CASE
    WHEN DAY(to_date (datum + to_number (1 - DAY(datum)) + INTERVAL '1 months' - INTERVAL '1 days')) =  DAY(datum)
    THEN 1 ELSE 0
  END                                                    AS DAY_IS_LAST_OF_MONTH
  FROM
  -- Generate days for the next ~20 years starting from 2014.
    (
      SELECT
      TO_DATE('2014-01-01') + NUMBER AS datum,
      NUMBER AS seq
      FROM public.numbers
        WHERE  NUMBER < 20 * 365
  ) DQ

ORDER BY 1
