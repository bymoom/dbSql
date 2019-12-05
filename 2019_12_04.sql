SELECT d.*, e.*
FROM
(SELECT ROWNUM rn, c.*
FROM
        (SELECT sido, sigungu, ���ù�������
        FROM
            (SELECT a.sido, a.sigungu, ROUND((a.cnt/b.cnt), 1) ���ù�������
            FROM
                    (SELECT sido, sigungu, COUNT(*) cnt
                    FROM fastfood
                    WHERE gb IN ('�Ƶ�����', '����ŷ', 'KFC')
                    GROUP BY sido, sigungu) a,
                    
                    (SELECT sido, sigungu, COUNT(*) cnt
                    FROM fastfood
                    WHERE gb = '�Ե�����'
                    GROUP BY sido, sigungu) b
            WHERE a.sido = b.sido
            AND a.sigungu = b.sigungu)
            ORDER BY ���ù������� desc) c
            ORDER BY rn)d,
            
            (SELECT ROWNUM rn, sido, sigungu, cal_sal
            FROM
                (SELECT sido, sigungu, sal, people, ROUND((sal/people), 1) cal_sal
                 FROM tax
                 ORDER BY cal_sal)) e
WHERE d.rn(+) = e.rn
ORDER BY e.rn;


--���ù������� �õ�, �ñ����� �������� ���Աݾ��� �õ�, �ñ����� ���� �������� ����
--���� ������ tax ���̺��� id�÷������� ����
SELECT d.*, e.*
FROM
(SELECT ROWNUM rn, c.*
FROM
        (SELECT sido, sigungu, ���ù�������
        FROM
            (SELECT a.sido, a.sigungu, ROUND((a.cnt/b.cnt), 1) ���ù�������
            FROM
                    (SELECT sido, sigungu, COUNT(*) cnt
                    FROM fastfood
                    WHERE gb IN ('�Ƶ�����', '����ŷ', 'KFC')
                    GROUP BY sido, sigungu) a,
                    
                    (SELECT sido, sigungu, COUNT(*) cnt
                    FROM fastfood
                    WHERE gb = '�Ե�����'
                    GROUP BY sido, sigungu) b
            WHERE a.sido = b.sido
            AND a.sigungu = b.sigungu)
            ORDER BY ���ù������� desc) c
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
--1. tax ���̺��� �̿� �õ�/�ñ����� �δ� �������� �Ű��� ���ϱ�
--2. �Ű����� ���� ������ ��ŷ �ο��ϱ�
--��ŷ, �õ�, �ñ���, �δ翬������ �Ű���
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
ORDER BY 5 desc; --�÷� ���� ��ȣ�� �Է��ص� �����ϴ�.

UPDATE tax SET PEOPLE = 70391
WHERE SIDO = '����������'
AND SIGUNGU = '����';
COMMIT;




--��������
--SMITH�� ���� �μ� ã�� --> 20
SELECT deptno
FROM emp
WHERE ename = 'SMITH';

--WHERE������ ���� ()��ȣ���� ����������� �Ѵ�
SELECT *
FROM emp
WHERE deptno = (SELECT deptno
                FROM emp
                WHERE ename = 'SMITH');

--���������� ����� �������϶�
SELECT *
FROM emp
WHERE deptno IN (SELECT deptno
                FROM emp);

--SCALAR SUBQOUERY
--SELECT ���� ǥ���� ��������
SELECT empno, ename, deptno, (SELECT dname FROM dept WHERE dept.deptno = emp.deptno) dname
FROM emp;

--�� ��, �� column�� ��ȸ�ؾ� �Ѵ�
SELECT empno, ename, deptno, (SELECT dname FROM dept) dname
FROM emp;

--INLIN VIEW
--FROM���� ���Ǵ� ���� ����

--SUBQUERY
--WHERE�� ���Ǵ� ���� ����

--SUB1 : ��� �޿����� ���� �޿��� �޴� ����� �Ǽ�
SELECT *
FROM emp;

SELECT AVG(sal) --��� ���ϴ� ���
FROM emp;

SELECT COUNT(*)
FROM emp
WHERE sal > (SELECT AVG(sal)
             FROM emp);
             
--sub2 : ��� �޿����� ���� �޿��� �޴� ������ ����
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

--deptno�� Ŭ���� 30�� �μ��� ���� ������� ����(20���� ū ����� ����)
--deptno�� �������� 10,20�μ��� ���� ������� ����.(10���� ū ����� ����)                  
SELECT *
FROM emp
WHERE deptno < ANY (SELECT deptno
                    FROM emp
                    WHERE ename IN ('SMITH', 'WARD'));

--deptno�� ������ 20, 30�� �μ� �����ϰ� 10�� �μ��� ����
--deptno�� Ŭ�� �ƹ��͵� �ȳ��´�
SELECT *
FROM emp
WHERE deptno > ALL (SELECT deptno
                    FROM emp
                    WHERE ename IN ('SMITH', 'WARD'));

--SMITH Ȥ�� WARD���� �޿��� ���� �޴� ���� ��ȸ
SELECT *
FROM emp
WHERE sal < ANY (SELECT sal --800, 1250 = 1250���� ���� ���
                 FROM emp
                 WHERE ename IN ('SMITH', 'WARD'));

SELECT *
FROM emp
WHERE sal <= ALL (SELECT sal --800, 1250 ('<='�� ���� : 800���� ũ�ų� ���� ���)
                 FROM emp
                 WHERE ename IN ('SMITH', 'WARD'));
                 
--������ ������ ���� �ʴ� ��� ���� ��ȸ
--NOT IN ������ ���� NULL�� �����Ϳ� �������� �ʾƾ� �������Ѵ�(NULL�� ���� ����� ���� ������ �ʱ⶧���� NVL�� ���� �����Ѵ�)
SELECT *
FROM emp
WHERE empno NOT IN (SELECT mgr
                    FROM emp); -->�������� mgr�÷��� NULL���� �ֱ� ������ ����� �ȳ��´�

SELECT *
FROM emp --��� ���� ��ȸ --> ������ ������ ���� �ʴ� ����
WHERE empno NOT IN (SELECT NVL(mgr, -1) --mgr�÷��� ���� �������� ���� �־���Ѵ�
                    FROM emp);

SELECT *
FROM emp --��� ���� ��ȸ --> ������ ������ ���� �ʴ� ����
WHERE empno NOT IN (SELECT mgr
                    FROM emp
                    WHERE mgr IS NOT null);
                    
--�������� ���
SELECT *
FROM emp
WHERE empno IN (SELECT mgr
                FROM emp);
                
                
--pair wise (���� �÷��� ���� ���ÿ� �����ؾ��ϴ� ���)
--ALLEN, CLARK�� �Ŵ����� �μ���ȣ�� ���ÿ� ���� ��� ���� ��ȸ

--'NON' PAIR WISE�� ���
-- (7698, 30)
-- (7839, 10)
SELECT *
FROM emp
WHERE (mgr, deptno) IN (SELECT mgr, deptno
                        FROM emp
                        WHERE empno IN (7499, 7782));

--PAIR WISE�� ��� 
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
               


--���ȣ ���� ���� ����
--���������� �÷��� ������������ ������� �ʴ� ������ ���� ����

--���ȣ ���� ���������� ��� ������������ ����ϴ� ���̺�, �������� ��ȸ ������ ���������� ������������ �Ǵ��Ͽ� ������ �����Ѵ�
--���������� emp���̺��� ���� �������� �ְ�, ���������� emp���̺��� ���� ���� ���� �ִ�

--���ȣ ���� ������������ ���������� ���̺��� ���� ���� ���� ���������� �����ڿ����� �ߴ�(�� � ���ڰ� ����)
--���ȣ ���� ������������ ���������� ���̺��� ���߿� ���� ���� ���������� Ȯ���ڿ����� �ߴ�(�� � ���ڰ� ����)

--������ �޿� ��պ��� ���� �޿��� �޴� ���� ���� ��ȸ
--������ �޿� ���
SELECT *
FROM emp
WHERE sal > (SELECT AVG(sal) --���������� ���� �۵��Ѵ�
             FROM emp);
             
--��ȣ ���� ���� ����
--�ش������� ���� �μ��� �޿���պ��� ���� �޿��� �޴� ���� ��ȸ

SELECT *
FROM emp m
WHERE sal > (SELECT AVG(sal)
            FROM emp
            WHERE deptno = m.deptno);