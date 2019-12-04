SELECT d.*, e.*
FROM
(SELECT ROWNUM rn, c.*
FROM
        (SELECT sido, sigungu, 도시발전지수
        FROM
            (SELECT a.sido, a.sigungu, ROUND((a.cnt/b.cnt), 1) 도시발전지수
            FROM
                    (SELECT sido, sigungu, COUNT(*) cnt
                    FROM fastfood
                    WHERE gb IN ('맥도날드', '버거킹', 'KFC')
                    GROUP BY sido, sigungu) a,
                    
                    (SELECT sido, sigungu, COUNT(*) cnt
                    FROM fastfood
                    WHERE gb = '롯데리아'
                    GROUP BY sido, sigungu) b
            WHERE a.sido = b.sido
            AND a.sigungu = b.sigungu)
            ORDER BY 도시발전지수 desc) c
            ORDER BY rn)d,
            
            (SELECT ROWNUM rn, sido, sigungu, cal_sal
            FROM
                (SELECT sido, sigungu, sal, people, ROUND((sal/people), 1) cal_sal
                 FROM tax
                 ORDER BY cal_sal)) e
WHERE d.rn(+) = e.rn
ORDER BY e.rn;


--도시발전지수 시도, 시군구와 연말정산 납입금액의 시도, 시군구가 같은 지역끼리 조인
--정렬 순서는 tax 테이블의 id컬럼순으로 정렬
SELECT d.*, e.*
FROM
(SELECT ROWNUM rn, c.*
FROM
        (SELECT sido, sigungu, 도시발전지수
        FROM
            (SELECT a.sido, a.sigungu, ROUND((a.cnt/b.cnt), 1) 도시발전지수
            FROM
                    (SELECT sido, sigungu, COUNT(*) cnt
                    FROM fastfood
                    WHERE gb IN ('맥도날드', '버거킹', 'KFC')
                    GROUP BY sido, sigungu) a,
                    
                    (SELECT sido, sigungu, COUNT(*) cnt
                    FROM fastfood
                    WHERE gb = '롯데리아'
                    GROUP BY sido, sigungu) b
            WHERE a.sido = b.sido
            AND a.sigungu = b.sigungu)
            ORDER BY 도시발전지수 desc) c
            ORDER BY rn)d,
            
            (SELECT ROWNUM rn, id, sido, sigungu, cal_sal
            FROM
                (SELECT id, sido, sigungu, sal, people, ROUND((sal/people), 1) cal_sal
                 FROM tax
                 ORDER BY cal_sal)) e
WHERE d.sido(+) = e.sido
AND d.sigungu(+) = e.sigungu
ORDER BY e.id;

UPDATE TAX SET SIGUNGU = TRIM(SIGUNGU);
COMMIT;


