---------------------------------------
-- 10. VIEW
---------------------------------------

CREATE VIEW v_comenzi_clienti AS
SELECT c.id_comanda,
       cl.nume_client,
       c.data_comanda
FROM comenzi c
JOIN clienti cl
ON c.id_client = cl.id_client;

---------------------------------------
-- 11. INDEX
---------------------------------------

CREATE INDEX idx_produse_categorie
ON produse(categorie);

---------------------------------------
-- 12. SEQUENCE
---------------------------------------

CREATE SEQUENCE seq_clienti
START WITH 11
INCREMENT BY 1;

---------------------------------------
-- 13. SYNONYM
---------------------------------------

CREATE SYNONYM clienti_syn
FOR clienti;

SELECT *
FROM clienti_syn;