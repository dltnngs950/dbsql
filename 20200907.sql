ROWNUM : 1부터 읽어야 한다.
         SELECT 절이 ORDER BY 절 보다 먼저 실행된다.
          ==> ROWNUM을 이용하여 순서를 부여 하려면 정렬부터 해야한다.
           ==> 인라인뷰 ( ORDER BY ~ 
           
           
row_1]

SELECT ROWNUM rn, empno, ename
FROM emp
WHERE ROWNUM <= 10;
--> 실행 순서가 from 1 -> where 2 -> select 로 갔기때문에 컬럼 별칭이 where 에서 읽힐 수가 없음을 인지해야함
    그래서 ROWNUM <= 10; 임 rn <= 10; 가 아니라.
 
row_2]

SELECT *
FROM
(SELECT ROWNUM rn, empno, ename
FROM emp)
WHERE rn BETWEEN 11 AND 20;

row_3]

SELECT *
FROM (SELECT ROWNUM rn, a.*
      FROM (SELECT empno, ename
            FROM emp
            ORDER BY ename) a)
WHERE rn BETWEEN 11 AND 20;



ORACLE 함수 분류
1. SINGLE ROW FUNCTION : 단일 행을 작업의 기준, 결과도 한건 반환
2. MULTI ROW FUNCTION : 여러 행을 작업의 기준, 하나의 행을 결과로 반환

dual 테이블
     1. sys 계정에 존재하는 누구나 사용할 수 있는 테이블
     2. 테이블에는 하나의 컬럼, dummy가 존재, 값은 X
     3. 하나의 행만 존재
      ***** SINGLE 
      
SELECT empno, ename, LENGTH(ename), LENGTH('hello')
FROM emp;

SELECT LENGTH ('hello')
FROM dual;

SELECT *
FROM dual;

sql 칠거지악
1. 좌변을 가공하지 말아라 (테이블 컬럼에 함수를 사용하지 말것)
  . 함수 실행 횟수
  . 인덱스 사용관련(추후에)
  
SELECT ename, LOWER(ename)
FROM emp
WHERE LOWER(ename) = 'smith';

SELECT ename, LOWER(ename)
FROM emp
WHERE ename = UPPER('smith');
==> 이 쿼리가 위에 쿼리보다 좋다.

SELECT ename, LOWER(ename)
FROM emp
WHERE ename = 'smith';

문자열 관련함수
SELECT CONCAT('Hello', ', World') concat,
       SUBSTR('Hello, World', 1, 5) substr,
       SUBSTR('Hello, World', 5) substr2,
       LENGTH('Hello, World') length,
       INSTR('Hello, World', 'o') instr,
       INSTR('Hello, World', 'o', 5 + 1) instr2,
       INSTR('Hello, World', 'o', INSTR('Hello, World', 'o') + 1) instr3,
       LPAD('Hello, World', 15, '*') lpad,
       LPAD('Hello, World', 15) lpad,
       RPAD('Hello, World', 15, '*') rpad,
       REPLACE('Hello, World', 'Hello', 'Hell') replace,
       TRIM('Hello, World') trim,
       TRIM('    Hello, World    ') trim2,
       TRIM( 'H' FROM 'Hello, World') trim3
FROM dual;


숫자 관련 함수
ROUND : 반올림 함수
TRUNC : 버림 함수
   ==> 몇번째 자리에서 반올림, 버림을 할지?
       두번째 인자가 0, 양수 : ROUND(숫자, 반올림 결과 자리수)
       두번째 인자가 음수 : ROUND(숫자, 발올림 해야하는 위치)
     
MOD : 나머지를 구하는 함수

SELECT TRUNC(105.54, 1) trunc,
       TRUNC(105.55, 1) trunc2,
       TRUNC(105.55, 0) trunc3,
       TRUNC(105.55, -1) trunc4
FROM dual;

mod 나머지 구하는 함수
피제수 - 나눔을 당하는 수, 제수 - 나누는 수

a/b = c
피제수 : a
제수 : b

SELECT mod(10, 3)
FROM dual;

10을 3으로 나누었을 때 몫을 구하기
SELECT mod(10, 3) "mod", 10*3 "double", TRUNC(10/3, 0) "trunc"
FROM dual;


날짜 관련 함수
문자열 ==> 날짜 타입 TO_DATE
SYSDATE : 오라클 서버의 현재 날짜, 시간을 돌려주는 특수함수
          함수의 인자가 없다
          (java 
           public void test(){
           }
           test();
           
           SQL
           length('Hello, World')
           SYSDATE ;
           
SELECT SYSDATE "date and time"
FROM dual;

날짜 타입 +- 정수(일자) : 날짜에서 정수만큼 더한(뺀) 날짜
하루 = 24
1일 = 24h
1/24일 = 1h
1/24일/60 = 1m
1/24일/60/60 = 1s
emp hiredate +5, -5

SELECT SYSDATE, SYSDATE + 5, SYSDATE - 5,
       SYSDATE + 1/24, SYSDATE + 1/24/60, SYSDATE + 1/24/60/60
FROM dual;

date fn1]

SELECT TO_DATE('20191231') lastday, TO_DATE('20191231') - 5 lastday_before5, SYSDATE now, SYSDATE -3 now_before3
FROM dual;

날짜를 어떻게 표현할까?
java : java.util.Date
sql : nsl 포맷에 설정된 문자열 형식을 따르거나
    ==> 툴 때문일수도 있음 예측하기 힘듬.
    TO_DATE 함수를 이용하여 명확하게 명시
    TO_DATE ('날짜 문자열', '날짜 문자열 형식')
    
SELECT TO_DATE('2019/12/31', 'YYYY/MM/DD') LASTDAY,
       TO_DATE('2019/12/31', 'YYYY/MM/DD')-5 "LASTDAY BEFORE5",
       SYSDATE NOW ,
       SYSDATE -3 "NOW BEFORE3"
FROM dual;