--AND c.sido = a.sido(+)
--            AND c.sigungu = a.sigungu(+
--1. tax 테이블을 이용 시도/시군구별 인당 연말정산 신고액 구하기
--2. 신고액이 많은 순서로 랭킹 부여하기
--랭킹, 시도, 시군구, 인당연말정산 신고액
SELECT *
FROM TAX;

SELECT ROWNUM rn, a.*
FROM
    (SELECT sido, sigungu, ROUND((sal/people), 1) sal
    FROM tax
    ORDER BY sal desc) a
ORDER BY rn;

SELECT sido, sigungu, sal, people, ROUND((sal/people), 1) sal
FROM tax
ORDER BY 5 desc; --컬럼 순서 번호를 입력해도 가능하다.

UPDATE tax SET PEOPLE = 70391
WHERE SIDO = '대전광역시'
AND SIGUNGU = '동구';
COMMIT;




--서브쿼리
--SMITH가 속한 부서 찾기 --> 20
SELECT deptno
FROM emp
WHERE ename = 'SMITH';

--WHERE절에서 쓰는 ()괄호안을 서브쿼리라고 한다
SELECT *
FROM emp
WHERE deptno = (SELECT deptno
                FROM emp
                WHERE ename = 'SMITH');

--서브쿼리의 결과가 여러개일때
SELECT *
FROM emp
WHERE deptno IN (SELECT deptno
                FROM emp);

--SCALAR SUBQOUERY
--SELECT 절에 표현된 서브쿼리
SELECT empno, ename, deptno, (SELECT dname FROM dept WHERE dept.deptno = emp.deptno) dname
FROM emp;

--한 행, 한 column을 조회해야 한다
SELECT empno, ename, deptno, (SELECT dname FROM dept) dname
FROM emp;

--INLIN VIEW
--FROM절에 사용되는 서브 쿼리

--SUBQUERY
--WHERE에 사용되는 서브 쿼리

--SUB1 : 평균 급여보다 높은 급여를 받는 사원의 건수
SELECT *
FROM emp;

SELECT AVG(sal) --평균 구하는 방법
FROM emp;

SELECT COUNT(*)
FROM emp
WHERE sal > (SELECT AVG(sal)
             FROM emp);
             
--sub2 : 평균 급여보다 높은 급여를 받는 직원의 정보
SELECT *
FROM emp
WHERE sal > (SELECT AVG(sal)
             FROM emp);
             
--sub3
SELECT *
FROM emp
WHERE deptno IN (SELECT deptno
                FROM emp
                WHERE ename IN ('SMITH', 'WARD'));

--deptno가 클때는 30번 부서에 속한 사원들이 나옴(20보다 큰 사원이 나옴)
--deptno가 작을때는 10,20부서에 속한 사원들이 나옴.(10보다 큰 사원이 나옴)                  
SELECT *
FROM emp
WHERE deptno < ANY (SELECT deptno
                    FROM emp
                    WHERE ename IN ('SMITH', 'WARD'));

--deptno가 작을땐 20, 30번 부서 제외하고 10번 부서만 나옴
--deptno가 클땐 아무것도 안나온다
SELECT *
FROM emp
WHERE deptno > ALL (SELECT deptno
                    FROM emp
                    WHERE ename IN ('SMITH', 'WARD'));

--SMITH 혹은 WARD보다 급여를 적게 받는 직원 조회
SELECT *
FROM emp
WHERE sal < ANY (SELECT sal --800, 1250 = 1250보다 작은 사원
                 FROM emp
                 WHERE ename IN ('SMITH', 'WARD'));

SELECT *
FROM emp
WHERE sal <= ALL (SELECT sal --800, 1250 ('<='도 가능 : 800보다 크거나 같은 사원)
                 FROM emp
                 WHERE ename IN ('SMITH', 'WARD'));
                 
--관리자 역할을 하지 않는 사원 정보 조회
--NOT IN 연산자 사용시 NULL이 데이터에 존재하지 않아야 정상동작한다(NULL이 있음 결과가 전혀 나오지 않기때문에 NVL로 값을 변경한다)
SELECT *
FROM emp --사원 정보 조회 --> 관리자 역할을 하지 않는 직원
WHERE empno NOT IN (SELECT NVL(mgr, -1) --mgr컬럼에 절대 없을만한 값을 넣어야한다
                    FROM emp);

SELECT *
FROM emp --사원 정보 조회 --> 관리자 역할을 하지 않는 직원
WHERE empno NOT IN (SELECT mgr --mgr컬럼에 절대 없을만한 값을 넣어야한다
                    FROM emp
                    WHERE mgr IS NOT null);
                    
--관리자인 사원
SELECT *
FROM emp
WHERE empno IN (SELECT mgr
                FROM emp);
                
                
--pair wise (여러 컬럼의 값을 동시에 만족해야하는 경우)
--ALLEN, CLARK의 매니저와 부서번호가 동시에 같은 사원 정보 조회

--'NON' PAIR WISE인 경우
-- (7698, 30)
-- (7839, 10)
SELECT *
FROM emp
WHERE (mgr, deptno) IN (SELECT mgr, deptno
                        FROM emp
                        WHERE empno IN (7499, 7782));

--PAIR WISE인 경우 
--7698, 10
--7698, 30
--7839, 10
--7839, 10
SELECT *
FROM emp
WHERE mgr IN (SELECT mgr
              FROM emp
              WHERE empno IN (7499, 7782))                        
AND deptno IN (SELECT deptno
               FROM emp
               WHERE empno IN (7499, 7782));
               


--비상호 연관 서브 쿼리
--메인쿼리의 컬럼을 서브쿼리에서 사용하지 않는 형태의 서브 쿼리

--비상호 연관 서브쿼리의 경우 메인쿼리에서 사용하는 테이블, 서브쿼리 조회 순서를 성능적으로 유리한쪽으로 판단하여 순서를 결정한다
--메인쿼리의 emp테이블을 먼저 읽을수도 있고, 서브쿼리의 emp테이블을 먼저 읽을 수도 있다

--비상호 연관 서브쿼리에서 서브쿼리쪽 테이블을 먼저 읽을 때는 서브쿼리가 제공자역할을 했다(고 어떤 저자가 말함)
--비상호 연관 서브쿼리에서 서브쿼리쪽 테이블을 나중에 읽을 때는 서브쿼리가 확인자역할을 했다(고 어떤 저자가 말함)

--직원의 급여 평균보다 높은 급여를 받는 직원 정보 조회
--직원의 급여 평균
SELECT *
FROM emp
WHERE sal > (SELECT AVG(sal) --서브쿼리가 따로 작동한다
             FROM emp);
             
--상호 연관 서브 쿼리
--해당직원이 속한 부서의 급여평균보다 높은 급여를 받는 직원 조회

SELECT *
FROM emp m
WHERE sal > (SELECT AVG(sal)
            FROM emp
            WHERE deptno = m.deptno);