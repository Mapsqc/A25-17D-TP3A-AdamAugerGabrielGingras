-- User 1
ALTER SESSION SET CURRENT_SCHEMA = SYS;

DECLARE
    resultat       INTEGER;
    nom_schema     sys.dba_users.username%type := 'TP3A_2350431';
    nom_schema_pw  VARCHAR2(20)                := 'garneau';
    code_erreur    number;
    message_erreur varchar2(255);
BEGIN
    SELECT
        COUNT(1)
    INTO resultat
    FROM
        sys.dba_users
    WHERE
        username = UPPER(nom_schema);
    IF resultat = 1 THEN
        EXECUTE IMMEDIATE 'drop USER ' || UPPER(nom_schema) || ' cascade';
        dbms_output.put_line('Utilisateur supprimé');
    END IF;
    EXECUTE IMMEDIATE 'create USER '
                      || nom_schema
                      || ' identified by '
                      || nom_schema_pw;
    EXECUTE IMMEDIATE 'grant connect, resource, dba to ' || nom_schema;
    dbms_output.put_line('Utilisateur créé');
EXCEPTION
    WHEN OTHERS THEN
        CASE
            WHEN SQLCODE = '-1940'
                THEN dbms_output.put_line('Vous devez vous déconnecter du schéma avant de pouvoir le supprimer. Connectez-vous à SYS et exécutez seulement cette partie');
            ELSE code_erreur := SQLCODE;
                 message_erreur := SQLERRM;
                 dbms_output.put_line('Erreur: ' || code_erreur || ' - ' || message_erreur);
            END CASE;
END;
/

-- User 2
ALTER SESSION SET CURRENT_SCHEMA = SYS;

DECLARE
    resultat       INTEGER;
    nom_schema     sys.dba_users.username%type := 'TP3A_2356954';
    nom_schema_pw  VARCHAR2(20)                := 'garneau';
    code_erreur    number;
    message_erreur varchar2(255);
BEGIN
    SELECT
        COUNT(1)
    INTO resultat
    FROM
        sys.dba_users
    WHERE
        username = UPPER(nom_schema);
    IF resultat = 1 THEN
        EXECUTE IMMEDIATE 'drop USER ' || UPPER(nom_schema) || ' cascade';
        dbms_output.put_line('Utilisateur supprimé');
    END IF;
    EXECUTE IMMEDIATE 'create USER '
                      || nom_schema
                      || ' identified by '
                      || nom_schema_pw;
    EXECUTE IMMEDIATE 'grant connect, resource, dba to ' || nom_schema;
    dbms_output.put_line('Utilisateur créé');
EXCEPTION
    WHEN OTHERS THEN
        CASE
            WHEN SQLCODE = '-1940'
                THEN dbms_output.put_line('Vous devez vous déconnecter du schéma avant de pouvoir le supprimer. Connectez-vous à SYS et exécutez seulement cette partie');
            ELSE code_erreur := SQLCODE;
                 message_erreur := SQLERRM;
                 dbms_output.put_line('Erreur: ' || code_erreur || ' - ' || message_erreur);
            END CASE;
END;
/