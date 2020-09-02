== SELECT 쿼리 문법 ==

SELECT * | { column | expression [alias] }   -> (expression은 컬럼에 연산을 하는 것.)
FROM 테이블 이름;

SQL 실행 방법
1. 실행하려고 하는 SQL을 선택 후 ctrl + enter;
2. 실행하려는 sql 구문에 커서를 위치시키고 ctrl + enter;

SELECT *
FROM emp;

SELECT empno, ename
FROM emp;

SELECT *
FROM dept;

sql의 경우 KET워드의 대소문자를 구분하지 않는다. 테이블 명도 상관안함 dept 든지 DEFT 든지 그래서 아래 쿼리도 정상적으로 작동한다.

select *
from DEPT;


coding rule
수업시간에서 ketword는 대문자
그 외 (테이블명, 컬럼명) 등은 소문자.

SELECT 실습1]

SELECT *
FROM lprod;

SELECT buyer_id, buyer_name
FROM buyer;

SELECT *
FROM cart;

SELECT mem_id, mem_pass, mem_name
FROM member;

연산

SELECT 쿼리는 데이터에 영향을 주지 않으므로 잘못 작성했다고 해서 데이터가 망가지거나 하지 않음.

SELECT ename, sal, sal+100
FROM emp;

데이터 타입 

DESC 테이블명 (테이블 구조를 확인)


숫자 + 숫자 = 숫자
5 + 6 = 11

문자 + 문자 = 문자 ==> java에서는 문자열을 이은, 문자열 결합으로 처리

수학적으로 정의된 개념이 아님
오라클에러 정의한 개념
날짜에다가 숫자를 일수로 생각해서 더하고 뺀 숫자가 일자가 결과로 된다.
-> 날짜 + 숫자 = 날짜

별칭 : 컬럼, expression에 새로운 이름을 부여
      컬럼 | expression [AS] [컬럼명]

SELECT ename AS emp_name, hiredate, 
hiredate + 365 after_1year, hiredate - 365 before_1year
FROM emp;

== 중요하지는 않음 ==

별칭을 부여할 때 주의할 점
1. 공백이나, 특수문자가 있는 경우 더블 쿼테이션으로 감싸주어야 한다. ( "  " ) -> 더블 쿼테이션
2. 별칭명은 기본적으로 대문자로 취급되지만 소문자로 지정하고 싶으면 더블 퀘테이션을 사용한다.

SELECT ename "emp name", empno emp_no
FROM emp;

자바에서의 문자열 : "Hello, World" -> 더블 쿼테이션
SQL에서의 문자열 : 'Hello, World' -> 싱글 쿼테이션

== 매우 중요 ==
NULL : 아직 모르는 값
숫자 타입 : 0이랑 NULL은 다르다.
문자 타입 : ' ' 공백문자와 NULL은 다르다.

**** NULL을 포함한 연산의 결과는 항상 NULL 이다.
5 * NULL = NULL
600 + NULL = NULL
800 + 0 =  800

emp 테이블에서 NULL 값을 확인해보자.

SELECT *
FROM emp;

emp 테이블 컬럼정리

1. empno : 사원번호
2. ename : 사원이름
3. job : 담당업무
4. mgr : 매니저번호
5. hiredate : 입사일자
6. sal : 급여
7. comm : 성과급
8. deptno : 부서번호

SELECT *
FROM dept;

emp 테이블에서 NULL값을 확인해보자.

SELECT ename, sal, comm, sal + comm AS total_sal
FROM emp;

SELECT userid, usernm, reg_dt, freg_dt + 5
FROM users;

SELECT 실습2 ]

SELECT prod_id AS id, prod_name AS name
FROM prod;

SELECT lprod_gu AS gu, lprod_nm AS nm
FROM lprod;

SELECT buyer_id AS 바이어아이디, buyer_name AS 이름
FROM buyer;

literal : 값 자체를 말함
literal 표기법 : 값을 표현하는 방법

숫자 10이라는 값을 
java : int a = 10;
sql : SELECT empno, 10
      FROM emp;
      
문자 Hello, world 라는 문자 값을
java : String str = "Hello, World";
sql : SELECT empno, 'Hello, World', "Hello, World"
      FROM emp;
      
날짜 2020년 9월 2일이라는 날짜 값을
java : primitive type (원시타입) : 8개 
                                 문자열 ==> String class
                                 날짜 ==> Date class
sql : 나중에 알려줌

문자열 연산 
java
     "Hello," + "World" ==> "Hello,World"
     "Hello," - "World" ==> 연산자가 정의되어 있지 않다.
     
Python
     "Hello," * 3 ==> "Hello, Hello, Hello"
sql ||, CONCAT 함수 ==> 결합 연산

emp 테이블의 ename, job 컬럼이 문자열 일때

ename + " " + job
ename || ' ' || job


SELECT ename || ' ' || job
FROM emp;

CONCAT (문자열1, 문자열2) : 문자열1과 문자열2를 합쳐서 만들어진 새로운 문자열을 반환해준다.

SELECT ename || ' ' || job, CONCAT(ename, ' ')
FROM emp;

SELECT ename || ' ' || job AS ename_job
FROM emp;

DESC emp;

USER_TABLES : 오라클에서 관리하는 테이블(뷰)
              접속한 사용자가 보유하고 있는 테이블 정보를 관리
              
SELECT table_name
FROM user_tables;

SELECT table_name, CONCAT('SELECT' , CONCAT(' * ', CONCAT(' FROM ', CONCAT(table_name,';')))) AS qeury
FROM user_tables;

선생님 답안 -->
SELECT table_name, 'SELECT * FROM ' || table_name || ';' AS qeury
FROM user_tables;



