--EXCEPTION
--에러 발생시 프로그램을 종료시키지 않고 해당 예외에 대해 다른 로직을 실행 시킬 수 있게끔 처리한다

--예외가 발생했는데 예외처리가 없는 경우 : PL/SQL 블록이 에러와 함께 종료된다
--여러건의 SELECT 결과가 존재하는 상황에서 스칼라변수에 값을 넣는 상황

--EMP 테이블에서 사원 이름을 조회
SET SERVEROUTPUT ON;
DECLARE
    --사원 이름을 저장할 수 있는 변수(ROW 하나밖에 저장못함)
    v_ename emp.ename%TYPE;
BEGIN
    --14건의 select 결과가 나오는 sql --> 스칼라 변수에 저장이 불가하다(에러)
    SELECT ename
    INTO v_ename
    FROM emp;
    
EXCEPTION
--    WHEN TOO_MANY_ROWS THEN
--        DBMS_OUTPUT.PUT_LINE('여러건의 SELECT 결과가 존재');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('WHEN OTHERS');
END;
/


--사용자 정의 예외
--오라클에서 사전에 정의한 예외 이외에도 개발자가 해당 사이트에서 비지니스 로직으로 정의한 예외를 생성, 사용할 수 있다
--예를 들어 SELECT 결과가 없는 상황에서 오라클에서는 NO_DATA_FOUND 예외를 던지면
--해당 예외를 잡아 NO_EMP라는 개발자가 정의한 예외로 재정의 하여 예외를 던질 수 있다

--
DECLARE
    --emp 테아블 조회 결과가 없을때 사용할 사용자 정의 예외
    --예외명 EXCEPTION;
    no_emp EXCEPTION;
    v_ename emp.ename%TYPE;
BEGIN
    --NO_DATA_FOUND
    BEGIN
        SELECT ename
        INTO v_ename
        FROM emp
        WHERE empno = 7000;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE no_emp; --java throw new NoEmpException()
    END;
EXCEPTION
    WHEN no_emp THEN
        DBMS_OUTPUT.PUT_LINE('NO_EMP');
END;
/


--사번을 입력받아서 해당 직원의 이름을 리턴하는 함수
--getEmpName(7369) --> SMITH
CREATE OR REPLACE FUNCTION getEmpName (p_empno emp.empno%TYPE) --함수의 변수
RETURN VARCHAR2 IS --리턴 받을 타입
    --선언부
    v_ename emp.ename%TYPE;
BEGIN
    SELECT ename
    INTO v_ename
    FROM emp
    WHERE empno = p_empno;
    
    return v_ename;
END;
/

--함수 조회
SELECT getempname(7369)
FROM dual;

SELECT getempname(empno)
FROM emp;



--실습 function1
CREATE OR REPLACE FUNCTION getDeptName (p_deptno dept.deptno%TYPE)
RETURN VARCHAR2 IS
    v_dname dept.dname%TYPE;
BEGIN
    SELECT dname
    INTO v_dname
    FROM dept
    WHERE deptno = p_deptno;
    
    return v_dname;
END;
/
--함수에는 cache가 있다 : 디폴트 값이 20개
--데이터 분포도 :
--deptno (중복이 발생가능) : 분포도가 좋지 못하다
--empno(중복이 없다) : 분포도가 좋다
--emp 테이블의 데이터가 100만건인 경우 : 100만건 중에서 deptno 종류는 4건(10~40)
--함수는 분포도가 좋지 않을때 유리하다
--getdeptname(deptno) --4가지(함수가 유리)
--getempname(empno) --row수만큼 데이터가 존재 (cache가 소용이 없다 -> 이때는 조인이 유리)
SELECT getdeptname(20)
FROM dual;


--실습 function2
CREATE OR REPLACE FUNCTION indent (p_lv NUMBER, p_dname VARCHAR2)
RETURN VARCHAR2 IS
    v_dname VARCHAR2(200);
BEGIN
    SELECT LPAD(' ', (p_lv -1) *4, ' ') || p_dname
    INTO v_dname
    FROM dual;
--    v_dname := LPAD(' ', (p_lv - 1) * 4, ' ') || p_dname; ->select절 대신 이것도 가능

return v_dname;
END;
/

SELECT deptcd, indent(LEVEL, deptnm) deptnm
FROM dept_h
START WITH p_deptcd IS NULL
CONNECT BY PRIOR deptcd = p_deptcd;



--Trigger 생성(개발할때 도움됨)
--유지보수는 쿼리 두개 사용
--INSERT USERS_HISRTORY...
--UPDATE USERS...
SELECT *
FROM users;

--users테이블의 비밀번호 컬럼이 변경이 생겼을 때
--기존에 사용하던 비밀번호 컬럼 이력을 관리하기 위한 테이블
CREATE TABLE users_history(
    userid VARCHAR2(20),
    pass VARCHAR2(100),
    mod_dt DATE
);

CREATE OR REPLACE TRIGGER make_history
    --timing
    BEFORE UPDATE ON users
    FOR EACH ROW --행트리거, 행에 변경이 있을때마다 실행한다
    --현재 데이터 참조 : OLD (<- 키워드)
    --갱신 데이터 참조 : NEW
BEGIN
    --users 테이블의 pass 컬럼을 변경할때 trigger 실행
    IF :OLD.pass != :NEW.pass THEN
        INSERT INTO users_history
            VALUES (:OLD.userid, :OLD.pass, sysdate);
    END IF;
END;
/

--uawea 테이블의 pass 컬럼을 변경했을때
--trigger에 의해서 users_history 테이블에 이력이 생성되는지 확인
SELECT *
FROM users_history;
UPDATE USERS set pass = '1234'
WHERE userid = 'brown';


