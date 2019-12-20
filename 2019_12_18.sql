SELECT dept_h.*, LEVEL --67�� PPT�� ������ǥ���� XXȸ��� 1LEVEL, �� �� �����ʹ� 2LEVEL...
FROM dept_h
START WITH deptcd = 'dept0'  --�������� deptcd = 'dept0' --> XXȸ��(�ֻ�������)
CONNECT BY PRIOR deptcd = p_deptcd; --PRIOR (deptcd) : �̹� ���� ������, prior�� ���� ������ ���� ���� �������̴�.

/*  --�����͸� ���� ������ �� ���� prior�� �ȴ�
    dept0(XXȸ��)
        dept0_00(�����κ�)
            dept0_00_0(��������)
        dept0_01(������ȹ��)
            dept0_01_0(��ȹ��)
                dept0_00_0_0(��ȹ��Ʈ)
        dept0_02(�����ý��ۺ�)
            dept0_02_0(����1��)
            dept0_02_1(����2��) */
            
SELECT LPAD('XXȸ��', 15)
FROM dual;
            
SELECT dept_h.*, LEVEL, LPAD(' ', (LEVEL-1) * 3) || deptnm--67�� PPT�� ������ǥ���� XXȸ��� 1LEVEL, �� �� �����ʹ� 2LEVEL...
FROM dept_h
START WITH deptcd = 'dept0'  --�������� deptcd = 'dept0' --> XXȸ��(�ֻ�������)
CONNECT BY PRIOR deptcd = p_deptcd; --PRIOR (deptcd) : �̹� ���� ������, prior�� ���� ������ ���� ���� �������̴�.


--�ǽ�h_2
SELECT dept_h.*, LEVEL, LPAD(' ', (LEVEL-1) * 3) || deptnm
FROM dept_h
START WITH deptcd = 'dept0_02'
CONNECT BY PRIOR deptcd = p_deptcd;


--��������(dept0_00_0)�� �������� ����� �������� �ۼ�
--�ڱ� �μ��� �θ� �μ��� ������ �Ѵ�
SELECT *
FROM dept_h;

SELECT dept_h.*, LEVEL
FROM dept_h
START WITH deptcd = 'dept0_00_0'
CONNECT BY deptcd = PRIOR p_deptcd; --PRIOR�� �÷��� �ٴ� Ű�����
--CONNECT BY deptcd = PRIOR p_deptcd AND col = PRIOR col2; -> �̰͵� ����

--���� ������ ���÷����� �����Ҽ��ִ°�? -> (�������� �÷� �����ϴ�)
SELECT *
FROM tab_a, tab_b
WHERE tab_a.a = tab_b.a
AND tab_a.b = tab_b.b;

SELECT dept_h.*, LEVEL
FROM dept_h
START WITH deptcd = 'dept0_00_0'
CONNECT BY deptcd = PRIOR p_deptcd
AND deptnm LIKE '������%'; --deptnm�� prior�� ���� �Ͱ� �ٸ� ����� ���´�

--�ǽ�h_3
SELECT deptcd, LPAD(' ', (LEVEL-1)*3) || deptnm deptnm, p_deptcd
FROM dept_h
START WITH deptcd = 'dept0_00_0'
CONNECT BY deptcd = PRIOR p_deptcd;


create table h_sum as
select '0' s_id, null ps_id, null value from dual union all
select '01' s_id, '0' ps_id, null value from dual union all
select '012' s_id, '01' ps_id, null value from dual union all
select '0123' s_id, '012' ps_id, 10 value from dual union all
select '0124' s_id, '012' ps_id, 10 value from dual union all
select '015' s_id, '01' ps_id, null value from dual union all
select '0156' s_id, '015' ps_id, 20 value from dual union all

select '017' s_id, '01' ps_id, 50 value from dual union all
select '018' s_id, '01' ps_id, null value from dual union all
select '0189' s_id, '018' ps_id, 10 value from dual union all
select '11' s_id, '0' ps_id, 27 value from dual;

--�ǽ� h_4
SELECT h_sum.*, level
FROM h_sum
START WITH s_id = '0'
CONNECT BY PRIOR s_id = ps_id;

SELECT LPAD(' ', 3*(level-1)) || s_id s_id, value --level-1 : �ֻ��� 0���� ������ �� �ֱ� ���ؼ�.
FROM h_sum
START WITH s_id = '0'
CONNECT BY PRIOR s_id = ps_id;

create table no_emp(
    org_cd varchar2(100),
    parent_org_cd varchar2(100),
    no_emp number
);
insert into no_emp values('XXȸ��', null, 1);
insert into no_emp values('�����ý��ۺ�', 'XXȸ��', 2);
insert into no_emp values('����1��', '�����ý��ۺ�', 5);
insert into no_emp values('����2��', '�����ý��ۺ�', 10);
insert into no_emp values('������ȹ��', 'XXȸ��', 3);
insert into no_emp values('��ȹ��', '������ȹ��', 7);
insert into no_emp values('��ȹ��Ʈ', '��ȹ��', 4);
insert into no_emp values('�����κ�', 'XXȸ��', 1);
insert into no_emp values('��������', '�����κ�', 7);

