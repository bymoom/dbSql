INSERT INTO dept VALUES (99, 'ddit', 'daejeon');
COMMIT;

--sub4.������ �������� �ʴ� �μ�����
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
                

--�Ŵ����� �����ϴ� ���� ���� ��ȸ
SELECT *
FROM emp e --������� Ȯ��
WHERE EXISTS (SELECT 1
                FROM emp m --�Ŵ������� Ȯ��
                WHERE m.empno = e.mgr); --EXISTS�� ���������� �ִ� ������ �Ѱ����� ���̸� ���� ��� ���´�

--sub8
SELECT *
FROM emp
WHERE mgr IS NOT NULL;

SELECT e.* --e�� �Ҷ�, m���� �Ҷ��� ������� �ٸ���*****************************************
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
WHERE NOT EXISTS --���������� ������ �ƴѰ��� ��µ�
               (SELECT 'x'
                FROM cycle c
                WHERE c.pid = p.pid
                AND c.cid = 1);
            

--���� ����
--UNION : ������, �� ������ �ߺ����� �����Ѵ�
--�������� SALES�� ������ȣ, ���� �̸� ��ȸ
--���Ʒ��� ������� �����ϱ� ������ ������ ������ �ϰ� �� ��� �ߺ��Ǵ� �����ʹ� �ѹ��� ǥ���Ѵ�.
SELECT empno, ename
FROM emp
WHERE job = 'SALESMAN'
UNION
SELECT empno, ename
FROM emp
WHERE job = 'SALESMAN';

--���� �ٸ� ������ ������
SELECT empno, ename
FROM emp
WHERE job = 'SALESMAN'
UNION
SELECT empno, ename
FROM emp
WHERE job = 'CLERK';

--UNION ALL
--������ ����� �ߺ� ���Ÿ� ���� �ʴ´�
--���Ʒ� ��� ���� �ٿ� �ֱ⸸ �Ѵ�
SELECT empno, ename
FROM emp
WHERE job = 'SALESMAN'
UNION ALL
SELECT empno, ename
FROM emp
WHERE job = 'SALESMAN';

--���տ���� ���ռ��� �÷��� ���� �ؾ��Ѵ�
--�÷��� ������ �ٸ� ��� ���� ���� �ִ� ������� ������ �����ش�
SELECT empno, ename, '' --�÷������� ���Ƿ� ����
FROM emp
WHERE job = 'SALESMAN'
UNION ALL
SELECT empno, ename, job
FROM emp
WHERE job = 'SALESMAN';

--INTERSECT : ������
--�� ���հ� �������� �����͸� ��ȸ
SELECT empno, ename
FROM emp
WHERE job IN ('SALESMAN', 'CLERK')
INTERSECT
SELECT empno, ename
FROM emp
WHERE job IN ('SALESMAN');

--MINUS
--������ : ��, �Ʒ� ������ �������� �� ���տ��� ������ ������ ��ȸ
--�������� ��� ������, �����հ� �ٸ��� ������ ���� ������ ��� ���տ� ������ �ش�
SELECT empno, ename
FROM emp
WHERE job IN ('SALESMAN', 'CLERK')
MINUS
SELECT empno, ename
FROM emp
WHERE job IN ('SALESMAN'); --����� 'CLERK'�� ����

--UNION ALL�� �� ù��° ������ ORDER BY�Ϸ��� �ζ��κ並 ����ؾ��Ѵ�
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
--INSERT : ���̺��� ���ο� �����͸� �Է�
SELECT *
FROM dept;
DELETE dept --�����Ҷ� �����Ұ�. ���⿡ ; �Է��ϸ� ��ü�� ������
WHERE deptno = 99;
COMMIT;

--INSERT�� �÷��� ������ ���
--������ �÷��� ���� �Է��� ���� ������ ������ ����Ѵ�
--INSERT INTO ���̺��� (�÷�1, �÷�2...)
            --VALUES (��1, ��2...)
--dept ���̺��� 99�� �μ���ȣ, ddit ������, daejeon �������� ���� ������ �Է�
INSERT INTO dept (deptno, dname, loc)
            VALUES (99, 'ddit', 'daejeon');
ROLLBACK;

SELECT *
FROM dept;

--�÷��� ����� ��� ���̺��� �÷� ���� ������ �ٸ��� �����ص� ����� ����(��� values�� ������ �Է��� �÷� ������ �������)
--���� dept ���̺��� �÷� ���� : deptno, dname, loc
INSERT INTO dept (loc, deptno, dname)
            VALUES ('daejeon', 99, 'ddit');
ROLLBACK;

--�÷��� ������� ���� ���� �ִ� : ���̺��� �÷� ���� ������ ���� ���� ����Ѵ�
DESC dept; --dept���̺��� �÷��� ���� Ȯ��
INSERT INTO dept VALUES (99, 'ddit', 'daejeon');

--��¥ �� �Է��ϱ�
--1.SYSDATE
--2.����ڷκ��� ���� ���ڿ��� DATE Ÿ������ �����Ͽ� �Է�
DESC emp;
INSERT INTO emp VALUES (9998, 'sally', 'SALESMAN', NULL, SYSDATE, 500, NULL, NULL);

SELECT *
FROM emp;

--2019�� 12�� 2�� �Ի�
INSERT INTO emp VALUES (9997, 'james', 'CLERK', NULL, TO_DATE('20191202', 'YYYYMMDD'), 500, NULL, NULL);

ROLLBACK;

--�������� �����͸� �ѹ��� �Է�
--SELECT ����� ���̺��� �Է� �� �� �ִ�
INSERT INTO emp
SELECT 9998, 'sally', 'SALESMAN', NULL, SYSDATE, 500, NULL, NULL
FROM dual
UNION ALL
SELECT 9997, 'james', 'CLERK', NULL, TO_DATE('20191202', 'YYYYMMDD'), 500, NULL, NULL
FROM dual;

ROLLBACK;