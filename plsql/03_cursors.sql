-- =====================================================
-- Blocuri PL/SQL cu cursori
-- =====================================================

-- -----------------------------------------------------
-- Cursori expliciți
-- -----------------------------------------------------

-- Exercițiul 1
-- Calculați valoarea totală pentru fiecare comandă.

set serveroutput on;

declare
    cursor c_total_comenzi is
        select id_comanda,
               sum(cantitate * pret_unitar) as total
        from detalii_comenzi
        group by id_comanda;

begin
    for rec in c_total_comenzi loop
        dbms_output.put_line('Comanda: ' || rec.id_comanda || ' | Total: ' || rec.total);

    end loop;

end;
/


-- Exercițiul 2
-- Detectați comenzile „suspecte”(dacă o comandă conține un produs cu preț >= 15).

set serveroutput on;

declare
    cursor c_comenzi is
        select distinct c.id_comanda
        from comenzi c
        join detalii_comenzi d on c.id_comanda = d.id_comanda
        where d.pret_unitar >=15;

    v_gasit boolean := false;

begin
    for rec in c_comenzi loop
        dbms_output.put_line('Comanda suspecta: ' || rec.id_comanda);
        v_gasit := true;
    end loop;

    if v_gasit = false then
        dbms_output.put_line('Nu exista comenzi suspecte.');
    end if;
end;
/


-- Exercițiul 3
-- Pentru fiecare client, afișați comenzile lui (client → comenzi).

set serveroutput on;

declare
    cursor c_clienti is
        select id_client, nume_client
        from clienti;

    cursor c_comenzi(p_id_client clienti.id_client%type) is
        select id_comanda
        from comenzi
        where id_client = p_id_client;

begin
    for c in c_clienti loop
        dbms_output.put_line('Client: ' || c.nume_client);

        for com in c_comenzi(c.id_client) loop
            dbms_output.put_line('   Comanda: ' || com.id_comanda );
        end loop;

        dbms_output.put_line('--------------------');
    end loop;
end;
/


-- -----------------------------------------------------
-- Cursori impliciți
-- -----------------------------------------------------

-- Exercițiul 1
-- Identificați angajații inactivi și penalizați-i:
-- dacă NU au gestionat nicio comandă → scădeți salariul cu 5%
-- afișați câți angajați au fost afectați

set serveroutput on;

begin
    update angajati a
    set salariu = salariu * 0.95
    where a.id_angajat not in (
        select distinct id_angajat
        from comenzi
        where id_angajat is not null
    );

    dbms_output.put_line(
        'Angajati afectati: ' || sql%rowcount
    );
end;
/


-- Exercițiul 2
-- Aplicați o strategie de fidelizare a clienților:
-- pentru comenzile mai vechi de 30 de zile → aplicați reducere de 10% la produse
-- afișați câte comenzi au fost actualizate

set serveroutput on;

begin
    update detalii_comenzi d
    set pret_unitar = pret_unitar * 0.9
    where d.id_comanda in (
        select c.id_comanda
        from comenzi c
        where c.data_comanda < sysdate - 30
    );

    dbms_output.put_line('Produse cu reducere aplicata: ' || sql%rowcount);
end;
/


-- Exercițiul 3
-- Verificați dacă există clienți fără email și afișați un mesaj de avertizare.

set serveroutput on;

declare
    v_nr number;

begin
    select count(*)
    into v_nr
    from clienti
    where email is null;

    if v_nr > 0 then
        dbms_output.put_line('Exista clienti fara email!');
    else
        dbms_output.put_line('Toti clientii au email.');
    end if;
end;
/
