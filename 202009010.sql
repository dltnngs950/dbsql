많이 쓰이는 함수 , 잘 알아두자
(개념 적으로 혼돈하지말고 잘 정리하자 - SELECT 절에 올 수 있는 컬럼에 대해 잘 정리

그룹 함수 : 여러개의 행을 입력받아 하나의 행으로 결과를 반환하는 함수

오라클 제공 그룹함수
MIN(컬럼|익스프레션) : 그룹중에 최소값을 반환
MAX(컬럼|익스프레션) : 그룹중에 최대값을 반환
AVG(컬럼|익스프레션) : 그룹의 평균값을 반환
SUM(컬럼|익스프레션) : 그룹의 합계값을 반환
COUNT(컬럼  |  익스프레션  | * ) : 그룹핑된 행의 갯수

SELECT 행을 묶을 컬럼, 그룹 함수
FROM 테이블명
[WHERE]
GROUP BY 행을 묶을 컬럼
[HAVING 그룹함수 체크조건];



그룹함수에서 많이 어려워 하는 부분
SELECT 절에 기술할 수 있는 컬럼의 구분 : GROUP BY절에 나오니 않은 컬럼이 SELECT 절에 나오면 에러

SELECT deptno, COUNT(*), MIN(sal), MAX(sal), SUM(sal), AVG(sal)
FROM emp
GROUP BY deptno;

전체 직원(모든 행을 대상으로) 중에 가장 많은 급여를 받는 사람의 값
: 전체행을 대상으로 그룹핑 할 경우 GROUP BY절을 기술하지 않는다.

전체직원중에 가장 큰 급여 값을 알수는 있지만 해당 급여를 받는 사람이 누구인지는 그룹함수 만으로는 구할 수 없다.
emp테이블에서 가장 큰 급여를 받는 사람의 값이 5000인 것은 알지만 해당 사원이 누구인지는 그룹함수만 이용해서는 누군지 식별할 수 없다.
      ==> 추후 진행
      
      
cOUNT 함수 * 인자
* : 행의 개수를 반환
컬럼 | 익스프레션 : NULL값이 아닌 행의 개수를 얘기함.


SELECT COUNT(*), COUNT(mgr), COUNT(COMM)
from emp;


그룹함수의 특징 : NULL값을 무시
NULL 연산의 특징 : 결과가 항상 NULL 이다.

SELECT SUM(comm) -- null을 무시해서 처리
FROM emp;

SELECT SUM(sal + comm), SUM(sal) + SUM(comm)
FROM emp;


그룹함수 특징 2: 그룹화와 관련이 없는 상수들은 SELECT 절에 기술할 수 있따.
SELECT deptno, SYSDATE, COUNT(*), 'TEST', 1
FROM emp
GROUP BY deptno;


그룹함수 특징3 :
    SINGLE ROW 함수의 경우 WHERE에 기술하는 것이 가능하다.
    ex) SELECT *
        FROM emp
        WHERE ename = UPPER('smith');
        
   그룹함수의 경우 WHERE절 에서 사용하는 것이 불가능 하다.
       ==> HAVING 절에서 그룹함수에 대한 조건을 기술하여 행을 제한할 수 있다.

     SELECT deptno, COUNT(*)
     FROM emp
     WHERE COUNT(*) >= 5
     GROUP BY deptno;
     
     
     그룹함수에 대한 행 제한은 HAVING 절에 기술
     SELECT deptno, COUNT(*)
     FROM emp
     WHERE COUNT(*) >= 5
     GROUP BY deptno;
     HAVING COUNT(*) >= 5;
     
GROUP BY 를 사용하면 WHERE절을 사용 못하냐?
GROUP BY 에 대상이 되는 행들을 제한할때 WHERE 절을 사용

group function 실습 grp1]

SELECT MAX(sal) max_sal, MIN(sal) mix_sal, ROUND(AVG(sal), 2) avg_sal,
       SUM(sal) sum_sal, COUNT(sal) count_sal, COUNT(mgr) count_mgr, COUNT(*) count_all
FROM emp

     
group function 실습 grp2]

SELECT deptno, MAX(sal) max_sal, MIN(sal) mix_sal, ROUND(AVG(sal), 2) avg_sal,
       SUM(sal) sum_sal, COUNT(sal) count_sal, COUNT(mgr) count_mgr, COUNT(*) count_all
FROM emp
GROUP BY deptno;
     
     
** GROUP BY 절에 기술한 컬럼이 SELECT 절에 오지 않아도 실행에는 문제 없다. **

group function 실습 grp3]

SELECT 
       CASE
           WHEN deptno = 10 THEN 'ACCOUNTING'
           WHEN deptno = 20 THEN 'RESEARCH'
           WHEN deptno = 30 THEN 'SALES'
           WHEN deptno = 40 THEN 'OPERATION'
       END deptnm,
     MAX(sal) max_sal, MIN(sal) mix_sal, ROUND(AVG(sal), 2) avg_sal,
       SUM(sal) sum_sal, COUNT(sal) count_sal, COUNT(mgr) count_mgr, COUNT(*) count_all
FROM emp
GROUP BY deptno;

SELECT MAX(sal) max_sal, MIN(sal) mix_sal, ROUND(AVG(sal), 2) avg_sal,
       SUM(sal) sum_sal, COUNT(sal) count_sal, COUNT(mgr) count_mgr, COUNT(*) count_all,
       DECODE( deptno,
               10, 'ACCOUNTING',
               20, 'RESEARCH',
               30, 'SALES',
               'OPERATION') deoptnm
FROM emp
GROUP BY deptno;

