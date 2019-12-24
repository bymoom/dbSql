--�ǽ� pro_3

CREATE OR REPLACE PROCEDURE UPDATEdept_test
(p_deptno IN dept.deptno%TYPE, p_dname IN dept.dname%TYPE, p_loc IN dept.loc%TYPE)
IS
BEGIN
    UPDATE dept_test SET dname = p_dname
    WHERE deptno = p_deptno AND loc = p_loc; --������Ʈ �������� where�� �� ���� ��� �����Ͱ� ������Ʈ�ȴ�
    COMMIT;
    
END;
/

EXEC UPDATEdept_test(99, 'ddit_m', 'daejeon');

ROLLBACK;
SELECT *
FROM dept_test;




--ROWTYPE
--Ư�� ���̺��� ROW ������ ���� �� �ִ� ���� Ÿ��
-- TYPE : ���̺���.���̺��÷���%TYPE
--ROWTYPE : ���̺���%ROWTYPE

SET SERVEROUTPUT ON;
DECLARE
    --dept ���̺��� row ������ ���� �� �ִ� ROWTYPE ���� ����
    dept_row dept%ROWTYPE;
BEGIN
    SELECT *
    INTO dept_row
    FROM dept
    WHERE deptno = 10;

    DBMS_OUTPUT.PUT_LINE(dept_row.dname || ', ' || dept_row.loc);
END;
/

