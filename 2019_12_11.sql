--INDEX만 조회하여 사용자의 요구사항에 만족하는 데이터를 만들어낼 수 있는 경우
SELECT *
FROM emp;

--emp테이블의 모든 컬럼을 조회
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(dbms_xplan.display);

Plan hash value: 2949544139
 
--------------------------------------------------------------------------------------
| Id  | Operation                   | Name   | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |        |     1 |    38 |     1   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP    |     1 |    38 |     1   (0)| 00:00:01 |
|*  2 |   INDEX UNIQUE SCAN         | PK_EMP |     1 |       |     0   (0)| 00:00:01 |
--------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("EMPNO"=7782)





--emp테이블의 empno 컬럼을 조회
EXPLAIN PLAN FOR
SELECT empno
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(dbms_xplan.display);

Plan hash value: 56244932
 
----------------------------------------------------------------------------
| Id  | Operation         | Name   | Rows  | Bytes | Cost (%CPU)| Time     |
----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |        |     1 |     4 |     0   (0)| 00:00:01 |
|*  1 |  INDEX UNIQUE SCAN| PK_EMP |     1 |     4 |     0   (0)| 00:00:01 |
----------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - access("EMPNO"=7782)
   
   

--기존 인덱스 제거(pk_emp 제약조건 삭제) --> unique 제약 삭제 --> pk_emp 인덱스 삭제
ALTER TABLE emp DROP CONSTRAINT pk_emp;

--index 종류 (컬럼중복 여부)
--unique index : 인덱스 컬럼의 값이 중복될 수 없는 인덱스(emp.empno, dept.deptno)
--non-unique index(default) : 인덱스 컬럼의 값이 중복될 수 있는 인덱스(emp.job)

--CREATE UNIQUE INDEX idx_n_emp_01 ON emp (empno); --empno 데이터 중복안함
--위쪽 상황이랑 달라진 것은 EMPNO 컬럼으로 생성된 인덱스가 UNIQUE -> NON-UNIQUE 인덱스로 변경됨
CREATE INDEX idx_n_emp_01 ON emp (empno); --empno 데이터 중복(제약조건이랑 관계없이 인덱스만 생성)

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(dbms_xplan.display);


Plan hash value: 2778386618
 
--------------------------------------------------------------------------------------------
| Id  | Operation                   | Name         | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |              |     1 |    38 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP          |     1 |    38 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_N_EMP_01 |     1 |       |     1   (0)| 00:00:01 |
--------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("EMPNO"=7782)
   
--INDEX RANGE SCAN -> 다음 데이터도 7782가 아닌지 읽어본다

--empno 7782 하나 더 추가 후 조회해봄
--(실행계획은 위와 동일하게 나옴=rows에 변화가 없다. 신뢰성없음. -> operation과 name만 참고하면됨) 
INSERT INTO emp (empno, ename) VALUES (7782, 'brown');
COMMIT;


--emp 테이블에 job 컬럼으로 non-unique 인덱스 생성
--인덱스명 : idx_n_emp_02
CREATE INDEX idx_n_emp_02 ON emp (job);

SELECT job, rowid
FROM emp
ORDER BY job;

--emp 테이블에는 인덱스가 2개 존재
--1. empno
--2. job
-- (+ 전체테이블)

SELECT *
FROM emp
WHERE sal > 500; --해당 인덱스가 없기때문에 전체테이블을 읽는다


SELECT *
FROM emp
WHERE job = 'MANAGER';

--IDX_02 인덱스
--실행계획보면
--   1 - filter("ENAME" LIKE 'C%')
--   2 - access("JOB"='MANAGER')
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%';

SELECT *
FROM TABLE(dbms_xplan.display);


--idx_n_emp_03
--emp 테이블의 job, enmae 컬럼으로 non-unique 인덱스 생성(컬럼명 입력 순서 중요함)
CREATE INDEX idx_n_emp_03 ON emp (job, ename);
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%'; --한번에 manager와 clerk을 찾음

--idx_n_emp_04
--ename, job 컬럼으로 emp 테이블에 non-unique 인덱스 생성
CREATE INDEX idx_n_emp_04 ON emp (ename, job);

SELECT ename, job, rowid
FROM emp
ORDER BY ename, job;

--아래 쿼리 경우에는 JOB을 먼저 읽는게 효율적이므로 3번 인덱스idx_n_emp_03)를 사용한다
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'J%';

SELECT *
FROM TABLE(dbms_xplan.display);

--JOIN 쿼리에서의 인덱스
--emp 테이블은 empno 컬럼으로 PRIMARY KEY 제약조건이 존재
--dept 테이블은 deptno 컬럼으로 PRIMARY KEY 제약조건이 존재
--emp 테이블은 primary key 제약을 삭제한 상태이므로 재생성
DELETE emp
WHERE ename = 'brown';
COMMIT;

ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);

EXPLAIN PLAN FOR
SELECT ename, dname, loc
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND emp.empno = 7788;

SELECT *
FROM TABLE(dbms_xplan.display);

Plan hash value: 3070176698
 
----------------------------------------------------------------------------------------------
| Id  | Operation                     | Name         | Rows  | Bytes | Cost (%CPU)| Time     |
----------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT              |              |     1 |    34 |     2   (0)| 00:00:01 |
|   1 |  NESTED LOOPS                 |              |       |       |            |          |
|   2 |   NESTED LOOPS                |              |     1 |    34 |     2   (0)| 00:00:01 |
|   3 |    TABLE ACCESS BY INDEX ROWID| EMP          |     1 |    13 |     1   (0)| 00:00:01 |
|*  4 |     INDEX RANGE SCAN          | IDX_N_EMP_01 |     1 |       |     0   (0)| 00:00:01 |
|*  5 |    INDEX UNIQUE SCAN          | PK_DEPT      |     1 |       |     0   (0)| 00:00:01 |
|   6 |   TABLE ACCESS BY INDEX ROWID | DEPT         |     5 |   105 |     1   (0)| 00:00:01 |
----------------------------------------------------------------------------------------------
 --읽는 순서 : 4 3 5 2 6 1 0
 --NESTED : for(반복)문
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   4 - access("EMP"."EMPNO"=7788)
   5 - access("EMP"."DEPTNO"="DEPT"."DEPTNO")
   
   
   
SELECT *
FROM dept_test;

DROP TABLE dept_test;

CREATE TABLE dept_test AS
SELECT *
FROM dept
WHERE 1 = 1; --이거 왜 넣더라?

--idx1
CREATE UNIQUE INDEX idx_u_dept_test_01 ON dept_test (deptno);

CREATE INDEX idx_u_dept_test_02 ON dept_test (dname);

CREATE INDEX idx_u_dept_test_03 ON dept_test (deptno, dname);

--idx2
DROP INDEX idx_u_dept_test_01;
DROP INDEX idx_u_dept_test_02;
DROP INDEX idx_u_dept_test_03;

