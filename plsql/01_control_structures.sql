-- =====================================================
-- Blocuri PL/SQL cu structuri de control
-- =====================================================

-- Exercițiul 1
-- Afișați primele 5 produse din tabela PRODUSE și modificați prețul în funcție de stoc:
-- dacă stoc < 20 → reducere 10%
-- dacă stoc între 20 și 50 → reducere 5%
-- altfel → preț neschimbat

set serveroutput on;

declare
begin
    for rec in (
        select id_produs, denumire_produs, pret, stoc
        from produse
        where rownum <= 5 )
    loop
        dbms_output.put_line('Produs: ' || rec.denumire_produs || ' | Pret initial: ' || rec.pret || ' | Stoc: ' || rec.stoc );

        if rec.stoc < 20 then
            update produse
            set pret = pret * 0.9
            where id_produs = rec.id_produs;

            dbms_output.put_line('Pret redus cu 10%');

        elsif rec.stoc between 20 and 50 then
            update produse
            set pret = pret * 0.95
            where id_produs = rec.id_produs;
            dbms_output.put_line('Pret redus cu 5%');

        else
            dbms_output.put_line('Pret nemodificat');
        end if;
    end loop;

    commit;

end;
/


-- Exercițiul 2
-- Parcurgeți toate comenzile și afișați: id comandă, client, număr produse din comandă.

set serveroutput on;

declare
    cursor c_comenzi is
        select co.id_comanda, c.nume_client
        from comenzi co
        join clienti c on co.id_client = c.id_client;
    v_nr_produse number;

begin

    for rec in c_comenzi loop
        select count(*)
        into v_nr_produse
        from detalii_comenzi
        where id_comanda = rec.id_comanda;

        dbms_output.put_line('Comanda: ' || rec.id_comanda || ' | Client: ' || rec.nume_client || ' | Produse: ' || v_nr_produse );

    end loop;

end;
/


-- Exercițiul 3
-- Determinați produsul care apare cel mai vândut în comenzile clienților.

set serveroutput on;

declare
    v_produs produse.denumire_produs%type;
    v_aparitii number;

begin
    for rec in (
        select p.denumire_produs, sum(dc.cantitate) nr
        from produse p
        join detalii_comenzi dc on p.id_produs = dc.id_produs
        group by p.denumire_produs
        order by sum(dc.cantitate) desc
    )
    loop

        v_produs := rec.denumire_produs;
        v_aparitii := rec.nr;
        dbms_output.put_line('Produs: ' || v_produs || ' | Cantitate: ' || v_aparitii);

        exit;

    end loop;

end;
/
