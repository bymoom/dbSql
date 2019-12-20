--hash join (��ü ó�� �ӵ��� ������)
SELECT *
FROM dept, emp --����� ���� ���̺��� ���� �а� �Ѵ�
WHERE dept.deptno = emp.deptno;
--dept ���� �д� ����
--join �÷��� hash �Լ��� ������ �ؽ� �Լ��� �ش��ϴ� bucket�� �����͸� �ִ´�
-- 10 --> aaabbaa (�ؽ���)

--emp ���̺��� ���� ���� ������ �����ϰ� ����
-- 10 --> aaabbaa (�ؽ���)

--WHERE���� ���������� ���� ��� HASH JOIN�� �Ͼ�� ���� ��찡 ũ��
SELECT *
FROM dept, emp
WHERE emp.deptno BETWEEN dept.deptno AND 99;
10 ---> AAAAA
20 ---> AAAAB -> �̷��� ���������� �ؽ����� ���ðŶ� ������ ����


--Sort Merge Join�� ������ �� �ؾ� ������� �� �� �ֱ� ������ ��ü ������ ó���Ѵ�
--��ü ���� ó��(���̺��� ��ü �����͸� �� �о���Ѵ�)
SELECT COUNT(*)
FROM emp;


--window �Լ�
-- �����ȣ, ����̸�, �μ���ȣ, �޿�, �μ����� ��ü �޿���
SELECT empno, ename, deptno, sal,
        SUM(sal) OVER () c_sum --() -> ��ü ���̱⶧���� ��Ƽ���̳� �������̸� ���� ���Ѵ�
FROM emp;

SELECT empno, ename, deptno, sal,
        SUM(sal) OVER (ORDER BY sal ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) c_sum, --���� ó������ ���������
        --ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        --UNBOUNDED PRECEDING = �������� ������ ��� ������(�� �ǹ��ϱ� ������ between�̶� and current row�� �ᵵ ������)
        -->���� ���� ������ ��� �������� �ο��
        
        --�ٷ� ���� ���̶� ����������� �޿���
        SUM(sal) OVER (ORDER BY sal ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) c_sum1
FROM emp
ORDER BY sal;


--�ǽ� ana7
SELECT empno, ename, deptno, sal,
        SUM(sal) OVER (PARTITION BY deptno ORDER BY sal, empno
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) c_sum
FROM emp;

--ROWS vs RANGE ���� Ȯ���ϱ�
SELECT empno, ename, deptno, sal,
        SUM(sal) OVER (ORDER BY sal ROWS UNBOUNDED PRECEDING) row_sum, --4������ ���ؼ� 4100
        SUM(sal) OVER (ORDER BY sal RANGE UNBOUNDED PRECEDING) range_sum, --5������ ���ؼ� 5350
        --range�� ���� ���� ���� �����ͱ���(�����ϴ� �������ε��� �ұ��ϰ�) ���ع�����
        SUM(sal) OVER (ORDER BY sal) c_sum
        --windowing�� �������� �ʾ��� �� ����Ŭ���� RANGE UNBOUNDED PRECEDING�� �⺻������ �־��ش�
FROM emp;


--PL/SQL
--PL/SQL �⺻����
--DECLARE : �����, ������ �����ϴ� �κ�
--BEGIN : PL/SQL�� ������ ���� �κ�
--EXCEPTION : ����ó����

SET SERVEROUTPUT ON; --DBMS_OUTPUT.PUT_LINE �Լ��� ����ϴ� ����� ȭ�鿡 �����ֵ��� Ȱ��ȭ
-- ���� �̸��� ���� block(������ �Ұ�)
DECLARE --�����
    --JAVA ����� : Ÿ�� ������;
    --PL/SQL ����� : ������ Ÿ��;
    /*v_dname VARCHAR2(14);
    v_loc VARCHAR2(13);*/
    
    --���̺� �÷��� ���Ǹ� �����Ͽ� ������ Ÿ���� �����Ѵ�
    v_dname dept.dname%TYPE;
    v_loc dept.loc%TYPE;
BEGIN
    --dept ���̺����� 10�� �μ��� �μ��̸�, loc ������ ��ȸ
    SELECT dname, loc
    INTO v_dname, v_loc --�� SELECT���� ������ ������ �ִ´�
    FROM dept
    WHERE deptno = 10;
    --String a = "t";
    --String b = "c";
    --system.out.println(a + b); -> �ڹ��� ���ڿ� ���� (+)
    DBMS_OUTPUT.PUT_LINE(v_dname || v_loc); --> ����Ŭ�� ���ڿ� ���� (||)
END;
/
--PL/SQL ������ ���� (/ �ٷ� ���� �ּ����̴ϱ� ������)

DESC dept; --�����ϱ� ���� Ÿ�� ��ȸ



--Procedure (�̸��� �ִ� pl/sql block)
--10�� �μ��� �μ��̸�, ��ġ������ ��ȸ�ؼ� ������ ��� ������ DBMS_OUTPUT.PUT_LINE�Լ��� �̿��Ͽ� console�� ���
CREATE OR REPLACE PROCEDURE printdept
( p_deptno IN dept.deptno%TYPE ) --���� ����(�ɼ�) : �Ķ���͸� IN/OUT Ÿ�� -> ���ڿ� ������ �����ϱ� ���� 'P_�Ķ�����̸�'
IS
--�����(�ɼ�) : (������) (���������̺�.�÷�%TYPE)
    dname dept.dname%TYPE;
    loc dept.loc%TYPE;
--�����
BEGIN
    SELECT dname, loc
    INTO dname, loc -- ������ ���
    FROM dept
    WHERE deptno = p_deptno; --10���̶�� �����ϴ� ��ſ� �Ķ���͸� �Է�
    
    DBMS_OUTPUT.PUT_LINE(dname || '     ' || loc);
--����ó����(�ɼ�)
END;
/

-- EXEC printdept; -> ���ν��� ���� ����
EXEC printdept(30); -- (10) : �Ķ������ ���� �����ϱ� ���� �Է�

--�ǽ� pro_1
CREATE OR REPLACE PROCEDURE printemp
( p_empno IN emp.empno%TYPE )
IS ename emp.ename%TYPE;
   dname dept.dname%TYPE;
BEGIN
    SELECT ename, dname
    INTO ename, dname
    FROM emp, dept
    WHERE emp.deptno = dept.deptno AND empno = p_empno;
    
    DBMS_OUTPUT.PUT_LINE(ename || '     ' || dname);
END;
/

EXEC printemp(7369);


CREATE OR REPLACE PROCEDURE registdept_test
(p_deptno IN dept_test.deptno%TYPE, p_dname IN dept_test.dname%TYPE, p_loc IN dept_test.loc%TYPE)
IS deptno dept_test.deptno%TYPE;
    dname dept_test.dname%TYPE;
    loc dept_test.loc%TYPE;
BEGIN
    INSERT INTO dept_test (deptno, dname, loc) VALUES (p_deptno, p_dname, p_loc);

END;
/

EXEC registdept_test(99, 'ddit', 'daejeon');

COMMIT;
SELECT *
FROM dept_test;