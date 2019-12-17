--WITH
--WITH 블록이름 AS (
--     서브쿼리 )
--SELECT *
--FROM 블록이름

SELECT deptno, ROUND(avg(sal), 2) avg_sal
--해당 부서의 급여평균이 전체 직원의 급여 평균보다 높은 부서에 한해 조회
FROM emp
GROUP BY deptno
HAVING avg(sal) > (SELECT AVG(sal) FROM emp); --avg(sal)를 비교하기 위해 Having절 사용

--WITH 절을 사용하여 위의 쿼리를 작성
WITH dept_sal_avg AS (
        SELECT deptno, ROUND(avg(sal), 2) avg_sal
        FROM emp
        GROUP BY deptno ),
    emp_sal_avg AS (
        SELECT ROUND(AVG(sal), 2) avg_sal FROM emp ) --연속으로 블럭을 나열할 수도 있다
SELECT *
FROM dept_sal_avg
WHERE avg_sal > (SELECT avg_sal FROM emp_sal_avg); --그룹바이가 끝난 상태이기때문에 having절 대신 where절 사용


WITH test AS (
    SELECT 1, 'TEST' FROM DUAL UNION ALL
    SELECT 2, 'TEST2' FROM DUAL UNION ALL
    SELECT 3, 'TEST3' FROM DUAL )
SELECT *
FROM test;



--계층 쿼리
--달력만들기
--CONNECT BY LEVEL <= N
--테이블의 ROW건수를 N만큼 반복한다
--CONNECT BY LEVEL 절을 사용한 쿼리에서는 SELECT 절에서 LEVEL 이라는 특수 컬럼을 사용할 수 있다
--계층을 표현하는 특수 컬럼으로 1부터 증가하며 ROWNUM과 유사하나 추후 배우게될 START WITH, CONNECT BY 절에서 다른 점을 배우게 된다

--2019년 11월은 30일까지 존재
--일자 + 정수 = 정수만큼 미래의 일자
--201911 -> 해당년월의 날짜가 몇일까지 존재 하는가??
--iw : 월요일이 주의 시작
SELECT /* DECODE(d, 1, iw+1, iw) iw, --대신 iw level에서 -1을 제거*/
       MAX(DECODE(d, 1, dt)) sun, MAX(DECODE(d, 2, dt)) mon, MAX(DECODE(d, 3, dt)) tue, MAX(DECODE(d, 4, dt)) wed,
       MAX(DECODE(d, 5, dt)) thu, MAX(DECODE(d, 6, dt)) fri, MAX(DECODE(d, 7, dt)) sat
FROM
    (SELECT 
            TO_DATE(:yyyymm, 'YYYYMM') + (level -1) DT, -- * 대신 level 썼더니 숫자가 증가함
            TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM') + (level -1), 'D') d,
            TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM') + (level), 'IW') iw
    FROM dual
    CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'yyyymm')), 'DD'))
GROUP BY iw
ORDER BY iw;



--잘못나오는 12월 달력 수정하기
SELECT /* DECODE(d, 1, iw+1, iw) iw, --대신 iw level에서 -1을 제거*/
       /*dt - (d-1),*/
       MAX(DECODE(d, 1, dt)) sun, MAX(DECODE(d, 2, dt)) mon, MAX(DECODE(d, 3, dt)) tue, MAX(DECODE(d, 4, dt)) wen,
       MAX(DECODE(d, 5, dt)) thu, MAX(DECODE(d, 6, dt)) fri, MAX(DECODE(d, 7, dt)) sat
       --NULL값을 없애기위해 MAX사용
FROM
    (SELECT TO_DATE(:yyyymm, 'YYYYMM') + (level -1) DT, -- * 대신 level 썼더니 숫자가 증가함
            TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM') + (level -1), 'D') d,
            TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM') + (level), 'IW') iw
    FROM dual
    CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'yyyymm')), 'DD'))
GROUP BY dt - (d-1)
ORDER BY dt - (d-1);


--order by만 변경해도 가능
SELECT /* DECODE(d, 1, iw+1, iw) iw, --대신 iw level에서 -1을 제거*/
       MAX(DECODE(d, 1, dt)) sun, MAX(DECODE(d, 2, dt)) mon, MAX(DECODE(d, 3, dt)) tue, MAX(DECODE(d, 4, dt)) wen,
       MAX(DECODE(d, 5, dt)) thu, MAX(DECODE(d, 6, dt)) fri, MAX(DECODE(d, 7, dt)) sat
       --NULL값을 없애기위해 MAX사용
       
FROM
    (SELECT TO_DATE(:yyyymm, 'YYYYMM') + (level -1) DT, -- * 대신 level 썼더니 숫자가 증가함
            TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM') + (level -1), 'D') d, --요일
            TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM') + (level), 'IW') iw
    FROM dual
    CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'yyyymm')), 'DD'))
GROUP BY iw
ORDER BY sat;

--LAST_DAY(:yyyymm)
SELECT TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'yyyymm')), 'DD')
FROM dual;


