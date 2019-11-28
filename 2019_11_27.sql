--con2
--�ǰ����� ����� ��ȸ ����
--1. ���س⵵�� ¦��/Ȧ���� ����
--2. hiredate���� �Ի�⵵�� ¦��/Ȧ�� ����

--1. TO_CHAR(SYSDATE, 'YYYY')
 --> ���س⵵ ���� ( 0:¦����, 1:Ȧ����)

SELECT MOD(TO_CHAR(SYSDATE, 'YYYY'), 2)
FROM dual;

--2.
--Ȧ���⵵�� �ǰ���������� = ���ش� Ȧ���⵵
SELECT empno, ename, hiredate,
        CASE
            WHEN MOD(TO_CHAR(TO_CHAR(hiredate, 'YYYY')),2) = 
                 MOD(TO_CHAR(TO_CHAR(SYSDATE, 'YYYY')),2)
            THEN '�ǰ����������'
            ELSE '�ǰ�����������'
        END contact_to_doctor
    FROM emp;
    
--���⵵ �ǰ����� ����ڸ� ��ȸ�ϴ� ������ �ۼ��غ�����
--2020�⵵(¦���⵵) 
SELECT empno, ename, hiredate,
        CASE
            WHEN MOD(TO_CHAR(TO_CHAR(hiredate, 'YYYY')), 2) =
                MOD(2019+1, 2)
            THEN '�ǰ����������'
            ELSE '�ǰ�����������'
        END contact_to_doctor
FROM emp;

--Function �̹��⵵�� �ǰ��������ڸ� ã�Ƴ���
--cond3
SELECT userid, usernm, alias, reg_dt,
        CASE
            WHEN MOD(TO_CHAR(reg_dt, 'YYYY'),2) = 
            MOD(TO_CHAR(sysdate, 'YYYY'),2) 
            THEN '�ǰ���������'
            ELSE '�ǰ����������'
        END contact_to_doctor
FROM users;

--GROUP FUNCTION
--Ư�� �÷��̳�, ǥ���� �������� �������� ���� ������ ����� ����
--COUNT-�Ǽ�, SUM-�հ�, AVG-���, MAX-�ִ밪, MIN-�ּҰ�
--��ü ������ ������� (14���� ->1��)
DESC emp;
SELECT MAX(sal) max_sal,--���� ���� �޿�
      MIN(sal) min_sal, --���� ���� �޿�
       ROUND(AVG(sal), 2) avg_sal, --�� ������ �޿� ���
       SUM(sal) sum_sal, --�� ������ �޿� �հ�
       COUNT(sal) count_sal, -- �޿� �Ǽ�(null�� �ƴ� ���̸� 1��)
       COUNT(mgr) count_mgr, --������ ������ �Ǽ�(KING�� ��� MGR�� ����)
       COUNT(*) count_row --Ư�� �÷��� �Ǽ��� �ƴ϶� ���� ������ �˰� ������
FROM emp;

--�μ���ȣ�� �׷��Լ� ����
SELECT deptno,
        MAX(sal) max_sal,--�μ����� ���� ���� �޿�
      MIN(sal) min_sal, --�μ����� ���� ���� �޿�
       ROUND(AVG(sal), 2)avg_sal, --�μ� ������ �޿� ���
       SUM(sal) sum_sal, --�μ� ������ �޿� �հ�
       COUNT(sal) count_sal, -- �μ��� �޿� �Ǽ�(null�� �ƴ� ���̸� 1��)
       COUNT(mgr) count_mgr, --�μ� ������ ������ �Ǽ�(KING�� ��� MGR�� ����)
       COUNT(*) count_row --�μ��� ��������
FROM emp
GROUP BY deptno;


--SELECT ������ GROUP BY ���� ǥ���� �÷� �̿��� �÷��� �� �� ����.
--�׷� �Լ����� null�÷��� ��꿡�� ���ܵȴ�.
SELECT deptno, ename,
        MAX(sal) max_sal,--�μ����� ���� ���� �޿�
      MIN(sal) min_sal, --�μ����� ���� ���� �޿�
       ROUND(AVG(sal), 2)avg_sal, --�μ� ������ �޿� ���
       SUM(sal) sum_sal, --�μ� ������ �޿� �հ�
       COUNT(sal) count_sal, -- �μ��� �޿� �Ǽ�(null�� �ƴ� ���̸� 1��)
       COUNT(mgr) count_mgr, --�μ� ������ ������ �Ǽ�(KING�� ��� MGR�� ����)
       COUNT(*) count_row --�μ��� ��������
