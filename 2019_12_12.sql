--��Ī : ���̺�, �÷��� �ٸ� �̸����� ��Ī
--[AS] ��Ī��
--SELECT empno [AS] eno
--FROM emp e

--SYNONYM(���Ǿ�) : �ٸ� ����� ���̺��� ��ȸ�� �� �ִ� ������ �޾����� ���(���� br(�ش� ������).employees �� ��ȸ�ؾ��ϴµ� �̰� �ó�ԽἭ �����ϰ� ����Ѵ�)
--����Ŭ ��ü�� �ٸ� �̸����� �θ� �� �ֵ��� �ϴ� ��
--���࿡ emp ���̺��� e��� �ϴ� synonym(���Ǿ�)�� ������ �ϸ� ������ ���� sql�� �ۼ��� �� �ִ�
-- SELECT *
-- FROM e; --�̷��� ��ȸ�� �� �ִ�

--br������ synonym ���� ������ �ο�(�ϰ� �� �ý��� ���� ���������ؾ���)
GRANT CREATE SYNONYM TO BR;

--emp ���̺��� ����Ͽ� synonym e�� ����
--CREATE SYNONYM �ó�� �̸� FOR ����Ŭ��ü;
CREATE SYNONYM e FOR emp;

--emp��� ���̺� �� ��ſ� e ��� �ϴ� �ó���� ����Ͽ� ������ �ۼ��� �� �ִ�
SELECT *
FROM e; --emp�� �ᵵ ��

--br������ fastfood ���̺��� hr ���������� �� �� �ֵ��� ���̺� ��ȸ ������ �ο�
GRANT SELECT ON fastfood TO HR;

--�����̸��� ������̸��� �ٸ���. SYSTEM �������� �Ʒ� ���� ��ȸ�� �����°� ����(=����� �̸�).
SELECT *
FROM DBA_USERS;

--DML : SELECT / INSERT / UPDATE / DELETE / INSERT ALL / MERGE
--TCL : COMMIT / ROLLBACK / [SAVEPOINT]
--DDL : CREATE (��ü) / ALTER / DROP
--DBL : GRANT / REVOKE

SELECT *
FROM DICTIONARY;

--������ SQL�� ���信 ������ �Ʒ� SQL���� �ٸ���
SELECT /* 201911_205 */ * FROM emp;
SELECT /* 201911_205 */ * FROM EMP;
SELECt /* 201911_205 */ * FROM EMP;

--�̷��� ��ȸ�ϸ� �����ȹ�� �ϳ��� �� ����ȴ�
SELECt /* 201911_205 */ * FROM EMP WHERE empno = 7369;
SELECt /* 201911_205 */ * FROM EMP WHERE empno = 7499;
--�׷��� ���ε庯���� ����Ѵ�
SELECt /* 201911_205 */ * FROM EMP WHERE empno = :empno;
--����� �����ȹ�� Ȯ���ϴ� ���(SYSTEM �������� ����)
--SELECT *
--FROM V$SQL
--WHERE SQL_TEXT LIKE '%201911_205%';

--multiple insert
SELECT *
FROM emp_test;
DROP TABLE emp_test;

--emp ���̺��� empno, ename �÷����� emp_test, emp_test2 ���̺��� ����
--����(CTAS, �����͵� ���� ����)
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

--unconditional insert : ���� ���̺��� �����͸� ���� �Է�
--BROWN, CONY �����͸� EMP_TEST, EMP_TEST2 ���̺��� ���� �Է�
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

--���̺� �� �ԷµǴ� �������� �÷��� ���� ����
ROLLBACK;

INSERT ALL
    INTO emp_test (empno, ename) VALUES(eno, enm)
    INTO emp_test2 (empno) VALUES (eno)
SELECT 9999 eno, 'brown' enm FROM DUAL UNION ALL
SELECT 9998, 'cony' FROM DUAL;

ROLLBACK;

--CONDITIONAL INSERT
--���ǿ� ���� ���̺��� �����͸� �Է�
/*
    CASE
        WHEN ���� THEN -----
        WHEN ���� THEN -----
        ELSE ------
*/
INSERT ALL
    WHEN eno > 9000 THEN
        INTO emp_test (empno, ename) VALUES (eno, enm)
        WHEN eno > 9500 THEN --�̰͵� ��ϵȴ�
        INTO emp_test (empno, ename) VALUES (eno, enm)
    ELSE
        INTO emp_test2 (empno) VALUES (eno)
SELECT 9999 eno, 'brown' enm FROM DUAL UNION ALL
SELECT 8998, 'cony' FROM DUAL;

ROLLBACK;

INSERT FIRST
    WHEN eno > 9000 THEN --�����ϴ� ù��° ���Ǹ� ��ϵȴ�
        INTO emp_test (empno, ename) VALUES (eno, enm)
        WHEN eno > 9500 THEN --�̰͵� �����Ѵ�
        INTO emp_test (empno, ename) VALUES (eno, enm)
    ELSE
        INTO emp_test2 (empno) VALUES (eno)
SELECT 9999 eno, 'brown' enm FROM DUAL UNION ALL
SELECT 8998, 'cony' FROM DUAL;