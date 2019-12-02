--join0_3(185p)
--�μ���ȣ(deptno)
SELECT empno, ename, sal, emp.deptno, dname --ó�� ���� ����� �� ��츦 ������ ���̺�.���� �տ� �� ���̴°� ����
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND sal > 2500
AND empno > 7600;

--join0_4
SELECT empno, ename, sal, emp.deptno, dname --ó�� ���� ����� �� ��츦 ������ ���̺�.���� �տ� �� ���̴°� ����
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND sal > 2500
AND empno > 7600
AND dept.dname = 'RESEARCH';

--join1
--erd ���̾�׷��� �����Ͽ� prod ���̺��� lprod���̺��� �����Ͽ� ������ ���� ����� ������ ������ �ۼ��غ�����.
SELECT lprod.lprod_gu, lprod.lprod_nm, prod.prod_id, prod.prod_name
FROM lprod, prod
WHERE lprod.lprod_gu = prod.prod_lgu;



SELECT *
FROM buyer;
SELECT *
FROM prod;
--join2
SELECT buyer.buyer_id, buyer.buyer_name, prod.prod_id, prod.prod_name
FROM buyer, prod
WHERE buyer.buyer_id = prod.prod_buyer;

--join3
SELECT member.mem_id, member.mem_name, prod.prod_id, prod.prod_name, cart.cart_qty
FROM member, cart, prod
WHERE cart.cart_prod = prod.prod_id AND member.mem_id = cart.cart_member;

--join4
SELECT cycle.cid, customer.cnm, cycle.pid, cycle.day, cycle.cnt
FROM customer, cycle
WHERE customer.cnm IN ('brown', 'sally')
AND customer.cid = cycle.cid;

--join5
SELECT cycle.cid, customer.cnm, cycle.pid, product.pnm, cycle.day, cycle.cnt
FROM customer, cycle, product
WHERE customer.cnm IN ('brown', 'sally')
AND cycle.pid = product.pid
AND cycle.cid = customer.cid;

--join6
SELECT cycle.cid, customer.cnm, product.pid, product.pnm,
        SUM(cycle.cnt) cnt
FROM customer, cycle, product
WHERE product.pid = cycle.pid AND cycle.cid = customer.cid
GROUP BY cycle.cid, customer.cnm, product.pid, product.pnm;

--SELECT a.cid, cnm, pid, pnm,
--FROM
--    (SELECT cid, pid, SUM(cnt) cnt
--    FROM cycle
--    GROUP BY cid, pid) a, customer, product
--WHERE a.cid = customer.cid
--AND a.pid = product.pid;

--join7
SELECT product.pid, product.pnm,
        SUM(cycle.cnt) cnt --GROUP �Լ��� ���������̴�
FROM cycle, product
WHERE product.pid = cycle.pid
GROUP BY product.pid, product.pnm;
SELECT *
FROM cycle;