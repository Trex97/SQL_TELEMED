SELECT COUNT(DISTINCT(v_t_f_opd_indiv_flat_y64.hcode)),
  COUNT(DISTINCT(v_t_f_opd_indiv_flat_y65.hcode)),
  COUNT(DISTINCT(v_t_f_opd_indiv_flat_y65.hcode))
FROM v_t_f_opd_indiv_flat_y64,
v_t_f_opd_indiv_flat_y65,v_t_f_opd_indiv_flat_y66;

CREATE table year60 as
SELECT DISTINCT (hcode)
FROM v_t_f_opd_indiv_flat_y60 vtfoify  ;

CREATE table year61 as
SELECT DISTINCT (hcode)
FROM v_t_f_opd_indiv_flat_y61 vtfoify  ;

CREATE table year62 as
SELECT DISTINCT (hcode)
FROM v_t_f_opd_indiv_flat_y62 vtfoify ;

CREATE table year64 as
SELECT DISTINCT (hcode)
FROM v_t_f_opd_indiv_flat_y64 vtfoify;

CREATE table year65 as
SELECT DISTINCT (hcode)
FROM v_t_f_opd_indiv_flat_y65 vtfoify ;

CREATE table year66 as
SELECT DISTINCT (hcode)
FROM v_t_f_opd_indiv_flat_y66 vtfoify ;


----### CHECK TOTAL AMOUNT OF HCODE EACH YEAR ###
--year 60 -- 11,780
SELECT  COUNT(DISTINCT(hcode))
FROM v_t_f_opd_indiv_flat_y60 vtfoify;

SELECT count(*) 
FROM year60;

--year 61 -- 11,452
SELECT  COUNT(DISTINCT(hcode))
FROM v_t_f_opd_indiv_flat_y61 vtfoify;

SELECT count(*) 
FROM year61;

--year 62 -- 11,856
SELECT  COUNT(DISTINCT(hcode))
FROM v_t_f_opd_indiv_flat_y62 vtfoify;

SELECT count(*) 
FROM year62;

--year 63 -- 11,922
SELECT  COUNT(DISTINCT(hcode))
FROM v_t_f_opd_indiv_flat_y63 vtfoify;

SELECT count(*) 
FROM year63;

--year 64--  11,850
SELECT  COUNT(DISTINCT(hcode))
FROM v_t_f_opd_indiv_flat_y64 vtfoify;

--11,850
SELECT count(*) 
FROM year64;

--year 65 ---11,857
SELECT COUNT(DISTINCT(hcode))
FROM v_t_f_opd_indiv_flat_y65 vtfoify ;
---11,857
SELECT count(*)
FROM year65;

--year 66 ---11,505
SELECT COUNT(DISTINCT(hcode))
FROM v_t_f_opd_indiv_flat_y66 vtfoify ;
--11,505
SELECT count(*)
FROM year66;

--- HCODE OPD active from 2564-2566 --- result 11,424 hospitals
SELECT COUNT(*) 
FROM year64 
INNER JOIN year65 ON year64.hcode = year65.hcode
INNER JOIN year66 ON year65.hcode = year66.hcode ;

--- TABLE HCODE OF OPD Y64-66 ---

CREATE TABLE OPD_HCODE AS
SELECT year64.hcode 
FROM year64
INNER JOIN year65 ON year64.hcode = year65.hcode
INNER JOIN year66 ON year65.hcode = year66.hcode ;

--- result 11,424 ---
SELECT COUNT(*)
FROM opd_hcode;
-- result 11,424 ---
SELECT COUNT(DISTINCT (hcode))
FROM opd_hcode;

-- CREATE TABLE >>> HCODE OF TELEMED ---
CREATE TABLE tele_hcode AS
SELECT DISTINCT(hcode)
FROM v_t_telemed;

-- COUNT TELE hospitals -- result 904--
SELECT COUNT(*)
FROM tele_hcode;

-- CREATE TABLE HCODE TELEMED WITH NUMBER 1 --
CREATE TABLE tele_hcode_n AS
SELECT hcode, 1 as TELEMED
FROM tele_hcode;


-----result 904 ---
SELECT COUNT(tele_hcode_n.hcode) 
FROM opd_hcode 
FULL JOIN tele_hcode_n 
ON opd_hcode.hcode = tele_hcode_n.hcode;

-----result 866 ---
SELECT COUNT(tele_hcode_n.hcode) 
FROM opd_hcode 
LEFT JOIN tele_hcode_n 
ON opd_hcode.hcode = tele_hcode_n.hcode;

-- list HCODE from Telemed only -- extra 38 hosp from OPD--- 
CREATE table HCODE_38 AS
SELECT tele_hcode.hcode 
FROM tele_hcode
WHERE tele_hcode.hcode NOT IN (SELECT opd_hcode.hcode 
         FROM opd_hcode LEFT JOIN tele_hcode_n 
         ON opd_hcode.hcode = tele_hcode_n.hcode);
        
-- JOIN TABLE HCODE OF OPD and Telemed --         
SELECT *
FROM opd_hcode
 LEFT JOIN tele_hcode_n  
     ON opd_hcode.hcode = tele_hcode_n.hcode;


-- COUNT VISIT YEAR 2564 --
SELECT hcode, count(pid) as VISIT
FROM v_t_telemed
WHERE year_serv ="2564"
GROUP BY hcode ;

-- COUNT VISIT YEAR 2565 --
SELECT hcode, count(pid) as VISIT 
FROM v_t_telemed
WHERE year_serv = "2565"
GROUP BY hcode, year_serv  ;

-- Count Tele visit by year -- 
SELECT year_serv as Year, SUBSTR(month_serv,5,2)as month ,sex , COUNT(tran_id) as Visit
FROM v_t_telemed vtt 
GROUP BY year_serv, SUBSTR(month_serv,5,2), sex 
ORDER BY year_serv, SUBSTR(month_serv,5,2), sex ;

-- 
SELECT year_serv as Year,sex, COUNT(pid) 
FROM v_t_telemed
GROUP BY year_serv , sex 
ORDER BY year_serv , sex;

--- By hospital --
SELECT year_serv as Year,SUBSTR(month_serv,5,2) as Month,hname, province_name , COUNT(pid) as Visit
FROM v_t_telemed
GROUP BY year_serv ,SUBSTR(month_serv,5,2),hname , province_name
ORDER BY year_serv ,SUBSTR(month_serv,5,2),hname , province_name;

--- 
SELECT year_serv as Year,SUBSTR(month_serv,5,2) as Month,hname, province_name , COUNT(pid) as Visit
FROM v_t_telemed
GROUP BY year_serv ,SUBSTR(month_serv,5,2),hname , province_name
ORDER BY year_serv ,SUBSTR(month_serv,5,2),hname , province_name;

--- Number of PID (TELEMED only) ----
SELECT COUNT(DISTINCT pid)
FROM v_t_telemed vtt 
WHERE sub_fund = 'TELEMED';

--- Number of Telemed visit ---
SELECT COUNT(pid)
FROM v_t_telemed vtt
WHERE sub_fund = 'TELEMED';
