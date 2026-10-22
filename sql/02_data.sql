---------------------------------------
-- 3. INSERAREA DATELOR CLIENTI
---------------------------------------

INSERT INTO clienti VALUES (1,'Popescu Ana','0711111111','ana.popescu@example.com',SYSDATE - 120,'Bucuresti');
INSERT INTO clienti VALUES (2,'Ionescu Mihai','0722222222','mihai.ionescu@example.com',SYSDATE - 110,'Cluj');
INSERT INTO clienti VALUES (3,'Georgescu Andrei','0733333333','andrei.georgescu@example.com',SYSDATE - 100,'Brasov');
INSERT INTO clienti VALUES (4,'Marin Ioana','0744444444','ioana.marin@example.com',SYSDATE - 95,'Constanta');
INSERT INTO clienti VALUES (5,'Dumitru Paul','0755555555','paul.dumitru@example.com',SYSDATE - 90,'Timisoara');
INSERT INTO clienti VALUES (6,'Stan Elena','0766666666','elena.stan@example.com',SYSDATE - 80,'Bucuresti');
INSERT INTO clienti VALUES (7,'Radu Mihnea','0777777777','mihnea.radu@example.com',SYSDATE - 70,'Cluj');
INSERT INTO clienti VALUES (8,'Popa Cristina','0788888888','cristina.popa@example.com',SYSDATE - 60,'Iasi');
INSERT INTO clienti VALUES (9,'Dinu George','0799999999','george.dinu@example.com',SYSDATE - 50,'Brasov');
INSERT INTO clienti VALUES (10,'Neagu Andra','0700000000','andra.neagu@example.com',SYSDATE - 45,'Constanta');

COMMIT;

---------------------------------------
-- 4. INSERAREA DATELOR ANGAJATI
---------------------------------------

INSERT INTO angajati VALUES (1,'Manager Cafenea','Manager',6000,NULL);
INSERT INTO angajati VALUES (2,'Barista Andrei','Barista',3500,1);
INSERT INTO angajati VALUES (3,'Barista Ioana','Barista',3400,1);
INSERT INTO angajati VALUES (4,'Casier Maria','Casier',3200,1);
INSERT INTO angajati VALUES (5,'Casier Alex','Casier',3100,1);
INSERT INTO angajati VALUES (6,'Barista Paul','Barista',4200,1);
INSERT INTO angajati VALUES (7,'Barista Vlad','Barista',4100,1);
INSERT INTO angajati VALUES (8,'Casier Ana','Casier',3800,1);
INSERT INTO angajati VALUES (9,'Casier Ion','Casier',3700,1);
INSERT INTO angajati VALUES (10,'Curatenie Ion','Personal auxiliar',3000,1);

COMMIT;

---------------------------------------
-- 5. INSERAREA DATELOR PRODUSE
---------------------------------------

INSERT INTO produse VALUES (1,'Espresso','Cafea',8,100);
INSERT INTO produse VALUES (2,'Cappuccino','Cafea',12,80);
INSERT INTO produse VALUES (3,'Latte','Cafea',14,70);
INSERT INTO produse VALUES (4,'Americano','Cafea',9,60);
INSERT INTO produse VALUES (5,'Croissant','Patiserie',7,50);
INSERT INTO produse VALUES (6,'Ceai Verde','Ceai',6,40);
INSERT INTO produse VALUES (7,'Ceai Negru','Ceai',6,40);
INSERT INTO produse VALUES (8,'Tort Ciocolata','Patiserie',15,20);
INSERT INTO produse VALUES (9,'Briose','Patiserie',5,30);
INSERT INTO produse VALUES (10,'Sandwich','Snack',10,25);

COMMIT;

---------------------------------------
-- 6. INSERAREA DATELOR COMENZI
---------------------------------------

INSERT INTO comenzi VALUES (1,SYSDATE - 75,1,2);
INSERT INTO comenzi VALUES (2,SYSDATE - 64,2,3);
INSERT INTO comenzi VALUES (3,SYSDATE - 52,3,4);
INSERT INTO comenzi VALUES (4,SYSDATE - 41,4,5);
INSERT INTO comenzi VALUES (5,SYSDATE - 35,5,2);
INSERT INTO comenzi VALUES (6,SYSDATE - 22,6,3);
INSERT INTO comenzi VALUES (7,SYSDATE - 15,7,3);
INSERT INTO comenzi VALUES (8,SYSDATE - 9,8,4);
INSERT INTO comenzi VALUES (9,SYSDATE - 4,9,5);
INSERT INTO comenzi VALUES (10,SYSDATE - 1,10,6);

COMMIT;

---------------------------------------
-- 7. INSERAREA DETALIILOR COMENZILOR
---------------------------------------

INSERT INTO detalii_comenzi VALUES (1,1,2,8);
INSERT INTO detalii_comenzi VALUES (1,5,1,7);
INSERT INTO detalii_comenzi VALUES (2,2,1,12);
INSERT INTO detalii_comenzi VALUES (3,3,1,14);
INSERT INTO detalii_comenzi VALUES (4,4,1,9);
INSERT INTO detalii_comenzi VALUES (5,6,2,6);
INSERT INTO detalii_comenzi VALUES (6,7,1,6);
INSERT INTO detalii_comenzi VALUES (7,8,1,15);
INSERT INTO detalii_comenzi VALUES (8,2,1,12);
INSERT INTO detalii_comenzi VALUES (9,9,3,5);
INSERT INTO detalii_comenzi VALUES (10,10,2,10);

COMMIT;

---------------------------------------
-- 8. UPDATE
---------------------------------------

UPDATE produse
SET stoc = 0
WHERE id_produs = 10;

COMMIT;
