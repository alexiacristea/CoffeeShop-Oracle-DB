-- =====================================================
-- Proceduri
-- =====================================================

-- Exercițiul 1
-- Afișați pentru fiecare client valoarea totală a comenzilor sale.

create or replace procedure total_clienti
is
    cursor c_client is
        select id_client, nume_client
        from clienti;

    v_total number;

begin
    for cl in c_client loop

        select nvl(sum(d.cantitate * d.pret_unitar), 0)
        into v_total
        from comenzi c
        join detalii_comenzi d
            on c.id_comanda = d.id_comanda
        where c.id_client = cl.id_client;

        dbms_output.put_line( 'Client: ' || cl.nume_client ||  ' | Total: ' || v_total );

    end loop;
end;
/

--apel procedura
set serveroutput on;

begin
    total_clienti;
end;
/


-- Exercițiul 2
-- Să se afișeze produsele care au stoc mai mic de 10, semnalând situațiile critice.

create or replace procedure produse_critice
is
begin
    for rec in (
        select denumire_produs, stoc
        from produse
    ) loop

        if rec.stoc < 10 then
            dbms_output.put_line( rec.denumire_produs || ' - STARE CRITICA');
        end if;

    end loop;
end;
/

--apel procedura
begin
    produse_critice;
end;
/


-- Exercițiul 3
-- Să se determine și să se afișeze clientul care a generat cea mai mare valoare totală a comenzilor.

create or replace procedure top_client
is
    v_nume clienti.nume_client%type;
    v_total number;
begin
    select nume_client, total
    into v_nume, v_total
    from (
        select cl.nume_client, sum(d.cantitate * d.pret_unitar) total
        from clienti cl
        join comenzi c
            on cl.id_client = c.id_client
        join detalii_comenzi d
            on c.id_comanda = d.id_comanda
        group by cl.nume_client
        order by total desc  )
    where rownum = 1;
    dbms_output.put_line( 'Top client: ' || v_nume || ' | Total: ' || v_total  );
exception
    when no_data_found then
        dbms_output.put_line('Nu exista date');
end;
/
--apel procedura
begin
    top_client;
end;
/
