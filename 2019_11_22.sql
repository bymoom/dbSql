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
--emp테이블에서 ename컬럼 기준으로 오름차순 정렬 했을때 11-14번째 행의 데이터만 조회하는 sql을 작성하세요
SELECT RN, empno, ename
FROM (SELECT ROWNUM RN, a.*
      FROM (SELECT empno, ename
            FROM emp
			ORDER BY ename) a)
WHERE RN BETWEEN 11 AND 14;


--DUAL 테이블 : sys 계정에 있는 누구나 사용가능한 테이블이며 데이터는 한행만 존재하며 컬럼(dummy)도 하나 존재

SELECT *
FROM dual;

--SINGLE ROW FUNCTION : 행당 한번의 FUNCTION이 실행
--1개의 행이 INPUT -> 1개의 행으로 OUTPUT (COLUMN)
--'Hello, World'
--dual 테이블에는 데이터가 하나의 행만 존재한다. 결과도 하나의 행으로 나온다
SELECT LOWER('Hello, World'), UPPER('Hello, World')
    INITCAP('Hello, World')
FROM dual;

--emp테이블에는 총 14건의 데이터(직원)가 존재 (14개의 행)
--아래쿼리는 결과도 14개의 행
SELECT emp.*, LOWER ('Hello, World'), UPPER ('Hello, World'),
        INITCAP ('Hello, World')
FROM emp;

--컬럼에 function 적용
SELECT empno, LOWER(ename) low_enm
FROM emp
WHERE ename = 'SMITH' ; --직원 이름이 smith인 사람을 조회 하려면 대문자/소문자? -> WHERE 절에서는 테이블에 써져있는대로 써야함

SELECT empno, LOWER(ename) low_enm
FROM emp
WHERE ename = UPPER ('smith') ; --직원 이름이 smith인 사람을 조회 하려면 대문자/소문자?

--테이블 컬럼을 가공해도 동일한 결과를 얻을 수 있지만 테이블 컬럼보다는 상수쪽을 가공하는 것이 속도면에서 유리
--해당 컬럼에 인덱스가 존재하더라도 함수를 적용하게되면 값이 달라지게 되어 인덱스를 활용할 수 없게 된다
--예외 : FBI(Function Based Index)
SELECT empno, LOWER(ename) low_enm
FROM emp
WHERE LOWER (ename) = 'smith' ; --올바른 형태가 아니다.

--HELLO
--,
--WORLD
--HELLO, WORLD (위 3가지 문자열 상수를 이용, CONCAT 함수를 사용하여 문자열 결합)

SELECT CONCAT (CONCAT ('HELLO', ', '), 'WORLD') c1,
        'HELLO' || ', ' || 'WORLD' c2,
        --시작인덱스는 1부터, 종료인덱스 문자열까지 포함한다
        SUBSTR ('HELLO, WORLD', 1, 5) s1, --SUBSTR(문자열, 시작인덱스, 종료인덱스) //자바에서는 0부터 5

        --INSTR :문자열에 특정 문자열이 존재하는지, 존재할 경우 문자의 인덱스를 리턴
        INSTR('HELLO, WORLD', 'O') i1, --5, 9
        --'HELLO, WORLD' 문자열의 6번째 인덱스 이후에 등장하는 'O'문자열의 인덱스 리턴
        INSTR('HELLO, WORLD', 'O', 6) i2, --문자열의 특정 인덱스 이후부터 검색하도록 옵션 값
        
        INSTR('HELLO, WORLD', 'O', INSTR('HELLO, WORLD', 'O') +1) i3,
        
        --L/RPAD 특정 문자열의 왼쪽/오른쪽에 설정한 문자열 길이보다 부족한만큼 문자열을 채워 넣는다
        LPAD ('HELLO, WORLD', 15, '*') L1,
        LPAD ('HELLO, WORLD', 15) L2, --DEFAULT 채움 문자는 공백이다
        RPAD ('HELLO, WORLD', 15, '*') R1,
        
        --REPLACE (대상문자열, 검색문자열, 변경할 문자열)
        --대상문자열에서 검색 문자열을 변경할 문자열로 치환
        REPLACE ('HELLO, WORLD', 'HELLO', 'hello') rep1, --hello, WORLD
        
        --문자열 앞, 뒤의 공백을 제거
        '  HELLO, WORLD   ' before_trim,
        TRIM ('   HELLO, WORLD   ') after_trim,
        TRIM ('H' FROM 'HELLO, WORLD') after_trim2 
