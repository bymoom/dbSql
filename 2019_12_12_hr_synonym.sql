SELECT *
FROM BR.USERS;

SELECT *
FROM jobs;

SELECT *
FROM user_tables;

--78개 --> 79 (br계정에서 fastfood 테이블 접근권한 방음)
SELECT *
FROM all_tables;

SELECT *
FROM all_tables
WHERE OWNER = 'BR';

--다른 계정 테이블 조회시 그 계정 이름 붙여줘야함
SELECT *
FROM br.fastfood;
--BR.fastfood --> fastfood 시노님으로 생성
--생성 후 다음 sql이 정상적으로 동작하는지 확인
CREATE SYNONYM fastfood FOR br.fastfood;
--DROP SYNONYM fastfood; --시노님 삭제

--단점 : 처음보는 사람은 어디서 온 테이블인지 모르기때문에 동의어를 다 찾아봐야한다
SELECT *
FROM fastfood;