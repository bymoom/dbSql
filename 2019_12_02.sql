--OUTER join : 조인 연결에 실패 하더라도 기준이 되는 테이블의 데이터는 나오도록 하는 join
--LEFT OUTER JOIN : 테이블1 LEFT OUTER JOIN 테이블2
--테이블1과 테이블2를 조인할때 조인에 실패하더라도 테이블1쪽의 데이터는 조회가 되도록 한다
--조인에 실패한 행에서 테이블2의 컬럼값은 존재하지 않으므로 NULL로 표시된다

--ANSI
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e LEFT OUTER JOIN emp m
            ON (e.mgr = m.empno);
            
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e JOIN emp m
            ON (e.mgr = m.empno);
            
--조
SELECT e.empno, e.ename, m.empno, m.ename , e.deptno, m.deptno --m 테이블의 부서번호 10번만 나오고 나머지는 null
FROM emp e LEFT OUTER JOIN emp m
            ON (e.mgr = m.empno) --'AND m.deptno=10'로 쓰면 null 값도 다 나옴
WHERE m.deptno=10; --where절에 'm.deptno=10'를 쓰면 null값은 다 빼버림

--ORACLE outer join syntax
--일반(ANSI)조인과 차이점은 WHERE절 컬럼명에 (+)을 입력한다
--(+)표시 : 데이터가 존재하지 않는데 나와야 하는 테이블의 컬럼
--ANSI에서는 직원 LEFT OUTER JOIN 매니저
--              ON(직원.매니저번호 = 매니저.직원번호)
--ORACLE OUTER에서는 WHERE 직원.매니저번호 = 매니저.직원번호(+) --매니저쪽 데이터가 존재하지 않을때
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno(+);

--매니저 부서번호 제한
--ANSI SQL에서 WHERE 절에 기술한 형태
--OUTER 조인이 적용되지 않은 상황(null값이 아닌 결과만 나옴)
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno(+)
AND m.deptno = 10;

--ANSI SQL의 ON절에 기술한 경우와 동일
--아우터 조인이 적용되어야 하는 테이블의 모든 컬럼에 (+)가 붙어야 한다.(모든 결과가 나옴)
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno(+)
AND m.deptno(+) = 10;

--emp 테이블에는 14명의 직원이 있고 14명은 10, 20, 30번 부서가 존재
--하지만 dept 테이블에는 10, 20, 30, 40번 부서가 존재
--부서번호, 부서명, 해당부서에 속한 직원수가 나오도록 쿼리를 작성
SELECT *
FROM emp;
SELECT *
FROM dept;

--ORACLE
SELECT dept.deptno, dname, NVL(emp_cnt.cnt, 0) cnt
FROM dept, 
    (SELECT deptno, COUNT(*) cnt
    FROM emp
    GROUP BY deptno) emp_cnt
WHERE dept.deptno = emp_cnt.deptno(+); --40번 부서 정보가 emp에 저장되어 있지 않기 때문에 (+)를 emp에 붙임

--ANSI SQL
SELECT dept.deptno, dname, NVL(emp_cnt.cnt, 0) cnt
FROM dept LEFT OUTER JOIN
    (SELECT deptno, COUNT(*) cnt
    FROM emp
    GROUP BY deptno) emp_cnt
    ON(dept.deptno = emp_cnt.deptno);
    
SELECT dept.deptno, dept.dname, COUNT(*) cnt, COUNT(emp.deptno) cnt --(숫자)값이 아닌 (행)수를 더할때는 COUNT(*)
FROM emp, dept
WHERE emp.deptno(+) = dept.deptno
GROUP BY dept.deptno, dept.dname;

--RIGHT OUTER JOIN
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e RIGHT OUTER JOIN emp m
            ON (e.mgr = m.empno);
            
--FULL OUTER JOIN <-ORACLE에는 FULL OUTER기능이 없다
--LEFT OUTER + RIGHT OUTER - 중복데이터 한건만 남긴다

--outerjoin1
SELECT *
FROM buyprod;
SELECT *
FROM prod;

--ORACLE
SELECT TO_CHAR(buyprod.buy_date, 'YY/MM/DD'), buyprod.buy_prod, prod.prod_id, prod.prod_name, buyprod.buy_qty
FROM buyprod, prod
WHERE buyprod.buy_date(+) = TO_DATE('050125', 'YYMMDD')
AND prod.prod_id = buyprod.buy_prod(+);

SELECT TO_CHAR(buyprod.buy_date, 'YY/MM/DD'), buyprod.buy_prod, prod.prod_id, prod.prod_name, buyprod.buy_qty
FROM buyprod, prod
WHERE buyprod.buy_date(+) = TO_DATE('050125', 'YYMMDD')
AND prod.prod_id = buyprod.buy_prod(+);

