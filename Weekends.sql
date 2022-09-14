-- CREATE OR REPLACE Procedure AddWeekends(start_day IN CHAR(8), end_day IN CHAR(8)) IS

DECLARE
	start_day CHAR(8) := '20220101';
	end_day CHAR(8) := '20240101';
	---------------------------------------------------
	start_date DATE := TO_DATE(start_day,'YYYYMMDD');
	end_date DATE := TO_DATE(end_day,'YYYYMMDD');
	char_date CHAR(8);
	today NUMBER; -- 6 = CUMARTESI, 7 = PAZAR
	day_exist NUMBER;

BEGIN
	WHILE (start_date <= end_date)
	LOOP
	    today := TO_CHAR(start_date, 'D');
		-- for English should use 1 = SUNDAY, 7 = SATURDAY
	    IF (today = 6 OR today = 7) THEN
	        char_date := TO_CHAR(start_date, 'YYYYMMDD');

	        SELECT COUNT(*) INTO day_exist
	        FROM MY_TABLE_NAME
	        WHERE HOLIDAY_DATE = char_date;

	        IF day_exist = 0 THEN
	            INSERT INTO MY_TABLE_NAME
	            (HOLIDAY_DATE, OFFICIAL_HOLIDAY)
	            VALUES (char_date, 1);
	        END IF;

	    END IF;

		-- for English should use today = 1
		IF today = 7 THEN
			start_date := start_date + 6;
		ELSE
			start_date := start_date + 1;
		END IF;

	END LOOP;
END;

/* CREATE TABLE
CREATE TABLE MY_TABLE_NAME
(HOLIDAY_DATE CHAR(8) NOT NULL,
OFFICIAL_HOLIDAY NUMBER NOT NULL);
*/

/* CHECK TABLE
SELECT * FROM MY_TABLE_NAME
WHERE TO_DATE(HOLIDAY_DATE,'YYYYMMDD') BETWEEN
TO_DATE('20220101','YYYYMMDD') AND
TO_DATE('20240101','YYYYMMDD');
*/