outer join 실습 1]

SELECT b.buy_date, b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
FROM buyprod b, prod p
WHERE b.buy_prod(+) = p.prod_id
  AND b.buy_date(+) = TO_DATE('20050125', 'yyyymmdd');
  
outer join 실습 2]

SELECT NVL(b.buy_date, '05/01/25') buy_date, b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
FROM buyprod b, prod p
WHERE b.buy_prod(+) = p.prod_id
  AND b.buy_date(+) = TO_DATE('20050125', 'yyyymmdd');

outer join 실습 3]

SELECT NVL(b.buy_date, '05/01/25') buy_date, b.buy_prod, p.prod_id, p.prod_name, NVL2(b.buy_qty, b.buy_qty, 0)
FROM buyprod b, prod p
WHERE b.buy_prod(+) = p.prod_id
  AND b.buy_date(+) = TO_DATE('20050125', 'yyyymmdd');

outer join 실습 4]

SELECT p.pid, p.pnm, :cid cid, nvl(day, 0) day, nvl(cnt, 0) cnt
FROM cycle c, product p
WHERE c.pid(+) = p.pid
  AND c.cid(+) = '1';
  
outer join 실습 5]

SELECT p.pid, p.pnm, NVL(c.cid, 1) cid, NVL(m.cnm, 'brown') cnm, NVL(c.day, 0) day, NVL(c.cnt, 0) cnt
FROM cycle c, customer m, product p
WHERE c.pid(+) = p.pid
  AND m.cid(+) = c.cid
  AND c.cid(+) = 1
ORDER BY p.pid DESC, c.day DESC;

ANSI-SQL
SELECT product.pid, product.pnm, :cid cid, NVL(cycle.day, 0) day, NVL(cycle.cnt, 0) cnt
FROM cycle RIGHT OUTER JOIN product ON (cycle.pid = product.pid AND cycle.CID = '1');
  
  
cross join 실습 1]

SELECT c.cid, c.cnm, p.pid, p.pnm
FROM customer c, product p;

SELECT *
FROM customer, product;


서브쿼리 : 쿼리 안에서 실행되는 쿼리
1. 서브쿼리 분류 - 서브쿼리가 사용되는 위치에 따른 분류
 1.1 SELECT : 스칼라 서브쿼리(SCALAR SUBQUERY)
 1.2 FROM : 인라인 뷰 (INLINE-VIEW)
 1.3 WHERE : 서브쿼리 (SUB - QUERY)
                           (행1, 행 여러개), (컬럼1, 컬럼 여러개)
2. 서브쿼리 분류 - 서브쿼리가 반환하는 행, 컬럼의 개수의 따른 분류
(행1, 행 여러개), (컬럼1, 컬럼 여러개) :
(행, 컬럼) : 4가지
 2.1 단일행, 단일 컬럼
 2.2 단일행, 복수 컬럼 ==> X (잘 사용 안함)
 2.3 복수행, 단일 컬럼
 2.4 복수행, 복수 컬럼

3. 서브쿼리 분류 - 메인쿼리의 컬럼을 서브쿼리에서 사용여부에 따른 분류
 3.1 상호 연관 서브 쿼리 (CO-RELATED SUB QUERY)
     - 메인 쿼리의 컬럼을 서브 쿼리에서 사용하는 경우
 3.2 비상호 연관 서브 쿼리 (NON-CORELATED SUB QUERY)
     - 메인 쿼리의 컬럼을 서브 쿼리에서 사용하지 않는 경우
     
SMITH가 속한 부서에 속한 사원들은 누가 있을까?
1. SMITH가 속한 부서번호 구하기
2. 1번에서 구한 부서에 속해 있는 사원들 구하기

1. SELECT deptno
   FROM emp
   WHERE ename = 'SMITH';
   
2. SELECT *
   FROM emp
   WHERE deptno = 20;
   
SELECT *
FROM emp
WHERE deptno = (SELECT deptno
                FROM emp
                WHERE ename = 'SMITH');
   
==> 서브쿼리를 이용하여 하나로 합칠수가 있다.
SELECT *
FROM emp
WHERE deptno = (SELECT deptno
                FROM emp
                WHERE ename = 'SMITH');
                
                -- 이 서브쿼리는 단일행 , 단일컬럼 이다.
                
서브쿼리를 사용할 때 주의점
1. 연산자
2. 서브쿼리의 리턴 형태

서브쿼리가 한개의 행 복수컬럼을 조회하고, 단일 컬럼과 '=' 비교 하는경우 ==> X

SELECT *
FROM emp
WHERE deptno = (SELECT deptno, empno
                FROM emp
                WHERE ename = 'SMITH'); -- 단일 행 복수컬럼이고 값이 매치가 안되서 안됌.

