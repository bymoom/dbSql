--�������� Ȱ��ȭ / ��Ȱ��ȭ
--ALTER TABLE ���̺��� ENABLE OR DISABLE CONSTRAINT �������Ǹ�;

--USER_CONSTRAINTS view�� ���� dept_test ���̺��� ������ �������� Ȯ��
SELECT *
FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'DEPT_TEST';

ALTER TABLE dept_test DISABLE CONSTRAINT SYS_C007137;

--dept_test ���̺��� deptno �÷��� ����� PRIMARY KEY ���������� ��Ȱ��ȭ �Ͽ�
--������ �μ���ȣ(99)�� ���� �����͸� �Է��� �� �ִ�
INSERT INTO dept_test VALUES (99, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES (99, 'DDIT', '����');

--dept_test ���̺��� PRIMARY KEY �������� Ȱ��ȭ
--�̹� ������ ������ �ΰ��� INSERT ������ ���� ���� �μ���ȣ�� ���� �����Ͱ�
--�����ϱ� ������ primary key ���������� Ȱ��ȭ�� �� ����
--Ȱ��ȭ�Ϸ��� �ߺ������͸� �����ؾ��Ѵ�
ALTER TABLE dept_test ENABLE CONSTRAINT SYS_C007137;

--�μ���ȣ�� �ߺ��Ǵ� �����͸� ��ȸ�Ͽ�
--�ش� �����Ϳ� ���� ������ PRIMARY KEY ���������� Ȱ��ȭ �� �� �ִ�
SELECT deptno, COUNT(*)
FROM dept_test
GROUP BY deptno
HAVING COUNT(*) >= 2; --ī��Ʈ ����(COUNT(*) >= 2)�� HAVING���� ����

--table_name, constraint_name, column_name
--position ���� (ASC)
SELECT *
FROM user_constraints
WHERE table_name = 'BUYER';

--���������� �ɸ� �÷��� ������ ���� ���
SELECT *
FROM user_cons_columns
WHERE table_name = 'BUYER';

--���̺��� ���� ����(�ּ�) VIEW
SELECT *
FROM USER_TAB_COMMENTS;

--���̺� �ּ�
--COMMENT ON TABLE ���̺��� IS '�ּ�';
COMMENT ON TABLE dept IS '�μ�';

--�÷��� ���� ����(�ּ�) VIEW
SELECT *
FROM USER_COL_COMMENTS
WHERE TABLE_NAME = 'DEPT';

--�÷� �ּ�
--COMMENT ON COLUMN ���̺���.�÷��� IS '�ּ�';
COMMENT ON COLUMN dept.deptno IS '�μ���ȣ';
COMMENT ON COLUMN dept.dname IS '�μ���';
COMMENT ON COLUMN dept.loc IS '�μ���ġ ����';


--comment1
SELECT t.table_name, t.table_type, t.comments tab_name, c.column_name, c.comments col_comment
FROM USER_TAB_COMMENTS t, USER_COL_COMMENTS c
WHERE t.table_name = c.table_name
AND t.TABLE_NAME IN ('CUSTOMER', 'CYCLE', 'DAILY', 'PRODUCT'); --�ҹ��ڷ� ���� ����


--VIEW : QUERY�̴� (���̺��ƴ�)
--���̺�ó�� �����Ͱ� ���������� �����ϴ� ���� �ƴϱ⶧����.
--������ ������ �� = QUERY

--VIEW ����
--CREATE OR REPLACE VIEW ���̸� [(�÷���Ī1, �÷���Ī2...)] AS
--SUBQUERY

--emp���̺����� sal, comm�÷��� ������ ������ 6�� �÷��� ��ȸ�� �Ǵ� view�� v_emp�̸����� ����
CREATE OR REPLACE VIEW v_emp AS
SELECT empno, ename, job, mgr, hiredate, deptno
FROM emp; --�����߻�(view ���������̾��)

--VIEW ���� ������ �ڽ��� ������ �ο�
--SYSTEMP �������� �۾��ؾ���
GRANT CREATE VIEW TO BR; --���� �ο� �� SYSTEM ���� ���������� ��

--VIEW�� ���� ������ ��ȸ
SELECT *
FROM v_emp;

--INLINE VIEW (�� ����� �� ������ �״�� �����ؼ� �����)
SELECT *
FROM (SELECT empno, ename, job, mgr, hiredate, deptno
      FROM emp);

--EMP���̺��� �����ϸ� VIEW�� ������ ������? -�ִ�
--KING�� �μ���ȣ�� ���� 10��
--emp ���̺��� KING�� �μ���ȣ �����͸� 30������ ����
--v_emp ���̺����� KING�� �μ���ȣ�� ����

UPDATE emp SET deptno = 30
WHERE ename = 'KING';

SELECT *
FROM v_emp;
ROLLBACK;

--���ε� ����� view�� ���� (���� ��ȸ�ϴ� ���� ���̺��� �����α�)
CREATE OR REPLACE VIEW v_emp_dept AS
SELECT emp.empno, emp.ename, dept.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

SELECT *
FROM v_emp_dept;

--emp ���̺����� KING ������ ����(COMMIT ���� ����)
SELECT *
FROM emp
WHERE ename = 'KING';

DELETE emp
WHERE ename = 'KING';

--EMP ���̺����� KING ������ ���� �� V_EMP_DEPT VIEW�� ��ȸ ��� Ȯ��
SELECT *
FROM v_emp_dept;

INSERT INTO EMP VALUES
        (7839, 'KING', 'PRESIDENT', NULL,
        TO_DATE('17-NOV-1981', 'DD-MON-YYYY', 'NLS_DATE_LANGUAGE = AMERICAN'), 5000, NULL, 10);
COMMIT;

--INLINE VIEW
SELECT *
FROM (SELECT emp.empno, emp.ename, dept.deptno, dept.dname
        FROM emp, dept
        WHERE emp.deptno = dept.deptno);
        
--emp���̺��� empno �÷��� eno�� �÷��̸� ����(�ϸ� �䰡 ������=�����߻�, �ٽ� �����ص� ������. �ٽ� �����̺� �����ؾ���)
ALTER TABLE emp RENAME COLUMN empno TO eno;
ALTER TABLE emp RENAME COLUMN eno TO empno; --DDL �����̶� �ڵ� COMMIT��

SELECT *
FROM v_emp_dept;

--view ����
--v_emp ����
DROP VIEW v_emp;

--�μ��� ������ �޿� �հ�
SELECT *
FROM emp;

--���÷�����(�׷��Լ��� ���⶧��)
CREATE OR REPLACE VIEW v_emp_sal AS
SELECT deptno, SUM(sal) sum_sal
FROM emp
GROUP BY deptno;

SELECT *
FROM v_emp_sal
WHERE deptno = 20;

--inline view (���� ���� ���)
SELECT *
FROM (SELECT deptno, SUM(sal) sum_sal
        FROM emp
        GROUP BY deptno)
WHERE deptno = 20;


--SEQUENCE
--����Ŭ��ü�� �ߺ����� �ʴ� ���� ���� �������ִ� ��ü
--CREATE SEQUENCE ��������
--[�ɼ�...(PPTȮ���ϸ� ����)]

CREATE SEQUENCE seq_board;
--MINVALUE 1
--MAXVALUE 9999999999999999999999999999
--INCREMENT BY 1
--START WITH 1
--CACHE 20 -->�޸𸮿� �̸� ��������(20��ŭ)�� �÷��� ���� �Ǵ�.
--NOORDER
--NOCYCLE ; -> ������ ��������(sql)�� ������ �ɼ� ����(�� �ڵ� �����ȴ�)

--������ ����� : ��������.nextval
SELECT seq_board.nextval
FROM dual;

--�ݵ�� ����(����)�� �ʿ����.
--������-����(��¥���� ������ ���ϰ� �ʹٸ� �������� ����ϸ� �ȵ�)
SELECT TO_CHAR(sysdate, 'YYYYMMDD') ||'-'|| seq_board.nextval
FROM dual;

--nextval ����� ���� ��ġ�� ��ȸ
SELECT seq_board.currval
FROM dual;


--rowid = �ο� �ּ�(�� �˸� �����͸� �� ������ ã�� �� ����)
SELECT rowid, rownum, emp.*
FROM emp;

SELECT *
FROM emp_test;

--emp ���̺� empno �÷����� PRIMARY KEY ���� ���� : PK_EMP
--dept ���̺� deptno �÷����� PRIMARY KEY ���� ���� : PK_dept
--emp ���̺��� deptno�÷��� dept ���̺��� deptno �÷��� �����ϵ��� FOREIGN KEY ���� �߰�:FK_dept_deptno

ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);
ALTER TABLE dept ADD CONSTRAINT pk_dept PRIMARY KEY (deptno);
ALTER TABLE emp ADD CONSTRAINT fk_dept_deptno FOREIGN KEY (deptno)
            REFERENCES dept (deptno);

