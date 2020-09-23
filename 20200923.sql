인덱스 생성 방법
1. 자동생성
  UNIQUE, PRIMARY 생성시
  해당 컬럼으로 이루어진 인덱스가 없을 경우 해당 제약조건 명으로 인덱스를 자동생성
  
  ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);
  empno 컬럼을 선두컬럼으로 하는 인덱스가 없을 경우 pk_emp라는 이름으로 UNIQUE 인덱스 자동 생성.
  자동생성
  
  UNIQUE : 컬럼의 중복된 값이 없음을 보장하는 제약조건.
  PRIMARY KEY : UNIQUE + NOT NULL
  
  DBMS의 입장에서는 신규 데이터가 입력되거나 기존 데이터가 수정된 때
  UNIQUE 제약에 문제가 없는지 확인한다 == > 무결성을 지키기 위해.
  
  빠른 속도 중복 데이터 겸증을 위해 오라클에서는 UNIQUE, PRIMARY KEY 생성시
  해당 컬럼으로 인덱스를 강제한다.
  
  PRIMARY KEY 제약조건 생성 후 해당 인덱스 삭제 시도시 삭제 불가
  
  FOREIGN KEY : 입력하려는 데이터가 참조하는 테이블의 컬럼에 존재하는 데이터만
                입력되도록 제한
emp 테이블에 brown 사원을 50번 부서에 입력을 하게 되면 50번 부서가 
dept테이블의 deptno 컬럼에 존재 여부를확인하여 존재할 시에만 emp 테이블에 데이터를 입력.


idx_테이블명_n_01

idx_테이블명_u_01

DDL index 실습 idx 1]
CREATE TABLE dept_test2 AS
SELECT *
FROM dept
WHERE 1=1;

SELECT *
FROM dept_test2;

1. deptno UNIQUE
CREATE UNIQUE INDEX idx_dept_test2_u_01 ON dept_test2 (deptno);
DROP INDEX idx_dept_test2_u_01;

2. dname non-unique
CREATE INDEX idx_dept_test2_n_02 ON dept_test2 (dname);
DROP INDEX idx_dept_test2_n_02;

3. deptno, dname non-unique
CREATE INDEX idx_dept_test2_n_03 ON dept_test2 (deptno, dname);
DROP INDEX idx_dept_test2_n_03;

SELECT *
FROM emp
WHERE empno = :empno

실습 idx3]
1) empno(=) (1)
2) ename(=)
3) deptno(=), empno(LIKE :empno || '%') 이퀄조건이 선두에온다.
4) deptno(=), sal(BETWEEN)
5) deptno(=), mgr컬럼이 있을경우 테이블 엑세스 불필요
6) deptno, hiredate 컬럼으로 구성된 인덱스가 있을 경우 테이블 액세스 불필요

CREATE UNIQUE INDEX idx_emp_u_01 ON emp (empno, deptno);
CREATE INDEX idx_emp_02 ON emp (ename);
CREATE INDEX idx_emp_03 ON emp (deptno, sal, mgr, hiredate);

--NOT NULL 제약조건을 걸지 않으면 INDEX는 NULL을 애초에 읽을 수 없기때문에
--전체테이블에서 찾는다 FULL SCAN
-- FBI = FUNCTION Based Index .

인덱스 사용에 있어서 중요한점
인덱스 구성컬럼이 모두 NULL이면 인덱스에 저장을 하지 않는다.
즉 테이블 저근을 해봐야 해당 행에 대한 정보를 알 수 있다.
가급적이면 컬럼에 값이 NULL이 들어오지 않을 경우는 NOT NULL 제약을 적극적으로 활용
==> 실제로 오라클 입장에서 실행계획을 세우는데 도움이 된다.

-----------------------------------------------------------------------

synonym : 동의어
오라클 객체에 별칭을 생성한 객체
오라클 객체를 짧은 일므으로 지어줄 수 있다.

생성방법
CREATE [PUBLIC] SYNONYM 동의어_이름 FOR 오라클 객체;
PUBLIC : 공용동의어 생성시 사용하는 옵션.
         시스템관리자 권한이 있어야 생성가능
         
emp테이블에 e라는 이름으로 synonym을 생성
CREATE SYNONYM e for emp;

SELECT *
FROM e;


dictionary : 오라클의 객체 정보를 볼 수 있는 view
dictionary의 종류는 dictionary view를 통해 조회 가능

SELECT * 
FROM dictionary;

