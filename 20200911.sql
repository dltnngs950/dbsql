SELECT prod_lgu, prod_name
FROM prod;

SELECT lprod_gu, lprod_nm
FROM lprod;

SELECT l.lprod_gu, l.lprod_nm, p.prod_id, p.prod_name
FROM prod p, lprod l
WHERE p.prod_lgu = l.lprod_gu;

prod 테이블 건수? 조인에 성공하면 다른 테이블을 자기 테이블 처럼 사용.

SELECT COUNT(*)
FROM prod;

실습 join2 ]
SELECT b.buyer_id, b.buyer_name, p.prod_id, p.prod_name
FROM buyer b, prod p
WHERE p.prod_buyer = b.buyer_id;

SELECT buyer_id, buyer_name
FROM buyer;

SELECT prod_id, prod_name
FROM prod;

실습 join3 ]

(Oracle) ->
SELECT m.mem_id, m.mem_name, p.prod_id, p.prod_name, c.cart_qty
FROM member m, cart c, prod p
WHERE m.mem_id = c.cart_member
  AND p.prod_id = c.cart_prod;
 
(Ansi) -> 

SELECT m.mem_id, m.mem_name, p.prod_id, p.prod_name , c.cart_qty
FROM prod p JOIN cart c ON ( p.prod_id = c.cart_prod ) --조인을 완수하면 하나의 테이블처럼된다.
JOIN member m ON( m.mem_id = c.cart_member ); --그래서 바로 JOIN 테이블 ON 가능








