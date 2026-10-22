---------------------------------------
-- PROIECT BAZE DE DATE - CAFENEA
---------------------------------------

---------------------------------------
-- 0. STERGEREA OBIECTELOR EXISTENTE
---------------------------------------

begin
    for obj in (
        select 'drop synonym clienti_syn'                             as cmd from dual union all
        select 'drop view v_comenzi_clienti'                          from dual union all
        select 'drop sequence seq_clienti'                            from dual union all
        select 'drop table detalii_comenzi cascade constraints purge' from dual union all
        select 'drop table comenzi cascade constraints purge'         from dual union all
        select 'drop table produse cascade constraints purge'         from dual union all
        select 'drop table angajati cascade constraints purge'        from dual union all
        select 'drop table clienti cascade constraints purge'         from dual
    ) loop
        begin
            execute immediate obj.cmd;
        exception
            when others then null; -- obiectul nu exista inca
        end;
    end loop;
end;
/

---------------------------------------
-- 1. CREAREA TABELELOR
---------------------------------------

CREATE TABLE clienti (
    id_client NUMBER PRIMARY KEY,
    nume_client VARCHAR2(50) NOT NULL,
    telefon VARCHAR2(20),
    email VARCHAR2(50),
    data_inregistrare DATE DEFAULT SYSDATE
);

CREATE TABLE angajati (
    id_angajat NUMBER PRIMARY KEY,
    nume_angajat VARCHAR2(50) NOT NULL,
    functie VARCHAR2(30),
    salariu NUMBER(8,2),
    id_manager NUMBER,
    CONSTRAINT chk_salariu CHECK (salariu > 0),
    CONSTRAINT fk_manager
        FOREIGN KEY (id_manager)
        REFERENCES angajati(id_angajat)
);

CREATE TABLE produse (
    id_produs NUMBER PRIMARY KEY,
    denumire_produs VARCHAR2(50) NOT NULL,
    categorie VARCHAR2(30),
    pret NUMBER(6,2),
    stoc NUMBER DEFAULT 0,
    CONSTRAINT chk_stoc CHECK (stoc >= 0)
);

CREATE TABLE comenzi (
    id_comanda NUMBER PRIMARY KEY,
    data_comanda DATE DEFAULT SYSDATE NOT NULL,
    id_client NUMBER,
    id_angajat NUMBER,
    CONSTRAINT fk_client
        FOREIGN KEY (id_client)
        REFERENCES clienti(id_client),
    CONSTRAINT fk_angajat
        FOREIGN KEY (id_angajat)
        REFERENCES angajati(id_angajat)
);

CREATE TABLE detalii_comenzi (
    id_comanda NUMBER,
    id_produs NUMBER,
    cantitate NUMBER NOT NULL,
    pret_unitar NUMBER(6,2) NOT NULL,
    CONSTRAINT pk_detalii PRIMARY KEY (id_comanda, id_produs),
    CONSTRAINT chk_cantitate CHECK (cantitate > 0),
    CONSTRAINT fk_det_com
        FOREIGN KEY (id_comanda)
        REFERENCES comenzi(id_comanda),
    CONSTRAINT fk_det_prod
        FOREIGN KEY (id_produs)
        REFERENCES produse(id_produs)
);

---------------------------------------
-- 2. MODIFICAREA STRUCTURII TABELELOR
---------------------------------------

ALTER TABLE clienti
ADD oras VARCHAR2(30);

ALTER TABLE produse
MODIFY pret NUMBER(7,2);

ALTER TABLE produse
ADD CONSTRAINT chk_pret CHECK (pret > 0);

