-- =====================================================
-- Triggere
-- =====================================================

-- Exercițiul 1
-- Să nu permită introducerea unui produs cu preț negativ sau egal cu 0.

create or replace trigger trg_pret_valid
before insert or update on produse
for each row

begin

    if :new.pret <= 0 then

        raise_application_error( -20001, 'Pretul produsului trebuie sa fie pozitiv' );

    end if;

end;
/

-- test valid
insert into produse
values(999, 'Test', 'Test', 100, 50);

-- test invalid
insert into produse
values(1000, 'Test2', 'Test', -10, 50);
/


-- Exercițiul 2
-- La introducerea unui produs într-o comandă:
-- să se scadă automat stocul produsului;
-- să nu permită comandarea unei cantități mai mari decât stocul disponibil.

create or replace trigger trg_actualizare_stoc
before insert on detalii_comenzi
for each row

declare

    v_stoc produse.stoc%type;

begin

    select stoc
    into v_stoc
    from produse
    where id_produs = :new.id_produs;

    if :new.cantitate > v_stoc then

        raise_application_error(-20002, 'Stoc insuficient pentru produs');

    else

        update produse
        set stoc = stoc - :new.cantitate
        where id_produs = :new.id_produs;

    end if;

end;
/

-- test valid
insert into detalii_comenzi
values(2,1,2,8);

-- test invalid
insert into detalii_comenzi
values(3,10,5,10);
/


-- Exercițiul 3
-- La inserarea unui produs nou, dacă prețul este mai mic decât 5, prețul să fie setat automat la 5.

create or replace trigger trg_pret_minim
before insert on produse
for each row
follows trg_pret_valid

begin

    if :new.pret < 5 then

        :new.pret := 5;

    end if;

end;
/

--test
insert into produse
values(20,'Apa','Bautura',2,50);

--verificare
select *
from produse
where id_produs = 20;
