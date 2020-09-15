cid : customer id
cnm : customer name

SELECT *
FROM customer;

SELECT *
FROM cycle;

pid : product id : 제품번호
pnm : product name : 제품이름
SELECT *
FROM product;

cycle : 고객애음주기
cid : customer id 고객 아이디
pdi : product id 제품 아이디
day : 1-7(일~토) 애음요일 
cnt : COUNT, 수량
SELECT *
FROM cycle;


join 실습4]

ORACLE 표기법 
SELECT cycle.cid, customer.cnm, cycle.pid, cycle.day, cycle.cnt
FROM customer, cycle
WHERE customer.cid = cycle.cid
AND customer.cnm IN ('brown', 'sally');

ANSI-SQL 표기법

SELECT cid, cnm, cycle.pid, cycle.day, cycle.cnt
FROM customer NATURAL JOIN cycle
WHERE customer.cnm IN ('brown', 'sally');

SELECT customer.cid, customer.cnm, cycle.pid, cycle.day, cycle.cnt
FROM customer JOIN cycle ON ( customer.cid = cycle.cid)
WHERE customer.cnm IN ('brown', 'sally');

SELECT cid, cnm, cycle.pid, cycle.day, cycle.cnt
FROM customer JOIN cycle USING (cid)
WHERE customer.cnm IN ('brown', 'sally');

--애음주기라는 것은 고객이없으면 있을 수가 없으므로 고객테이블이 엄마 테이블.


join 실습5]

EXPLAIN PLAN FOR
SELECT cycle.cid, customer.cnm, cycle.pid, product.pnm, cycle.day, cycle.cnt
FROM customer, cycle, product
WHERE customer.cid = cycle.cid
AND cycle.pid = product.pid
AND customer.cnm IN ('brown', 'sally');

SELECT *
FROM TABLE(dbms_xplan.display);


SELECT a.cid, a.cnm, a.pid, product.pnm, a.day, a.cnt
FROM
(SELECT customer.*, cycle.cid, customer.cnm, cycle.pid, cycle.day, cycle.cnt
FROM customer, cycle, product
WHERE customer.cid = cycle.cid
AND customer.cnm IN ('brown', 'sally') a) , product
WHERE a.pid = product.pid;

SQL : 실행에 대한 순서가 없다.
      조인할 테이블에 대해서 FROM 절에 기술한 순으로 테이블을 읽지 않음.
      FROM customer, cycle, product ==> 오라클에서는 product 테이블부터 읽을 수도 있다.


join 6~13 번 과제 til day 4;

OUTER JOIN : 자주 쓰이지는 않지만 중요하다. 반드시 알고있어야함 
JOIN구분

1.문법에 따른 구분 ANSI-SQL, ORACLE
2.JOIN 의 형태에 따른 구분 : SELF-JOIN, NONEQUI-JOIN, CROSS-JOIN
3.JOIN 성공여부에 따라 데이터 표시여부
          : INNER JOIN - 조인이 성공했을 때 데이터를 표시.
            OUTER JOIN - 조인이 실패해도 기준으로 정한 테이블의 컬럼 정보는 표시.
            
사번, 사원의이름, 관리자 사번, 관리자 이름
KING (PRESIDENT)의 경우 MGR 컬럼의 값이 NULL이기 때문에 조인에 실패 -> 13건 조회.

SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno(+);
이 경우 (+) 를 어디에 붙여야 할지 잘 생각.
-----------------------------------------------

SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e LEFT OUTER JOIN emp m ON(e.mgr = m.empno);

SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp m RIGHT OUTER JOIN emp e ON(e.mgr = m.empno);

-- This two qeuries are exacrly same queries without any doubts.

ORACLE-SQL : 데이터가 없는 쪽의 컬럼에 (+) 기호를 붙인다.
             ANSI-SQL 기준 테이블 반대편 테이블의 컬럼에 (+)을 붙인다.
             WHERE 절 연결 조건에 적용
             
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno(+);

--매니저 사원번호는 m.empno 쪽엔 없으므로 (+)를 붙여준 모습이다. There are no mgr number in m.empno so added (+)
--반대쪽 테이블엔 모두 붙여야함. It should be exist in both sides.
--OUTER JOIN 의 핵심 : 실패해도 조인결과가 나오도록 한다. Results of join have to be came out although they are failed. 


행에 대한 제한 조건 기술시 WHERE 절에 기술 했을 때와 ON 절에 기술 했을 때 결과가 다르다.

사원의 부서가 10번인 사람들만 조회 되도록 부서 번호 조건을 추가
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e LEFT OUTER JOIN emp m ON(e.mgr = m.empno AND e.deptno = 10);

조건을 WHERE 절에 기술한 경우 - > OUTER JOIN 이 아닌 INNER 조인 결과가 나온다.
SELECT e.empno, e.ename, e.deptno, e.mgr, m.ename, m.deptno
FROM emp e LEFT OUTER JOIN emp m ON ( e.mgr = m.empno )
WHERE e.deptno = 10;

SELECT e.empno, e.ename, e.deptno, e.mgr, m.ename, m.deptno
FROM emp e JOIN emp m ON ( e.mgr = m.empno )
WHERE e.deptno = 10;


SELECT *
FROM emp
ORDER BY deptno;

SELECT e.ename, m.ename
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno)
UNION
SELECT e.ename, m.ename
FROM emp e RIGHT OUTER JOIN emp m ON (e.mgr = m.empno)
INTERSECT
SELECT e.ename, m.ename
FROM emp e FULL OUTER JOIN emp m ON (e.mgr = m.empno);

실습 OUTERJOIN 1]

SELECT *
FROM buyprod;

SELECT *
FROM prod;

SELECT b.buy_date, b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
FROM buyprod b, prod p
WHERE b.buy_prod(+) = p.prod_id
AND b.buy_date(+) = TO_DATE('05/01/25', 'YY/MM/DD');

-- buy_date 쪽엔 없는 정보까지 얻고싶으므로 기준은 prod_id가 된다 그래서 데이터가 없는쪽인 buy_date에 (+)를붙여야함

SELECT buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM buyprod b RIGHT OUTER JOIN prod p
ON ( b.buy_prod = p.prod_id AND buy_date = TO_DATE('05/01/25', 'YY/MM/DD'));








