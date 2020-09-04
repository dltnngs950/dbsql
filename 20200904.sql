SELECT *
FROM emp
WHERE 10 BETWEEN 10 AND 50

DESC emp;

NULL 비교
NULL 값은 =, != 등의 비교연산으로 비교가 불가능
EX : emp 테이블에는 comm컬럼의 값이 NULL인 데이터가 존재

comm이 NULL인 데이터를 조회 하기 위해 다음과 같이 실행할 경우
정상적으로 동작하지 않음.

SELECT *
FROM emp
WHERE comm IS NULL;

comm컬럼의 값이 NULL이 아닐 때?

SELECT *
FROM emp
WHERE comm IS NOT NULL;

IN 에서도 NOT 사용 가능

SELECT *
FROM emp
WHERE deptno NOT IN (10);

사원중에 자신의 상급자가 존재하지 않는 사원들만 조회해보자. in ( 모든 컬럼)
SELECT *
FROM emp
WHERE mgr IS NULL;

논리 연산 : AND, OR, NOT 
AND, OR : 조건을 결합
    AND : 조건1 AND 조건2 : 조건1과, 조건2를 동시에 만족하는 행만 조회가 되도록 제한.
    OR  : 조건1 OR 조건2 : 조건1 혹은 조건2를 만족하는 행만 조회 되도록
    
조건1     조건2     조건1 AND 조건2     조건1 AND 조건2
 T        T             T                  T
 T        F             F                  T
 F        T             F                  T
 F        F             F                  F
 
 WHERE 절에 AND 조건을 사용하게 되면 => 보통은 행이 줄어든다.
 WHERE 절에 OR 조건을 사용하게 되면 => 보통은 행이 늘어난다.

NOT : 부정연산
다른 연산자와 함께 사용되며 부정형 표현으로 사용됨.
NOT IN (값1, 값2...)
IS NOT NULL
NOT EXISTS

mgr가 7698사번을 갖으면서 급여가 1000보다 큰 사원들을 조회
SELECT *
FROM emp
WHERE mgr = 7698
AND sal > 1000;

mgr가 7698 이거나 sal 보다 큰 사람
SELECT *
FROM emp
WHERE mgr = 7698
OR sal > 1000;

emp 테이블의 사원중에 mgr가 7698이 아니거나, 7839가 아닌 직원
SELECT *
FROM emp
WHERE mgr != 7698
AND mgr != 7839;

SELECT *
FROM emp
WHERE mgr NOT IN (7698, 7839);

IN 연산자는 OR연산자로 대체하는 것이 가능

WHERE mgr IN (7698, 7839); ==> mgr = 7698 OR mgr = 7839
WHERE mgr NOT IN (7998, 7839); ==> mgr != 7698 AND mgr != 7839   --> 시험에 나옴

IN 연산자 사용시 NULL 데이터 유의점
요구사항 : mgr가 7698, 7839, NULL 인 사원만 조회

SELECT *
FROM emp
WHERE mgr IN (7698, 7839, NULL);
mgr = 7698 OR mgr = 7839 OR mgr = NULL; 

SELECT *
FROM emp
WHERE mgr NOT IN (7698, 7839, NULL);
mgr != 7698 AND mgr != 7839 AND mgr != NULL;

WHERE 7]
SELECT *
FROM emp
WHERE job = 'SALESMAN'
AND hiredate > TO_DATE('1981/06/01','yyyy/mm/dd');

data type 표현
두가지 조건을 논리연산자로 묶는 방법 (AND) 을 한것이다. 

WHERE 8]
SELECT *
FROM emp
WHERE deptno != 10
AND hiredate > TO_DATE('19810601','yyyymmdd');

WHERE 10]
SELECT *
FROM emp
WHERE deptno IN (20, 30)
AND hiredate > TO_DATE('19810601','yyyymmdd');

WHERE 11 ~ 14 과제

정렬
********** 매우매우 중요 ***********

RDBMS는 집합에서 많은 부분을 차용했다.
집합의 특징   1 => 순서가 없다.
            2 => 중복을 허용하지 않는다.
{1, 5, 10} ==> {5, 1, 10} (집합에 순서는 없다)
{1, 5, 5, 10} ==> {1, 5, 10} (집합은 중복을 허용하지 않는다)

아래 sql의 실행결과, 데이터의 조회 순서는 보장되지 않는다.
지금은 7396, 7499 ..... 조회가 되지만
내일 동일한 sql을 실행 하더라도 오늘과 같은 순서가 보장되지 않는다 (바뀔수가 있음)

*데이터는 보편적으로 데이터를 입력한 순서대로 나온다 (보장되진 않음)
** table 에는 순서가 없다.
SELECT *
FROM emp;

