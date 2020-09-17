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
  
sub 10]

SELECT *
FROM product p
WHERE NOT EXISTS (SELECT *
              FROM cycle c
              WHERE c.pid = p.pid
                AND c.cid = 1);
                
                
        