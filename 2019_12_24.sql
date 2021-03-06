--FOR LOOP에서 명시적 커서 사용하기
SET SERVEROUTPUT ON;
DECLARE
    CURSOR dept_cursor IS
        SELECT dname, loc
        FROM dept;
    v_dname dept.dname%TYPE;
    v_loc dept.loc%TYPE;
BEGIN
    --java에서 향상된 for문과 같은 역할
    FOR record_row IN dept_cursor LOOP --레코드 변수 IN 커서변수
        DBMS_OUTPUT.PUT_LINE(record_row.dname || ', ' || record_row.loc);
    END LOOP;
END;
/


--커서에서 인자가 들어가는 경우
--p_deptno dept.deptno%TYPE -> 커서에서 사용할 인자를 입력하면 for문에 값(10)을 넣어 조회할 수 있다
DECLARE
    CURSOR dept_cursor(p_deptno dept.deptno%TYPE) IS
        SELECT dname, loc
        FROM dept
        WHERE deptno = p_deptno;
    v_dname dept.dname%TYPE;
    v_loc dept.loc%TYPE;
BEGIN
    --java에서 향상된 for문과 같은 역할
    FOR record_row IN dept_cursor(10) LOOP --레코드 변수 IN 커서변수
--FOR LOOP에서 명시적 커서 사용하기
SET SERVEROUTPUT ON;
DECLARE
    CURSOR dept_cursor IS
        SELECT dname, loc
        FROM dept;
    v_dname dept.dname%TYPE;
    v_loc dept.loc%TYPE;
BEGIN
    --java에서 향상된 for문과 같은 역할
    FOR record_row IN dept_cursor LOOP --레코드 변수 IN 커서변수
        DBMS_OUTPUT.PUT_LINE(record_row.dname || ', ' || record_row.loc);
    END LOOP;
END;
/


--커서에서 인자가 들어가는 경우
--p_deptno dept.deptno%TYPE -> 커서에서 사용할 인자를 입력하면 for문에 값(10)을 넣어 조회할 수 있다
DECLARE
    CURSOR dept_cursor(p_deptno dept.deptno%TYPE) IS
        SELECT dname, loc
        FROM dept
        WHERE deptno = p_deptno;
    v_dname dept.dname%TYPE;
    v_loc dept.loc%TYPE;
BEGIN
    --java에서 향상된 for문과 같은 역할
    FOR record_row IN dept_cursor(10) LOOP --레코드 변수 IN 커서변수
        DBMS_OUTPUT.PUT_LINE(record_row.dname || ', ' || record_row.loc);
    END LOOP;
END;
/

--FOR LOOP 인라인 커서
--FOR LOOP 구문에서 커서를 직접 선언
DECLARE
BEGIN
    FOR record_row IN (SELECT dname, loc FROM dept) LOOP --(SELECT dname, loc FROM dept)--커서가 직접 들어감
        DBMS_OUTPUT.PUT_LINE(record_row.dname || ', ' || record_row.loc);
    END LOOP;
END;
/


 CREATE TABLE DT
(	DT DATE);

insert into dt
select trunc(sysdate + 10) from dual union all
select trunc(sysdate + 5) from dual union all
select trunc(sysdate) from dual union all
select trunc(sysdate - 5) from dual union all
select trunc(sysdate - 10) from dual union all
select trunc(sysdate - 15) from dual union all
select trunc(sysdate - 20) from dual union all
select trunc(sysdate - 25) from dual;

commit;


--실습pro_3
--int a = 0;
--	int sum = 0;
--	int avg = 0;
--	for(int i = 0; i < intList.size()-1; i++){
--			a = intList.get(i+1) - intList.get(i);
--			sum += a;
--	}
--	avg = sum / (intList.size()-1);
--	System.out.println(avg);
CREATE OR REPLACE PROCEDURE avgdt IS
    TYPE dt_tab IS TABLE OF dt%ROWTYPE INDEX BY BINARY_INTEGER;
    v_dt_tab dt_tab;
    v_sum NUMBER := 0;
BEGIN
    SELECT *
    BULK COLLECT INTO v_dt_tab
    FROM dt;
    
    FOR i IN 1..v_dt_tab.count-1 LOOP
        v_sum := v_sum + v_dt_tab(i+1).dt - v_dt_tab(i).dt;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(v_sum);
END;
/                                                                                                                    
    END LOOP;
END;
/

--FOR LOOP 인라인 커서
--FOR LOOP 구문에서 커서를 직접 선언
DECLARE
BEGIN
    FOR record_row IN (SELECT dname, loc FROM dept) LOOP --(SELECT dname, loc FROM dept)--커서가 직접 들어감
        DBMS_OUTPUT.PUT_LINE(record_row.dname || ', ' || record_row.loc);
    END LOOP;
END;
/


 CREATE TABLE DT
(	DT DATE);