--ANSI
SELECT TO_CHAR(buyprod.buy_date, 'YY/MM/DD') buy_date, buyprod.buy_prod, prod.prod_id, prod.prod_name, buyprod.buy_qty
FROM buyprod RIGHT OUTER JOIN prod
ON (buyprod.buy_date = TO_DATE('050125', 'YYMMDD') --TO_DATE(:yyymmdd, 'YYYYMMDD') -> 바인드변수
    AND prod.prod_id = buyprod.buy_prod);

--outerjoin2
SELECT NVL(TO_CHAR(buy_date, 'YY/MM/DD'), '05/01/25') buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM buyprod RIGHT OUTER JOIN prod ON (buyprod.buy_prod = prod.prod_id)
AND buy_date = TO_DATE('05/01/25', 'YY/MM/DD');

--outerjoin3
SELECT NVL(TO_CHAR(buy_date, 'YY/MM/DD'), '05/01/25'), buy_prod, prod_id, prod_name, NVL (buy_qty, 0)
FROM buyprod RIGHT JOIN prod ON (buyprod.buy_prod = prod.prod_id)
AND buy_date = TO_DATE('05/01/25', 'YY/MM/DD');

--outerjoin4
SELECT *
FROM cycle;
SELECT *
FROM product;

--ANSI
SELECT product.pid, product.pnm, NVL(cycle.cid, 1) cid, NVL(cycle.day, 0) day, NVL(cycle.cnt, 0) cnt
FROM cycle RIGHT OUTER JOIN product ON (cycle.pid = product.pid)
AND cycle.cid = '1';

--ORACLE
SELECT product.pid, product.pnm, NVL(cycle.cid, 1) cid, --('NVL(cycle.cid, 1) cid'대신 바인드변수 ':cid' 사용가능),
        NVL(cycle.day, 0) day, NVL(cycle.cnt, 0) cnt
FROM cycle, product
WHERE cycle.pid(+) = product.pid
AND cycle.cid(+) = '1'; --('1'대신 바인드변수 ':cid' 사용가능)

--outerjoin5
SELECT product.pid, product.pnm, NVL(cycle.cid, 1) cid, NVL(customer.cnm, 'brown'), NVL(cycle.day, 0) day, NVL(cycle.cnt, 0) cnt
FROM cycle, product, customer
WHERE cycle.pid(+) = product.pid
AND customer.cid(+) = cycle.cid
AND cycle.cid(+) = '1'
ORDER BY pid desc;

--((product cycle(+)) customer(+) --인라인뷰 사용
SELECT a.pid, a.pnm, a.cid, customer.cnm, a.day, a.cnt 
FROM
    (SELECT product.pid, product.pnm, :cid cid, --('NVL(cycle.cid, 1) cid'대신 바인드변수 ':cid' 사용가능),
            NVL(cycle.day, 0) day, NVL(cycle.cnt, 0) cnt
    FROM cycle, product
    WHERE cycle.cid(+) = :cid
    AND cycle.pid(+) = product.pid) a, customer
WHERE a.cid = customer.cid; --('1'대신 바인드변수 ':cid' 사용가능)

--crossjoin1
--ORACLE
SELECT cid, cnm, pid, pnm
FROM customer, product;

--ANSI
SELECT cid, cnm, pid, pnm
FROM customer CROSS JOIN product;

--도시발전지수 --
--도시발전지수가 높은 순으로 나열
--도시발전지수 = (버거킹개수 + KFC 개수 + 맥도날드 개수) / 롯데리아 개수
--순위 / 시도 / 시군구 / 도시발전지수(소수점 둘째 자리에서 반올림)
-- 1  /서울특별시/서초구/7.5
-- 2  /서울특별시/강남구/7.2

--해당 시도, 시군구별 프렌차이즈별 건수가 필요
SELECT ROWNUM rn, d.*
FROM
    (SELECT sido, sigungu, 도시발전지수
    FROM
        (SELECT a.sido, a.sigungu, ROUND((a.cnt/b.cnt), 1) as 도시발전지수 --'a.cnt, b.cnt'는 조회후 뺐음
        FROM
            (SELECT sido, sigungu, COUNT(*) cnt --버거킹, KFC, 맥도날드 건수
            FROM fastfood
            WHERE gb IN('KFC', '버거킹', '맥도날드')
            GROUP BY sido, sigungu) a,

            (SELECT sido, sigungu, COUNT(*) cnt --롯데리아 건수
            FROM fastfood
            WHERE gb = '롯데리아'
            GROUP BY sido, sigungu) b
        WHERE a.sido = b.sido
        AND a.sigungu = b.sigungu) c
    ORDER BY 도시발전지수 desc) d
ORDER BY rn;

SELECT *
FROM fastfood;

SELECT ROWNUM rn, d.*
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
            AND a.sigungu = b.sigungu) c
        ORDER BY 도시발전지수 desc) d
ORDER BY rn;

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