--emp_test ���̺� ����
DROP TABLE emp_test;

--emp ���̺��� �̿��Ͽ� emp_test ���̺� ����
CREATE TABLE emp_test AS --�������� �ɾ������ �ȵ���´�
SELECT *
FROM emp;

--emp_test ���̺����� �ε����� ���� ����
--���ϴ� �����͸� ã�� ���ؼ��� ���̺��� �����͸� ��� �о�����Ѵ�
EXPLAIN PLAN FOR --�����ȹ
SELECT *
FROM emp_test
WHERE empno=7369;

SELECT *
FROM table(dbms_xplan.display); --�����ȹ �̾Ƴ���

--�����ȹ�� ���� 7369 ����� ���� ���� ������ ��ȸ�ϱ� ���� ���̺��� ��� ������(14��)�� �о ������
--����� 7369�� �����͸� �����Ͽ� ����ڿ��� ��ȯ
--**13���� �����͸� ���ʿ��ϰ� ��ȸ �� ����
--Plan hash value: 3124080142
-- 
--------------------------------------------------------------------------------
--| Id  | Operation         | Name     | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------
--|   0 | SELECT STATEMENT  |          |     1 |    87 |     3   (0)| 00:00:01 |
--|*  1 |  TABLE ACCESS FULL| EMP_TEST |     1 |    87 |     3   (0)| 00:00:01 | --�ڽĺ��� �д´�
--------------------------------------------------------------------------------
-- 
--Predicate Information (identified by operation id):
-----------------------------------------------------
-- 
--   1 - filter("EMPNO"=7369) -> filter : ��ü�� �а����� �ɸ�
-- 
--Note
-------
--   - dynamic sampling used for this statement (level=2)
   

