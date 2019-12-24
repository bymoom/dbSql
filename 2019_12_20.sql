--hash join (전체 처리 속도가 빠르다)
SELECT *
FROM dept, emp --사이즈가 작은 테이블을 먼저 읽게 한다
WHERE dept.deptno = emp.deptno;
--dept 먼저 읽는 형태
--join 컬럼을 hash 함수로 돌려서 해쉬 함수에 해당하는 bucket에 데이터를 넣는다
-- 10 --> aaabbaa (해쉬값)

--emp 테이블에 대해 위의 진행을 동일하게 진행
-- 10 --> aaabbaa (해쉬값)

--WHERE절에 범위조건을 넣은 경우 HASH JOIN이 일어나지 않을 경우가 크다
SELECT *
FROM dept, emp
WHERE emp.deptno BETWEEN dept.deptno AND 99;
10 ---> AAAAA
20 ---> AAAAB -> 이렇게 순차적으로 해쉬값이 나올거란 보장이 없음


--Sort Merge Join은 정렬을 다 해야 결과값을 낼 수 있기 때문에 전체 범위를 처리한다
--전체 범위 처리(테이블의 전체 데이터를 다 읽어야한다)
SELECT COUNT(*)
FROM emp;


--window 함수
-- 사원번호, 사원이름, 부서번호, 급여, 부서원의 전체 급여합
SELECT empno, ename, deptno, sal,
        SUM(sal) OVER () c_sum --() -> 전체 합이기때문에 파티션이나 오더바이를 따로 안한다
FROM emp;

SELECT empno, ename, deptno, sal,
        SUM(sal) OVER (ORDER BY sal ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) c_sum, --가장 처음부터 현재행까지
        --ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        --UNBOUNDED PRECEDING = 현재행을 포함한 모든 이전행(을 의미하기 때문에 between이랑 and current row안 써도 무관함)
        -->현재 행을 포함한 모든 이전행의 로우들
        
        --바로 이전 행이랑 현재행까지의 급여함
        SUM(sal) OVER (ORDER BY sal ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) c_sum1
FROM emp
ORDER BY sal;


--실습 ana7
SELECT empno, ename, deptno, sal,
        SUM(sal) OVER (PARTITION BY deptno ORDER BY sal, empno
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) c_sum
FROM emp;

--ROWS vs RANGE 차이 확인하기
SELECT empno, ename, deptno, sal,
        SUM(sal) OVER (ORDER BY sal ROWS UNBOUNDED PRECEDING) row_sum, --4번까지 합해서 4100
        SUM(sal) OVER (ORDER BY sal RANGE UNBOUNDED PRECEDING) range_sum, --5번까지 합해서 5350
        --range는 같은 값을 가진 데이터까지(후행하는 데이터인데도 불구하고) 합해버린다
        SUM(sal) OVER (ORDER BY sal) c_sum
        --windowing을 적용하지 않았을 땐 오라클에서 RANGE UNBOUNDED PRECEDING를 기본값으로 넣어준다
FROM emp;


--PL/SQL
--PL/SQL 기본구조
--DECLARE : 선언부, 변수를 선언하는 부분
--BEGIN : PL/SQL의 로직이 들어가는 부분
--EXCEPTION : 예외처리부

SET SERVEROUTPUT ON; --DBMS_OUTPUT.PUT_LINE 함수가 출력하는 결과를 화면에 보여주도록 활성화
-- ↓↓↓ 이름이 없는 block(재사용이 불가)
DECLARE --선언부
    --JAVA 선언법 : 타입 변수명;
    --PL/SQL 선언법 : 변수명 타입;
    /*v_dname VARCHAR2(14);
    v_loc VARCHAR2(13);*/
    
    --테이블 컬럼의 정의를 참조하여 데이터 타입을 선언한다
    v_dname dept.dname%TYPE;
    v_loc dept.loc%TYPE;
BEGIN
    --dept 테이블에서 10번 부서의 부서이름, loc 정보를 조회
    SELECT dname, loc
    INTO v_dname, v_loc --이 SELECT문의 내용을 변수에 넣는다
    FROM dept
    WHERE deptno = 10;
    --String a = "t";
    --String b = "c";
    --system.out.println(a + b); -> 자바의 문자열 결합 (+)
    DBMS_OUTPUT.PUT_LINE(v_dname || v_loc); --> 오라클의 문자열 결합 (||)
END;
/
--PL/SQL 블록을 실행 (/ 바로 옆에 주석붙이니까 오류남)

DESC dept; --선언하기 위해 타입 조회



--Procedure (이름이 있는 pl/sql block)
--10번 부서의 부서이름, 위치지역을 조회해서 변수에 담고 변수를 DBMS_OUTPUT.PUT_LINE함수를 이용하여 console에 출력
CREATE OR REPLACE PROCEDURE printdept
( p_deptno IN dept.deptno%TYPE ) --인자 선언(옵션) : 파라미터명 IN/OUT 타입 -> 인자와 변수를 구분하기 위해 'P_파라미터이름'
IS
--선언부(옵션) : (변수명) (참조할테이블.컬럼%TYPE)
    dname dept.dname%TYPE;
    loc dept.loc%TYPE;
--실행부
BEGIN
    SELECT dname, loc
    INTO dname, loc -- 변수에 담기
    FROM dept
    WHERE deptno = p_deptno; --10번이라고 지정하는 대신에 파라미터명 입력
    
    DBMS_OUTPUT.PUT_LINE(dname || '     ' || loc);
--예외처리부(옵션)
END;
/

-- EXEC printdept; -> 프로시저 실행 구문
EXEC printdept(30); -- (10) : 파라미터의 값을 리턴하기 위해 입력

--실습 pro_1
CREATE OR REPLACE PROCEDURE printemp
( p_empno IN emp.empno%TYPE )
IS ename emp.ename%TYPE;
   dname dept.dname%TYPE;
BEGIN
    SELECT ename, dname
    INTO ename, dname
    FROM emp, dept
    WHERE emp.deptno = dept.deptno AND empno = p_empno;
    
    DBMS_OUTPUT.PUT_LINE(ename || '     ' || dname);
END;
/

EXEC printemp(7369);


CREATE OR REPLACE PROCEDURE registdept_test
(p_deptno IN dept.deptno%TYPE, p_dname IN dept.dname%TYPE, p_loc IN dept.loc%TYPE)
IS deptno dept.deptno%TYPE;
    dname dept.dname%TYPE;
    loc dept.loc%TYPE;
BEGIN
    INSERT INTO dept_test (deptno, dname, loc) VALUES (p_deptno, p_dname, p_loc);
    COMMIT;
END;
/

EXEC registdept_test(99, 'ddit', 'daejeon');

SELECT *
FROM dept_test;