---------------------------------과제----------------------------------
SELECT /* DECODE(d, 1, iw+1, iw) iw, --대신 iw level에서 -1을 제거*/
       MAX(DECODE(d, 1, dt)) sun, MAX(DECODE(d, 2, dt)) mon, MAX(DECODE(d, 3, dt)) tue, MAX(DECODE(d, 4, dt)) wen,
       MAX(DECODE(d, 5, dt)) thu, MAX(DECODE(d, 6, dt)) fri, MAX(DECODE(d, 7, dt)) sat
       --NULL값을 없애기위해 MAX사용
       
FROM
    (SELECT TO_DATE(:yyyymm, 'YYYYMM') + (level -1) DT, -- * 대신 level 썼더니 숫자가 증가함
            TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM') + (level -1), 'D') d, --요일
            TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM') + (level), 'IW') iw
    FROM dual
    CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'yyyymm')), 'DD'))
GROUP BY iw
ORDER BY sat;
---------------------------------과제----------------------------------



create table sales as 
select to_date('2019-01-03', 'yyyy-MM-dd') dt, 500 sales from dual union all
select to_date('2019-01-15', 'yyyy-MM-dd') dt, 700 sales from dual union all
select to_date('2019-02-17', 'yyyy-MM-dd') dt, 300 sales from dual union all
select to_date('2019-02-28', 'yyyy-MM-dd') dt, 1000 sales from dual union all
select to_date('2019-04-05', 'yyyy-MM-dd') dt, 300 sales from dual union all
select to_date('2019-04-20', 'yyyy-MM-dd') dt, 900 sales from dual union all
select to_date('2019-05-11', 'yyyy-MM-dd') dt, 150 sales from dual union all
select to_date('2019-05-30', 'yyyy-MM-dd') dt, 100 sales from dual union all
select to_date('2019-06-22', 'yyyy-MM-dd') dt, 1400 sales from dual union all
select to_date('2019-06-27', 'yyyy-MM-dd') dt, 1300 sales from dual;


--DECODE를 사용하면 조건에 해당하지 않는 값이 NULL로 나온다. 그 NULL값을 삭제하기 위해 MIN 사용.
--3월 데이터(null)을 0으로 만들기 위해 nvl 사용
SELECT NVL(MIN(DECODE(mm, '01', sales_sum)), 0) jan,
        NVL(MIN(DECODE(mm, '02', sales_sum)), 0) feb,
        NVL(MIN(DECODE(mm, '03', sales_sum)), 0) mar,
        NVL(MIN(DECODE(mm, '04', sales_sum)), 0) apr,
        NVL(MIN(DECODE(mm, '05', sales_sum)), 0) may, 
        NVL(MIN(DECODE(mm, '06', sales_sum)), 0) jun
FROM (SELECT TO_CHAR(dt, 'MM') mm, SUM(sales) sales_sum
        FROM sales
        GROUP BY TO_CHAR(dt, 'MM'));




SELECT *
FROM sales;





create table dept_h (
    deptcd varchar2(20) primary key ,
    deptnm varchar2(40) not null,
    p_deptcd varchar2(20),
    
    CONSTRAINT fk_dept_h_to_dept_h FOREIGN KEY
    (p_deptcd) REFERENCES  dept_h (deptcd) 
);




create table dept_h (
    deptcd varchar2(20) primary key ,
    deptnm varchar2(40) not null,
    p_deptcd varchar2(20),
    
    CONSTRAINT fk_dept_h_to_dept_h FOREIGN KEY
    (p_deptcd) REFERENCES  dept_h (deptcd) 
);
insert into dept_h values ('dept0', 'XX회사', '');
insert into dept_h values ('dept0_00', '디자인부', 'dept0');
insert into dept_h values ('dept0_01', '정보기획부', 'dept0');
insert into dept_h values ('dept0_02', '정보시스템부', 'dept0');
insert into dept_h values ('dept0_00_0', '디자인팀', 'dept0_00');
insert into dept_h values ('dept0_01_0', '기획팀', 'dept0_01');
insert into dept_h values ('dept0_02_0', '개발1팀', 'dept0_02');
insert into dept_h values ('dept0_02_1', '개발2팀', 'dept0_02');
insert into dept_h values ('dept0_00_0_0', '기획파트', 'dept0_01_0');
commit;


SELECT dept_h.*, LEVEL --67번 PPT의 데이터표에서 XX회사는 1LEVEL, 그 밑 데이터는 2LEVEL...
FROM dept_h
START WITH deptcd = 'dept0'  --시작점은 deptcd = 'dept0' --> XX회사(최상위조직)
CONNECT BY PRIOR deptcd = p_deptcd; --PRIOR (deptcd) : 이미 읽은 데이터, prior가 붙지 않으면 읽지 않은 데이터이다.

/*  --데이터를 읽을 때마다 그 값이 prior가 된다
    dept0(XX회사)
        dept0_00(디자인부)
            dept0_00_0(디자인팀)
        dept0_01(정보기획부)
            dept0_01_0(기획팀)
                dept0_00_0_0(기획파트)
        dept0_02(정보시스템부)
            dept0_02_0(개발1팀)
            dept0_02_1(개발2팀)