--emp ���̺�, dept ���̺� ����

EXPLAIN PLAN FOR
SELECT ename, emp.deptno, dept.dname --emp���̺��� deptno�� dept���̺��� dname�� �����Ѵ�
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND emp.deptno=10; --�� ���̺����� �������

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

SELECT ename, emp.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno != dept.deptno --emp���̺��� dept���̺��� �����Ͱ� �ٸ� ��� ����
AND emp.deptno=10; --deptno�� �����͸� 10���� �ٲ۴�

SELECT ename, deptno
FROM emp;

SELECT deptno, dname
FROM dept;

--natural join : ���� ���̺��� ���� Ÿ��, ���� �̸��� �÷����� ���� ���� ���� ��� ����
DESC emp;
DESC dept;

ALTER TABLE emp DROP COLUMN dname;

--ANSI SQL
SELECT deptno, a.empno, ename --emp��� ��Ī a�� ���
FROM emp a NATURAL JOIN dept; --��Ī a

--oracle ����
SELECT a.deptno, emp.empno, ename
FROM emp a, dept
WHERE a.deptno = dept.deptno;

--JOIN USING
--join �Ϸ��� �ϴ� ���̺��� ������ �̸��� �÷��� �ΰ� �̻��ϋ�
--join �÷��� �ϳ��� ����ϰ� ���� ��

--ANSI SQL
SELECT *
FROM emp JOIN dept USING (deptno); --deptno�� �տ� �ϳ��� ���´�

--ORACLE SQL
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno; --deptno�� ���� ���´�

--ANSI JOIN with ON
--�����ϰ��� �ϴ� ���̺��� �÷� �̸��� �ٸ���
--�����ڰ� ���� ������ ���� ������ ��

--ANSI
SELECT *
FROM emp JOIN dept ON (emp.deptno = dept.deptno);

--oracle
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;

--SELF JOIN : ���� ���̺��� ����
--emp ���̺��� ���� �Ҹ��� ���� : ������ ������ ���� ��ȸ //������ ����(mgr)�� ��ȣ�� �����ȣ(empno)�� ���� ����� ã�´�
--������ ������ ������ ��ȸ
--�����̸�, ������ �̸�

--ANSI
SELECT e.ename, m.ename
FROM emp e JOIN emp m ON (e.mgr = m.empno); --emp e�� ����������(mgr), emp m�� �� �������� �����ȣ(deptno)

--ORACLE
SELECT e.ename, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno; --����� ������ ������ �������� �����ȣ�� ����

--�����̸�, ������ ����� �̸�, ������ ������� ����� �̸�
SELECT e.ename, m.ename, t.ename
FROM emp e, emp m, emp t
WHERE e.mgr = m.empno
AND m.mgr = t.empno;

--������ �������� �������� ������ �̸�
SELECT e.ename, m.ename, t.ename, k.ename
FROM emp e, emp m, emp t, emp k
WHERE e.mgr = m.empno
AND m.mgr = t.empno
AND t.mgr = k.empno;

--�������̺��� ANSI JOIN�� �̿��� JOIN
SELECT e.ename, m.ename, t.ename, k.ename
FROM emp e JOIN emp m ON (e.mgr = m.empno) --JOIN ���̺��� ���� ����� �� ����
    JOIN emp t ON (m.mgr = t.empno)
    JOIN emp k ON (t.mgr = k.empno);

--������ �̸��� �ش� ������ ������ �̸��� ��ȸ�Ѵ�
--�� ������ ����� 7369~7698�� ������ ������� ��ȸ
SELECT *
FROM emp e, emp m
WHERE e.empno BETWEEN 7369 AND 7698
AND e.mgr = m.empno;

--ANSI
SELECT e.ename, m.ename
FROM emp e JOIN emp m ON (e.mgr = m.empno)
WHERE e.empno BETWEEN 7369 AND 7698;


--NON-EQUI JOIN : ���� ������ =(equal)�� �ƴ� JOIN (���� �ٸ� �� join�ϴ� ���)
-- !=, BETWEEN AND
SELECT *
FROM salgrade;

SELECT empno, ename, sal /*�޿� grade */
FROM emp;

--ORACLE
SELECT empno, ename, sal, grade
FROM emp, salgrade
WHERE emp.sal BETWEEN salgrade.losal AND salgrade.hisal;
--WHERE emp.sal >= salgrade.losal //�̷��Ե� ��������
--AND emp.sal <= salgrade.hisal;

--ANSI
SELECT empno, ename, sal, grade
FROM emp JOIN salgrade ON emp.sal BETWEEN salgrade.losal AND salgrade.hisal;

--join0
SELECT *
FROM emp;

SELECT *
FROM dept;

SELECT empno, ename, emp.deptno, dname
FROM emp JOIN dept ON (emp.deptno = dept.deptno)
ORDER BY emp.deptno;

SELECT empno, ename, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
ORDER BY emp.deptno;

--join0_1
SELECT empno, ename, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND (dept.deptno = 10 OR dept.deptno = 30); --AND�� OR���� ���� ����Ǳ� ������ ��ȣ�� �����
--AND emp.deptno IN (10, 30); //�̰͵� ����

--join0_2
SELECT empno, ename, emp.sal, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno 
AND emp.sal > 2500;

--join0_3
SELECT empno, ename, sal, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND sal > 2500 AND empno > 7600;
--(����)BETWEEN�� WHERE�� �� �پ��־���Ѵ�

--join0_4
SELECT empno, ename, sal, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND dname = 'RESEARCH'
AND sal > 2500 AND empno > 7600;