서브쿼리가 여러개의 행, 단일 컬럼을 조회하는 경우
1. 사용되는 위치 : WHERE - 서브쿼리 
2. 조회되는 행, 컬럼의 개수 : 복수행, 단일 컬럼
3. 메인쿼리의 컬럼을 서브쿼리에서 사용 유무 : 비상호연관 서브쿼리 (따로 실행 가능)
SELECT *
FROM emp
WHERE deptno IN (SELECT deptno
                FROM emp
                WHERE ename = 'SMITH'
                   OR ename = 'ALLEN');
                   
서브쿼리 (실습 sub1) ]

SELECT sal
FROM emp;

SELECT COUNT(*)
FROM emp
WHERE sal > (SELECT AVG(sal)
             FROM emp);
             
실습 sub2]

SELECT *
FROM emp
WHERE sal > (SELECT AVG(sal)
             FROM emp);
             
실습 sub3]
SELECT *
FROM emp
WHERE deptno IN (SELECT deptno
                 FROM emp
                 WHERE ename = 'SMITH'
                    OR ename = 'WARD');
                    

복수행 연산자 : IN (매우중요), ANY, ALL (빈도가 떨어짐)
SELECT * 
FROM emp
WHERE sal > ALL (SELECT sal
                 FROM emp
                 WHERE ename IN ('SMITH', 'WARD'));
    --SAL 컬럼의 값이 800보다 크면서 1250보다 큰 사원  => 1250 이상
    
    
복습
NOT IN 연산자와 NULL

관리자가 아닌 사원의 정보를 조회
SELECT *
FROM emp
WHERE empno NOT IN(SELECT mgr
                   FROM emp);  --NULL값은 조회가 안된다.
                   
pair wise 개념 : 순서쌍, 두가지 조건을 동시에 만족시키는 데이터를 조회 할 때 사용
                AND 논리연산자와 결과 값이 다를 수 있다. (아래 예시 참조)
서브쿼리 : 복수행, 복수컬럼
SELECT *
FROM emp
WHERE (mgr, deptno) IN (SELECT mgr, deptno
                        FROM emp
                        WHERE empno IN ( 7499, 7782));
             
SELECT *
FROM emp
WHERE mgr IN (SELECT mgr
              FROM emp
              WHERE empno IN (7499, 7782)
          AND (SELECT deptno
               FROM emp
               WHERE empno IN (7499, 7782));
               
mgr 7698, 7839
deptno 30, 10
mgr, deptno => AND ==> 4가지 조합 (7698, 30) (7698, 10) (7839, 30) (7839, 10)
               pair wise => 2개만 (7698, 30)


SCALAR SUBQUERY : SELECT 절에 기술된 서브쿼리
                하나의 컬럼, 두개 이상의 컬럼은 할 수 없다.
*** 스칼라 서브 쿼리는 하나의 행, 하나의 컬럼을 조회하는 쿼리 이어야 한다. ***
                
SELECT dummy, (SELECT SYSDATE
               FROM dual)
FROM dual;

스칼라 서브쿼리가 복수행의 행(4개), 단일 컬럼을 조회 ==> 에러
SELECT empno, ename, deptno, (SELECT dname FROM dept) 
FROM emp;

emp 테이블과 스칼라 서브 쿼리를 이용하여 부서명 가져오기
기본 : emp 테이블과 dept 테이블을 조인하여 컬럼을 확장

SELECT empno, ename, deptno
FROM emp;

SELECT empno, ename, deptno, 
       (SELECT dname FROM dept WHERE deptno = emp.deptno) -- 상호연관 서브쿼리 (서브쿼리 따로 실행 불가) --한정자 필수
FROM emp;                                                 -- 비상호연관은 따로 실행 가능.

상호연관 서브쿼리 : 메인 쿼리의 컬럼을 서브쿼리에서 사용한 서브쿼리
                -서브쿼리만 단독으로 실행하는 것이 불가능 하다.
                -메인쿼리와 서브 쿼리의 실행 순서가 정해져 있다.
                  메인쿼리가 항상 먼저 실행된다.
                  
비상호연관 서브쿼리 : 메인 쿼리의 컬럼을 서브쿼리에서 사용하지 않은 서브쿼리
                -서브쿼리만 단독으로 실행하는 것이 가능하다.
                -메인 쿼리와 서브 쿼리의 실행 순서가 정해져 있지 않다
                  메인=> 서브, 서브 => 메인 둘다 실행 가능

SELECT *
FROM dept
WHERE deptno IN ( SELECT deptno
                  FROM emp);
                  
전체 직원의 급여 평균보다 높은 급여를 받는 사원들 조회
SELECT *
FROM emp
WHERE sal > (SELECT AVG(sal)
             FROM emp);
             
본인 속한 부서의 급여 평균보다 높은 급여를 받는 사람들을 조회

SELECT *
FROM emp e
WHERE  sal > (SELECT AVG(sal)
             FROM emp
             WHERE deptno = e.deptno);
             
             
sub 4]
테스트용 데이터 추가

DESC dept;
INSERT INTO dept VALUES (99, 'ddit', 'daejoen');

SELECT *
FROM dept
WHERE deptno NOT IN (SELECT deptno
FROM emp);

SELECT deptno
FROM emp;

sub 5]

