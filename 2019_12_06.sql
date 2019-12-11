SELECT *
FROM dept;

--dept ���̺��� �μ���ȣ 99, �μ��� ddit, ��ġ daejeon

INSERT INTO dept VALUES (99, 'ddit', 'daejeon');
COMMIT;

--UPDATE : ���̺��� ����� �÷��� ���� ����
--UPDATE ���̺��� SET �÷���1 = �����Ϸ����ϴ� ��1, �÷���2 = �����Ϸ����ϴ� ��2...
--[WHERE row ��ȸ ����] --��ȸ ���ǿ� �ش��ϴ� �����͸� ������Ʈ �ȴ�

--�μ���ȣ�� 99���� �μ��� �μ����� ���IT��, ������ ���κ������� ����
UPDATE dept SET dname = '���IT', loc = '���κ���'
WHERE deptno = 99;

--������Ʈ���� ������Ʈ �Ϸ��� �ϴ� ���̺��� WHERE���� ����� �������� SELECT�� �Ͽ� ������Ʈ ��� ROW�� Ȯ���غ���
SELECT *
FROM dept
WHERE deptno = 99;

--���� QUERY�� �����ϸ� WHERE���� ROW ���� ������ ���� ������ dept���̺��� ��� �࿡ ���� �μ���, ��ġ ������ �����Ѵ�
UPDATE dept SET dname = '���IT', loc = '���κ���';

--SUBQUERY�� �̿��� UPDATE
--emp���̺��� �ű� ������ �Է�
--�����ȣ  9999, ����̸� brown, ���� : null
INSERT INTO emp (empno, ename) VALUES (9999, 'brown');
COMMIT;

SELECT *
FROM emp
WHERE empno=9999;

--�����ȣ�� 9999�� ����� �Ҽ� �μ���, �������� SMITH����� �μ�, ������ ������Ʈ
UPDATE emp SET deptno = (SELECT deptno FROM emp WHERE ename = 'SMITH'),
                job = (SELECT job FROM emp WHERE ename = 'SMITH')
WHERE empno = 9999;
COMMIT;

--DELETE : ���ǿ� �ش��ϴ� ROW�� ����
--�÷��� ���� ����?? (NULL)������ �����Ϸ��� --> UPDATE ����ؾ���

--DELETE ���̺���
--[WHERE ����]

--UPDATE������ ���������� DELETE ���� ���������� �ش� ���̺��� WHERE������ �����ϰ� �Ͽ� SELECT�� ����, ������ ROW�� ���� Ȯ���غ���
--emp���̺��� �����ϴ� �����ȣ 9999�� ����� ����
DELETE emp
WHERE empno = 9999;

COMMIT;

SELECT *
FROM emp;

--�Ŵ����� 7698�� ��� ����� ����
--���������� ���
DELETE emp
WHERE empno IN (SELECT empno
                FROM emp
                WHERE mgr = 7698);
--�� ������ �Ʒ� ������ ����
DELETE emp WHERE mgr = 7698;

SELECT *
FROM emp;
ROLLBACK;

--�б� �ϰ��� (ISOLATION LEVEL)
--DML���� �ٸ� ����ڿ��� ��� ������ ��ġ���� ������ ����(0-3) --������ �������� ��������

--ISOLATION LEBVEL0 : Read Uncommitted
--���� Ʈ������� Ŀ�� ���� ���� �����͸� ���� Ʈ����ǿ��� �� �� �ִ� ����
--����Ŭ�� ������

--ISOLATION LEBVEL1 : Read committed
--Ŀ�Ե��� ���� �����ʹ� ���� Ʈ����ǿ��� ���� ����
--��κ��� DBMS�� �⺻ ����

--ISOLATION LEBVEL2 : Repeatable Read
--���� Ʈ����ǿ��� ���� ������(FOR UPDATE)�� ����, �������� ����
--�ٸ� Ʈ����ǿ��� ������ ���ϱ� ������ �� Ʈ����ǿ��� �ش� ROW�� �׻� ������ ��������� ��ȸ�Ҽ��ִ�
--������ ���� Ʈ����ǿ��� �ű� ������ �Է� �� COMMIT�� �ϸ� �� Ʈ����ǿ��� ��ȸ�� �ȴ�(phantom read �����б�)

