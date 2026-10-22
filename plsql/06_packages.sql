-- =====================================================
-- Pachete
-- =====================================================

-- Exercițiul 1
-- Să se creeze un pachet numit pachet_clienti care să gestioneze informații despre clienți și comenzile acestora. Pachetul trebuie să conțină:
-- o procedură care afișează valoarea totală a comenzilor pentru fiecare client
-- o procedură care determină clientul cu cea mai mare valoare a comenzilor
-- o funcție care calculează valoarea totală a comenzilor pentru un client dat

create or replace package pachet_clienti
is

    procedure total_clienti;
    procedure top_client;
    function total_client(p_id number)
    return number;

end pachet_clienti;
/

create or replace package body pachet_clienti
is
    procedure total_clienti
    is
        cursor c_client is
            select distinct c.id_client
            from comenzi c;
        v_total number;

    begin
        for cl in c_client loop
            select nvl(sum(d.cantitate * d.pret_unitar), 0)
            into v_total
            from comenzi c
            join detalii_comenzi d
                on c.id_comanda = d.id_comanda
            where c.id_client = cl.id_client;

            dbms_output.put_line( 'Client ID: ' || cl.id_client || ' | Total: ' || v_total);

        end loop;

    end total_clienti;

    procedure top_client
    is
        v_id number;
        v_total number;

    begin
        select id_client, total
        into v_id, v_total
        from (
            select c.id_client,
                   sum(d.cantitate * d.pret_unitar) total
            from comenzi c
            join detalii_comenzi d
                on c.id_comanda = d.id_comanda
            group by c.id_client
            order by total desc
        )
        where rownum = 1;

        dbms_output.put_line( 'Top client ID: ' || v_id ||  ' | Total: ' || v_total);

    exception
        when no_data_found then
            dbms_output.put_line('Nu exista date');

    end top_client;

    function total_client(p_id number)
    return number
    is
        v_total number;

    begin
        select nvl(sum(d.cantitate * d.pret_unitar), 0)
        into v_total
        from comenzi c
        join detalii_comenzi d
            on c.id_comanda = d.id_comanda
        where c.id_client = p_id;
        return v_total;

    end total_client;

end pachet_clienti;
/

--apel pachet
set serveroutput on;

begin
    pachet_clienti.total_clienti;
    pachet_clienti.top_client;

end;
/
select pachet_clienti.total_client(1)
from dual;


-- Exercițiul 2
-- Să se creeze un pachet numit pachet_produse care să gestioneze informații despre produse. Pachetul trebuie să conțină:
-- o procedură care afișează produsele cu preț sub medie
-- o funcție care determină categoria de preț a unui produs
-- o funcție care calculează prețul mediu al produselor

create or replace package pachet_produse
is
    procedure produse_sub_medie;

    function categorie_pret(p_id number)
    return varchar2;

    function pret_mediu
    return number;
end pachet_produse;
/

create or replace package body pachet_produse
is
    -- pretul mediu al tuturor produselor
    function pret_mediu
    return number
    is
        v_avg number;
    begin
        select avg(pret)
        into v_avg
        from produse;

        return v_avg;
    end pret_mediu;

    -- afiseaza produsele mai ieftine decat media (refoloseste pret_mediu)
    procedure produse_sub_medie
    is
        v_medie number := pret_mediu;
    begin
        dbms_output.put_line('Pret mediu: ' || round(v_medie, 2));

        for rec in (
            select denumire_produs, pret
            from produse
            where pret < v_medie
            order by pret
        )
        loop
            dbms_output.put_line(rec.denumire_produs || ' - ' || rec.pret || ' lei');
        end loop;
    end produse_sub_medie;

    -- clasifica un produs dupa pret: Ieftin (< 7), Mediu (7 - 12), Scump (> 12)
    function categorie_pret(p_id number)
    return varchar2
    is
        v_pret produse.pret%type;
    begin
        select pret
        into v_pret
        from produse
        where id_produs = p_id;

        if v_pret < 7 then
            return 'Ieftin';
        elsif v_pret <= 12 then
            return 'Mediu';
        else
            return 'Scump';
        end if;

    exception
        when no_data_found then
            return 'Produs inexistent';
    end categorie_pret;

end pachet_produse;
/

-- apel pachet
set serveroutput on;

begin
    pachet_produse.produse_sub_medie;
end;
/

-- clasificarea tuturor produselor
select id_produs, denumire_produs, pret,
       pachet_produse.categorie_pret(id_produs) as categorie
from produse
order by pret;

-- test pentru un produs inexistent
select pachet_produse.categorie_pret(100)
from dual;