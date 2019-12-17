SELECT *
FROM emp_test
ORDER BY empno;

--emp���̺��� �����ϴ� �����͸� emp_test ���̺��� ����
--���� empno�� ������ �����Ͱ� �����ϸ� ename update : enama || '_merge'
--���� empno�� ������ �����Ͱ� �������� ���� ��� emp���̺��� empno, ename�� emp_test �����ͷ� insert

--emp_test �����Ϳ��� ������ �����͸� ����
DELETE emp_test
WHERE empno >= 7788;
COMMIT;


--emp���̺����� 14���� �����Ͱ� ����
--emp_test ���̺����� ����� 7788���� ���� 7���� �����Ͱ� ����
--emp���̺��� �̿��Ͽ� emp_test ���̺��� �����ϰԵǸ�
--emp���̺����� �����ϴ� ����(����� 7788���� ũ�ų� ����) 7��
--emp_test�� ���Ӱ� insert�� �� ���̰�
--emp, emp_test�� �����ȣ�� �����ϰ� �����ϴ� 7���� �����ʹ�
--(����� 7788���� ���� ����)ename�÷��� ename || '_modify'�� ������Ʈ �Ѵ�

/*
MERGE INTO ���̺���
USION ������� ���̺�|VIEW|SUBQUERY
ON (���̺����� ��������� �������)
WHEN MATCHED THEN
        UPDATE ......
WHEN NOT MATCHED THEN
        INSERT ......
*/


MERGE INTO emp_test
USING emp
ON (emp.empno = emp_test.empno)
WHEN MATCHED THEN
    UPDATE SET ename = ename || '_mod'
WHEN NOT MATCHED THEN
    INSERT VALUES (emp.empno, emp.ename);

SELECT *
FROM emp_test;


--emp_test ���̺��� ����� 9999�� �����Ͱ� �����ϸ�
--ename�� 'brown'���� update
--�������� ���� ��� empno, ename VALUES (9999, 'brown')���� insert
--���� �ó������� MERGE ������ Ȱ���Ͽ� �ѹ��� SQL�� ����
--:empno -> 9999, :ename -> 'brown'
MERGE INTO emp_test
USING dual
ON (emp_test.empno = :empno)
WHEN MATCHED THEN
    UPDATE SET ename = :ename || '_mod'
WHEN NOT MATCHED THEN
    INSERT VALUES (:empno, :ename);
    
SELECT *
FROM emp_test
WHERE empno = 9999;

--���� merge ������ ���ٸ� �Ʒ��� �� �����ؾ��Ѵ�
-- 1. empno = 9999�� �����Ͱ� �����ϴ��� Ȯ��
-- 2-1. 1�����׿��� �����Ͱ� �����ϸ� UPDATE
-- 2-2. 1�����׿��� �����Ͱ� �������� ������ INSERT

SELECT a.deptno, SUM(a.sal)
FROM (SELECT deptno, SUM(sal) sal
        FROM emp
        GROUP BY deptno) a
GROUP BY deptno
ORDER BY deptno;

--UNION ALL�� ����� �׷�ȭ
SELECT deptno, SUM(sal) sal
FROM emp
GROUP BY deptno
UNION ALL
SELECT null, SUM(sal) --�׷�ȭ�� ���þ��� ����� �Է��� �� �ִ�(NULL)
FROM emp
ORDER BY deptno;

--JOIN ������� �׷�ȭ (����������)
--emp ���̺��� 14�ǿ� �����͸� 28������ ����
--������(1-14��, 2-14��)�� �������� group by
--������ 1 : �μ���ȣ �������� row (14��)
--������ 2 : ��ü row (14��)
SELECT DECODE(b.rn, 1, emp.deptno, 2, null) deptno,
        SUM(emp.sal) sal
FROM emp, (SELECT ROWNUM rn
            FROM dept
            WHERE ROWNUM <= 2) b
GROUP BY DECODE(b.rn, 1, emp.deptno, 2, null)
ORDER BY DECODE(b.rn, 1, emp.deptno, 2, null);


SELECT DECODE(b.rn, 1, emp.deptno, 2, null) deptno,
        SUM(emp.sal) sal
FROM emp, (SELECT 1 rn FROM dual UNION ALL
            SELECT 2 FROM dual) b
GROUP BY DECODE(b.rn, 1, emp.deptno, 2, null)
ORDER BY DECODE(b.rn, 1, emp.deptno, 2, null);


SELECT DECODE(b.rn, 1, emp.deptno, 2, null) deptno,
        SUM(emp.sal) sal
FROM emp, (SELECT LEVEL rn
            FROM dual
            CONNECT BY LEVEL <= 2) b
