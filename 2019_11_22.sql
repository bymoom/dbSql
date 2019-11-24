--col In (valuel, value2...)
--col의 값이 IN 연산자 안에 나열된 값중에 포함될 때 참으로 인정

--RDBMS - 집합개념
--1.집합에는 순서가 없다
-- (1, 5, 7), (5,1,7)

--2.집합에는 중복이 없다
-- (1,1,5,7), (5,1,7)

SELECT *
FROM emp
WHERE deptno In (10, 20);  --emp 테이블의 직원의 소속 부서가 10번"이거나" 20번인 직원 정보만 조회

-- 이거나 -> OR (또는) -두개중 하나만 만족해야함
-- 이고 -> AND (그리고) -두개 다 만족해야함

-- IN --> OR
-- BETWEEN AND --> AND + 산술비교

SELECT *
FROM emp
WHERE deptno = 10 OR deptno = 20;


SELECT *
FROM users;

--실습where3
SELECT userid 아이디, usernm 이름, ALIAS 별명
FROM users
WHERE userid In ('brown', 'cony', 'sally');

DESC users; --조회시 varchar2 = 문자열


-- LIKE 연산자 : 문자열 매칭 연산
-- % : 여러 문자(문자가 없을 수도 있다)
-- _ : 하나의 문자

--emp 테이블에서 사원이름(ename)이 S로 시작하는 사원 정보만 조회
SELECT *
FROM emp
WHERE ename LIKE 'S%';

--SMITH
--SCOTT
--첫글자는 s로 시작하고 4번째 글자는 T
--두번쨰, 세번째, 다섯번째 문자는 어떤 문자든 올 수 있다
SELECT *
FROM emp
WHERE ename LIKE 'S__T_'; -- 'STE', 'STTTTT', 'STESTS'


--실습 where4
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '신%';

SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '신__';

--실습where5
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '%이%';

--컬럼 값이 NULL인 데이터 찾기
--emp 테이블에 보면 MGR 컬럼이 NULL 데이터가 존재

SELECT *
FROM emp
WHERE MGR IS NULL; --NULL값 확인에는 IS NULL 연산자를 사용
WHERE MGR = NULL; --MGR 컬럼 값이 NULL인 사원 정보조회 (조회되지 않음)
WHERE MGR = 7698; --MGR 컬럼 값이 7698인 사원 정보조회

--실습where6
SELECT *
FROM emp
WHERE comm IS NOT NULL;

UPDATE emp SET comm = 0
WHERE empno=7844;

commit;

--AND : 조건을 동시에 만족
--OR : 조건을 한개만 충족하면 만족
--emp 테이블에서 mgr가 7698 사원번호이고(AND) 급여가 1000보다 큰 사람
SELECT *
FROM emp
WHERE MGR=7698
AND sal > 1000;

--emp 테이블에서 mgr가 7698 이거나(OR), 급여가 1000보다 큰 사람
SELECT *
FROM emp
WHERE mgr=7698
OR sal > 1000;

--emp테이블에서 관리자 사번이 7698, 7839가 아닌 직원 정보조회
SELECT *
FROM emp
WHERE mgr NOT IN (7698, 7839) --NULL 값은 안나옴
OR mgr IS NULL; --NULL값을 항상 고려할것

--실습where7
SELECT *
FROM emp
WHERE job = 'SALESMAN' --값은 대소문자를 가린다.
AND HIREDATE >= TO_DATE('19810601', 'YYYYMMDD');

--실습 where8
SELECT *
FROM emp
WHERE DEPTNO != 10 -- <>도 가능
AND HIREDATE > TO_DATE('19810601','YYYYMMDD'); --hiredate가 데이터기 때문에 문자열로 바꿔주는 TO_DATE

--실습 where9
SELECT *
FROM emp
WHERE DEPTNO NOT IN (10)
AND HIREDATE > TO_DATE('19810601', 'YYYYMMDD');

--where10
SELECT *
FROM emp
WHERE DEPTNO IN (20, 30)
AND HIREDATE > TO_DATE('19810601', 'YYYYMMDD');

--where11
SELECT *
FROM emp
WHERE job IN 'SALESMAN'
OR HIREDATE > TO_DATE('19810601', 'YYYYMMDD');

--where12
SELECT *
FROM emp
WHERE job = 'SALESMAN' --''를 사용하지 않으면 컬럼으로 해석한다
OR EMPNO LIKE '78%'; --LIKE ''

--where13(LIKE 사용하지 않고)
--BETWEEN 7800 AND 7899 를 사용하려면 EMPNO가 숫자여야된다 (DESC emp, empno NUMBER)
SELECT *
FROM emp
WHERE job IN 'SALESMAN'
OR EMPNO BETWEEN 7800 AND 7899;


--연산자 우선순위 (AND > OR)
--직원 이름이 SMITH 이거나, 직원이름이 ALLEN이면서 역할이 SALESMAN인 직원
SELECT *
FROM emp
WHERE ename 'SMITH'
OR (ename 'ALLEN' AND job = 'SALESMAN');

--직원 이름이 SMITH 이거나 ALLEN 이면서 역할이 SALESMAN인 사람
SELECT *
FROM emp
WHERE (ename = 'SMITH' OR ename = 'ALLEN')
AND job = 'SALESMAN';




