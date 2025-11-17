DECLARE
    TYPE t_objets IS TABLE OF VARCHAR2(100);
    table_a_supp t_objets := t_objets(
        'BO.EMPRUNTS_ARCHIVE_202012',
        'BO.EMPRUNTS_ARCHIVE_202104',
        'BO.EMPRUNTS',
        'BO.LIVRES',
        'BO.AUTEURS',
        'BO.GENRES',
        'BO.SECTIONS',
        'BO.MEMBRES'
    );

BEGIN
    FOR i IN 1..table_a_supp.COUNT LOOP
        BEGIN
            EXECUTE IMMEDIATE 'DROP TABLE ' || table_a_supp(i) || ' CASCADE CONSTRAINTS';
            DBMS_OUTPUT.PUT_LINE('Cette table a bien été supprimée' || table_a_supp(i));
        EXCEPTION
            WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('La table a pas été supprimer' || table_a_supp(i) || SQLERRM);
        END;
    END LOOP;
END;
/



