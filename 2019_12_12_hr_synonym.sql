SELECT *
FROM BR.USERS;

SELECT *
FROM jobs;

SELECT *
FROM user_tables;

--78�� --> 79 (br�������� fastfood ���̺� ���ٱ��� ����)
SELECT *
FROM all_tables;

SELECT *
FROM all_tables
WHERE OWNER = 'BR';

--�ٸ� ���� ���̺� ��ȸ�� �� ���� �̸� �ٿ������
SELECT *
FROM br.fastfood;
--BR.fastfood --> fastfood �ó������ ����
--���� �� ���� sql�� ���������� �����ϴ��� Ȯ��
CREATE SYNONYM fastfood FOR br.fastfood;
--DROP SYNONYM fastfood; --�ó�� ����

--���� : ó������ ����� ��� �� ���̺����� �𸣱⶧���� ���Ǿ �� ã�ƺ����Ѵ�
SELECT *
FROM fastfood;