SELECT *
FROM dept;

--dept 테이블에 부서번호 99, 부서명 ddit, 위치 daejeon

INSERT INTO dept VALUES (99, 'ddit', 'daejeon');
COMMIT;

--UPDATE : 테이블에 저장된 컬럼의 값을 변경
--UPDATE 테이블명 SET 컬럼명1 = 적용하려고하는 값1, 컬럼명2 = 적용하려고하는 값2...
--[WHERE row 조회 조건] --조회 조건에 해당하는 데이터만 업데이트 된다

--부서번호가 99번인 부서의 부서명을 대덕IT로, 지역을 영민빌딩으로 변경
UPDATE dept SET dname = '대덕IT', loc = '영민빌딩'
WHERE deptno = 99;

--업데이트전에 업데이트 하려고 하는 테이블을 WHERE절에 기술한 조건으로 SELECT를 하여 업데이트 대상 ROW를 확인해보자
SELECT *
FROM dept
WHERE deptno = 99;

--다음 QUERY를 실행하면 WHERE절에 ROW 제한 조건이 없기 때문에 dept테이블의 모든 행에 대해 부서명, 위치 정보를 수정한다
UPDATE dept SET dname = '대덕IT', loc = '영민빌딩';

--SUBQUERY를 이용한 UPDATE
--emp테이블에 신규 데이터 입력
--사원번호  9999, 사원이름 brown, 업무 : null
INSERT INTO emp (empno, ename) VALUES (9999, 'brown');
COMMIT;

SELECT *
FROM emp
WHERE empno=9999;

--사원번호가 9999인 사람의 소속 부서와, 담당업무를 SMITH사원의 부서, 업무로 업데이트
UPDATE emp SET deptno = (SELECT deptno FROM emp WHERE ename = 'SMITH'),
                job = (SELECT job FROM emp WHERE ename = 'SMITH')
WHERE empno = 9999;
COMMIT;

--DELETE : 조건에 해당하는 ROW를 삭제
--컬럼의 값을 삭제?? (NULL)값으로 변경하려면 --> UPDATE 사용해야함

--DELETE 테이블명
--[WHERE 조건]

--UPDATE쿼리와 마찬가지로 DELETE 쿼리 실행전에는 해당 테이블을 WHERE조건을 동일하게 하여 SELECT를 실행, 삭제될 ROW를 먼저 확인해보자
--emp테이블에 존재하는 사원번호 9999인 사원을 삭제
DELETE emp
WHERE empno = 9999;

COMMIT;

SELECT *
FROM emp;

--매니저가 7698인 모든 사원을 삭제
--서브쿼리를 사용
DELETE emp
WHERE empno IN (SELECT empno
                FROM emp
                WHERE mgr = 7698);
--위 쿼리는 아래 쿼리와 동일
DELETE emp WHERE mgr = 7698;

SELECT *
FROM emp;
ROLLBACK;

--읽기 일관성 (ISOLATION LEVEL)
--DML문이 다른 사용자에게 어떻게 영향을 미치는지 정의한 레벨(0-3) --레벨이 높을수록 보수적임

--ISOLATION LEBVEL0 : Read Uncommitted
--선행 트랜잭션의 커밋 되지 않은 데이터를 후행 트랜잭션에서 볼 수 있는 설정
--오라클른 미지원

--ISOLATION LEBVEL1 : Read committed
--커밋되지 않은 데이터는 후행 트랜잭션에서 볼수 없다
--대부분의 DBMS의 기본 설정

--ISOLATION LEBVEL2 : Repeatable Read
--선행 트랜잭션에서 읽은 데이터(FOR UPDATE)를 수정, 삭제하지 못함
--다른 트랜잭션에서 수정을 못하기 때문에 현 트랜잭션에서 해당 ROW는 항상 동일한 결과값으로 조회할수있다
--하지만 후행 트랜잭션에서 신규 데이터 입력 후 COMMIT을 하면 현 트랜잭션에서 조회가 된다(phantom read 유령읽기)