SELECT DECODE( deptno,
               10, 'ACCOUNTING',
               20, 'RESEARCH',
               30, 'SALES',
               'OPERATION') deoptnm,
       MAX(sal) max_sal, MIN(sal) mix_sal, ROUND(AVG(sal), 2) avg_sal,
       SUM(sal) sum_sal, COUNT(sal) count_sal, COUNT(mgr) count_mgr, COUNT(*) count_all
FROM emp
GROUP BY DECODE( deptno,
               10, 'ACCOUNTING',
               20, 'RESEARCH',
               30, 'SALES',
               'OPERATION');
               -- expression 으로도 GROUP BY 절을 사용할 수 있다.
               
 group function 실습 grp4]   
            
            
SELECT TO_CHAR(hiredate, 'yyyymm') hire_yyyymm, COUNT(*) cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'yyyymm');

실습 5~7 과제.


********* WHERE + JOIN SELECT SQL의 모든 것 ********* -- 매애애애우 중ㅇㅇㅇㅇ요함 .
JOIN : 다른 테이블과 연결하여 데이터를 확장하는 문법
        . 컬럼을 확장 -- 다른 테이블을 마치 원래 가지고 있던 테이블마냥 사용하기 때문.
        
** 행을 확장 - 집합연산자(UNION, INTERSECT, MINUS)

JOIN 문법 구분
 1. ANSI - SQL
      : RDBMS에서 사용하는 SQL 표준
        ( 표준을 잘 지킨 모든 RDBMS- MYSQL, MSSQL, POSTGRESQL ... 에서 실행가능 )
 2. ORACLE - SQL
      : ORACLE사만의 고유 문법
        
회사에서 요구하는 형태로 따라가는게 맞음.
7(ORACLE) : 3(ANSI)



NATURAL JOIN : JOIN 하고자 하는 테이블의 컬럼명이 같은 컬럼끼리 연결
               컬럼의 값이 같은 행들끼리 연결
    ANSI-SQL

    SELECT 컬럼
    FROM 테이블명 NATURAL JOIN 테이블명;
    

조인 컬럼에 테이블 한정자를 붙이며 NATURAL JOIN에서는 에러로 취급. ex) emp.empno, emp.deptno < 네추럴조인 deptno로햇으면 emp.떼야함 ㅋ
emp.deptno (x) -> deptno (o) / 

컬럼명이 한쪽 테이블에만 존재할 경우 테이블 한정자를 붙이지 않아도 상관이 없다.
empno는 emp테이블에만 있으므로 한정자 굳이 안붙여도 노상관.
emp.empno (o)  empno(o)

SELECT *
FROM emp NATURAL JOIN dept;

NATURAL JOIN 을 ORACLE 문법으로
1. FROM 절에 조인할 테이블을 나열한다. ( ,  )
2. WHERE 절에 테이블 조인 조건을 기술한다.

SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;

SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;

ORA-00918 : column ambiguoulsly defined
컬럼이 여러개의 테이블에 동시에 존재하는 상황에서 테이블 한정자를 붙이지 않아서
오라클 입장에서는 해당 컬럼이 어떤 테이블의 컬럼인지 알 수가 없을 때 발생한다.
deptno 컬럼은 emp, dept 테이블 양쪽 모두에 존재한다.

인라인뷰 별칭처럼, 테이블 별칭을 부여하는 것이 가능하다.
컬럼과 다르게 AS 키워드는 붙이지 않는다.

SELECT *
FROM emp e, dept d
WHERE e.deptno = d.deptno;


ANSI-SQL : JOIN WITH USING
     조인 하려는 테이블간 같은 이름의 컬럼이 두개 이상일 때 
     하나의 컬럼으로만 조인을 하고 싶을 때 사용.
     
SELECT *
FROM emp JOIN dept USING (deptno); -- NATURAL 조인했을때와 결과값은 동일하다.
     
ORACLE 문법
SELECT *
FROM emp, dept -- 조인하고싶은 테이블을 나열
WHERE emp.deptno = dept.deptno; 

ANSI-SQL : JOIN WITH ON - 조인 조건을 개발자가 직접 기술
           NATURAL JOIN, JOIN WITH USING 절을 JOIN WITH ON 절을 통해 표현이 가능하다.
           
SELECT *
FROM emp JOIN dept ON ( emp.deptno = dept.deptno ); 

ORACLE
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno
  AND emp.deptno IN (20, 30);
  

논리적인 형태에 따른 조인 구분
1. SELF JOIN : 조인하는 테이블이 서로 같은 경우


SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e JOIN emp m ON ( e.mgr = m.empno )

ORACLE

SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno;

KING 의 경우 mgr 컬럼의 값이 NULL 이기 때문에 e.mgr = m.empno 조건을 충족 시키지 못함
그래서 조인이 실패하여 14건중 13건의 데이터만 조회가 된다.

2. NONEQUI JOIN : 조인 조건이 =이 아닌 조인

SELECT *
FROM emp, dept
WHERE emp.empno = 7369
AND emp.deptno != dept.deptno;


SAL을 이용하여 등급을 구하기
SELECT *
FROM salgrade;
empno, ename, sal, 등급(grade)

SELECT e.empno, e.ename, e.sal, s.grade
FROM emp e, salgrade s
WHERE sal BETWEEN s.losal AND s.hisal;
-- 오라클 문법.
-- 무엇을 출력할지 SELECT 에서 정해야함
-- FROM 에 무슨 테이블을 사용할지 잘 나열해야함.
-- WHERE 절을 사용하여 어떤 테이블에서 어떤조건을 사용해야 하는지 잘 기술한다.

위의 오라클 문법을 ANSI-SQL로 변경하면
SELECT e.empno, e.ename, e.sal, s.grade
FROM emp e JOIN salgrade s ON ( e.sal >= s.losal AND e.sal <= s.hisal);
-- FROM 이용할 테이블 join 조인 할 테이블 ON (조건기술) 