FROM emp
GROUP BY deptno, ename;

--SELECT ������ GROUP BY ���� ǥ���� �÷� �̿��� �÷��� �� �� ����.
--���������� ������ ���� ����(3���� ���� ������ �Ѱ��� �����ͷ� �׷���)
--�� ���������� ��������� SELECT ���� ǥ���� ����
SELECT deptno, 1, '���ڿ�', SYSEATE, --���ڿ��� �ȵ�
        MAX(sal) max_sal,--�μ����� ���� ���� �޿�
      MIN(sal) min_sal, --�μ����� ���� ���� �޿�
       ROUND(AVG(sal), 2)avg_sal, --�μ� ������ �޿� ���
       SUM(sal) sum_sal, --�μ� ������ �޿� �հ�
       COUNT(sal) count_sal, -- �μ��� �޿� �Ǽ�(null�� �ƴ� ���̸� 1��)
       COUNT(mgr) count_mgr, --�μ� ������ ������ �Ǽ�(KING�� ��� MGR�� ����)
       COUNT(*) count_row --�μ��� ��������
FROM emp
GROUP BY deptno;

--�׷��Լ����� NULL �÷��� ��꿡�� ���ܵȴ�.
--emp���̺����� comm�÷��� null�� �ƴ� �����ʹ� 4���� ����, 9���� NULL)

SELECT COUNT(comm), --NULL�� �ƴ� ���� ��� 4
        SUM(comm) sum_comm,   --NULL���� ����, 300+500+1400+0= 2200
        SUM(sal) sum_sal,      
        SUM(sal + comm) tot_sal_sum,
        SUM(sal + NVL(comm, 0)) tot_sal_sum
FROM emp;

--WHERE ������ GROUP �Լ��� ǥ���� �� ����
--1.�μ��� �ִ� �޿� ���ϱ�
--2. �μ��� �ִ� �޿� ���� 3000�� �Ѵ� �ุ ���ϱ�
--deptno, �ִ�޿�
SELECT deptno, MAX(sal) max_sal
FROM emp
WHERE MAX(sal) > 3000 --ORA-00934 WHERE ������ GROUP �Լ��� �� �� ����
GROUP BY deptno;

SELECT deptno, MAX(sal) max_sal
FROM emp
GROUP BY deptno
HAVING MAX(sal) >= 3000;

--�ǽ� grp1
SELECT MAX(sal) MAX_SAL,
       MIN(sal) MIN_SAL,
       ROUND(AVG(sal), 2) AVG_SAL,
       SUM(sal) SUM_SAL,
       COUNT(sal) COUNT_SAL,
       COUNT(mgr) COUNT_MGR,
       COUNT(*) COUNT_ALL
FROM emp;

--�ǽ� grp2
SELECT deptno,
       MAX(sal) MAX_SAL,
       MIN(sal) MIN_SAL,
       ROUND(AVG(sal), 2) AVG_SAL,
       SUM(sal) SUM_SAL,
       COUNT(sal) COUNT_SAL,
       COUNT(mgr) COUNT_MGR,
       COUNT(*) COUNT_ALL
FROM emp
GROUP BY deptno;

--�ǽ�3 162������
SELECT DECODE(deptno, '10', 'ACCOUNTING', '20', 'RESERCH', '30', 'SALES') dname,
       MAX(sal) max_sal,
       MIN(sal) min_sal,
       ROUND(AVG(sal), 2) avg_sal,
       SUM(sal) sum_sal,
       COUNT(sal) count_sal,
       COUNT(mgr) count_mrg,
       COUNT(*) count_all
FROM emp
GROUP BY deptno;

--�ǽ�4 
SELECT TO_CHAR(hiredate, 'YYYYMM') hire_yyyymm,
        count(*) cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYYMM');

--���2
SELECT hire_yyyymm, COUNT(*) cnt 
FROM 
    (SELECT TO_CHAR(hiredate, 'YYYYMM') hire_yyyymm 
    FROM emp)
GROUP BY hire_yyyymm;

--�ǽ�5
SELECT TO_CHAR(hiredate, 'YYYY') hire_yyyy,
        count (*) cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYY');
