반복문
1. FOR LOOP : 루프를 실행할 데이터의 갯수가 정해져 있을 때
     for(int i = 0; i < list.size(); i++)
2. LOOP
3. WHILE : 루프 실행 횟수를 모를때, 루프 실행 조건이 로직에 의해 바뀔 때

FOR LOOP
FOR 인덱스변수 (개발자가 이름부여) IN [REVERSE] 시작인덱스..종료인덱스 LOOP
    반복 실행할 문장;
END LOOP;

1-5까지 출력
SET SERVEROUTPUT ON;

DECLARE
BEGIN
    FOR i IN 1..5 LOOP
       DBMS_OUTPUT.PUT_LINE(i);
    END LOOP;
END;
/


2~5단까지 구구단 연산 (포맷 신경쓰지 말고)

DECLARE
BEGIN
    FOR i IN 2..5 LOOP
    FOR j IN 1..9 LOOP
       DBMS_OUTPUT.PUT_LINE(i * j);
       
 
    END LOOP;
END;
/


WHILE 조건식 LOOP
    반복할 문장;
END LOOP;

DECLARE
   i NUMBER := 1;
BEGIN
    WHILE i <= 5 LOOP
       DBMS_OUTPUT.PUT_LINE(i);
       i := i + 1;
    END LOOP;
END;
/


SQL CURSOR : SELECT 문에 의해 추출된 데이터를 가리키는 포인터

SELECT 문 처리 순서
1. 실행계획 생성 OR 기 생성된 계획 찾기
2. 바인드 변수 처리
3. 실행
4. ******** 인출

커서를 통해 개발자가 인출 하는 과정을 통제함으로써 테이블 타입변수에
SELECT 결과를 모두 담지 않고도(메모리 낭비 없이도) 쵸율적으로 처리하는것이 가능하다.

커서의 종류
1. 묵시적 커서 - 커서 선언없이 실행한 SQLdp 대해 오라클 서버가 스스로 생성, 삭제하는 커서
2. 명시적 커서 - 개발자가 선언하여 사용하는 커서

커서의 속성
     커서명%ROWCOUNT : 커서에 담긴 행의 개수
     커서명%FOUND : 커서에 읽을 행이 더 있는지 여부
     커서명%NOTFOUND : 커서에 읽을 행이 더 없는지 여부
     커서명%ISOPEN : 커서가 메모리에 선언되어 사용 가능한 상태 여부
    
커서 사용법
1. 커서 선언
    CURSOR 커서이름 IS
        SELECT 쿼리;
        
2. 커서 열기
    OPEN 커서이름;
    
3. 커서로부터 패치
    FETCH 커서이름 INTO 변수

4. 커서닫기
    CLOSE 커서이름;
    
DEPT 테이블의 모든 부서에 대해 부서번호, 부서이름을 CURSOR를 통해
데이터 출력

SELECT deptno, dname
FROM dept;

DECLARE
    CURSOR c_dept IS
       SELECT deptno, dname
       FROM dept;
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
BEGIN
    open c_dept;
    
    LOOP
        FETCH c_dept INTO v_deptno, v_dname;
        EXIT WHEN c_dept%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('v_deptno : ' || v_deptno || ', v_dname : ' || v_dname);
    END LOOP;
    
    CLOSE c_dept;
END;
/


명시적 커서 FOR LOOP : FOR LOOP 와 명시적 커서를 결합한 형태로
                    커서의 OPEN, FETCH, CLOSE 단계를  FOR LOOP 에서 처리하여
                    개발자가 사용하기 쉬운 형태로 제공.
사용방법 (JAVA 향상된 FOR 문과 비슷)
     for(String name : names)
FOR 레코드이름 IN 커서 LOOP
    반복할 문장;
END LOOP


DECLARE
    CURSOR c_dept IS
       SELECT deptno, dname
       FROM dept;
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
BEGIN
    FOR rec IN c_dept LOOP
        DBMS_OUTPUT.PUT_LINE('rec.deptno : ' || rec.deptno || ', rec.dname : ' || rec.dname);
    END LOOP;
END;
/


파라미터가 있는 커서 : 함수처럼 커서에 인자를 전달해서 실행시 조건을 추가할 수 있다
    FROM emp
    WHERE deptno = 10;
    
    FROM emp
    WHERE deptno = 20;

커서 선언시 인자 명시
CURSOR 커서이름(파라미터명 파라미터타입) IS
    SELECT *
    FROM emp
    WHERE deptno = 파라미터명;
    
emp 테이블의 특정 부서에 속하는 사원들을 조회할 수 있는 커서를
커서 파라미터를 통해 생성 (사원 이름, 사원 번호)

DECLARE
    CURSOR c_emp (p_deptno dept.deptno%TYPE) IS
    SELECT empno, ename
    FROM emp
    WHERE deptno = p_deptno;
BEGIN
    FOR rec IN c_emp(10) LOOP
        DBMS_OUTPUT.PUT_LINE('rec.empno : ' || rec.empno || ', rec.ename : ' || rec.ename);
    END LOOP;
END;
/


커서가 짧을 경우 FOR LOOP 에 커서를 인라인 형태로 작성하여 사용가능
==> DECLARE 절에 커서를 선언하지 않음
FOR 레코드명 IN (SELECT 쿼리 ) LOOP
END LOOP;


DECLARE
BEGIN
    FOR rec IN (SELECT deptno, dname FROM dept) LOOP
        DBMS_OUTPUT.PUT_LINE('rec.deptno : ' || rec.deptno || ', rec.dname : ' || rec.dname);
    END LOOP;
END;
/

SELECT (SYSDATE + 5) - SYSDATE gab
FROM dual;
 
SELECT *
FROM dt;

CREATE OR REPLACE PROCEDURE avgdt IS
    TYPE t_dt IS TABLE OF dt%ROWTYPE INDEX BY BINARY_INTEGER; --자바의 클래스를 만드는 행위와 동일
    v_dt t_dt; --변수 타입 선언.
    diff_sum NUMBER := 0;
BEGIN
    SELECT dt BULK CONNECT INTO v_dt
    FROM dt
    ORDER BY dt DSEC;
    
    FOR i IN 1..v_dt.COUNT-1 LOOP
        diff_sum := diff_sum + v_dt(i).dt - v_dt(i+1).dt;
    END LOOP;
        DBMS_OUTPUT.PUT_LLNE( diff_sum / (v_dt.COUNT-1) );
END;
/



SELECT ( MAX(dt) - MIN(dt) ) /( COUNT(dt)-1) avg
FROM dt;






    