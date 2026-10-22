-- =====================================================
-- Functii
-- =====================================================

-- Exercițiul 1
-- Să se calculeze salariul mediu pentru o funcție dată.

create or replace function salariu_mediu(p_functie varchar2)
return number
is
    v_avg number;

begin
    select avg(salariu)
    into v_avg
    from angajati
    where functie = p_functie;

    return v_avg;
end;
/

--apel functie
select salariu_mediu('Barista')
from dual;


-- Exercițiul 2
-- Să se determine starea stocului pentru un produs dat (epuizat, scăzut, OK).

create or replace function stare_stoc(p_id number)
return varchar2
is
    v_stoc produse.stoc%type;

begin
    select stoc
    into v_stoc
    from produse
    where id_produs = p_id;

    if v_stoc = 0 then
        return 'Epuizat';
    elsif v_stoc < 10 then
        return 'Scazut';
    else
        return 'OK';

    end if;

exception
    when no_data_found then
        return 'Produs inexistent';
end;
/

--apel functie
select stare_stoc(1)
from dual;


-- Exercițiul 3
-- Să se calculeze valoarea totală a comenzilor pentru un client dat.

create or replace function total_client(p_id number)
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
end;
/
--apel functie
select total_client(1)
from dual;