FROM dual;


--숫자 조작함수
--ROUND : 반올림 - ROUND(숫자, 반올림 자리)
--TRUNC : 절삭 - TRUNC(숫자, 절삭 자리)
--MOD : 나머지 연산 MOD(피제수, 제수) //자바에서는 %//MOD (5,2) : 1

SELECT ROUND (105.54, 1) r1, --반올림결과가 소수점 한자리까지 나오도록(소수점 둘째자리에서 반올림)
        ROUND (105.55, 1) r2,
        ROUND (105.55, 0) r3, --소수점 첫번쨰 자리에서 반올림
        ROUND (105.55, -1) r4 --정수 첫번쨰 자리에서 반올림
FROM dual;

SELECT TRUNC (105.54, 1) r1, --절삭 결과가 소수점 한자리까지 나오도록(소수점 둘째자리에서 절삭)
        TRUNC (105.55, 1) r2,
        TRUNC (105.55, 0) r3, --소수점 첫번쨰 자리에서 절삭
        TRUNC (105.55, -1) r4 --정수 첫번쨰 자리에서 절삭
FROM dual;

--MOD(피제수, 제수) 피제수를 제수로 나눈 나머지 값
--MOD(M, 2)의 결과 종류 : 0, 1 ( 0 ~ 제수 -1)
SELECT MOD(5,2) M1 --5/2 : 몫이 2, [나머지가 1]
FROM dual;

--emp 테이블의 sal 컬럼을 1000으로 나눴을때 사원별 나머지 값을 조회 하는 sql 작성
--ename, sal, sal/1000일 떄의 몫, sal/1000일 떄의 나머지

SELECT ename, sal, TRUNC (sal/1000), MOD (sal, 1000),
       TRUNC (sal/1000) * 1000 + MOD (sal, 1000) sal2
FROM emp;

--DATE : 년월일, 시간, 분, 초
SELECT ename, hiredate, TO_CHAR (hiredate, 'YYYY/MM/DD hh24:mi:ss')  --YYYY/MM/DD //도구->환경설정에서 데이터베이스->NLS에서 날짜형식 수정가능(년도 두글자는 RR)
FROM emp;

--SYSDATE : 서버의 현재 DATE를 리턴하는 내장함수, 특별한 인자가 없다
SELECT SYSDATE
FROM dual;

SELECT TO_CHAR (SYSDATE, 'YYYY-MM-DD hh24:mi:ss')
FROM dual;

--DATE 연산 DATE + 정수N = N일자만큼 더한다
--DATE 연산에 있어서 정수는 일자
--하루는 24시간
--DATE 타입에 시간을 더할 수도 있다 1시간 = 1/24
SELECT TO_CHAR (SYSDATE + 5, 'YYYY-MM-DD hh24:mi:ss') AFTERS_DAYS,
       TO_CHAR (SYSDATE + 5/24, 'YYYY-MM-DD hh24:mi:ss') AFTERS_HOURS,
       TO_CHAR (SYSDATE + 5/24/60, 'YYYY-MM-DD hh24:mi:ss') AFTERS_MIN
FROM dual;

SELECT TO_DATE('20191231', 'YYYYMMDD') LASTDAY,
        TO_DATE('20191231', 'YYYYMMDD') -5 LASTDAY_BEFORES,
        SYSDATE NOW,
        SYSDATE -3 NOW_BEFORE3
FROM dual;