--ISOLATION LEBVEL3 : Serializable Read
--Ʈ������� ������ ��ȸ ������ Ʈ����� ���� �������� ��������
--�� ���� Ʈ����ǿ��� �����͸� �ű� �Է�, ����, ���� �� COMMIT�� �ϴ��� ����Ư����ǿ����� �ش� �����͸� ���� �ʴ´�
--����Ŭ������ ���������� ���� ����

--Ʈ����� ���� ����(serializable read)
--SET TRANSACTION isolation LEVEL SERIALIZABLE; --����1���� ����3(Serializable Read) ���� �ٲ�




--DDL : TABLE ����
--CREATE TABLE [����ڸ�.] ���̺��� (
    --�÷���1 �÷�Ÿ��1,
    --�÷���2 �÷�Ÿ��2, ...
    --�÷���N �÷�Ÿ��N );
--���̺� ���� DDL : Data Defination Language(������ ���Ǿ�)
--DDL rollback�� ����(�ڵ� Ŀ�� �ǹǷ� rollback�� �� �� ����)

CREATE TABLE ranger (
    ranger_no NUMBER,
    ranger_nm VARCHAR2(50),
    reg_dt DATE ); --reg_dt : ������ ��� ����

--���̺� ��� �� ��ȸ    
DESC ranger;

--DDL ������ ROLLBACK ó���� �Ұ�!!!
ROLLBACK;

SELECT *
FROM user_tables
WHERE table_name = 'RANGER';
--WHERE table_name = 'ranger'; --�ҹ��ڷ� ���� ��� �ȳ���
--����Ŭ������ ��ü ������ �ҹ��ڷ� �����ϴ��� ���������δ� �빮�ڷ� �����Ѵ�


--DML���� DDL�� �ٸ��� ROLLBACK�� �����ϴ� --INSERT���� ����ϴ°���
INSERT INTO ranger VALUES(1, 'brown', sysdate);
SELECT *
FROM ranger;
ROLLBACK;

--DATE Ÿ�Կ��� �ʵ� �����ϱ�
--EXTRACT(�ʵ�� FROM �÷�/expression)
SELECT TO_CHAR(SYSDATE, 'YYYY') yyyy,
        TO_CHAR(SYSDATE, 'mm') mm,
        EXTRACT(year FROM SYSDATE) ex_yyy,
        EXTRACT(month FROM SYSDATE) ex_mm
FROM dual;

--���̺� ������ �÷� ���� �������� ����
CREATE TABLE dept_test (
    deptno NUMBER(2),
    dname VARCHAR(14),
    loc VARCHAR2(13));

DROP TABLE dept_test;

CREATE TABLE dept_test (
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR(14),
    loc VARCHAR2(13));
    
--dept_test ���̺��� deptno �÷��� PRIMARY KEY ���������� �ֱ� ������ deptno�� ������ �����͸� �Է��ϰų� �����Ҽ�����.
--���� �������̹Ƿ� �Է� ����
INSERT INTO dept_test VALUES(99, 'ddit', 'daejeon');
--dept_test �����Ϳ� deptno�� 99���� �����Ͱ� �����Ƿ� primary key �������ǿ� ���� �Էµɼ�����
--ORA-00001 : unique constraint ���� ����
--����Ǵ� ���� ���Ǹ� SYS_C007118 ���� ���� ����
INSERT INTO dept_test VALUES(99, '���', '����'); --��ũ��Ʈ�� unique constraint(=unique��������)

--SYS_C007118 ���������� � ���� �������� �Ǵ��ϱ� ����Ƿ� �������ǿ� �̸��� �ڵ� �꿡 ���� �ٿ��ִ� ���� ���������� ���ϴ�
--���̺� ���� �� �������� �̸��� �߰��Ͽ� �����
DROP TABLE dept_test;

--primary key : pk_���̺���
CREATE TABLE dept_test (
    deptno NUMBER(2) CONSTRAINT pk_dept_test PRIMARY KEY,
    dname VARCHAR(14),
    loc VARCHAR2(13));
    
INSERT INTO dept_test VALUES(99, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES(99, '���', '����');