--where14 (아래 두 쿼리가 다른 결과를 낸다)
SELECT *
FROM emp
WHERE job = 'SALESMAN'
OR EMPNO BETWEEN 7800 AND 7899
AND HIREDATE > TO_DATE ('19810601', 'YYYYMMDD');

SELECT *
FROM emp
WHERE (job = 'SALESMAN' OR EMPNO BETWEEN 7800 AND 7899)
AND HIREDATE > TO_DATE ('19810601', 'YYYYMMDD');


--오름차순 : 1, 2, 3, 5, 10
--내림차순 : 10, 5, 3, 2, 1

--오름차순 : ASC (표기를 안할 경우 기본값)
--내림차순 : DESC (내림차순시 반드시 표기)

/*
    SELECT col1, col2, .....
    FROM 테이블명
    WHERE col1 = '값'
    ORDER BY 정렬기준컬럼1 [ASC / DESC], 정렬기준컬럼2... [ASC / DESC]
*/


--사원(emp) 테이블에서 직원의 정보를 직원 이름으로 오름차순 정렬
SELECT *
FROM emp
ORDER BY ename;

SELECT *
FROM emp
ORDER BY ename ASC; --정렬기준을 따로 작성하지 않아도 오름차순 적용

--사원(emp) 테이블에서 직원의 정보를 직원 이름(ename)으로 내림차순 정렬
SELECT *
FROM emp
ORDER BY ename DESC; --DESC : 사용되는 위치에 따라 다르게 적용됨

--사원(emp) 테이블에서 직원의 정보를 부서번호로 오름차순 정렬하고
--부서번호가 같을 때는 sal 내림차순 정렬
--급여(sal)가 같을때는 이름으로 오름차순(ASC) 정렬한다.

SELECT *
FROM emp
ORDER BY deptno, sal DESC, ename;

--정렬 컬럼을 ALIAS로 표현
SELECT deptno, sal, ename nm
FROM emp
ORDER BY nm;

--조회하는 컬럼의 위치 인덱스로 표현 가능
SELECT deptno, sal, ename nm
FROM emp
ORDER BY 3; --추천하지는 않음(SELECT에 컬럼 추가시 의도하지 않은 결과가 나올 수 있음)


--orderby1
--dept테이블의 모든 정보를 부서이름으로 오름차순정렬
SELECT *
FROM dept
ORDER BY DNAME;

--dept테이블의 모든 정보를 부서위치로 내림차순
SELECT *
FROM dept
ORDER BY LOC DESC;

--orderby2
--emp 테이블에서 상여정보가 있는 사람들만 조회
--상여를 많이 받는 사람이 먼저 조회되도록 (내림차순, DESC)
--상여가 같을 경우 사번으로 오름차순 (ASC)
SELECT *
FROM emp
WHERE COMM IS NOT NULL
ORDER BY COMM DESC, empno;

--orderby3
--emp 테이블에서 관리자가 있는 직원만 조회하고 MGR NULL이 아닌 데이터
--직군(job)순으로 오름차순 정렬
--직군이 같을 경우 사원번호가 큰사람이 먼저 조회 되도록 (사원번호 내림차순 DESC)
SELECT *
FROM emp
WHERE mgr IS NOT NULL
ORDER BY job, empno DESC;

--orderby4
SELECT *
FROM emp
WHERE deptno IN (10, 30) -- (deptno = 10 OR deptno = 30)도 가능
AND sal > 1500
ORDER BY ename DESC;

--ROWNUM
SELECT ROWNUM, empno,  ename
FROM emp;

SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM = 1;  --ROWNUM =(equal) 비교는 1만 가능

SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM <= 2; -- <= (<) ROWNUM을 1부터 순차적으로 조회하는 경우는 가능

SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM BETWEEN 1 AND 20; --1부터 시작하는 경우 가능

--SELECT 절과 ORDER BY 구문의 실행순서
--SELECT -> ROWNUM -> ORDER BY (순으로 하면 ROWNUM 기능 없어짐)
SELECT ROWNUM, empno, ename
FROM emp
ORDER BY ename;

--INLINE VIEW (FROM (INLINE VIEW)) 를 통해 정렬 먼저 실행하고, 해당 결과에 ROWNUM을 적용
SELECT ROWNUM, a.* --*표현하고, 다른 컬럼|표현식을 썼을 경우 *앞에 테이블명이나, 테이블 별칭을 적용
FROM (SELECT empno, ename
      FROM emp
      ORDER BY ename) a;

SELECT emp.* --가능
FROM emp e;

SELECT e.* --가능
FROM emp e;

--row_1
SELECT ROWNUM RN, empno, ename
FROM emp
WHERE ROWNUM BETWEEN 1 AND 10;


--row_2 (ROWNUM이 11-14인 데이터
SELECT a.*
FROM (SELECT ROWNUM RN, empno, ename
      FROM emp) a
WHERE rn BETWEEN 11 AND 20;

--row_3
--emp테이블에서 사원정보를 이름컬럼으로 오름차순 적용 했을 때의 11~14번째 행을 다음과 같이 조회하는 쿼리를 작성.
SELECT a.*
FROM (SELECT ROWNUM RN, empno, ename
      FROM (SELECT empno, ename
            FROM emp
			ORDER BY ename)) a
WHERE RN BETWEEN 11 AND 14;