dictionary는 크게 4가지로 구분 가능
USER_ : 해양 사용자가 소유한 객체만 조회
ALL_ : 해당 사용자가 소유한 객체 + 다른 사용자부터 권한을 부여받은 객체
DBA_ : 시스템 관리자만 몰 수 있으며 모든 사용자의 객체 조회
V$ : 시스템 성능과 관련된 특수 view

SELECT *
FROM all_tables;

DBA 권한이 있는 계정에서만 조회 가능 (SYSTEM, SYS)
SELECT *
FROM dba_tables;

--------------------------------------------------------------------------------

multiple insert : 조건에 따라 여러 테이블에 데이터를 입력하는 INSERT

기존에 배운 쿼리는 하나의 테이블에 여러건 데이터를 입력하는 쿼리
INSERT INTO emp (empno, ename)
SELECT empno, ename
FROM emp;

multiple insert 구분
1. unconditional insert : 여러 테이블에 insert
2. conditional all insert : 조건을 만족하는 모든 테이블에 insert
3. conditional first insert : 조건을 만족하는 첫번째 테이블에 insert



1. unconditonal insert : 조건과 관계없이 여러 테이블에 insert
CREATE TABLE emp_test AS
SELECT empno, ename
FROM emp
WHERE 1=2;

CREATE TABLE emp_test2 AS
SELECT empno, ename
FROM emp
WHERE 1=2;

INSERT ALL INTO emp_test
           INTO emp_test2
SELECT 9999, 'brown' FROM dual UNION ALL
SELECT 9998, 'sally' FROM dual;

SELECT *
FROM emp_test;

SELECT *
FROM emp_test2;

uncondition insert 실행시 테이블 마다 데이터를 입력할 컬럼을 조작하는 것이 가능
그동안 : INSERT INTO emp_test VALUES(....) 테이블의 모든 컬럼에 대해 입력
        INSERT INTO emp_test (empno) VALUES (9999) 특정 컬럼을 지정하여 입력 가능


INSERT ALL
     INTO emp_test (empno) VALUES (eno)
     INTO emp_test2 (empno, ename) VALUES (eno, enm)
SELECT 9999 eno, 'brown' enm FROM dual UNION ALL
SELECT 9998, 'sally' FROM dual;

conditional insert : 조건에 따라 데이터를 입력
CASE 
    WHEN job = 'MANAGER'    THEN sal * 1.05
    WHEN job = 'PRESIDENT'  THEN sal * 1.20
END


INSERT ALL 
    WHEN eno >= 9500 THEN 
       INTO emp_test VALUES (eno, enm)
       INTO emp_test2 VALUES (eno, enm)
    WHEN eno >= 9900 THEN
       INTO emp_test2 VALUES (eno, enm)
SELECT 9500 eno, 'brown' enm FROM dual UNION ALL
SELECT 9998, 'sally' FROM dual;

SELECT *
FROM emp_test;

SELECT *
FROM emp_test2;

DDL 실습 idx 4]

EXPLAIN PLAN FOR
SELECT *
FROM emp_test3, dept_test3
WHERE emp_test3.deptno = dept_test3.deptno
AND emp_test3.deptno = :deptno
AND emp_test3.empno LIKE :empno || '%';

SELECT *
FROM TABLE(dbms_xplan.display);

DROP INDEX idx_emp_test3;

CREATE UNIQUE INDEX idx_emp_test3 ON emp_test3 (empno, deptno);
ALTER INDEX idx_emp_test3 ADD 

EXPLAIN PLAN FOR
SELECT *
FROM emp_test3
WHERE sal BETWEEN :st_sal AND :ed_sal
AND deptno = :deptno;

SELECT *
FROM TABLE(dbms_xplan.display);

CREATE INDEX idx_emp_test3_03 ON emp_test3 (deptno, sal);

EXPLAIN PLAN FOR
SELECT *
FROM emp_test3, dept_test3
WHERE emp_test3.deptno = dept_test3.deptno
AND emp_test3.deptno = :deptno
AND dept_test3.loc = :loc;

SELECT *
FROM dept_test3;

SELECT *
FROM TABLE(dbms_xplan.display);


CREATE UNIQUE INDEX idx_emp_test3 ON emp_test3 (empno, deptno);
CREATE INDEX idx_dept_text3_01 ON dept_test3 (deptno, loc);
CREATE INDEX idx_emp_n_text3_04 ON emp_test3 (deptno, sal);




















