PRIMARY KEY : PK_테이블명
FOREIGN KEY : FK_소스테이블명_참조테이블명

제약조건 삭제
ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건명;

1. 부서 테이블에 PRIMARY KEY 제약조건 추가
2. 사원 테이블에 PRIMARY KEY 제약조건 추가
3. 사원 테이블 - 부서 테이블 간 FOREIGN KEY 제약조건 추가

제약조건 삭제시 데이터 입력과 반대로 자식부터 먼저 삭제.
3 - (1,2) 3번을 먼저 삭제 해야되는것이 핵심.

ALTER TABLE emp_test DROP CONSTRAINT FK_emp_test_dept_test;
ALTER TABLE dept_test DROP CONSTRAINT PK_dept_test;
ALTER TABLE emp_test DROP CONSTRAINT PK_emp_test;

SELECT *
FROM user_constraints
WHERE table_name IN ('EMP_TEST', 'DETP_TEST');

제약조건 생성
dept_test 테이블의 deptno 컬럼에 PRIMARY KEY 제약조건 추가
emp_test 테이블의 empno컬럼에 PRIMARY KEY 제약조건 추가
emp_test 테이블의 deptno컬럼이 dept_test 컬럼의 deptno컬럼을 참조하는 FOREIGN KEY 제약조건추가

ALTER TABLE dept_test ADD CONSTRAINT PK_dept_test PRIMARY KEY (deptno);
ALTER TABLE emp_test ADD CONSTRAINT PK_emp_test PRIMARY KEY (empno);
ALTER TABLE dept_test ADD CONSTRAINT KF_emp_test_dept_test FOREIGN KEY (deptno)
REFERENCES dept_test (deptno);

SELECT *
FROM user_constraints
WHERE table_name IN ('EMP_TEST', 'DEPT_TEST');

제약조건 활성화 - 비활성화 테스트
테스트 데이터 준비 : 부모 - 자식 관계가 있는 테이블 부모테이블의 데이터를 먼저 입력
dept_test ==> emp_test
INSERT INTO dept_test VALUES (10, 'ddit', 99);
dept_test와 emp_test테이블 간 FK가설정되어 있지만 10번 부서는 dept_test에 존재하기 때문에 정상 이력
INSERT INTO emp_test VALUES (9999, 'brwon', 10);
20번 부서는 dept_test 테이블에 존재하지 않는 데이터이기 때문에 EF에 의해 입력 불가.
INSERT INTO emp_test VALUES (9998, 'sally', 20);

FK를 비활성화 후 다시 입력
ALTER TABLE emp_test DISABLE CONSTRAINT EK_emp_test_dept_test;
INSERT INTO emp_test VALUES (9998, 'sally', 20);

SELECT *
FROM dept_test;

SELECT *
FROM user_constraints
WHERE table_name IN ('EMP_TEST', 'DEPT_TEST');
COMMIT;

FK 제약조건 재활성화
ALTER TABLE emp_test ENABLE CONSTRAINT FK_emp_test_dept_test;

테이블, 컬럼, 주석 (comments) 생성가능
테이블 주석 정보 확인
user_tables, user_constraints, user_tab_comments

SELECT *
FROM user_tab_comments;

테이블 주석 작성 방법
COMMNET ON TABLE 테이블명 IS '주석'; --다른 사람을 위해서 쓰는게 조오오옿다.

EMP 테이블에 주석 (사원) 생성하기;
COMMENT ON TABLE emp IS '사원';

컬럼 주석 확인
SELECT *
FROM user_col_comments
WHERE TABLE_NAME = 'EMP';

컬럼 주석 다는 문법
COMMENT ON COLUMN 테이블명.컬렴멍 IS '주석';

 COMMENT ON COLUMN emp.EMPNO is '사번';      
 COMMENT ON COLUMN emp.ENAME is '사원이름';      
 COMMENT ON COLUMN emp.JOB is '담당역할';        
 COMMENT ON COLUMN emp.MGR is '매니저 사번';        
 COMMENT ON COLUMN emp.HIREDATE is '입사일자';   
 COMMENT ON COLUMN emp.SAL is '급여';        
 COMMENT ON COLUMN emp.COMM is '성과금';       
 COMMENT ON COLUMN emp.DEPTNO is '소속부서번호';
 
 --해당 테이블에 어떤 정보가 있고 어떻게 짜여져 있는가? 부터 확인 !
 --USER_TAB_COMMNENTS   ,,   USER_COL_COLUMN
 
TABLE - COMMENTS 실습 COMMENT1]

SELECT t.*, c.column_name, c.comments
FROM user_tab_comments t, user_col_comments c
WHERE t.table_name = c.table_name
  AND t.table_name IN ('CYCLE', 'CUSTOMER', 'PRODUCT', 'DAILY');

SELECT *
FROM user_constraints
WHERE table_name IN ('emp', 'dept');

ALTER TABLE emp ADD CONSTRAINT PK_emp PRIMARY KEY (empno);

ALTER TABLE dept ADD CONSTRAINT PK_dept PRIMARY KEY (deptno);

ALTER TABLE emp ADD CONSTRAINT FK_emp_emp FOREIGN KEY (mgr)
REFERENCES emp (empno);

ALTER TABLE emp ADD CONSTRAINT FK_emp_dept FOREIGN KEY (deptno)
REFERENCES dept (deptno);

SELECT *
FROM user_constraints
WHERE table_name IN ('EMP', 'DEPT');

DDL(view)

VIEW : VIEW는 쿼리이다. (VIEW 테이블은 잘못된 표현)
. 물리적인 데이터를 갖고 있지 않고 논리적인 데이터 정의 집합이다.(SELECT 쿼리이다)
. view가 사용하고 있는 테이블의 데이터가 바뀌면 view의 조회 겨과도 같이 바뀐다.
. 

문법
CREATE OR REPLACE VIEW 뷰이름 AS
SELECT 쿼리;

emp테이블에서 sal, comm 컬럼 두개를 제외한 나머지 6개 컬럼으로 v_emp이름의 view 생성
CREATE OR REPLACE VIEW v_emp AS
SELECT empno, ename, job, mgr, hiredate, deptno
FROM emp;

GRANT CONNECT, RESOURCE TO 계정명;
VIEW에 대한 생성권한은 RESOURCE 에 포함되지 않는다.

SELECT *
FROM
(SELECT empno, ename, job, mgr, hiredate, deptno
FROM emp);

---------------------------------
DELETE emp
WHERE deptno = 10;
실제 emp테이블에서 10번부서에 속하는 3명을 지웠으면 VIEW또한 3명이 지워진 상태로 조회가 된다.

------------------------------------

SEM (Soohun) 계정에 있는 V_EMP 뷰를 HR계정에게 조회할 수 있도록 권한 부여

GRANT SELECT ON v_emp TO hr;




      















