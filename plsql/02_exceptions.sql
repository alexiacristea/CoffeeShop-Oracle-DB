-- =====================================================
-- Blocuri PL/SQL cu exceptii
-- =====================================================

-- -----------------------------------------------------
-- Excepții explicite
-- -----------------------------------------------------

-- Exercițiul 1
-- Calculați valoarea fiecărei comenzi și clasificați în mică / medie / mare. Dacă o comandă nu are produse, să se afișeze un mesaj de eroare.

set serveroutput on;

declare
    cursor c_comenzi is
        select id_comanda
        from comenzi
        order by id_comanda;
    v_total number;
    ex_zero exception;

begin
    for rec in c_comenzi loop
        -- bloc interior: o eroare la o comanda nu opreste verificarea celorlalte
        begin
            select sum(cantitate * pret_unitar)
            into v_total
            from detalii_comenzi
            where id_comanda = rec.id_comanda;

            if v_total is null then
                raise ex_zero;
            end if;

            if v_total < 10 then
                dbms_output.put_line('Comanda ' || rec.id_comanda || ' mica (' || v_total || ')');
            elsif v_total < 50 then
                dbms_output.put_line('Comanda ' || rec.id_comanda || ' medie (' || v_total || ')');
            else
                dbms_output.put_line('Comanda ' || rec.id_comanda || ' mare (' || v_total || ')');
            end if;

        exception
            when ex_zero then
                dbms_output.put_line('Comanda ' || rec.id_comanda || ' nu are produse!');
        end;
    end loop;
end;
/

-- Exercițiul 2
-- Micșorați stocul pentru produsele comandate. Dacă nu există stoc suficient, să se afișeze un mesaj de eroare.

set serveroutput on;

declare
    cursor c_detalii is
        select id_produs, cantitate
        from detalii_comenzi
        order by id_comanda, id_produs;
    v_stoc   produse.stoc%type;
    v_produs produse.id_produs%type;
    ex_stoc_insuficient exception;

begin
    for rec in c_detalii loop
        v_produs := rec.id_produs;

        select stoc into v_stoc
        from produse
        where id_produs = rec.id_produs;

        if v_stoc < rec.cantitate then
            raise ex_stoc_insuficient;
        end if;

        update produse
        set stoc = stoc - rec.cantitate
        where id_produs = rec.id_produs;
    end loop;

    commit;
    dbms_output.put_line('Stoc actualizat!');

exception
    -- "totul sau nimic": la orice eroare anulam toate modificarile facute in bucla
    when ex_stoc_insuficient then
        rollback;
        dbms_output.put_line('Stoc insuficient pentru produsul ' || v_produs
                             || '. Nicio modificare nu a fost salvata.');
    when no_data_found then
        rollback;
        dbms_output.put_line('Produsul ' || v_produs
                             || ' nu exista. Nicio modificare nu a fost salvata.');
end;
/


-- -----------------------------------------------------
-- Excepții implicite
-- -----------------------------------------------------

-- Exercițiul 1
-- Pentru un client dat, se afișează toate comenzile și numărul total de produse. Dacă nu există client, să se afișeze un mesaj de eroare.

set serveroutput on;

declare
    v_id number := &id_client;
    v_exista clienti.id_client%type;
    v_total number;

    cursor c_comenzi is
        select c.id_comanda
        from comenzi c
        where c.id_client = v_id;

begin
    select id_client into v_exista
    from clienti
    where id_client = v_id;

    for rec in c_comenzi loop
        select count(*) into v_total
        from detalii_comenzi
        where id_comanda = rec.id_comanda;

        dbms_output.put_line( 'Comanda ' || rec.id_comanda ||   ' are ' || v_total || ' produse'
        );
    end loop;

exception
    when no_data_found then
        dbms_output.put_line('Clientul nu exista!');
end;
/


-- Exercițiul 2
-- Verificați stocul produselor și dublați-l dacă este mic. Dacă produsul nu există, să se afișeze un mesaj de eroare.

set serveroutput on;

declare
    v_id number := &id_produs;
    v_stoc produse.stoc%type;

    ex_stoc exception;

begin
    select stoc into v_stoc
    from produse
    where id_produs = v_id;

    if v_stoc < 80 then
        update produse
        set stoc = stoc * 2
        where id_produs = v_id;

        dbms_output.put_line('Stoc marit!');
    else
        raise ex_stoc;
    end if;

exception
    when no_data_found then
        dbms_output.put_line('Produs inexistent!');

    when ex_stoc then
        dbms_output.put_line('Stoc suficient, nu se modifica!');
end;
/
