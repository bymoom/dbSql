SELECT *
FROM emp_test
ORDER BY empno;

--emp테이블에 존재하는 데이터를 emp_test 테이블로 머지
--만약 empno가 동일한 데이터가 존재하면 ename update : enama || '_merge'
--만약 empno가 동일한 데이터가 존재하지 않을 경우 emp테이블의 empno, ename를 emp_test 데이터로 insert

--emp_test 데이터에서 절반의 데이터를 삭제
DELETE emp_test
WHERE empno >= 7788;
COMMIT;


--emp테이블에는 14건의 데이터가 존재
--emp_test 테이블에는 사번지 7788보다 작은 7명의 데이터가 존재
--emp테이블을 이용하여 emp_test 테이블을 머지하게되면
--emp테이블에만 존재하는 직원(사번이 7788보다 크거나 같은) 7명
--emp_test로 새롭게 insert가 될 것이고
--emp, emp_test에 사원번호가 동일하게 존재하는 7명의 데이터는
--(사번이 7788보다 작은 직원)ename컬럼을 ename || '_modify'로 업데이트 한다

/*
MERGE INTO 테이블명
USION 머지대상 테이블|VIEW|SUBQUERY
ON (테이블명과 머지대상의 연결관계)
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


--emp_test 테이블에 사번이 9999인 데이터가 존재하면
--ename을 'brown'으로 update
--존재하지 않을 경우 empno, ename VALUES (9999, 'brown')으로 insert
--위의 시나리오를 MERGE 구문을 활용하여 한번의 SQL로 구현
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

--만약 merge 구문이 없다면 아래를 다 실행해야한다
-- 1. empno = 9999인 데이터가 존재하는지 확인
-- 2-1. 1번사항에서 데이터가 존재하면 UPDATE
-- 2-2. 1번사항에서 데이터가 존재하지 않으면 INSERT

SELECT a.deptno, SUM(a.sal)
FROM (SELECT deptno, SUM(sal) sal
        FROM emp
        GROUP BY deptno) a
GROUP BY deptno
ORDER BY deptno;

--UNION ALL을 사용한 그룹화
SELECT deptno, SUM(sal) sal
FROM emp
GROUP BY deptno
UNION ALL
SELECT null, SUM(sal) --그룹화와 관련없는 상수를 입력할 수 있다(NULL)
FROM emp
ORDER BY deptno;

--JOIN 방식으로 그룹화 (묻지마조인)
--emp 테이블의 14건에 데이터를 28건으로 생성
--구분자(1-14건, 2-14건)를 기준으로 group by
--구분자 1 : 부서번호 기준으로 row (14건)
--구분자 2 : 전체 row (14건)
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
--ROLLUP절에 기술된 컬럼을 오른쪽에서부터 지원 결과로
--SUB GROUP을 생성하여 여러개의 GROUP BY절을 하나의 SQL에서 실행되도록 한다
--GROUP BY ROLLUP(job, deptno)
--1. GROUP BY job, deptno -->한꺼번에 그룹화함
--2. GROUP BY job
--3. GROUP BY --> 전체 행을 대상으로 GROUP BY

--emp테이블을 이용하여 부서번호별, 전체 직원별 급여합을 구하는 쿼리를
--ROLLUP 기능을 이용하여 작성
SELECT deptno, SUM(sal) sal
FROM emp
GROUP BY ROLLUP(deptno);

--emp테이블을 이용하여 job, deptno 별 sal+comm합계
--                    job 별 sal+comm 합계
--                    전체직원의 sal+comm 합계
--ROLLUP을 활용하여 작성

SELECT job, deptno, SUM(sal + NVL(comm,0)) sal_sum --comm에 null이 있기때문에 값변경
FROM emp
--ROLLUP은 컬럼 순서가 조회 결과에 따라 영향을 미친다.
GROUP BY ROLLUP (job, deptno);
--1. GROUP BY job, deptno --> 한꺼번에 그룹화함
--2. GROUP BY job --> JOB을 기준으로 그룹화함
--3. GROUP BY --> 전체 ROW 대상
-->1, 2, 3의 모든 결과가 나온다

--실습 AD2
SELECT DECODE(GROUPING(job), 1, '총계', job) job, deptno, SUM(sal + NVL(comm,0)) sal
FROM emp
GROUP BY ROLLUP (job, deptno);

--AD2-1
SELECT DECODE(GROUPING(job), 1, '총', job) job,
        CASE
            WHEN deptno IS NULL AND job IS NULL THEN '계'
            WHEN deptno IS NULL AND job IS NOT NULL THEN '소계'
            ELSE '' || deptno --deptno를 문자열로 치환(TO_CHAR(deptno)도 가능)
        END,
        SUM(sal + NVL(comm, 0)) sal
FROM emp
GROUP BY ROLLUP (job, deptno);

--AD2-1을 DECODE로..
SELECT DECODE(GROUPING(job), 1, '총', job) job,
        DECODE(GROUPING(deptno) + DECODE(GROUPING(job), 2, '계', 1, '소계', deptno)),
--        DECODE(GROUPING(deptno), 1, DECODE(GROUPING(job), 1, '계', '소계'), deptno),
        SUM(sal + NVL(comm, 0)) sal
FROM emp
GROUP BY ROLLUP (job, deptno);

--실습ad3
SELECT deptno, job, SUM(sal + NVL(comm, 0)) sal
FROM emp
GROUP BY ROLLUP (deptno, job);

--UNION ALL로 치환
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

--실습 ad4
SELECT dname, job, sal
FROM dept, (SELECT job, SUM(sal + NVL(comm, 0)) sal, deptno
            FROM emp
            GROUP BY ROLLUP (deptno, job)) a
--WHERE dept.deptno = a.deptno; -->조인에 실패함(총계가 안나옴)
WHERE dept.deptno(+) = a.deptno; --OUTER JOIN을 해야함

SELECT dname, job, SUM(sal + NVL(comm, 0)) sal
FROM emp, dept
WHERE emp.deptno = dept.deptno
GROUP BY ROLLUP (dname, job);

--실습 ad5
SELECT DECODE(GROUPING(dname), 1, '총합', dname) dname, job, SUM(sal + NVL(comm, 0)) sal
FROM emp, dept
WHERE emp.deptno = dept.deptno
GROUP BY ROLLUP (dname, job);