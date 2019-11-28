--날짜관련 함수
--ROUND, TRUNC
--(MONTHS_BETWEEN) ADD_MONTHS, NEXT_DAY
--LAST_DAY : 해당 날짜가 속한 월의 마지막 일자(DATE)

--월 : 1, 2, 3, 5, 7, 8, 9, 10, 12 : 31일
--  : 2 -윤년 여부 28, 29
--  : 4, 6, 9, 11 : 30일

--fn3
--해당 달의 마지막 날짜로 이동
--일자 필드만 추출하기
--DATE --> 일자컬럼(DD)만 추출
--DATE --> 문자열(DD)
SELECT '201912' param,
        TO_CHAR(LAST_DAY(TO_DATE('201912', 'YYYYMM')), 'DD') dt
FROM dual;

--바인드 변수
SELECT : yyyymm param,
        TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')), 'DD') dt --실행하면 '바인드입력' 나옴 - 날짜 입력 가능
FROM dual;

--SYSDATE를 YYYY/MM/DD 포맷의 문자열로 변경
SELECT TO_CHAR(SYSDATE, 'YYYY/MM/DD')
FROM dual;

--'2019/11/26' 문자열 --> DATE
SELECT TO_DATE(TO_CHAR(SYSDATE, 'YYYY/MM/DD'), 'YYYY/MM/DD')
FROM dual;

--YYYY-MM-DD HH24:MI:SS 문자열로 변경
SELECT TO_CHAR(SYSDATE, 'YYYY/MM/DD'),
        TO_CHAR(TO_DATE(TO_CHAR(SYSDATE, 'YYYY/MM/DD'), 'YYYY-MM-DD'), 'YYYY-MM-DD HH24:MI:SS')
FROM dual;

--EMPNO    NOT NULL NUMBER(4)   
--HIREDATE          DATE  
DESC emp;

--empno가 7369인 직원 정보 조회하기
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7369;


--실행 단계 보는 방법 (EXPLAIN PLAN FOR + SELECT * + FROM TABLE(dbms_xplan.display);)
SELECT *
FROM TABLE(dbms_xplan.display);

Plan hash value: 3956160932
 
--------------------------------------------------------------------------
| Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |      |     1 |    38 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| EMP  |     1 |    38 |     3   (0)| 00:00:01 | --자식부터 읽는다 (1->0)
--------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("EMPNO"=7369) --묵시적 형변환
   
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE TO_CHAR(empno) = '7369';

SELECT *
FROM TABLE(dbms_xplan.display);


SELECT 7300 + '69'
FROM dual;


EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7300 + '69'; --문자열에 + 라는 기호가 없기때문에 69를 숫자로 변경

SELECT *
FROM TABLE(dbms_xplan.display);

--
SELECT *
FROM emp
WHERE hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD');

--DATE타입의 묵시적 형변환은 사용을 권하지 않음 (->WHERE hiredate >= '1981/06/01';)

SELECT *
FROM emp
WHERE hiredate >= TO_DATE('81/06/01', 'RR/MM/DD');

SELECT TO_DATE('50/06/01', 'RR/MM/DD') --19로 시작
--        TO_DATE('49/06/01', 'RR/MM/DD'), --20으로 시작
--        TO_DATE('49/06/01', 'YY/MM/DD') --20으로 시작
FROM dual;

--숫자 --> 문자열
--문자열 --> 숫자
--숫자 : 1000000 --> 1,000,000.00(이건 문자, 한국표기법)
--숫자 : 1000000 --> 1,000.000,00(이건 문자, 독일표기법)
--날짜 포맷 : YYYY, MM, DD, HH24, MI, SS
--숫자 포맷 : 숫자 표현 : 9, 자리맞춤을 위한 0표시 : 0, 화폐단위 : L (한국기준 원단위가 나옴)
--            1000자리 구분 : , // 소수점 : .
--숫자 -> 문자열 TO_CHAR(숫자, '포맷')
--숫자 포맷이 길어질 경우 숫자 자리수를 충분히 표현
SELECT empno, ename, sal, TO_CHAR(sal, 'L000009,999') fm_sal
FROM emp;

