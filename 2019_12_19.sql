--사원이름, 사원번호, 전체직원건수
--SELECT ename, empno, COUNT(*) --그룹바이를 하지 않으면 에러가 난다
--FROM emp;
SELECT ename, empno, COUNT(*)
FROM EMP
GROUP BY ename, empno; --COUNT가 의미가 없어짐

--실습 ANA0
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



--ana0을 분석함수로
SELECT ename, sal, deptno,
        RANK() OVER(PARTITION BY deptno ORDER BY sal) rank, --PARTITION BY 부서를 기준으로 나눈다
        DENSE_RANK() OVER(PARTITION BY deptno ORDER BY sal) dense_rank,
        ROW_NUMBER() OVER(PARTITION BY deptno ORDER BY sal) row_rank
FROM emp;

--실습ANA1
SELECT empno, ename, sal, deptno,
        RANK() OVER(ORDER BY sal DESC, empno) sal_rank, --PARTITION BY 뺄 수 있음
        DENSE_RANK() OVER(ORDER BY sal DESC, empno) sal_dense_rank,
        ROW_NUMBER() OVER(ORDER BY sal DESC, empno) sal_row_rank
FROM emp;

--실습 no_ana2

SELECT a.*, b.cnt
FROM
    (SELECT empno, ename, deptno
    FROM emp) a,
    (SELECT deptno, COUNT(*) cnt
    FROM emp
    GROUP BY deptno) b
WHERE a.deptno = b.deptno
ORDER BY a.deptno;

--위 쿼리보다 더 단순한 쿼리
SELECT emp.empno, emp.ename, emp.deptno, a.cnt
FROM emp,
    (SELECT deptno, COUNT(*) cnt
    FROM emp
    GROUP BY deptno) a
WHERE a.deptno = emp.deptno
ORDER BY emp.deptno;


--사원번호, 사원이름, 부서번호, 부서의 직원
SELECT empno, ename, deptno,
        COUNT(*) OVER (PARTITION BY deptno) cnt --COUNT(*) 자리에 다른 집계함수 사용 가능
FROM emp;


--실습ana2
SELECT empno, ename, sal, deptno,
       ROUND(AVG(sal) OVER (PARTITION BY deptno), 2) cnt
FROM emp;


--실습ana3
SELECT empno, ename, sal, deptno,
        MAX(sal) OVER (PARTITION BY deptno) max_sal
FROM emp;


--실습ana4
SELECT empno, ename, sal, deptno,
        MIN(sal) OVER (PARTITION BY deptno) min_sal
FROM emp;

--전체사원을 대상으로 급여순위가 자신보다 한단계 낮은 사람의 급여
--급여가 같을 경우 입사일자가 빠른 사람이 높은 순위
SELECT empno, ename, hiredate, sal,
        LEAD(sal) OVER (ORDER BY sal DESC, hiredate) lead_sal 
FROM emp;

--실습ana5
SELECT empno, ename, hiredate, sal,
        LAG(sal) OVER (ORDER BY sal DESC, hiredate) lead_sal
FROM emp;

--실습ana6
SELECT empno, ename, hiredate, job, sal,
        LAG(sal) OVER (PARTITION BY job ORDER BY sal DESC, hiredate) lag_sal
FROM emp;


--실습no_ana3
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