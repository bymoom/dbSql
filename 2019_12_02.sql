--OUTER join : ���� ���ῡ ���� �ϴ��� ������ �Ǵ� ���̺��� �����ʹ� �������� �ϴ� join
--LEFT OUTER JOIN : ���̺�1 LEFT OUTER JOIN ���̺�2
--���̺�1�� ���̺�2�� �����Ҷ� ���ο� �����ϴ��� ���̺�1���� �����ʹ� ��ȸ�� �ǵ��� �Ѵ�
--���ο� ������ �࿡�� ���̺�2�� �÷����� �������� �����Ƿ� NULL�� ǥ�õȴ�

--ANSI
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e LEFT OUTER JOIN emp m
            ON (e.mgr = m.empno);
            
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e JOIN emp m
            ON (e.mgr = m.empno);
            
--��
SELECT e.empno, e.ename, m.empno, m.ename , e.deptno, m.deptno --m ���̺��� �μ���ȣ 10���� ������ �������� null
FROM emp e LEFT OUTER JOIN emp m
            ON (e.mgr = m.empno) --'AND m.deptno=10'�� ���� null ���� �� ����
WHERE m.deptno=10; --where���� 'm.deptno=10'�� ���� null���� �� ������

--ORACLE outer join syntax
--�Ϲ�(ANSI)���ΰ� �������� WHERE�� �÷����� (+)�� �Է��Ѵ�
--(+)ǥ�� : �����Ͱ� �������� �ʴµ� ���;� �ϴ� ���̺��� �÷�
--ANSI������ ���� LEFT OUTER JOIN �Ŵ���
--              ON(����.�Ŵ�����ȣ = �Ŵ���.������ȣ)
--ORACLE OUTER������ WHERE ����.�Ŵ�����ȣ = �Ŵ���.������ȣ(+) --�Ŵ����� �����Ͱ� �������� ������
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno(+);

--�Ŵ��� �μ���ȣ ����
--ANSI SQL���� WHERE ���� ����� ����
--OUTER ������ ������� ���� ��Ȳ(null���� �ƴ� ����� ����)
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno(+)
AND m.deptno = 10;

--ANSI SQL�� ON���� ����� ���� ����
--�ƿ��� ������ ����Ǿ�� �ϴ� ���̺��� ��� �÷��� (+)�� �پ�� �Ѵ�.(��� ����� ����)
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno(+)
AND m.deptno(+) = 10;

--emp ���̺����� 14���� ������ �ְ� 14���� 10, 20, 30�� �μ��� ����
--������ dept ���̺����� 10, 20, 30, 40�� �μ��� ����
--�μ���ȣ, �μ���, �ش�μ��� ���� �������� �������� ������ �ۼ�
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
WHERE dept.deptno = emp_cnt.deptno(+); --40�� �μ� ������ emp�� ����Ǿ� ���� �ʱ� ������ (+)�� emp�� ����

--ANSI SQL
SELECT dept.deptno, dname, NVL(emp_cnt.cnt, 0) cnt
FROM dept LEFT OUTER JOIN
    (SELECT deptno, COUNT(*) cnt
    FROM emp
    GROUP BY deptno) emp_cnt
    ON(dept.deptno = emp_cnt.deptno);
    
SELECT dept.deptno, dept.dname, COUNT(*) cnt, COUNT(emp.deptno) cnt --(����)���� �ƴ� (��)���� ���Ҷ��� COUNT(*)
FROM emp, dept
WHERE emp.deptno(+) = dept.deptno
GROUP BY dept.deptno, dept.dname;

--RIGHT OUTER JOIN
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e RIGHT OUTER JOIN emp m
            ON (e.mgr = m.empno);
            
--FULL OUTER JOIN <-ORACLE���� FULL OUTER����� ����
--LEFT OUTER + RIGHT OUTER - �ߺ������� �ѰǸ� �����

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
ON (buyprod.buy_date = TO_DATE('050125', 'YYMMDD')
    AND prod.prod_id = buyprod.buy_prod);

--outerjoin2
SELECT NVL(TO_CHAR(buy_date, 'YY/MM/DD'), '05/01/25') buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM buyprod RIGHT OUTER JOIN prod ON (buyprod.buy_prod = prod.prod_id)
AND buy_date = TO_DATE('05/01/25', 'YY/MM/DD');

--outerjoin3
SELECT NVL(buy_date, '2005/01/25'), buy_prod, prod_id, prod_name, NVL (buy_qty, 0)
FROM buyprod RIGHT JOIN prod ON (buyprod.buy_prod = prod.prod_id)
AND buy_date = '2005/01/25';

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
SELECT product.pid, product.pnm, NVL(cycle.cid, 1) cid, NVL(cycle.day, 0) day, NVL(cycle.cnt, 0) cnt
FROM cycle, product
WHERE cycle.pid(+) = product.pid
AND cycle.cid(+) = '1';

--outerjoin5
SELECT product.pid, product.pnm, NVL(cycle.cid, 1) cid, NVL(customer.cnm, 'brown'), NVL(cycle.day, 0) day, NVL(cycle.cnt, 0) cnt
FROM cycle, product, customer
WHERE cycle.pid(+) = product.pid
AND customer.cid(+) = cycle.cid
AND cycle.cid(+) = '1'
ORDER BY pid desc;