SELECT TO_CHAR(100000000000000, '999,999,999,999,999')
FROM dual;

--NULL 처리 함수 : NVL, NVL2, NULLIF, COALESCE

--NVL(expr1, expr2) : 함수 인자 두개
--expr1이 NULL이면 expr2를 반환
--expr1이 NULL이 아니면 expr1을 반환
SELECT empno, ename, comm, NVL(comm, -1) nvl_comm
FROM emp;

--NVL2 (expr1, expr2, expr3)
--expr1 IS NOT NULL expr2 리턴
--expr1 IS NULL expr3 리턴
SELECT empno, ename, comm, NVL2(comm, 1000, -500) nvl_comm,
        NVL2(comm, comm, -500) nvl_comm --NVL과 동일한 결과
FROM emp;

--NULLIF(expr1, expr2)
--expr1 = expr2 NULL을 리턴
--expr1 != expr2 expr1을 리턴
--comm이 NULL일때 comm+500 : NULL
--  NULLIF(NULL, NULL) : NULL
--comm이 NULL이 아닐때 comm+500 : comm+500
--  NULLIF(comm, comm+500) : comm
SELECT empno, ename, comm, NULLIF(comm, comm+500) nullif_comm
FROM emp;

SELECT comm, NULLIF(comm+1, comm+1)
FROM emp;
--COALESCE(expr1, expr2, expr3....) //값이 여러개 올 수 있음
--인자중에 첫번쨰로 등장하는 NULL이 아닌 exprN을 리턴
--expr1 IS NOT NULL expr1을 리턴하고
--expr1 IS NULL COALESCE(expr2, expr3....)

SELECT empno, ename, comm, sal, COALESCE(comm, sal) coal_sal
FROM emp;

SELECT empno, ename, mgr, NVL(mgr, 9999) mgr_n,
        NVL2(mgr, mgr, 9999) mgr_n_2,
        COALESCE(mgr, 9999) mgr_n_3
FROM emp;

SELECT userid, usernm, reg_dt, NVL(reg_dt, SYSDATE)        
FROM users
WHERE userid NOT IN ('brown');

--condition
--case
--emp.job 컬럼을 기준으로
--'SALESMAN'이면 sal *1.05를 적용한 값 리턴
--'MANAGER'이면 sal *1.10를 적용한 값 리턴
--'PRESIDENT'이면 sal *1.20를 적용한 값 리턴
--위 3가지 직군이 아닐경우 sal 리턴
--empno, ename, sal, 요율 적용한 급여 AS bonus
SELECT empno, ename, job, sal,
        CASE
            WHEN job = 'SALESMAN' THEN sal * 1.05
            WHEN job = 'MANAGER' THEN sal * 1.10
            WHEN job = 'PRESIDENT' THEN sal * 1.20
            ELSE sal
        END bonus,
        comm,
        --NULL처리 함수 사용하지 않고 CASE 절을 이용하여
        --comm이 NULL일 경우 -10을 리턴하도록 구성
        CASE
            WHEN comm IS NULL THEN -10
            ELSE comm
        END case_null
FROM emp;

--DECODE
SELECT empno, ename, job, sal,
        DECODE(job, 'SALESMAN', sal*1.05, 'MANAGER', sal * 1.10, 'PRESIDENT', sal * 1.20, sal) bonus
FROM emp;

--144번
SELECT empno, ename, deptno,
        CASE
            WHEN deptno = '10' THEN 'ACCOUNTING'
            WHEN deptno = '20' THEN 'RESEARCH'
            WHEN deptno = '30' THEN 'SALES'
            WHEN deptno = '40' THEN 'OPERATIONS'
            ELSE 'DDIT'
        END DNAME
FROM emp;

--155번 실습
SELECT empno, ename, TO_CHAR(hiredate, 'YY/MM/DD') hiredate,
        CASE
            WHEN MOD(TO_NUMBER(TO_CHAR(hiredate, 'YY')), 2) = 1
            THEN '건강검진 대상자'
            ELSE '건강검진 비대상자'
        END CONTACT_TO_DOCTOR
FROM emp;