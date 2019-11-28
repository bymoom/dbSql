--emp 테이블, dept 테이블 조인

EXPLAIN PLAN FOR
SELECT ename, emp.deptno, dept.dname --emp테이블의 deptno와 dept테이블의 dname을 결합한다
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND emp.deptno=10; --두 테이블간의 연결고리

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

SELECT ename, emp.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno != dept.deptno --emp테이블과 dept테이블의 데이터가 다른 경우 연결
AND emp.deptno=10; --deptno의 데이터를 10으로 바꾼다

SELECT ename, deptno
FROM emp;

SELECT deptno, dname
FROM dept;

--natural join : 조인 테이블간 같은 타입, 같은 이름의 컬럼으로 같은 값을 가질 경우 조인
DESC emp;
DESC dept;

ALTER TABLE emp DROP COLUMN dname;

--ANSI SQL
SELECT deptno, a.empno, ename --emp대신 별칭 a를 사용
FROM emp a NATURAL JOIN dept; --별칭 a

--oracle 문법
SELECT a.deptno, emp.empno, ename
FROM emp a, dept
WHERE a.deptno = dept.deptno;

--JOIN USING
--join 하려고 하는 테이블간 동일한 이름의 컬럼이 두개 이상일떄
--join 컬럼을 하나만 사용하고 싶을 때

--ANSI SQL
SELECT *
FROM emp JOIN dept USING (deptno); --deptno가 앞에 하나만 나온다

--ORACLE SQL
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno; --deptno가 따로 나온다

--ANSI JOIN with ON
--조인하고자 하는 테이블의 컬럼 이름이 다를떄
--개발자가 조인 조건을 직접 제어할 때

--ANSI
SELECT *
FROM emp JOIN dept ON (emp.deptno = dept.deptno);

--oracle
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;

--SELF JOIN : 같은 테이블간 조인
--emp 테이블간 조인 할만한 사항 : 직원의 관리자 정보 조회 //관리자 정보(mgr)의 번호와 사원번호(empno)가 같은 사람을 찾는다
--직원의 관리자 정보를 조회
--직원이름, 관리자 이름

--ANSI
SELECT e.ename, m.ename
FROM emp e JOIN emp m ON (e.mgr = m.empno); --emp e는 관리자정보(mgr), emp m은 그 관리자의 사원번호(deptno)

--ORACLE
SELECT e.ename, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno; --사원의 관리자 정보와 관리자의 사원번호가 같다

--직원이름, 직원의 상급자 이름, 직원의 상급자의 상급자 이름
SELECT e.ename, m.ename, t.ename
FROM emp e, emp m, emp t
WHERE e.mgr = m.empno
AND m.mgr = t.empno;

--직원의 관리자의 관리자의 관리자 이름
SELECT e.ename, m.ename, t.ename, k.ename
FROM emp e, emp m, emp t, emp k
WHERE e.mgr = m.empno
AND m.mgr = t.empno
AND t.mgr = k.empno;

--여러테이블을 ANSI JOIN을 이용한 JOIN
SELECT e.ename, m.ename, t.ename, k.ename
FROM emp e JOIN emp m ON (e.mgr = m.empno) --JOIN 테이블을 세개 사용할 수 없음
    JOIN emp t ON (m.mgr = t.empno)
    JOIN emp k ON (t.mgr = k.empno);

--직원의 이름과 해당 직원의 관리자 이름을 조회한다
--단 직원의 사번이 7369~7698인 직원을 대상으로 조회
SELECT *
FROM emp e, emp m
WHERE e.empno BETWEEN 7369 AND 7698
AND e.mgr = m.empno;

--ANSI
SELECT e.ename, m.ename
FROM emp e JOIN emp m ON (e.mgr = m.empno)
WHERE e.empno BETWEEN 7369 AND 7698;


--NON-EQUI JOIN : 조인 조건이 =(equal)이 아닌 JOIN (값이 다를 때 join하는 경우)
-- !=, BETWEEN AND
SELECT *
FROM salgrade;

SELECT empno, ename, sal /*급여 grade */
FROM emp;

--ORACLE
SELECT empno, ename, sal, grade
FROM emp, salgrade
WHERE emp.sal BETWEEN salgrade.losal AND salgrade.hisal;
--WHERE emp.sal >= salgrade.losal //이렇게도 쓸수있음
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
AND (dept.deptno = 10 OR dept.deptno = 30); --AND가 OR보다 먼저 실행되기 때문에 괄호를 써야함
--AND emp.deptno IN (10, 30); //이것도 가능

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
--(참고)BETWEEN은 WHERE과 꼭 붙어있어야한다

--join0_4
SELECT empno, ename, sal, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND dname = 'RESEARCH'
AND sal > 2500 AND empno > 7600;
