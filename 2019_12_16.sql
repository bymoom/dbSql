--GROUPING SETS(col1, col2)
--개발자가 GROUP BY의 기준을 직접 명시한다
--ROLLUP과 달리 방향성을 갖지 않는다
--GROUPING SETS(col1, col2) = GROUPING SETS(col2, col1)
--다음과 결과가 동일하다
--GROUP BY col1
--UNION ALL
--GROUP BY col2

--emp테이블에서 직원의 job별 급여(sal) + 상여(comm)함
--                 deptno(부서)별 급여(sal) + 상여(comm)함 구하기
--기존방식(GROUP FUNCTION) : 2번의 SQL 작성 필요(UNION / UNION ALL)
SELECT job, SUM(sal + NVL(comm, 0)) sal_comm_sum
FROM emp
GROUP BY job
UNION ALL --두 테이블을 UNION ALL하려면 deptno를 문자열로 치환('' || deptno)하거나 위 테이블에 null deptno를 입력해야한다
SELECT '' || deptno, SUM(sal + NVL(comm, 0)) sal_comm_sum
FROM emp
GROUP BY deptno;

--GROUPING SETS 구문을 이용하여 위의 SQL을 집합연산을 사용하지 않고 테이블을 한번 읽어서 처리
SELECT job, deptno, SUM(sal + NVL(comm, 0)) sal_comm_sum
FROM emp
GROUP BY GROUPING SETS (job, deptno); --다른 그룹함수와는 달리 총계 안나옴

--job, deptno를 그룹으로 한 sal+comm 합
--mgr을 그룹으로한 sal+comm 합
--GROUP BY job, deptno
--UNION ALL
--GROUP BY mgr
-- --> GROUPING SETS((job, deptno), mgr)
SELECT job, deptno, mgr, SUM(sal + NVL(comm, 0)) sal_comm_sum,
        GROUPING(job), GROUPING(deptno), GROUPING(mgr) --GROUPING을 사용해서 KING 값이 총계인지 확인한다
FROM emp
GROUP BY GROUPING SETS ((job, deptno), mgr);

--CUBE (col1, col2 ...)
--나열된 컬럼의 모든 가능한 조합으로 GROUP BY subset을 만든다
--CUBE에 나열된 컬럼이 2개인 경우 : 가능한 조합 4개
--CUBE에 나열된 컬럼이 3개인 경우 : 가능한 조합 8개
--CUBE에 나열된 컬럼수를 2의 제곱승 한 결과가 가능한 조합 개수가 된다(2^n)
--컬럼이 조금만 많아져도 가능한 조합이 기하급수적으로 늘어나기 때문에 많이 사용하지 않는다

--job, deptno를 이용하여 CUBE 적용
SELECT job, deptno, SUM(sal + NVL(comm, 0)) sal_comm_sum
FROM emp
GROUP BY CUBE(job, deptno);
--job, detpno
--1, 1 --> GROUP BY job, deptno
--1, 0 --> GROUP BY job
--0, 1 --> GROUP BY deptno
--0, 0 --> GROUP BY --emp테이블의 모든 행에 대해 GROUP BY

--GROUP BY 응용
--GROUP BY, ROLLUP, CUBE를 섞어 사용하기
--가능한 조합을 생각해보면 쉽게 결과를 예측할 수 있다
--GROUP BY job, rollup(deptno), cube(mgr)

SELECT job, deptno, mgr, SUM(sal + NVL(comm, 0)) sal_comm_sum
FROM emp
GROUP BY job, ROLLUP(deptno), CUBE(mgr);
-->GROUP BY job, deptno, mgr + job, mgr + job, deptno + job -->job을 default로 해놨기 때문에 총계는 안나온다

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
SET empcnt = (SELECT COUNT(emp.deptno) -- COUNT(*)로 쓰면됨
            FROM emp
            WHERE dept_test.deptno = emp.deptno);

--------------------------          
INSERT INTO dept_test VALUES (99, 'it1', 'daejeon');
INSERT INTO dept_test VALUES (98, 'it2', 'daejeon');

DELETE FROM dept_test --from은 있어도 되고 없어도 됨
WHERE deptno NOT IN (SELECT deptno
                    FROM emp
                    WHERE emp.deptno = dept_test.deptno); --WHERE절 빠져도됨
                    

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


--MERGE 구문을 이용한 업데이트 
MERGE INTO emp_test a
USING (SELECT deptno, ROUND(AVG(sal), 2) avg_sal
       FROM emp_test
       GROUP BY deptno) b
ON ( a.deptno = b.deptno )
WHEN MATCHED THEN
    UPDATE SET sal = sal + 200
WHERE a.sal < b.avg_sal; --(ON절에 기술한 컬럼은 업데이트할 수 없기때문에 where 절 사용)

--MERGE에 CASE절 사용
MERGE INTO emp_test a
USING (SELECT deptno, ROUND(AVG(sal), 2) avg_sal
       FROM emp_test
       GROUP BY deptno) b
ON ( a.deptno = b.deptno)
WHEN MATCHED THEN
    UPDATE SET sal = CASE --동일한 값도 업데이트하기 때문에 위 쿼리와 다르게 14개 행 병합됨
                        WHEN a.sal < b.avg_sal THEN sal + 200
                        ELSE sal
                    END;
                    
                    