시스템을 만들다 보면 정렬이 중요한 경우가 많다
ex => 네이버 카페등에 글을 올리면 가장 최신글이 위로 와야함으로 내가 쓴 글이 제일 최신글이 된다.

**즉 SELECT 결과 행의 순서를 조정할 수 있어야 한다.
  ==> ORDER BY 구문
문법 
SELECT *
FROM 테이블명
[WHERE]
[ORDER BY 컬럼1, 컬럼2]

오름차순, ASC => 값이 작은 데이터부터 큰 데이터 순으로 나열 
내림차순, DESC => 값이 큰 데이터부터 작은 데이터 순으로 나열

ORACLE에서는 기본적으로 오름차순이 기본 값으로 적용됨
내림차순으로 정렬을 원할경우 정렬 기준 컬럼 뒤에 DESC를 붙여준다.

job컬럼으로 오름차순 정렬하고, 같은 job을 갖는 행끼리는 empno로 내림차순 정렬한다

SELECT *   
FROM emp
ORDER BY job, empno DESC;

참고 :
1. ORDER BY 절에 별칭을 사용할 수 있다.

SELECT empno eno, ename enm
FROM emp
ORDER BY enm;

2. ORDER BY 절에 SELECT 절의 컬럼 순서번호를 기술하여 정렬가능
SELECT empno, ename
FROM emp
ORDER BY 2; ==> ORDER BY ename

3. expression 도 가능
SELECT empno, ename, sal + 500 sal_ps
FROM emp
ORDER BY sal_ps;

ORDER BY 1]
SELECT *
FROM dept
ORDER BY DNAME ASC;

SELECT *
FROM dept
ORDER BY LOC DESC;

ORDER BY 2]
SELECT *
FROM emp
WHERE comm IS NOT NULL
AND comm NOT IN (0)
ORDER BY empno DESC, comm DESC;

ORDER BY 3]
SELECT *
FROM emp
WHERE mgr IS NOT NULL
ORDER BY job ASC, empno DESC;

ORDER BY 4]
1. SELECT *
2. FROM emp
3. WHERE deptno != 20
AND sal > 1500
4. ORDER BY ename DESC;

오라클 실행 순서 2 - 3 - 1- 4

****** 실무에서 매우 많이 사용된다 ******
ROWNUM : 행에 번호를 부여해주는 가상 컬럼
        ** 조회된 순서대로 번호를 부여
    
SELECT ROWNUM, empno, ename
FROM emp;
WHERE 글번호 BETWEEN 46 AND 60;

  < ROWNUM은 1번부터 순차적으로 데이터를 읽어 올 때만 가능하다 >
1. WHERE  절에 사용하는 것이 가능
   * WHERE ROWNUM = 1 ( = 동등 비교 연산의 경우 1만 가능)
     WHERE ROWNUM <= 15
     WHERE ROWNUM BETWEEN 1 AND 15
   
SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM = 3;
==> 이 쿼리는 작동을 안함 3을 넣었기 때문에. 1부터 순차적으로 읽어와야함.

SELECT ROWNUM, empno, ename
FROM emp
WHERE 

2. ORDER BY 절은 SELECT 절 이후에 실행된다.
   **  SELECT절에 ROWNUM을 사용하고 ORDER BY절을 적용하게 되면
       원하는 결과를 얻지 못한다.
       
SELECT ROWNUM, empno, ename
FROM emp
ORDER BY ename;

정렬을 먼저 하고, 정렬된 결과에 ROWNUN을 적용해야 한다. 
==> INLINE-VIEW
    SELECT 결과를 하나의 테이블처럼 만들어 준다.

사원정보를 페이징 처리
1페이지 5명씩 조회
1페이지 : 1~5,   (page-1)*pageSize + 1 ~ page * pageSize
2페이지 : 6~10 
3페이지 : 11~15

page = 1, pageSize = 5

SELECT *
FROM 
(SELECT ROWNUM rn, a.*
      FROM
       (SELECT empno, ename
        FROM emp
        ORDER BY ename) a )
WHERE rn BETWEEN (:page - 1) * : pageSize + 1 AND : page * : pageSize;

SELECT 절에 * 사용 했는데, 를 통해 다른 특수 컬럼이나 EXPRESSION을 사용 할 경우는 * 앞에
       해당 데이터가 어떤 테이블에서 왔는지 명시를 해줘야 한다(한정자)
       
SELECT ROWNUM, emp.*
FROM emp;

별칭은 테이블에도 적용이 가능하다, 단 컬럼이랑 다르게 AS 옵션은 없다.

SELECT ROWNUM, e.*
FROM emp e;

하나의 쿼리를 테이블로 만들 경우 테이블 별칭을 지어줘야지만 ROWNUM 을 실무에서 사용할 수 있다.1
