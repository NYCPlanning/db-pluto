--copy condo table from DOF
DROP TABLE IF EXISTS pluto_condo;
CREATE TABLE pluto_condo AS(
SELECT * FROM dof_condo);

-- remove duplicate records
DELETE FROM dof_condo
WHERE id IN
    (SELECT id
    FROM 
        (SELECT condo_base||condo_bill,
         ROW_NUMBER() OVER( PARTITION BY condo_base,condo_bill
        ORDER BY  condo_base||condo_bill ) AS row_num
        FROM dof_condo ) t
        WHERE t.row_num > 1 );

-- remove duplicate records where base bbl is None or NULL
DELETE FROM dof_condo
WHERE condo_base IN
( SELECT condo_base FROM
(SELECT condo_base,
         ROW_NUMBER() OVER( 
         	PARTITION BY condo_base
         ) AS row_num
        FROM dof_condo) t
        WHERE t.row_num > 1)
AND condo_bill IS NULL;

-- remove duplicate records where base bbl is the same but billing bbl is different
DELETE 
SELECT COUNT(*) FROM dof_condo
WHERE condo_base IN
( SELECT condo_base, condo_bill FROM
(SELECT condo_base,
         ROW_NUMBER() OVER( 
         	PARTITION BY condo_base, condo_bill
         ) AS row_num
        FROM dof_condo) t
        WHERE t.row_num > 1)
AND condo_bill NOT IN (SELECT DISTINCT billingbbl FROM pluto_rpad_geo);