SELECT *
FROM product
WHERE pid NOT IN (SELECT pid
                  FROM cycle
                  WHERE cid = 1);

SELECT pid
FROM cycle
WHERE cid = 1;

SELECT *
FROM product;

sub 6]

SELECT *
FROM cycle
WHERE cid = 1
  AND pid IN (SELECT pid
            FROM cycle
            WHERE cid = 2);
            
sub 7]

SELECT c.cid, m.cnm, c.pid, p.pnm, c.day, c.cnt
FROM customer m, product p, (SELECT *
                            FROM cycle
                            WHERE cid = 1
                            AND pid IN (SELECT pid
                                        FROM cycle
                                        WHERE cid = 2)) c
WHERE c.pid = p.pid  
  AND c.cid = m.cid;
 
 
EXISTS 연산자 : 조건을 만족하는 서브 쿼리의 행이 존재하면 TRUE . KEY!

SELECT *
FROM emp e
WHERE EXISTS ( SELECT *
               FROM emp m
               WHERE e.mgr = m.empno);
               
sub 8]

SELECT *
FROM emp e, emp m
WHERE e.mgr = m.empno;

sub 9]

SELECT *
FROM product p
WHERE EXISTS (SELECT *
              FROM cycle c
              WHERE c.pid = p.pid
                AND c.cid = 1);

sub 10]

SELECT *
FROM product p
WHERE NOT EXISTS (SELECT *
              FROM cycle c
              WHERE c.pid = p.pid
                AND c.cid = 1);

집합 연산자 : 알아두자
수학의 집합 연산
A = { 1, 3, 5 }
B = { 1, 4, 5 }

합집합 : A U B = { 1, 3, 4, 5 } (교환법칙 성립) A U B == B U A
교집합 : A ^ B = { 1, 5 } (교환법칙 성립) A ^ B == B ^ A
차집합 : A - B = { 3 } (교환법칙 비성립) A - B != B - A
        B - A = { 4 }
        
SQL에서의 집합 연산자
합집합 : UNION      : 수학적 합집합과 개념이 동일(중복을 허용하지 않음)
                     중복을 체크 ==> 두 집합에서 중복된 값을 확인 ==> 연산이 느림
        UNION ALL  : 수학적 합집합 개념을 떠나 두개의 집합을 단순히 합친다.
                     (중복 데이터 존재 가능)
                     중복 체크 없음 ==> 두 집합에서 중복된 값 확인 없음 ==> 연산이 빠름
                     **개발자가 두개의 집합에 중복되는 데이터가 없다는 것을 알 수 있는
                     상황이라면 UNION연산자를 사용하는 것보다 UNION ALL을 사용하여 
                     (오라클이 하는) 연산을 절약할 수 있다.
       INTERSECT : 수학적 교집합 개념과 동일
       MINUS : 수학적 차집합 개념과 동일 ;
      
위아래 집합이 동일하기 때문에 합집합을 하더라도 행이 추가되진 않는다.     
SELECT empno, ename
FROM emp
WHERE deptno = 10
UNION
SELECT empno, ename
FROM emp
WHERE deptno = 10;


위아래 집합에서 7369번 사번은 중복되므로 한번만 나오게 된다 : 전체 행은 3건    
SELECT empno, ename
FROM emp
WHERE empno IN ( 7369, 7566) 
UNION
SELECT empno, ename
FROM emp
WHERE empno IN ( 7369, 7782);


UNION ALL 연산자는 중복제거 단계가 없다. : 전체 행 4건
SELECT empno, ename
FROM emp
WHERE empno IN ( 7369, 7566) 
UNION ALL
SELECT empno, ename
FROM emp
WHERE empno IN ( 7369, 7782);

                    
두 집합의 공통된 부분은 7369행 밖에 없음 : 총 데이터 1행
SELECT empno, ename
FROM emp
WHERE empno IN ( 7369, 7566) 
INTERSECT
SELECT empno, ename
FROM emp
WHERE empno IN ( 7369, 7782);


윗쪽 집합에서 아래쪽 집합의 행을 제거하고 남은 행 : 1개의 행 (7566)
SELECT empno, ename
FROM emp
WHERE empno IN ( 7369, 7566) 
MINUS
SELECT empno, ename
FROM emp
WHERE empno IN ( 7369, 7782);


집합연산자 특징
1. 컬렴명은 첫번째 집합의 컬럼명을 따라간다
2. order by 절은 마지막 집합에 적용한다
   마지막 sql이 아닌 SQL에서 정렬을 사용하고 싶은 경우 INLINE-VIEW를 활용
   UNION ALL의 경우 위, 아래 집합을 이어 주기 때문에 집합의 순서를 그댈 유지
   하기 때문에 요구사항에 따라 정렬된 데이터 집합이 필요하다면 해당 방법을 고려
SELECT empno, ename
FROM emp
WHERE empno IN ( 7369, 7566) 
UNION ALL
SELECT empno, ename
FROM emp
WHERE empno IN ( 7369, 7782);









