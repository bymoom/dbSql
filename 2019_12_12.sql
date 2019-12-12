--별칭 : 테이블, 컬럼을 다른 이름으로 지칭
--[AS] 별칭명
--SELECT empno [AS] eno
--FROM emp e

--SYNONYM(동의어) : 다른 사람의 테이블의 조회할 수 있는 권한을 받았을때 사용(원래 br(해당 계정명).employees 로 조회해야하는데 이걸 시노님써서 간단하게 사용한다)
--오라클 객체를 다른 이름으로 부를 수 있도록 하는 것
--만약에 emp 테이블을 e라고 하는 synonym(동의어)로 생성을 하면 다음과 같은 sql을 작성할 수 있다
-- SELECT *
-- FROM e; --이렇게 조회할 수 있다

--br계정에 synonym 생성 권한을 부여(하고 꼭 시스템 계정 접속해제해야함)
GRANT CREATE SYNONYM TO BR;

--emp 테이블을 사용하여 synonym e를 생성
--CREATE SYNONYM 시노님 이름 FOR 오라클객체;
CREATE SYNONYM e FOR emp;

--emp라는 테이블 명 대신에 e 라고 하는 시노님을 사용하여 쿼리를 작성할 수 있다
SELECT *
FROM e; --emp로 써도 됨

--br계정의 fastfood 테이블을 hr 계정에서도 볼 수 있도록 테이블 조회 권한을 부여
GRANT SELECT ON fastfood TO HR;

--접속이름과 사용자이름은 다르다. SYSTEM 계정에서 아래 쿼리 조회시 나오는게 계정(=사용자 이름).
SELECT *
FROM DBA_USERS;

--DML : SELECT / INSERT / UPDATE / DELETE / INSERT ALL / MERGE
--TCL : COMMIT / ROLLBACK / [SAVEPOINT]
--DDL : CREATE (객체) / ALTER / DROP
--DBL : GRANT / REVOKE

SELECT *
FROM DICTIONARY;

--동일한 SQL의 개념에 따르면 아래 SQL들은 다르다
SELECT /* 201911_205 */ * FROM emp;
SELECT /* 201911_205 */ * FROM EMP;
SELECt /* 201911_205 */ * FROM EMP;

--이렇게 조회하면 실행계획에 하나씩 다 저장된다
SELECt /* 201911_205 */ * FROM EMP WHERE empno = 7369;
SELECt /* 201911_205 */ * FROM EMP WHERE empno = 7499;
--그래서 바인드변수를 사용한다
SELECt /* 201911_205 */ * FROM EMP WHERE empno = :empno;
--저장된 실행계획을 확인하는 방법(SYSTEM 계정에서 실행)
--SELECT *
--FROM V$SQL
--WHERE SQL_TEXT LIKE '%201911_205%';

--multiple insert
SELECT *
FROM emp_test;
DROP TABLE emp_test;

--emp 테이블의 empno, ename 컬럼으로 emp_test, emp_test2 테이블을 생성
--생성(CTAS, 데이터도 같이 복사)
CREATE TABLE emp_test AS
SELECT empno, ename
FROM emp;

CREATE TABLE emp_test2 AS
SELECT empno, ename
FROM emp;

SELECT *
FROM emp_test;
SELECT *
FROM emp_test2;

--unconditional insert : 여러 테이블에 데이터를 동시 입력
--BROWN, CONY 데이터를 EMP_TEST, EMP_TEST2 테이블에 동시 입력
INSERT ALL
    INTO emp_test
    INTO emp_test2
SELECT 9999, 'brown' FROM DUAL UNION ALL
SELECT 9998, 'cony' FROM DUAL;

SELECT *
FROM emp_test
WHERE empno > 9000

UNION ALL

SELECT *
FROM emp_test2
WHERE empno > 9000;

--테이블 별 입력되는 데이터의 컬럼을 제어 가능
ROLLBACK;

INSERT ALL
    INTO emp_test (empno, ename) VALUES(eno, enm)
    INTO emp_test2 (empno) VALUES (eno)
SELECT 9999 eno, 'brown' enm FROM DUAL UNION ALL
SELECT 9998, 'cony' FROM DUAL;

ROLLBACK;

--CONDITIONAL INSERT
--조건에 따라 테이블에 데이터를 입력
/*
    CASE
        WHEN 조건 THEN -----
        WHEN 조건 THEN -----
        ELSE ------
*/
INSERT ALL
    WHEN eno > 9000 THEN
        INTO emp_test (empno, ename) VALUES (eno, enm)
        WHEN eno > 9500 THEN --이것도 등록된다
        INTO emp_test (empno, ename) VALUES (eno, enm)
    ELSE
        INTO emp_test2 (empno) VALUES (eno)
SELECT 9999 eno, 'brown' enm FROM DUAL UNION ALL
SELECT 8998, 'cony' FROM DUAL;

ROLLBACK;

INSERT FIRST
    WHEN eno > 9000 THEN --만족하는 첫번째 조건만 등록된다
        INTO emp_test (empno, ename) VALUES (eno, enm)
        WHEN eno > 9500 THEN --이것도 저장한다
        INTO emp_test (empno, ename) VALUES (eno, enm)
    ELSE
        INTO emp_test2 (empno) VALUES (eno)
SELECT 9999 eno, 'brown' enm FROM DUAL UNION ALL
SELECT 8998, 'cony' FROM DUAL;
