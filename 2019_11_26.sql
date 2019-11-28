--��¥���� �Լ�
--ROUND, TRUNC
--(MONTHS_BETWEEN) ADD_MONTHS, NEXT_DAY
--LAST_DAY : �ش� ��¥�� ���� ���� ������ ����(DATE)

--�� : 1, 2, 3, 5, 7, 8, 9, 10, 12 : 31��
--  : 2 -���� ���� 28, 29
--  : 4, 6, 9, 11 : 30��

--fn3
--�ش� ���� ������ ��¥�� �̵�
--���� �ʵ常 �����ϱ�
--DATE --> �����÷�(DD)�� ����
--DATE --> ���ڿ�(DD)
SELECT '201912' param,
        TO_CHAR(LAST_DAY(TO_DATE('201912', 'YYYYMM')), 'DD') dt
FROM dual;

--���ε� ����
SELECT : yyyymm param,
        TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')), 'DD') dt --�����ϸ� '���ε��Է�' ���� - ��¥ �Է� ����
FROM dual;

--SYSDATE�� YYYY/MM/DD ������ ���ڿ��� ����
SELECT TO_CHAR(SYSDATE, 'YYYY/MM/DD')
FROM dual;

--'2019/11/26' ���ڿ� --> DATE
SELECT TO_DATE(TO_CHAR(SYSDATE, 'YYYY/MM/DD'), 'YYYY/MM/DD')
FROM dual;

--YYYY-MM-DD HH24:MI:SS ���ڿ��� ����
SELECT TO_CHAR(SYSDATE, 'YYYY/MM/DD'),
        TO_CHAR(TO_DATE(TO_CHAR(SYSDATE, 'YYYY/MM/DD'), 'YYYY-MM-DD'), 'YYYY-MM-DD HH24:MI:SS')
FROM dual;

--EMPNO    NOT NULL NUMBER(4)   
--HIREDATE          DATE  
DESC emp;

--empno�� 7369�� ���� ���� ��ȸ�ϱ�
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7369;


--���� �ܰ� ���� ��� (EXPLAIN PLAN FOR + SELECT * + FROM TABLE(dbms_xplan.display);)
SELECT *
FROM TABLE(dbms_xplan.display);

Plan hash value: 3956160932
 
--------------------------------------------------------------------------
| Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |      |     1 |    38 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| EMP  |     1 |    38 |     3   (0)| 00:00:01 | --�ڽĺ��� �д´� (1->0)
--------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("EMPNO"=7369) --������ ����ȯ
   
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE TO_CHAR(empno) = '7369';

SELECT *
FROM TABLE(dbms_xplan.display);


SELECT 7300 + '69'
FROM dual;


EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7300 + '69'; --���ڿ��� + ��� ��ȣ�� ���⶧���� 69�� ���ڷ� ����

SELECT *
FROM TABLE(dbms_xplan.display);

--
SELECT *
FROM emp
WHERE hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD');

--DATEŸ���� ������ ����ȯ�� ����� ������ ���� (->WHERE hiredate >= '1981/06/01';)

SELECT *
FROM emp
WHERE hiredate >= TO_DATE('81/06/01', 'RR/MM/DD');

SELECT TO_DATE('50/06/01', 'RR/MM/DD') --19�� ����
--        TO_DATE('49/06/01', 'RR/MM/DD'), --20���� ����
--        TO_DATE('49/06/01', 'YY/MM/DD') --20���� ����
FROM dual;

--���� --> ���ڿ�
--���ڿ� --> ����
--���� : 1000000 --> 1,000,000.00(�̰� ����, �ѱ�ǥ���)
--���� : 1000000 --> 1,000.000,00(�̰� ����, ����ǥ���)
--��¥ ���� : YYYY, MM, DD, HH24, MI, SS
--���� ���� : ���� ǥ�� : 9, �ڸ������� ���� 0ǥ�� : 0, ȭ����� : L (�ѱ����� �������� ����)
--            1000�ڸ� ���� : , // �Ҽ��� : .
--���� -> ���ڿ� TO_CHAR(����, '����')
--���� ������ ����� ��� ���� �ڸ����� ����� ǥ��
SELECT empno, ename, sal, TO_CHAR(sal, 'L000009,999') fm_sal
FROM emp;

SELECT TO_CHAR(100000000000000, '999,999,999,999,999')
FROM dual;

--NULL ó�� �Լ� : NVL, NVL2, NULLIF, COALESCE

--NVL(expr1, expr2) : �Լ� ���� �ΰ�
--expr1�� NULL�̸� expr2�� ��ȯ
--expr1�� NULL�� �ƴϸ� expr1�� ��ȯ
SELECT empno, ename, comm, NVL(comm, -1) nvl_comm
FROM emp;

--NVL2 (expr1, expr2, expr3)
--expr1 IS NOT NULL expr2 ����
--expr1 IS NULL expr3 ����
SELECT empno, ename, comm, NVL2(comm, 1000, -500) nvl_comm,
        NVL2(comm, comm, -500) nvl_comm --NVL�� ������ ���
FROM emp;

--NULLIF(expr1, expr2)
--expr1 = expr2 NULL�� ����
--expr1 != expr2 expr1�� ����
--comm�� NULL�϶� comm+500 : NULL
--  NULLIF(NULL, NULL) : NULL
--comm�� NULL�� �ƴҶ� comm+500 : comm+500
--  NULLIF(comm, comm+500) : comm
SELECT empno, ename, comm, NULLIF(comm, comm+500) nullif_comm
FROM emp;

SELECT comm, NULLIF(comm+1, comm+1)
FROM emp;
--COALESCE(expr1, expr2, expr3....) //���� ������ �� �� ����
--�����߿� ù������ �����ϴ� NULL�� �ƴ� exprN�� ����
--expr1 IS NOT NULL expr1�� �����ϰ�
--expr1 IS NULL COALESCE(expr2, expr3....)

SELECT empno, ename, comm, sal, COALESCE(comm, sal) coal_sal
FROM emp;

SELECT empno, ename, mgr, NVL(mgr, 9999) mgr_n,
        NVL2(mgr, mgr, 9999) mgr_n_2,
        COALESCE(mgr, 9999) mgr_n_3
FROM emp;

SELECT userid, usernm, reg_dt, NVL(reg_dt, SYSDATE)        
FROM users
WHERE userid NOT IN ('brown');

--condition
--case
--emp.job �÷��� ��������
--'SALESMAN'�̸� sal *1.05�� ������ �� ����
--'MANAGER'�̸� sal *1.10�� ������ �� ����
--'PRESIDENT'�̸� sal *1.20�� ������ �� ����
--�� 3���� ������ �ƴҰ�� sal ����
--empno, ename, sal, ���� ������ �޿� AS bonus
SELECT empno, ename, job, sal,
        CASE
            WHEN job = 'SALESMAN' THEN sal * 1.05
            WHEN job = 'MANAGER' THEN sal * 1.10
            WHEN job = 'PRESIDENT' THEN sal * 1.20
            ELSE sal
        END bonus,
        comm,
        --NULLó�� �Լ� ������� �ʰ� CASE ���� �̿��Ͽ�
        --comm�� NULL�� ��� -10�� �����ϵ��� ����
        CASE
            WHEN comm IS NULL THEN -10
            ELSE comm
        END case_null
FROM emp;

--DECODE
SELECT empno, ename, job, sal,
        DECODE(job, 'SALESMAN', sal*1.05, 'MANAGER', sal * 1.10, 'PRESIDENT', sal * 1.20, sal) bonus
FROM emp;

--144��, 155�� �ǽ