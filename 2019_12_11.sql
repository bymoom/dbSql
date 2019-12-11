--INDEX�� ��ȸ�Ͽ� ������� �䱸���׿� �����ϴ� �����͸� ���� �� �ִ� ���
SELECT *
FROM emp;

--emp���̺��� ��� �÷��� ��ȸ
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





--emp���̺��� empno �÷��� ��ȸ
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
   
   

--���� �ε��� ����(pk_emp �������� ����) --> unique ���� ���� --> pk_emp �ε��� ����
ALTER TABLE emp DROP CONSTRAINT pk_emp;

--index ���� (�÷��ߺ� ����)
--unique index : �ε��� �÷��� ���� �ߺ��� �� ���� �ε���(emp.empno, dept.deptno)
--non-unique index(default) : �ε��� �÷��� ���� �ߺ��� �� �ִ� �ε���(emp.job)

--CREATE UNIQUE INDEX idx_n_emp_01 ON emp (empno); --empno ������ �ߺ�����
--���� ��Ȳ�̶� �޶��� ���� EMPNO �÷����� ������ �ε����� UNIQUE -> NON-UNIQUE �ε����� �����
CREATE INDEX idx_n_emp_01 ON emp (empno); --empno ������ �ߺ�(���������̶� ������� �ε����� ����)

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
   
--INDEX RANGE SCAN -> ���� �����͵� 7782�� �ƴ��� �о��

--empno 7782 �ϳ� �� �߰� �� ��ȸ�غ�
--(�����ȹ�� ���� �����ϰ� ����=rows�� ��ȭ�� ����. �ŷڼ�����. -> operation�� name�� �����ϸ��) 
INSERT INTO emp (empno, ename) VALUES (7782, 'brown');
COMMIT;


--emp ���̺��� job �÷����� non-unique �ε��� ����
--�ε����� : idx_n_emp_02
CREATE INDEX idx_n_emp_02 ON emp (job);

SELECT job, rowid
FROM emp
ORDER BY job;

--emp ���̺����� �ε����� 2�� ����
--1. empno
--2. job
-- (+ ��ü���̺�)

SELECT *
FROM emp
WHERE sal > 500; --�ش� �ε����� ���⶧���� ��ü���̺��� �д´�


SELECT *
FROM emp
WHERE job = 'MANAGER';

--IDX_02 �ε���
--�����ȹ����
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
--emp ���̺��� job, enmae �÷����� non-unique �ε��� ����(�÷��� �Է� ���� �߿���)
CREATE INDEX idx_n_emp_03 ON emp (job, ename);
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%'; --�ѹ��� manager�� clerk�� ã��

--idx_n_emp_04
--ename, job �÷����� emp ���̺��� non-unique �ε��� ����
CREATE INDEX idx_n_emp_04 ON emp (ename, job);

SELECT ename, job, rowid
FROM emp
ORDER BY ename, job;

--�Ʒ� ���� ��쿡�� JOB�� ���� �д°� ȿ�����̹Ƿ� 3�� �ε���idx_n_emp_03)�� ����Ѵ�
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'J%';

SELECT *
FROM TABLE(dbms_xplan.display);

--JOIN ���������� �ε���
--emp ���̺��� empno �÷����� PRIMARY KEY ���������� ����
--dept ���̺��� deptno �÷����� PRIMARY KEY ���������� ����
--emp ���̺��� primary key ������ ������ �����̹Ƿ� �����
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
 --�д� ���� : 4 3 5 2 6 1 0
 --NESTED : for(�ݺ�)��
 
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
WHERE 1 = 1; --�̰� �� �ִ���?

--idx1
CREATE UNIQUE INDEX idx_u_dept_test_01 ON dept_test (deptno);

CREATE INDEX idx_u_dept_test_02 ON dept_test (dname);

CREATE INDEX idx_u_dept_test_03 ON dept_test (deptno, dname);

--idx2
DROP INDEX idx_u_dept_test_01;
DROP INDEX idx_u_dept_test_02;
DROP INDEX idx_u_dept_test_03;
