--PRIMARY KEY ���� : UNIQUE + NOT NULL

--UNIQUE : �ش� �÷��� ������ ���� �ߺ��� �� ����
--        (EX : emp ���̺��� empno(���)
--            dept ���̺��� deptno(�μ���ȣ))
--            �ش� �÷��� null���� �����ִ�
--            
--NOT NULL : ������ �Է½� �ش� �÷��� ���� �ݵ�� ���;� �Ѵ�

--�÷������� PRIMARY KEY ���� ����
--����Ŭ�� �������� �̸��� ���Ƿ� ����(EX : SYS-C000701)�ϹǷ� ����Ŭ ���� ������ �̸��� ���Ƿ� �����Ѵ�
--primary key : pk_���̺���
--CREATE TABLE dept_test (
--    deptno NUMBER(2) CONSTRAINT pk_dept_test PRIMARY KEY,


--PAIRWISE : ���� ����
--����� PRIMARY KEY ���� ������ ��� �ϳ��� �÷��� ���� ������ �����ϴ� ���̾���
--���� �÷��� �������� PRIMARY KEY �������� ������ �� �ִ� -> �ش� ����� ���� �ΰ��� ����ó�� �÷� ���������� ������ �� ����
-->TABLE LEVEL ���� ���ǻ���

--������ ������ dept_test ���̺� ����(drop)
DROP TABLE dept_test;

--�÷������� �ƴ�, ���̺� ������ �������� ����
CREATE TABLE dept_test (
    deptno NUMBER(2),
    dname VARCHAR(14),
    loc VARCHAR2(13), --������ �÷� ������ �޸� ������ �ʱ�
    --deptno, dname �÷��� ������ ������(�ߺ���) �����ͷ� �ν�
    CONSTRAINT pk_dept_test PRIMARY KEY (deptno, dname) --�÷� �ϳ��� �Է��� ���� ����
    );

--�μ���ȣ, �μ��̸� ���������� �ߺ� �����͸� ����
--�Ʒ� �ΰ��� insert ������ �μ���ȣ�� ������ �μ����� �ٸ��Ƿ� ���� �ٸ� �����ͷ� �ν� --> INSERT ����
INSERT INTO dept_test VALUES(99, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES(99, '���', '����');

SELECT *
FROM dept_test;

--�ι�° INSERT ������ Ű���� �ߺ��ǹǷ� ����
INSERT INTO dept_test VALUES(99, '���', 'û��');

--NOT NULL ��������
--�ش� �÷��� NULL ���� ������ ���� ������ �� ���
--���� �÷����� �Ÿ��� �ִ�

--������ ������ dept_test ���̺� ����(drop)
DROP TABLE dept_test;

--�÷������� �ƴ�, ���̺� ������ �������� ����
--dname �÷��� null���� ������ ���ϵ��� NOT NULL ���� ���� ����
CREATE TABLE dept_test (
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR(14) NOT NULL,
    loc VARCHAR2(13)
    );

--deptno �÷��� primary key ���࿡ �ɸ��� �ʰ�
--loc �÷��� nullable�̱� ������ null ���� �Է� �� �� �ִ�
INSERT INTO dept_test VALUES(99, 'ddit', NULL);

--deptno �÷��� primary key ���࿡ �ɸ��� �ʰ�(�ߺ��� ���� �ƴϴϱ�)
--dname �÷��� NOT NULL ���������� ����
INSERT INTO dept_test VALUES(98, NULL, '����');


--
DROP TABLE dept_test;

CREATE TABLE dept_test (
    deptno NUMBER(2) PRIMARY KEY,
    --deptno NUMBER(2) CONSTRAINT pk_dept_test PRIMARY KEY,
    dname VARCHAR(14) CONSTRAINT NN_dname NOT NULL,
    loc VARCHAR2(13)
    );


--    
DROP TABLE dept_test;

CREATE TABLE dept_test (
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR(14),
    loc VARCHAR2(13)
    --CONSTRAINT NN_dname NOT NULL (dname) : NOT NULL�� �� ���°� ������ �ʴ´�
    ); 

--1.�÷�����
--2.�÷����� �������� �̸� ���̱�
--3.���̺�����
--4.���̺� ������ �������� ����

--UNIQUE ���� ����
--�ش� �÷��� ���� �ߺ��Ǵ� ���� ����
--�� NULL ���� ���
--GLOBAL solution�� ��� ������ ���� ���� ������ �ٸ��� ������ pk ���ຸ�ٴ� UNIQUE ������ ����ϴ� ���̸�,
--������ ���� ������ APPLICATION �������� üũ�ϵ��� �����ϴ� ������ �ִ�

--���� ������ ���̺� ����(DROP)
DROP TABLE dept_test;

--�÷� ���� UNIQUE ���� ����
CREATE TABLE dept_test (
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR(14) UNIQUE, --������ ����Ŭ���� ���Ƿ� ������ �������� ���
    loc VARCHAR2(13)
    );

--�ΰ��� insert ������ ���� dname�� ���� ���� �Է��ϱ� ������
--dname �÷��� ����� UNIQUE ���࿡ ���� �ι�° ������ ���������� ����� �� ����
INSERT INTO dept_test VALUES (99, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES (98, 'ddit', '����');





--���� ������ ���̺� ����(DROP)
DROP TABLE dept_test;

--�÷� ���� UNIQUE ���� ����
CREATE TABLE dept_test (
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR(14) CONSTRAINT IDX_U_dept_test_01 UNIQUE, --������ constraint�� �������� ���
    loc VARCHAR2(13)
    );

--�ΰ��� insert ������ ���� dname�� ���� ���� �Է��ϱ� ������
--dname �÷��� ����� UNIQUE ���࿡ ���� �ι�° ������ ���������� ����� �� ����
INSERT INTO dept_test VALUES (99, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES (98, 'ddit', '����'); --������ constraint�� �������� ���




--���� ������ ���̺� ����(DROP)
DROP TABLE dept_test;

--���̺� ���� UNIQUE ���� ����
CREATE TABLE dept_test (
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR(14),
    loc VARCHAR2(13),

    CONSTRAINT IDX_U_dept_test_01 UNIQUE (dname) --'IDX' = �ε����� �ǹ�, 'U' = ����ũ�� �ǹ�
    );

--�ΰ��� insert ������ ���� dname�� ���� ���� �Է��ϱ� ������
--dname �÷��� ����� UNIQUE ���࿡ ���� �ι�° ������ ���������� ����� �� ����
INSERT INTO dept_test VALUES (99, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES (98, 'ddit', '����'); --�����߻�


--FOREIGN KEY ��������
--�ٸ� ���̺��� �����ϴ� ���� �Էµ� �� �ֵ��� ����

--emp_test.deptno -> dept_test.deptno �÷��� ���� �ϵ��� FOREIGN KEY ���� ���� ����


--dept_test ���̺� ����(drop)
DROP TABLE dept_test;

--dept_test ���̺� ���� (deptno �÷� PRIMARY KEY ����)
--DEPT ���̺��� �÷��̸�, Ÿ�� �����ϰ� ����
CREATE TABLE dept_test (
     deptno NUMBER(2) PRIMARY KEY,
     dname VARCHAR2(14),
     loc VARCHAR2(13)
     );
     
INSERT INTO dept_test VALUES(99, 'DDIT', 'daejeon');
COMMIT;

DESC emp;
--empno, ename, deptno : emp_test
--empno PRIMARY KEY
--deptno dept_test.deptno FOREIGN KEY

--�÷� ���� FOREIGN KEY
CREATE TABLE emp_test (
     empno NUMBER(4) PRIMARY KEY,
     ename VARCHAR2(10),
     deptno NUMBER(2) REFERENCES dept_test (deptno) --FOREIGN KEY�� REFERENCES(+ ������ ���̺��� (�÷���))��� ����
     );

--dept_test ���̺��� �����ϴ� deptno(99)�� ���� �Է�
INSERT INTO emp_test VALUES (9999, 'brown', 99);

--dept_test ���̺��� �������� �ʴ� deptno(98)�� ���� �Է�
INSERT INTO emp_test VALUES (9998, 'sally', 98); --�����߻�(99�� �Է��ϸ� ����ȴ�)


--emp_test ����
DROP TABLE emp_test;

--�÷� ���� FOREIGN KEY(�������� �� �߰�)
CREATE TABLE emp_test (
     empno NUMBER(4) PRIMARY KEY,
     --     empno NUMBER(4) CONSTRAINT ���������̸� PRIMARY KEY,
     ename VARCHAR2(10),
     --deptno NUMBER(2) REFERENCES dept_test (deptno) --FOREIGN KEY�� REFERENCES(+ ������ ���̺��� (�÷���))��� ����

--     deptno NUMBER(2) CONSTRAINT FK_dept_test FOREIGN KEY
--                        REFERENCES dept_test (deptno) --�̰� �ȵ�(�÷����������� ���������̸��� ��������)
    deptno NUMBER(2),
    
    CONSTRAINT FK_dept_test FOREIGN KEY (deptno)
    REFERENCES dept_test (deptno) --���̺��������� ���������̸� ���
     );

--dept_test ���̺��� �����ϴ� deptno(99)�� ���� �Է�
INSERT INTO emp_test VALUES (9999, 'brown', 99);

--dept_test ���̺��� �������� �ʴ� deptno(98)�� ���� �Է�
INSERT INTO emp_test VALUES (9998, 'sally', 98); --�����߻�(99�� �Է��ϸ� ����ȴ�)

SELECT *
FROM emp_test;

--DELETE dept_test
--WHERE deptno=99; --FOREIGN KEY �ɾ���� �����ϴ°� �ȵ�
--�μ������� ������� ��������ϴ� �μ���ȣ�� �����ϴ� ���������� ���� �Ǵ� deptno �÷��� NULL ó��
--emp_test(�θ�) ����� -> dept_test(�ڽ�) ��������



--���� ���̺� ����(DROP)
DROP TABLE emp_test;

--FOREIGN KEY OPTION -ON DELETE CASCADE
CREATE TABLE emp_test (
     empno NUMBER(4) PRIMARY KEY,
     ename VARCHAR2(10),
    deptno NUMBER(2),
    
    CONSTRAINT FK_dept_test FOREIGN KEY (deptno)
    REFERENCES dept_test (deptno) ON DELETE CASCADE --ON DELETE CASCADE ���� �ڽ� ���̺����� �����͸� ������ ��� �θ����̺� �����͵� ������
     );

--dept_test ���̺��� �����ϴ� deptno(99)�� ���� �Է�
INSERT INTO emp_test VALUES (9999, 'brown', 99);
COMMIT;

--������ �Է� Ȯ��
SELECT *
FROM emp_test;

--ON DELETE CASCADE �ɼǿ� ���� DEPT �����͸� ������ ��� �ش� �����͸� �����ϰ� �ִ� EMP ���̺��� ��� �����͵� �����ȴ�
DELETE dept_test
WHERE deptno=99; --emp_test ���̺� ������ ON DELETE CASCADE �Է��ϸ� dept_test���̺��� �����͸� �����ϸ� emp_test ���̺��� �����͵� ������
ROLLBACK;



--���� ���̺� ����(DROP)
DROP TABLE emp_test;

--FOREIGN KEY OPTION -ON DELETE SET NULL
CREATE TABLE emp_test (
     empno NUMBER(4) PRIMARY KEY,
     ename VARCHAR2(10),
    deptno NUMBER(2),
    
    CONSTRAINT FK_dept_test FOREIGN KEY (deptno)
    REFERENCES dept_test (deptno) ON DELETE SET NULL --ON DELETE SET NULL ���� �ڽ� ���̺����� �����͸� ������ ��� �θ����̺� �����Ͱ� null�� �ٲ�
     );

--dept_test ���̺��� �����ϴ� deptno(99)�� ���� �Է�
INSERT INTO emp_test VALUES (9999, 'brown', 99);
COMMIT;

--������ �Է� Ȯ��
SELECT *
FROM emp_test;

--ON DELETE SET NULL �ɼǿ� ���� DEPT �����͸� ������ ��� �ش� �����͸� �����ϰ� �ִ� EMP ���̺��� EMP���̺��� DEPTNO �÷��� NULL�� ����
DELETE dept_test
WHERE deptno=99; --emp_test ���̺� ������ ON DELETE SET NULL �Է��ϸ� dept_test���̺��� �����͸� ������ emp_test ���̺��� �����ʹ� null�� �ٲ�
ROLLBACK;



--CHECK ��������
--�÷��� ���� ���� ������ ��
--EX : �޿� �÷����� ���� 0���� ū ���� ������ üũ
--      ���� �÷����� ��/�� Ȥ�� F/M ���� ������ ����

--emp_test ���̺� ����(drop)
DROP TABLE emp_test;

--emp_test ���̺� �÷�
--empno NUMBER(4)
--ename VARCHAR2(10)
--sal NUMBER(7,2) --0���� ū ���ڸ� �Է� �ǵ��� ����
--emp_gb VARCHAR2(2) --���� ���� 01-������, 02-����
CREATE TABLE emp_test (
        empno NUMBER(4) PRIMARY KEY,
        ename VARCHAR2(10),
        sal NUMBER(7, 2) CHECK (sal > 0),
        emp_gb VARCHAR2(2) CHECK (emp_gb IN ('01', '02')) 
        );
        
--emp_test ������ �Է�
--sal �÷� check ��������(sal > 0)�� ���ؼ� ���� ���� �Է� �ɼ� ����
INSERT INTO emp_test VALUES (9999, 'brown', -1, '01'); --check constraint (BR.SYS_C007146)����

--CHECK �������� �������� �����Ƿ� ���� �Է�(sal, emp_gb)
INSERT INTO emp_test VALUES (9999, 'brown', 1000, '01');

--emp_gb check ���ǿ� ���� (emp_gb IN ('01', '02'))
INSERT INTO emp_test VALUES (9998, 'sally', 1000, '03'); --check constraint (BR.SYS_C007147)����

--CHECK �������� �������� �����Ƿ� ���� �Է�(sal, emp_gb)
INSERT INTO emp_test VALUES (9998, 'sally', 1000, '02');

SELECT *
FROM emp_test;

--���̺� ����
DROP TABLE emp_test;

--CHECK �������ǿ��� ���������̸� ����
CREATE TABLE emp_test (
        empno NUMBER(4) PRIMARY KEY,
--        empno NUMBER(4) CONSTRAINT �������Ǹ� PRIMARY KEY,

        ename VARCHAR2(10),
--        sal NUMBER(7, 2) CHECK (sal > 0),
        sal NUMBER(7, 2) CONSTRAINT C_SAL CHECK (sal > 0),
        
--        emp_gb VARCHAR2(2) CHECK (emp_gb IN ('01', '02'))
        emp_gb VARCHAR2(2) CONSTRAINT C_EMP_GB
                            CHECK (emp_gb IN ('01', '02'))
        );
        
        

        
--���̺� ����
DROP TABLE emp_test;

--table level�� CHECK �������ǿ��� ���������̸� ����
CREATE TABLE emp_test (
        empno NUMBER(4) PRIMARY KEY,
        ename VARCHAR2(10),
        sal NUMBER(7, 2),
        emp_gb VARCHAR2(2),

        CONSTRAINT nn_ename CHECK (ename IS NOT NULL), --NOT NULL�� CHECK ���࿡ �������� ���� ���� ����ϱ⶧���� ������ PRIMARY KEYó�� �÷��� ���� ���� ���        
        CONSTRAINT C_SAL CHECK (sal > 0),
        CONSTRAINT C_EMP_GB CHECK (emp_gb IN ('01', '02'))
        );
        
        
--���̺� ���� : CREATE TABLE ���̺��� (
--                  �÷� �÷� Ÿ�� .....);
--���� ���̺��� Ȱ���ؼ� ���̺� �����ϱ� (Create Table As : CTAS (��Ÿ��))
--CREATE TABLE ���̺��� [(�÷�1, �÷�2, �÷�3...)] AS -> [] = �ɼ�
--SELECT col1, col2...
--FROM �ٸ� ���̺���
--WHERE ���� -> �����ͱ��� ������ �� ����

--emp_test ���̺� ����(drop)
DROP TABLE emp_test;

--emp ���̺��� �����͸� �����ؼ� emp_test ���̺��� ����
CREATE TABLE emp_test AS
    SELECT *
    FROM emp;

--���� ���̺��� �����͸� �����ؼ� ������ ���̺��� ������ �����͸� ���� �ִ��� Ȯ���ϴ� ���
--emp - emp_test = ������    
SELECT *
FROM emp_test
MINUS
SELECT *
FROM emp;

--emp_test - emp = ������
SELECT *
FROM emp
MINUS
SELECT *
FROM emp_test;


--emp_test ���̺� ����(drop)
DROP TABLE emp_test;

--emp ���̺��� �����͸� �����ؼ� emp_test ���̺��� �÷����� �����Ͽ� ����
CREATE TABLE emp_test (c1, c2, c3, c4, c5, c6, c7, c8) AS
    SELECT *
    FROM emp;

--emp_test ���̺� ����(drop)
DROP TABLE emp_test;

--�����ʹ� �����ϰ� ���̺��� ��ü(�÷� ����)�� �����Ͽ� ���̺� ����
CREATE TABLE emp_test AS
    SELECT *
    FROM emp
    WHERE 1=2; --������ ���� ������ �Է��Ѵ�

SELECT *
FROM emp_test;

--���� ���̺��� �����͸� ����� �� CREATE TABLE AS�� ��� -> KEY�� �������� �ʴ´�. ������ �����ؾ���
--CREATE TABLE emp_20191209 AS
--SELECT *
--FROM emp;


--emp_test ���̺� ����
DROP TABLE emp_test;

--empno, ename, deptno �÷����� emp_test ����
CREATE TABLE emp_test AS
    SELECT empno, ename, deptno
    FROM emp
    WHERE 1=2;
    
--emp_test ���̺��� �ű� �÷� �߰�
--HP VARCHAR2(20) DEFAULT '010'
--ALTER TABLE ���̺��� ADD (�÷��� �÷�Ÿ�� [default value]);
ALTER TABLE emp_test ADD (HP VARCHAR2(20) DEFAULT '010');

--���� �÷� ����
--ALTER TABLE ���̺��� MODIFY (�÷� �÷�Ÿ��);
--HP �÷��� Ÿ���� VARCHAR2(20) -> VARCHAR2(30)���� ����
ALTER TABLE emp_test MODIFY (HP VARCHAR2(30)); --���� ������� ū ������� ���쳪 �ݴ�� ��ƴ�

--hp �÷��� Ÿ���� VARCHAR2(30) -> NUMBER�� �����غ���
--���� emp_test ���̺��� "�����Ͱ� ���� ������" �÷� Ÿ���� �����ϴ� ���� �����ϴ�
ALTER TABLE emp_test MODIFY (HP NUMBER);
DESC emp_test;

--�÷��� ����
--�ش� �÷��� pk, unique, not null, check ���� ���ǽ� ����� �÷����� ���ؼ��� �ڵ������� ������ �ȴ�
--hp �÷� -> hp_n
--ALTER TABLE ���̺��� RENAME COLUMN �����÷��� TO �����÷���;
ALTER TABLE emp_test RENAME COLUMN hp TO hp_n;
DESC emp_test;

--�÷� ����
--ALTER TABLE ���̺��� DROP (�÷���); �Ǵ� DROP COLUMN �÷���;
--hp_n �÷� ����
ALTER TABLE emp_test DROP (hp_n);
ALTER TABLE emp_test DROP COLUMN hp_n; --�Ѵٰ���

--���������߰�
--ALTER TABLE ���̺��� ADD --���̺� ���� �������� ��ũ��Ʈ
--emp_test ���̺��� empno�÷��� pk�������� �߰�
ALTER TABLE emp_test ADD CONSTRAINT pk_emp_test PRIMARY KEY(empno);

--���� ���� ����
--ALTER TABLE ���̺��� DROP CONSTRAINT ���������̸�;
--emp_test ���̺��� PRIMARY KEY ���������� pk_emp_test ���� ����
ALTER TABLE emp_test DROP CONSTRAINT pk_emp_test;

--���̺� �÷�, Ÿ�� ������ ���������γ��� ����
--���̺��� �÷� ������ �����ϴ� ���� �Ұ����ϴ�
--empno, ename, job --> empno, job, ename (X)