insert into dt
select trunc(sysdate + 10) from dual union all
select trunc(sysdate + 5) from dual union all
select trunc(sysdate) from dual union all
select trunc(sysdate - 5) from dual union all
select trunc(sysdate - 10) from dual union all
select trunc(sysdate - 15) from dual union all
select trunc(sysdate - 20) from dual union all
select trunc(sysdate - 25) from dual;

commit;


--실습pro_3
--int a = 0;
--	int sum = 0;
--	int avg = 0;
--	for(int i = 0; i < intList.size()-1; i++){
--			a = intList.get(i+1) - intList.get(i);
--			sum += a;
--	}
--	avg = sum / (intList.size()-1);
--	System.out.println(avg);
CREATE OR REPLACE PROCEDURE avgdt IS
    TYPE dt_tab IS TABLE OF dt%ROWTYPE INDEX BY BINARY_INTEGER;
    v_dt_tab dt_tab;
    v_sum NUMBER := 0;
BEGIN
    SELECT *
    BULK COLLECT INTO v_dt_tab
    FROM dt
    ORDER BY dt;
    
    FOR i IN 1..v_dt_tab.count-1 LOOP
        v_sum := v_sum + v_dt_tab(i+1).dt - v_dt_tab(i).dt;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(v_sum / (v_dt_tab.count-1));
END;
/

exec AVGDT;


--sql로
--1. rownum으로

--2. 분석함수로
SELECT AVG(sum_avg) sum_avg
FROM
(SELECT dt, LEAD(dt) OVER (ORDER BY dt) - dt sum_avg
FROM dt);
--3. ???
SELECT (MAX(dt) - MIN(dt)) / (COUNT(*)-1) avg_sum
FROM dt;


--실습pro_4
SELECT *
FROM cycle;
--1번 고객이 월요일에 1개를 마신다면 --> 1, 100, 2, 1 --> 1, 100, 20191202, 1
                                                --> 1, 100, 20191209, 1...5건까지
SELECT *
FROM daily;

CREATE OR REPLACE PROCEDURE create_daily_sales (v_yyyymm IN VARCHAR2) --DESC daily; 검색해서 dt 타입 확인
IS
    TYPE cal_row_type IS RECORD (dt VARCHAR2(8), day NUMBER); --레코드 만들기
    TYPE cal_tab IS TABLE OF cal_row_type INDEX BY BINARY_INTEGER; --레코드의 여러개의 결과값을 테이블로 만든다
    v_cal_tab cal_tab; --cal_tab타입의 변수 선언
BEGIN
    --생성하기전에 해당년월에 해당하는 일실적 데이터를 삭제한다
    DELETE daily
    WHERE dt LIKE v_yyyymm || '%';

    --달력정보를 table 변수에 저장한다
    --반복적인 sql 실행을 방지하기 위해 한번만 실행하여 변수에 저장
    SELECT TO_CHAR(TO_DATE(v_yyyymm, 'YYYYMM') + (LEVEL-1), 'YYYYMMDD') dt, --날짜함수를 VARCHAR타입으로 만들기
        TO_CHAR(TO_DATE(v_yyyymm, 'YYYYMM') + (LEVEL-1), 'D') day --요일
    BULK COLLECT INTO v_cal_tab
    FROM dual
    CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(v_yyyymm, 'YYYYMM')), 'DD'); --마지막날짜 구하기

    --애음주기 정보를 읽는다
    FOR daily IN (SELECT * FROM cycle) LOOP --outer loop
        FOR i IN 1..v_cal_tab.count LOOP --inner loop 달력정보 읽는 용도(12월 일자달력 : cycle row 건수만큼 반복)
            IF daily.day = v_cal_tab(i).day THEN
                --cid, pid, 일자, 수량
                INSERT INTO daily VALUES (daily.cid, daily.pid, v_cal_tab(i).dt, daily.cnt);
            END IF;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(daily.cid || ', ' || daily.day);
    END LOOP;
    
    COMMIT;
END;
/

exec CREATE_DAILY_SALES('201912');


SELECT *
FROM daily;

--INSERT INTO daily VALUES (daily.cid, daily.pid, v_cal_tab(i).dt, daily.cnt);를 효율적인 쿼리로 바꾼것
--for문으로 insert를 하면 모든 데이터를 읽으면서 수행하기 때문에 시간이 오래 걸린다
SELECT cycle.cid, cycle.pid, cal.dt, cycle.cnt
FROM cycle,
(SELECT TO_CHAR(TO_DATE(:v_yyyymm, 'YYYYMM') + (LEVEL-1), 'YYYYMMDD') dt,
        TO_CHAR(TO_DATE(:v_yyyymm, 'YYYYMM') + (LEVEL-1), 'D') day
    FROM dual
    CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:v_yyyymm, 'YYYYMM')), 'DD')) cal
WHERE cycle.day = cal.day;