GROUP BY DECODE(b.rn, 1, emp.deptno, 2, null)
ORDER BY DECODE(b.rn, 1, emp.deptno, 2, null);


--REPORT GROUP BY
--ROLLUP
--GROUP BY ROLLUP(col1...)
--ROLLUP���� ����� �÷��� �����ʿ������� ���� �����
--SUB GROUP�� �����Ͽ� �������� GROUP BY���� �ϳ��� SQL���� ����ǵ��� �Ѵ�
--GROUP BY ROLLUP(job, deptno)
--1. GROUP BY job, deptno -->�Ѳ����� �׷�ȭ��
--2. GROUP BY job
--3. GROUP BY --> ��ü ���� ������� GROUP BY

--emp���̺��� �̿��Ͽ� �μ���ȣ��, ��ü ������ �޿����� ���ϴ� ������
--ROLLUP ����� �̿��Ͽ� �ۼ�
SELECT deptno, SUM(sal) sal
FROM emp
GROUP BY ROLLUP(deptno);

--emp���̺��� �̿��Ͽ� job, deptno �� sal+comm�հ�
--                    job �� sal+comm �հ�
--                    ��ü������ sal+comm �հ�
--ROLLUP�� Ȱ���Ͽ� �ۼ�

SELECT job, deptno, SUM(sal + NVL(comm,0)) sal_sum --comm�� null�� �ֱ⶧���� ������
FROM emp
--ROLLUP�� �÷� ������ ��ȸ ����� ���� ������ ��ģ��.
GROUP BY ROLLUP (job, deptno);
--1. GROUP BY job, deptno --> �Ѳ����� �׷�ȭ��
--2. GROUP BY job --> JOB�� �������� �׷�ȭ��
--3. GROUP BY --> ��ü ROW ���
-->1, 2, 3�� ��� ����� ���´�

--�ǽ� AD2
SELECT DECODE(GROUPING(job), 1, '�Ѱ�', job) job, deptno, SUM(sal + NVL(comm,0)) sal
FROM emp
GROUP BY ROLLUP (job, deptno);

--AD2-1
SELECT DECODE(GROUPING(job), 1, '��', job) job,
        CASE
            WHEN deptno IS NULL AND job IS NULL THEN '��'
            WHEN deptno IS NULL AND job IS NOT NULL THEN '�Ұ�'
            ELSE '' || deptno --deptno�� ���ڿ��� ġȯ(TO_CHAR(deptno)�� ����)
        END,
        SUM(sal + NVL(comm, 0)) sal
FROM emp
GROUP BY ROLLUP (job, deptno);

--AD2-1�� DECODE��..
SELECT DECODE(GROUPING(job), 1, '��', job) job,
        DECODE(GROUPING(deptno) + DECODE(GROUPING(job), 2, '��', 1, '�Ұ�', deptno)),
--        DECODE(GROUPING(deptno), 1, DECODE(GROUPING(job), 1, '��', '�Ұ�'), deptno),
        SUM(sal + NVL(comm, 0)) sal
FROM emp
GROUP BY ROLLUP (job, deptno);

--�ǽ�ad3
SELECT deptno, job, SUM(sal + NVL(comm, 0)) sal
FROM emp
GROUP BY ROLLUP (deptno, job);

--UNION ALL�� ġȯ
SELECT deptno, job, SUM(sal + NVL(comm, 0)) sal
FROM emp
GROUP BY deptno, job
UNION ALL
SELECT deptno, NULL, SUM(sal + NVL(comm, 0)) sal
FROM emp
GROUP BY deptno
UNION ALL
SELECT NULL, NULL, SUM(sal + NVL(comm, 0)) sal
FROM emp;

SELECT job, SUM(sal + NVL(comm, 0)) sal
FROM emp
GROUP BY job;

SELECT *
FROM emp;
SELECT *
FROM dept;

--�ǽ� ad4
SELECT dname, job, sal
FROM dept, (SELECT job, SUM(sal + NVL(comm, 0)) sal, deptno
            FROM emp
            GROUP BY ROLLUP (deptno, job)) a
--WHERE dept.deptno = a.deptno; -->���ο� ������(�Ѱ谡 �ȳ���)
WHERE dept.deptno(+) = a.deptno; --OUTER JOIN�� �ؾ���

SELECT dname, job, SUM(sal + NVL(comm, 0)) sal
FROM emp, dept
WHERE emp.deptno = dept.deptno
GROUP BY ROLLUP (dname, job);

--�ǽ� ad5
SELECT DECODE(GROUPING(dname), 1, '����', dname) dname, job, SUM(sal + NVL(comm, 0)) sal
FROM emp, dept
WHERE emp.deptno = dept.deptno
GROUP BY ROLLUP (dname, job);