--emp ���̺����� �ε����� �ִ� ����
EXPLAIN PLAN FOR --�����ȹ
SELECT *
FROM emp
WHERE empno=7369;

SELECT *
FROM table(dbms_xplan.display); --�����ȹ �̾Ƴ���

--�����ȹ�� ���� �м��� �ϸ� empno�� 7369�� ������ index�� ���� �ſ� ������ �ε����� ����
--���� ����Ǿ� �ִ� rowid ���� ���� table�� ������ �Ѵ�
--table���� ���� �����ʹ� 7369��� ������ �ѰǸ� ��ȸ�� �ϰ� ������ 13�ǿ� ���ؼ��� ���� �ʰ� ó��
--Plan hash value: 2949544139
-- 
----------------------------------------------------------------------------------------
--| Id  | Operation                   | Name   | Rows  | Bytes | Cost (%CPU)| Time     |
----------------------------------------------------------------------------------------
--|   0 | SELECT STATEMENT            |        |     1 |    38 |     1   (0)| 00:00:01 |
--|   1 |  TABLE ACCESS BY INDEX ROWID| EMP    |     1 |    38 |     1   (0)| 00:00:01 | --�ε����� �ִ� �ο���̵� ���� ����
--|*  2 |   INDEX UNIQUE SCAN         | PK_EMP |     1 |       |     0   (0)| 00:00:01 | --������ �ڽĺ��� �д´�
----------------------------------------------------------------------------------------
-- 
--Predicate Information (identified by operation id):
-----------------------------------------------------
-- 
--   2 - access("EMPNO"=7369) --> access : 7369�� �ٷ� ������


--rowid�� �˻��� �� �ִ�
EXPLAIN PLAN FOR
SELECT rowid, emp.*
FROM emp
WHERE rowid = 'AAAE5uAAFAAAAEVAAB';

SELECT *
FROM table(dbms_xplan.display);
--Plan hash value: 1116584662
-- 
-------------------------------------------------------------------------------------
--| Id  | Operation                  | Name | Rows  | Bytes | Cost (%CPU)| Time     |
-------------------------------------------------------------------------------------
--|   0 | SELECT STATEMENT           |      |     1 |    38 |     1   (0)| 00:00:01 |
--|   1 |  TABLE ACCESS BY USER ROWID| EMP  |     1 |    38 |     1   (0)| 00:00:01 | -->�ο���̵�� ������
-------------------------------------------------------------------------------------