--RECORD TYPE : �����ڰ� �÷��� ���� �����Ͽ� ���߿� �ʿ��� TYPE�� ����
--TYPE Ÿ���̸� IS RECORD(�÷�1 �÷�1TYPE, �÷�2 �÷�2TYPE);
--public class Ŭ������(�ʵ�type �ʵ�(�÷�); �ʵ�type �ʵ�(�÷�); //String name; int age;)
DECLARE
    --�μ��̸�, LOC ������ ������ �� �ִ� RECORD TYPE ����
    TYPE dept_row IS RECORD(
        dname dept.dname%TYPE,
        loc dept.loc%TYPE
        );
        --type ������ �Ϸ�, type�� ���� ������ ����
        --java : Class ���� �� �ش� class�� �ν��Ͻ��� ����(new)
        --plsql ���� ���� : �����̸� ����Ÿ�� (dname dept.dname%TYPE;)
        dept_row_data dept_row;
BEGIN
    SELECT dname, loc
    INTO dept_row_data
    FROM dept
    WHERE deptno = 10;
    DBMS_OUTPUT.PUT_LINE(dept_row_data.dname || ', ' || dept_row_data.loc);
END;
/

--TABLE TYPE : �������� ROWTYPE�� ������ �� �ִ� TYPE
--col --> row --> table
--TYPE ���̺�Ÿ�Ը� IS TABLE OF ROWTYPE/RECORD INDEX BY �ε��� Ÿ��(BINARY_INTEGER�� �ַ� ���)
--java�� �ٸ��� plsql������ array ������ �ϴ� table type�� �ε����� ���ڻӸ� �ƴ϶� ���ڿ� ���µ� �����ϴ�
--arr(1).name = 'brown'
--arr('person').name = 'brown'
--�׷��� ������ index�� ���� Ÿ���� �����Ѵ�
--�Ϲ������� array(list) ������ ����� INDEX BY BINARY_INTEGER�� �ַ� ����Ѵ�

--dept ���̺��� row�� ������ ������ �� �ִ� dept_tab TABLE TYPE �����Ͽ� SELECT * FROM dept;�� ���(������)�� ������ ��´�
DECLARE
    TYPE dept_tab IS TABLE OF dept%ROWTYPE INDEX BY BINARY_INTEGER;
    v_dept dept_tab;
BEGIN
    --�� row�� ���� ������ ���� : INTO
    --���� row�� ���� ������ ���� : BULK(�������� ��´ٴ� �ǹ�) COLLECT INTO
    SELECT *
    BULK COLLECT INTO v_dept
    FROM dept;
    
    FOR i IN 1..v_dept.count LOOP --�ڹٿ��� FOR���� ���� ���� (count = index)
        --arr[1] --> arr(1)
        DBMS_OUTPUT.PUT_LINE(v_dept(i).deptno);
    END LOOP;
END;
/


--���� ���� IF
--IF condition THEN
--  statement
--ELSIF condition THEN (-->ELS'E'IF �ƴ� ����)
--  statement
--ELSE
--  statement
--END IF; --IF���� ����

--PL/SQL IF �ǽ�
--���� p (NUMBER)�� 2��� ���� �Ҵ��ϰ�
--int a;
--a = 5;
--int a = 5;
--IF ������ ���� p�� ���� 1, 2, �׹��� ���϶� �ؽ�Ʈ���

DECLARE
    p NUMBER; --���� p ���� // p NUMBER := 2;�� ����
BEGIN
    p := 2; --(':=' --> �� �Ҵ�)
    IF p = 1 THEN
        DBMS_OUTPUT.PUT_LINE('p=1');
    ELSIF p = 2 THEN
        DBMS_OUTPUT.PUT_LINE('p=2');
    ELSE
        DBMS_OUTPUT.PUT_LINE(p);
    END IF; --IF���� ����
END;
/


--FOR LOOP
--FOR �ε������� IN [REVERSE] START..END LOOP
--      �ݺ����๮
--END LOOP;
--0~5���� ���� ������ �̿��Ͽ� �ݺ��� ����
DECLARE
BEGIN
    FOR i IN 0..5 LOOP --���� i ����� �ʱ�ȭ
        DBMS_OUTPUT.PUT_LINE(i);
    END LOOP;
END;
/

-- 1~10 : 55
-- 1~10������ ���� loop�� �̿��Ͽ� ���, ����� s_val �̶�� ������ ��� DBMS_OUTPUT.PUT_LINE �Լ��� ���� ȭ�鿡 ���

DECLARE
    s_val NUMBER := 0; --�ʱ�ȭ �ʿ�
BEGIN
    FOR i IN 1..10 LOOP
         s_val := s_val+i;
    END LOOP;
         DBMS_OUTPUT.PUT_LINE(s_val);
END;
/

--while loop
--WHILE condition Loop
--  statement
--END LOOP;
--0���� 5���� while���� �̿��Ͽ� ���
DECLARE
    i NUMBER := 0; --while�������� ���� �ʱ�ȭ �ʿ�
BEGIN
    WHILE i <= 5 LOOP
        i := i + 1;
        DBMS_OUTPUT.PUT_LINE(i);
    END LOOP;
END;
/


-- LOOP
-- LOOP
--  statement;
--  EXIT [WHEN condition];
-- END LOOP;
DECLARE
    i NUMBER := 0;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(i);
        EXIT WHEN i >= 5;
        i := i + 1;
    END LOOP;
END;
/



--CURSOR : sql�� �����ڰ� ������ �� �ִ� ��ü
--������ : �����ڰ� ������ Ŀ������ ������� ���� ����, ORACLE���� �ڵ�����
--        OPEN, ����, FETCH, CLOSE�� �����Ѵ�
--������ : �����ڰ� �̸��� ���� Ŀ��. �����ڰ� ���� �����ϸ�
--        ����, OPEN, FETCH, CLOSE �ܰ谡 ����
--CURSOR Ŀ���̸� IS -- Ŀ�� ����
--  QUERY;
--OPEN Ŀ���̸�;    --Ŀ�� OPEN
--FETCH Ŀ���̸� INTO ����1, ����2...   --Ŀ�� FETCH(�� ����)
--CLOSE Ŀ���̸�;   --Ŀ�� CLOSE

--�μ����̺��� ��� ���� �μ��̸�, ��ġ ���� ������ ��� (CURSOR�� �̿�)
DECLARE
    --Ŀ�� ����
    CURSOR dept_cursor IS
        SELECT dname, loc
        FROM dept;
    v_dname dept.dname%TYPE; --Ŀ���� ���� ���� (BULKŸ������ �ϸ� ��� �����Ͱ� ����(�޸�) �ϳ��� �� ���, CURSOR�� �̿��ϸ� ���� ���� ���� �� �ִ�)
    v_loc dept.loc%TYPE;
BEGIN
    --Ŀ�� ����
    OPEN dept_cursor;
    LOOP
        FETCH dept_cursor INTO v_dname, v_loc; --�� �ٸ� ���� �ѰǸ� ��ġ�ϱ� ������ LOOP�� �����
        --�������� : FETCH�� �����Ͱ� ���� �� ����
        EXIT WHEN dept_cursor%NOTFOUND; --���� Ŀ�� ���� ���������� dept_cursor ��� SQL ���
        DBMS_OUTPUT.PUT_LINE(v_dname || ', ' || v_loc);
    END LOOP;
    
    CLOSE dept_cursor;    

END;
/