commit;

--�ǽ� h_5
SELECT no_emp.*, level
FROM no_emp
START WITH org_cd = 'XXȸ��'
CONNECT BY PRIOR org_cd = parent_org_cd;

SELECT LPAD(' ', 4*(LEVEL-1)) || org_cd org_cd, no_emp
FROM no_emp
START WITH org_cd = 'XXȸ��'
CONNECT BY PRIOR org_cd = parent_org_cd;


--pruning branch (����ġ��)
--���� ������ �������
--FROM -> START WITH - CONNECT BY -> WHERE
--������ CONNECT BY ���� ����� ���
-- . ���ǿ� ���� ���� ROW�� ������ �ȵǰ� ����
--������ WHERE ���� ����� ���
-- . START WITH - CONNECT BY ���� ���� ���������� ���� ����� WHERE ���� ����� ��� ���� �ش��ϴ� �����͸� ��ȸ

--�ֻ��� ��忡�� ��������� Ž��
--CONNECT BY ���� deptnm != '������ȹ��' ������ ����� ���
SELECT *
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd AND deptnm != '������ȹ��'; --������ȹ�ο� ����� ���� �� �ȳ���


--WHERE ���� deptnm != '������ȹ��' ������ ����� ���
--���������� �����ϰ����� ���� ����� WHERE�� ������ ����(�����ȹ�� WHERE���� �������̱⶧��)
SELECT *
FROM dept_h
WHERE deptnm != '������ȹ��' --����������� '������ȹ��'�� ������
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;


--���� �������� ��밡���� Ư�� �Լ�
--CONNECT_BY_ROOT(col) ���� �ֻ��� row�� col���� �� ��ȸ
SELECT deptcd, LPAD(' ', 4*(LEVEL-1)) || deptnm,
        CONNECT_BY_ROOT(deptnm) c_root
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;


--SYS_CONNECT_BY_PATH(col, ������) : �ֻ��� row���� ���� row���� col���� �����ڷ� �������� ���ڿ�
--XXȸ��-�����κ�-��������(�� �ο쿡 ��Ÿ����)
SELECT deptcd, LPAD(' ', 4*(LEVEL-1)) || deptnm,
        CONNECT_BY_ROOT(deptnm) c_root,
        LTRIM(SYS_CONNECT_BY_PATH(deptnm, '-'), '-') sys_path --LTRIM ���ʿ� �ִ� ������('-')�� ����
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

--CONNECT_BY_ISLEAF : �ش� ROW�� ������ ���(leaf Node)���� ��ȸ
--leaf node : 1, node : 0
SELECT deptcd, LPAD(' ', 4*(LEVEL-1)) || deptnm,
        CONNECT_BY_ROOT(deptnm) c_root,
        LTRIM(SYS_CONNECT_BY_PATH(deptnm, '-'), '-') sys_path, --LTRIM ���ʿ� �ִ� ������('-')�� ����
        CONNECT_BY_ISLEAF isleaf
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;



create table board_test (
 seq number,
 parent_seq number,
 title varchar2(100) );
 
insert into board_test values (1, null, 'ù��° ���Դϴ�');
insert into board_test values (2, null, '�ι�° ���Դϴ�');
insert into board_test values (3, 2, '����° ���� �ι�° ���� ����Դϴ�');
insert into board_test values (4, null, '�׹�° ���Դϴ�');
insert into board_test values (5, 4, '�ټ���° ���� �׹�° ���� ����Դϴ�');
insert into board_test values (6, 5, '������° ���� �ټ���° ���� ����Դϴ�');
insert into board_test values (7, 6, '�ϰ���° ���� ������° ���� ����Դϴ�');
insert into board_test values (8, 5, '������° ���� �ټ���° ���� ����Դϴ�');
insert into board_test values (9, 1, '��ȩ��° ���� ù��° ���� ����Դϴ�');
insert into board_test values (10, 4, '����° ���� �׹�° ���� ����Դϴ�');
insert into board_test values (11, 10, '���ѹ�° ���� ����° ���� ����Դϴ�');
commit;

--�ǽ� h6
SELECT *
FROM board_test;

SELECT board_test.*, level
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq;

SELECT seq, LPAD(' ', 4*(LEVEL-1)) || title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq;

--�ǽ� h7 (������� �߸��� ���)
SELECT seq, LPAD(' ', 4*(LEVEL-1)) || title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER BY seq DESC;


--�ǽ� h8(92P)
SELECT seq, LPAD(' ', 4*(LEVEL-1)) || title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY seq DESC; --title�� �ص� �ǳ�? �� ���� �ٸ�...


--�ǽ� h9
SELECT NVL(parent_seq, seq), seq, LPAD(' ', 4*(LEVEL-1)) || title, level
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY NVL(parent_seq, seq) DESC;

SELECT NVL(parent_seq, seq), seq, LPAD(' ', 4*(LEVEL-1)) || title, level
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER BY CONNECT_BY_ROOT(seq) desc, seq asc;

