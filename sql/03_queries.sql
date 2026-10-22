---------------------------------------
-- 9. INTEROGARI
---------------------------------------

SELECT *
FROM produse
WHERE pret > 10;

SELECT *
FROM clienti
WHERE oras = 'Bucuresti';

SELECT AVG(pret)
FROM produse;

SELECT UPPER(nume_client)
FROM clienti;

SELECT id_comanda,
       TO_CHAR(data_comanda,'DD-MM-YYYY')
FROM comenzi;

SELECT categorie,
       AVG(pret)
FROM produse
GROUP BY categorie
HAVING AVG(pret) > 8;

SELECT c.id_comanda,
       cl.nume_client,
       a.nume_angajat,
       p.denumire_produs,
       d.cantitate
FROM comenzi c
JOIN clienti cl
ON c.id_client = cl.id_client
JOIN angajati a
ON c.id_angajat = a.id_angajat
JOIN detalii_comenzi d
ON c.id_comanda = d.id_comanda
JOIN produse p
ON d.id_produs = p.id_produs;
