--GROUPING SETS(col1, col2)
--�����ڰ� GROUP BY�� ������ ���� �����Ѵ�
--ROLLUP�� �޸� ���⼺�� ���� �ʴ´�
--GROUPING SETS(col1, col2) = GROUPING SETS(col2, col1)
--������ ����� �����ϴ�
--GROUP BY col1
--UNION ALL
--GROUP BY col2

--emp���̺����� ������ job�� �޿�(sal) + ��(comm)��
--                 deptno(�μ�)�� �޿�(sal) + ��(comm)�� ���ϱ�
--�������(GROUP FUNCTION) : 2���� SQL �ۼ� �ʿ�(UNION / UNION ALL)
SELECT job, SUM(sal + NVL(comm, 0)) sal_comm_sum
FROM emp
GROUP BY job
UNION ALL --�� ���̺��� UNION ALL�Ϸ��� deptno�� ���ڿ��� ġȯ('' || deptno)�ϰų� �� ���̺��� null deptno�� �Է��ؾ��Ѵ�
SELECT '' || deptno, SUM(sal + NVL(comm, 0)) sal_comm_sum
FROM emp
GROUP BY deptno;

--GROUPING SETS ������ �̿��Ͽ� ���� SQL�� ���տ����� ������� �ʰ� ���̺��� �ѹ� �о ó��
SELECT job, deptno, SUM(sal + NVL(comm, 0)) sal_comm_sum
FROM emp
GROUP BY GROUPING SETS (job, deptno); --�ٸ� �׷��Լ��ʹ� �޸� �Ѱ� �ȳ���

--job, deptno�� �׷����� �� sal+comm ��
--mgr�� �׷������� sal+comm ��
--GROUP BY job, deptno
--UNION ALL
--GROUP BY mgr
-- --> GROUPING SETS((job, deptno), mgr)
SELECT job, deptno, mgr, SUM(sal + NVL(comm, 0)) sal_comm_sum,
        GROUPING(job), GROUPING(deptno), GROUPING(mgr) --GROUPING�� ����ؼ� KING ���� �Ѱ����� Ȯ���Ѵ�
FROM emp
GROUP BY GROUPING SETS ((job, deptno), mgr);

--CUBE (col1, col2 ...)
--������ �÷��� ��� ������ �������� GROUP BY subset�� �����
--CUBE�� ������ �÷��� 2���� ��� : ������ ���� 4��
--CUBE�� ������ �÷��� 3���� ��� : ������ ���� 8��
--CUBE�� ������ �÷����� 2�� ������ �� ����� ������ ���� ������ �ȴ�(2^n)
--�÷��� ���ݸ� �������� ������ ������ ���ϱ޼������� �þ�� ������ ���� ������� �ʴ´�

--job, deptno�� �̿��Ͽ� CUBE ����
SELECT job, deptno, SUM(sal + NVL(comm, 0)) sal_comm_sum
FROM emp
GROUP BY CUBE(job, deptno);
--job, detpno
--1, 1 --> GROUP BY job, deptno
--1, 0 --> GROUP BY job
--0, 1 --> GROUP BY deptno
--0, 0 --> GROUP BY --emp���̺��� ��� �࿡ ���� GROUP BY

--GROUP BY ����
--GROUP BY, ROLLUP, CUBE�� ���� ����ϱ�
--������ ������ �����غ��� ���� ����� ������ �� �ִ�
--GROUP BY job, rollup(deptno), cube(mgr)

SELECT job, deptno, mgr, SUM(sal + NVL(comm, 0)) sal_comm_sum
FROM emp
GROUP BY job, ROLLUP(deptno), CUBE(mgr);
-->GROUP BY job, deptno, mgr + job, mgr + job, deptno + job -->job�� default�� �س��� ������ �Ѱ�� �ȳ��´�

SELECT *
FROM dept_test;
DROP TABLE dept_test;

SELECT COUNT(deptno), deptno
FROM emp
GROUP BY deptno;

CREATE TABLE dept_test AS
SELECT *
FROM dept;

SELECT *
FROM dept_test;

ALTER TABLE dept_test ADD (empcnt NUMBER);

UPDATE dept_test
SET empcnt = (SELECT COUNT(emp.deptno) -- COUNT(*)�� �����
            FROM emp
            WHERE dept_test.deptno = emp.deptno);

--------------------------          
INSERT INTO dept_test VALUES (99, 'it1', 'daejeon');
INSERT INTO dept_test VALUES (98, 'it2', 'daejeon');

DELETE FROM dept_test --from�� �־ �ǰ� ��� ��
WHERE deptno NOT IN (SELECT deptno
                    FROM emp
                    WHERE emp.deptno = dept_test.deptno); --WHERE�� ��������
                    

SELECT *
FROM emp_test;

DROP TABLE emp_test;

CREATE TABLE emp_test AS
SELECT *
FROM emp;

SELECT deptno, ROUND(AVG(sal), 2)
FROM emp_test
GROUP BY deptno;

UPDATE emp_test SET sal = sal + 200
WHERE sal < (SELECT ROUND(AVG(sal), 2)
                FROM emp
                WHERE deptno = emp_test.deptno);

ROLLBACK;


--MERGE ������ �̿��� ������Ʈ 
MERGE INTO emp_test a
USING (SELECT deptno, ROUND(AVG(sal), 2) avg_sal
       FROM emp_test
       GROUP BY deptno) b
ON ( a.deptno = b.deptno )
WHEN MATCHED THEN
    UPDATE SET sal = sal + 200
WHERE a.sal < b.avg_sal; --(ON���� ����� �÷��� ������Ʈ�� �� ���⶧���� where �� ���)

--MERGE�� CASE�� ���
MERGE INTO emp_test a
USING (SELECT deptno, ROUND(AVG(sal), 2) avg_sal
       FROM emp_test
       GROUP BY deptno) b
ON ( a.deptno = b.deptno)
WHEN MATCHED THEN
    UPDATE SET sal = CASE --������ ���� ������Ʈ�ϱ� ������ �� ������ �ٸ��� 14�� �� ���յ�
                        WHEN a.sal < b.avg_sal THEN sal + 200
                        ELSE sal
                    END;

select *
from dept;