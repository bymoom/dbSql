INSERT INTO dept VALUES (99, 'ddit', 'daejeon');
COMMIT;

--sub4.직원이 존재하지 않는 부서정보
SELECT *
FROM dept
WHERE deptno NOT IN (SELECT deptno
                     FROM emp);

--sub5
SELECT *
FROM product
WHERE  pid NOT IN (SELECT pid
                    FROM cycle
                    WHERE cid = 1);

--sub6
SELECT *
FROM cycle
WHERE cid = 1
AND pid IN (SELECT pid
                FROM cycle
                WHERE cid = 2);
                
--sub7
SELECT *
FROM customer;
SELECT *
FROM product;
SELECT *
FROM cycle;

SELECT cycle.cid, customer.cnm, cycle.pid, product.pnm, cycle.day, cycle.cnt
FROM cycle, customer, product
WHERE cycle.cid = customer.cid
AND cycle.pid = product.pid
AND cycle.cid = 1
AND cycle.pid IN (SELECT pid
                FROM cycle
                WHERE cid = 2);
                

--매니저가 존재하는 직원 정보 조회
SELECT *
FROM emp e --사원정보 확인
WHERE EXISTS (SELECT 1
                FROM emp m --매니저정보 확인
                WHERE m.empno = e.mgr); --EXISTS는 서브쿼리에 있는 정보가 한가지라도 참이면 값이 모두 나온다

--sub8
SELECT *
FROM emp
WHERE mgr IS NOT NULL;

SELECT e.* --e로 할때, m으로 할때의 결과값이 다르다*****************************************
FROM emp e, emp m
WHERE e.mgr = m.empno;

--sub9
SELECT *
FROM cycle;
SELECT *
FROM product p
WHERE EXISTS (SELECT 'x'
            FROM cycle c
            WHERE c.pid = p.pid AND c.cid = 1);

--sub10            
SELECT *
FROM product p
WHERE NOT EXISTS --서브쿼리의 정보가 아닌것이 출력됨
               (SELECT 'x'
                FROM cycle c
                WHERE c.pid = p.pid
                AND c.cid = 1);
            

--집합 연산
--UNION : 합집합, 두 집합의 중복건을 제거한다
--담당업무가 SALES인 직원번호, 직원 이름 조회
--위아래의 결과셋이 동일하기 때문에 합집합 연산을 하게 될 경우 중복되는 데이터는 한번만 표현한다.
SELECT empno, ename
FROM emp
WHERE job = 'SALESMAN'
UNION
SELECT empno, ename
FROM emp
WHERE job = 'SALESMAN';

--서로 다른 집합의 합집합
SELECT empno, ename
FROM emp
WHERE job = 'SALESMAN'
UNION
SELECT empno, ename
FROM emp
WHERE job = 'CLERK';

--UNION ALL
--합집합 연산시 중복 제거를 하지 않는다
--위아래 결과 셋을 붙여 주기만 한다
SELECT empno, ename
FROM emp
WHERE job = 'SALESMAN'
UNION ALL
SELECT empno, ename
FROM emp
WHERE job = 'SALESMAN';

--집합연산시 집합셋의 컬럼이 동일 해야한다
--컬럼의 개수가 다를 경우 임의 값을 넣는 방식으로 개수를 맞춰준다
SELECT empno, ename, '' --컬럼개수를 임의로 맞춤
FROM emp
WHERE job = 'SALESMAN'
UNION ALL
SELECT empno, ename, job
FROM emp
WHERE job = 'SALESMAN';

--INTERSECT : 교집합
--두 집합간 공통적인 데이터만 조회
SELECT empno, ename
FROM emp
WHERE job IN ('SALESMAN', 'CLERK')
INTERSECT
SELECT empno, ename
FROM emp
WHERE job IN ('SALESMAN');

--MINUS
--차집합 : 위, 아래 집합의 교집합을 위 집합에서 제거한 집합을 조회
--차집합의 경우 합집합, 교집합과 다르게 집합의 선언 순서가 결과 집합에 영향을 준다
SELECT empno, ename
FROM emp
WHERE job IN ('SALESMAN', 'CLERK')
MINUS
SELECT empno, ename
FROM emp
WHERE job IN ('SALESMAN'); --결과가 'CLERK'만 나옴

--UNION ALL일 때 첫번째 집합을 ORDER BY하려면 인라인뷰를 사용해야한다
SELECT *
FROM
(SELECT empno, ename
FROM emp
WHERE job IN ('SALESMAN', 'CLERK')
ORDER BY job)
UNION ALL
SELECT empno, ename
FROM emp
WHERE job IN ('SALESMAN');

--DML
--INSERT : 테이블에 새로운 데이터를 입력
SELECT *
FROM dept;
DELETE dept --삭제할때 조심할것. 여기에 ; 입력하면 전체가 삭제됨
WHERE deptno = 99;
COMMIT;

--INSERT시 컬럼을 나열한 경우
--나열한 컬럼에 맞춰 입력할 값을 동일한 순서로 기술한다
--INSERT INTO 테이블명 (컬럼1, 컬럼2...)
            --VALUES (값1, 값2...)
--dept 테이블에 99번 부서번호, ddit 조직명, daejeon 지역명을 갖는 데이터 입력
INSERT INTO dept (deptno, dname, loc)
            VALUES (99, 'ddit', 'daejeon');
ROLLBACK;

SELECT *
FROM dept;

--컬럼을 기술할 경우 테이블의 컬럼 정의 순서와 다르게 나열해도 상관이 없다(대신 values의 순서는 입력한 컬럼 순서와 맞춰야함)
--기존 dept 테이블의 컬럼 순서 : deptno, dname, loc
INSERT INTO dept (loc, deptno, dname)
            VALUES ('daejeon', 99, 'ddit');
ROLLBACK;

--컬럼을 기술하지 않을 수도 있다 : 테이블의 컬럼 정의 순서에 맞춰 값을 기술한다
DESC dept; --dept테이블의 컬럼명 순서 확인
INSERT INTO dept VALUES (99, 'ddit', 'daejeon');

--날짜 값 입력하기
--1.SYSDATE
--2.사용자로부터 받은 문자열을 DATE 타입으로 변경하여 입력
DESC emp;
INSERT INTO emp VALUES (9998, 'sally', 'SALESMAN', NULL, SYSDATE, 500, NULL, NULL);

SELECT *
FROM emp;

--2019년 12월 2일 입사
INSERT INTO emp VALUES (9997, 'james', 'CLERK', NULL, TO_DATE('20191202', 'YYYYMMDD'), 500, NULL, NULL);

ROLLBACK;

--여러건의 데이터를 한번에 입력
--SELECT 결과를 테이블에 입력 할 수 있다
INSERT INTO emp
SELECT 9998, 'sally', 'SALESMAN', NULL, SYSDATE, 500, NULL, NULL
FROM dual
UNION ALL
SELECT 9997, 'james', 'CLERK', NULL, TO_DATE('20191202', 'YYYYMMDD'), 500, NULL, NULL
FROM dual;

ROLLBACK;
