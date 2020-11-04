/*
Number sequence table
*/

CREATE OR REPLACE TABLE public.numbers (
  NUMBER    INTEGER NOT NULL PRIMARY KEY
);

/*
Populate table to 1 million
this will start at 0
*/
GRANT SELECT on TABLE public.numbers
to    ROLE  public;
INSERT INTO public.numbers
SELECT seq4()
FROM   TABLE (GENERATOR(ROWCOUNT=> 1000001))