--ISOLATION LEBVEL3 : Serializable Read
--트랜잭션의 데이터 조회 기준이 트랜잭션 시작 시점으로 맞춰진다
--즉 후행 트랜잭션에서 데이터를 신규 입력, 수정, 삭제 후 COMMIT을 하더라도 선행특랜잭션에서는 해당 데이터를 보지 않는다
--오라클에서는 공식적으로 지원 안함

--트랜잭션 레벨 수정(serializable read)
--SET TRANSACTION isolation LEVEL SERIALIZABLE; --레벨1에서 레벨3(Serializable Read) 으로 바뀜




--DDL : TABLE 생성
--CREATE TABLE [사용자명.] 테이블명 (
    --컬럼명1 컬럼타입1,
    --컬럼명2 컬럼타입2, ...
    --컬럼명N 컬럼타입N );
--테이블 생성 DDL : Data Defination Language(데이터 정의어)
--DDL rollback이 없다(자동 커밋 되므로 rollback을 할 수 없다)

CREATE TABLE ranger (
    ranger_no NUMBER,
    ranger_nm VARCHAR2(50),
    reg_dt DATE ); --reg_dt : 레인저 등록 일자

--테이블 등록 후 조회    
DESC ranger;

--DDL 문장은 ROLLBACK 처리가 불가!!!
ROLLBACK;

SELECT *
FROM user_tables
WHERE table_name = 'RANGER';
--WHERE table_name = 'ranger'; --소문자로 쓰면 결과 안나옴
--오라클에서는 객체 생성시 소문자로 생성하더라도 내부적으로는 대문자로 관리한다


--DML문은 DDL과 다르게 ROLLBACK이 가능하다 --INSERT구문 얘기하는거임
INSERT INTO ranger VALUES(1, 'brown', sysdate);
SELECT *
FROM ranger;
ROLLBACK;

--DATE 타입에서 필드 추출하기
--EXTRACT(필드명 FROM 컬럼/expression)
SELECT TO_CHAR(SYSDATE, 'YYYY') yyyy,
        TO_CHAR(SYSDATE, 'mm') mm,
        EXTRACT(year FROM SYSDATE) ex_yyy,
        EXTRACT(month FROM SYSDATE) ex_mm
FROM dual;

--테이블 생성시 컬럼 레벨 제약조건 생성
CREATE TABLE dept_test (
    deptno NUMBER(2),
    dname VARCHAR(14),
    loc VARCHAR2(13));

DROP TABLE dept_test;

CREATE TABLE dept_test (
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR(14),
    loc VARCHAR2(13));
    
--dept_test 테이블의 deptno 컬럼에 PRIMARY KEY 제약조건이 있기 때문에 deptno가 동일한 데이터를 입력하거나 수정할수없다.
--최초 데이터이므로 입력 성공
INSERT INTO dept_test VALUES(99, 'ddit', 'daejeon');
--dept_test 데이터에 deptno가 99번인 데이터가 있으므로 primary key 제약조건에 의해 입력될수없다
--ORA-00001 : unique constraint 제약 위배
--위배되는 제약 조건명 SYS_C007118 제약 조건 위배
INSERT INTO dept_test VALUES(99, '대덕', '대전'); --스크립트에 unique constraint(=unique제약조건)

--SYS_C007118 제약조건을 어떤 제약 조건인지 판단하기 힘드므로 제약조건에 이름을 코딩 룰에 의해 붙여주는 편이 유지보수시 편하다
--테이블 삭제 후 제약조건 이름을 추가하여 재생성
DROP TABLE dept_test;

--primary key : pk_테이블명
CREATE TABLE dept_test (
    deptno NUMBER(2) CONSTRAINT pk_dept_test PRIMARY KEY,
    dname VARCHAR(14),
    loc VARCHAR2(13));
    
INSERT INTO dept_test VALUES(99, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES(99, '대덕', '대전');
