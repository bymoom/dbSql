--����̸�, �����ȣ, ��ü�����Ǽ�
--SELECT ename, empno, COUNT(*) --�׷���̸� ���� ������ ������ ����
--FROM emp;
SELECT ename, empno, COUNT(*)
FROM EMP
GROUP BY ename, empno; --COUNT�� �ǹ̰� ������

--�ǽ� ANA0
SELECT a.ename, a.sal, a.deptno, b.rn
FROM
(SELECT ename, sal, deptno, ROWNUM j_rn
FROM
(SELECT ename, sal, deptno
FROM emp
ORDER BY deptno, sal DESC)) a,
(SELECT rn, ROWNUM j_rn
FROM
    (SELECT b.*, a.rn
    FROM
    (SELECT ROWNUM rn
    FROM dual
    CONNECT BY level <= (SELECT COUNT(*) FROM emp)) a,
    (SELECT deptno, COUNT(*) cnt
    FROM emp
    GROUP BY deptno) b
WHERE b.cnt >= a.rn
ORDER BY b.deptno, a.rn)) b
WHERE a.j_rn = b.j_rn;



--ana0�� �м��Լ���
SELECT ename, sal, deptno,
        RANK() OVER(PARTITION BY deptno ORDER BY sal) rank, --PARTITION BY �μ��� �������� ������
        DENSE_RANK() OVER(PARTITION BY deptno ORDER BY sal) dense_rank,
        ROW_NUMBER() OVER(PARTITION BY deptno ORDER BY sal) row_rank
FROM emp;

--�ǽ�ANA1
SELECT empno, ename, sal, deptno,
        RANK() OVER(ORDER BY sal DESC, empno) sal_rank, --PARTITION BY �� �� ����
        DENSE_RANK() OVER(ORDER BY sal DESC, empno) sal_dense_rank,
        ROW_NUMBER() OVER(ORDER BY sal DESC, empno) sal_row_rank
FROM emp;

--�ǽ� no_ana2

SELECT a.*, b.cnt
FROM
    (SELECT empno, ename, deptno
    FROM emp) a,
    (SELECT deptno, COUNT(*) cnt
    FROM emp
    GROUP BY deptno) b
WHERE a.deptno = b.deptno
ORDER BY a.deptno;

--�� �������� �� �ܼ��� ����
SELECT emp.empno, emp.ename, emp.deptno, a.cnt
FROM emp,
    (SELECT deptno, COUNT(*) cnt
    FROM emp
    GROUP BY deptno) a
WHERE a.deptno = emp.deptno
ORDER BY emp.deptno;


--�����ȣ, ����̸�, �μ���ȣ, �μ��� ����
SELECT empno, ename, deptno,
        COUNT(*) OVER (PARTITION BY deptno) cnt --COUNT(*) �ڸ��� �ٸ� �����Լ� ��� ����
FROM emp;


--�ǽ�ana2
SELECT empno, ename, sal, deptno,
       ROUND(AVG(sal) OVER (PARTITION BY deptno), 2) cnt
FROM emp;


--�ǽ�ana3
SELECT empno, ename, sal, deptno,
        MAX(sal) OVER (PARTITION BY deptno) max_sal
FROM emp;


--�ǽ�ana4
SELECT empno, ename, sal, deptno,
        MIN(sal) OVER (PARTITION BY deptno) min_sal
FROM emp;

--��ü����� ������� �޿������� �ڽź��� �Ѵܰ� ���� ����� �޿�
--�޿��� ���� ��� �Ի����ڰ� ���� ����� ���� ����
SELECT empno, ename, hiredate, sal,
        LEAD(sal) OVER (ORDER BY sal DESC, hiredate) lead_sal 
FROM emp;

--�ǽ�ana5
SELECT empno, ename, hiredate, sal,
        LAG(sal) OVER (ORDER BY sal DESC, hiredate) lead_sal
FROM emp;

--�ǽ�ana6
SELECT empno, ename, hiredate, job, sal,
        LAG(sal) OVER (PARTITION BY job ORDER BY sal DESC, hiredate) lag_sal
FROM emp;


--�ǽ�no_ana3
SELECT a.empno, a.ename, a.sal, SUM(b.sal) c_sum
FROM
(SELECT a.*, ROWNUM rn
FROM emp,
(SELECT empno, ename, sal
FROM emp
ORDER BY sal) a
WHERE emp.empno = a.empno) a,
(SELECT a.*, ROWNUM rn
FROM emp,
(SELECT empno, ename, sal
FROM emp
ORDER BY sal) a
WHERE emp.empno = a.empno) b
WHERE a.rn >= b.rn
GROUP BY a.empno, a.ename, a.sal
ORDER BY c_sum;