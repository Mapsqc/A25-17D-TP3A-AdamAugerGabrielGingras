CREATE OR REPLACE PACKAGE BODY GESTION_EMPRUNTS_PKG IS 

-- Procédure D. retourner_livre_prc
PROCEDURE retourner_livre_prc (i_id_membre IN NUMBER, i_id_livre IN NUMBER) IS penalite NUMBER:= 0;

BEGIN
    -- Verifier sil y a des penalites non paye
    penalite := est_penalites_impayees_fct(i_id_membre);

    -- SI la penalite est plus grande que 0 alors on l'affiche
    IF penalite > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Penalite de : ' || penalite || '.');
    END IF;

    -- Mettre a jour la date pour le retour du livre

    UPDATE bo.emprunts SET date_retour = SYSDATE
    WHERE membres_id = i_id_membre
    AND livres_id = i_id_livre AND date_retour IS NULL;

    DBMS_OUTPUT.PUT_LINE('Voici le nombre d enregistrement mis a jour : ' || SQL%ROWCOUNT);

EXCEPTION
    -- Exceptions
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Une erreur sest produite. Veuillez reesayer.');

END retourner_livre_prc;

-- Fonction E. rechercher_livre_fct

FUNCTION rechercher_livre_fct(io_id_livre IN OUT NUMBER) RETURN livre IS rec_livre pkg_tp3.T_INFO_LIVRE;

BEGIN
    -- Recherche le livre avec l'id specifie
    SELECT livres_id, sections_id, auteurs_id, genres_id, isbn, titre, maison_edition, annee_publication, langage, prix 
    INTO rec_livre
    FROM bo.livres
    WHERE livres_id = io_id_livre;

    -- retourner le livre trouve
    RETURN rec_livre;

-- Gestion des exceptions
EXCEPTION
    -- Si aucun livre n'a ete trouve, on le dit a l'utilisateur
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Aucun livre a ete trouve avec le id specifie.');
        -- L'id devient 0 si il n'y a pas de livre trouve
        io_id_livre := 0;
    RETURN NULL;

    -- Gestion des autres erreurs
    WHEN OTHERS THEN
        -- On informe l'utilisateur quil y a eu une erreur
        DBMS_OUTPUT.PUT_LINE('Une erreur sest produite veuillez reesayer.');
    RETURN NULL;

END rechercher_livre_fct;

-- Fonction F. archiver_prc

PROCEDURE archiver_prc(i_annee IN NUMBER DEFAULT 2020, i_mois IN NUMBER DEFAULT 12) IS nom_nouvelle_table VARCHAR2(100); chaine_sql VARCHAR2(100); mois_format VARCHAR2(2);

BEGIN
    -- Si le mois est plus petit que 10 ajoute un 0 devant
    IF i_mois < 10 THEN
        mois_format := '0' || i_mois;
    -- Sinon on garde le mois
    ELSE
        mois_format := i_mois;
    END IF;

    -- Nom bo.emprunts_archive_AAAAMM
    nom_nouvelle_table := 'bo.emprunts_archive_' || i_annee || mois_format;

    -- Requete chaine_sql
    chaine_sql := 'CREATE TABLE ' || nom_nouvelle_table || ' AS SELECT * FROM bo.emprunts WHERE EXTRACT(YEAR FROM date_emprunt) = ' || i_annee || ' AND EXTRACT(MONTH FROM date_emprunt) = ' || i_mois;

    EXECUTE IMMEDIATE chaine_sql;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Une erreur sest produite veuillez reesayer.');

END archiver_prc;

END GESTION_EMPRUNTS_PKG;