--YYYY, MM, DD, D(요일을 숫자로:일요일1, 월요일2, 화요일3...토요일7)
--IW(주차 1-53), HH, MI, SS
SELECT TO_CHAR (SYSDATE, 'YYYY') YYYY --현재 년도
        ,TO_CHAR (SYSDATE, 'MM') MM --현재월
        ,TO_CHAR (SYSDATE, 'DD') DD --현재일
        ,TO_CHAR (SYSDATE, 'D') D --현재 요일(주간일자1~7)
        ,TO_CHAR (SYSDATE, 'IW') IW --현재 일자의 주차(해당주의 목요일을 주차의 기준으로)
        --2019년 12월 31일은 몇주차가 나오는가?
        ,TO_CHAR(TO_DATE ('20191231', 'YYYYMMDD'), 'IW') IW_20191231
FROM dual;

--fn2
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD') DT_DASH,
        TO_CHAR(SYSDATE, 'YYYY-MM-DD hh24:mi:ss') DT_DASH_WIDTH_TIME,
        TO_CHAR(SYSDATE, 'DD-MM-YYYY') DT_DD_MM_YYYY
FROM dual;


--DATE 타입의 ROUND, TRUNC 적용
SELECT TO_CHAR (SYSDATE, 'YYYY-MM-DD hh24:mi:ss') now,
    --MM에서 반올림 (11월->1년)
        TO_CHAR (ROUND(SYSDATE, 'YYYY'), 'YYYY-MM-DD hh24:mi:ss') now_YYYY,
        --DD에서 반올림 (25일 -> 1개월)
        TO_CHAR (ROUND(SYSDATE, 'MM'), 'YYYY-MM-DD hh24:mi:ss') now_DD,
        --시간에서 반올림
        TO_CHAR (ROUND(SYSDATE, 'DD'), 'YYYY-MM-DD hh24:mi:ss') now_DD 
FROM dual;



SELECT TO_CHAR (SYSDATE, 'YYYY-MM-DD hh24:mi:ss') now,
    --MM에서 절삭 (11월->1월)
        TO_CHAR (TRUNC(SYSDATE, 'YYYY'), 'YYYY-MM-DD hh24:mi:ss') now_YYYY,
        --DD에서 절삭 (25일 ->1일)
        TO_CHAR (TRUNC(SYSDATE, 'MM'), 'YYYY-MM-DD hh24:mi:ss') now_DD,
        --시간에서 절삭 (현재시간 -> 0시)
        TO_CHAR (TRUNC(SYSDATE, 'DD'), 'YYYY-MM-DD hh24:mi:ss') now_DD 
FROM dual;

--날짜 조작 함수
--MONTH_BTWEEN(date1, date2) : date2와 date1 사이의 개월수
--ADD_MONTHS(date, 가감할 개월수) : date에서 특정 개월수를 더하거나 뺸 날짜
--NEXT_DAY(date, weekday(1-7)) : date이후 첫번째 weekday 날짜
--LAST_DAY(date) : date가 속한 월의 마지막 날짜



--MONTHS_BETWEEN (date1, date2)
SELECT MONTHS_BETWEEN (TO_DATE('2019-11-25', 'YYYY-MM-DD'),
                        TO_DATE('2019-03-25', 'YYYY-MM-DD')) m_bat,
                        TO_DATE('2019-11-25', 'YYYY-MM-DD') - TO_DATE('2019-03-25', 'YYYY-MM-DD') d_m --두 날짜 사이의 일자수
FROM dual;

--ADD_MONTHS(date, number(+,-)
SELECT ADD_MONTHS(TO_DATE ('20191125', 'YYYYMMDD'), 5) NOW_AFTER5M,
        ADD_MONTHS(TO_DATE ('20191125', 'YYYYMMDD'), -5) NOW_BEFORE5M,
        SYSDATE + 100 --100일 뒤의 날짜 (월 개념 3-31, 2-28/29
FROM dual;

--NEXT_DAY(date, weekday number(1-7))
SELECT NEXT_DAY(SYSDATE, 7) --오늘 날짜(2019/11/25)일 이후 등장하는 첫번쨰 토요일
FROM dual;