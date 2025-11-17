CREATE OR REPLACE PACKAGE BODY GESTION_EMPRUNTS_PKG IS 

 -- Calculer les pénalitées
FUNCTION calculer_penalite_membre_fct(p_id_membre IN NUMBER) RETURN NUMBER IS
    v_total NUMBER := 0;
BEGIN

    -- Tu prends tous les emprunts qui sont liés à l'id du membre et tu calcule le nombre de jours part 0.25 comme dans le TP2
    SELECT NVL(SUM(CASE WHEN SYSDATE > e.date_retour_prevu THEN (SYSDATE - e.date_retour_prevu) * 0.25 ELSE 0 END), 0) INTO v_total FROM BO.emprunts e
    WHERE e.membres_id = p_id_membre;

    -- retourne le total
    RETURN v_total;
END calculer_penalite_membre_fct;


-- Vérifier si le membre a une pénalité
FUNCTION est_penalites_impayees_fct(i_id_membre IN NUMBER,o_montant_penalites OUT NUMBER ) RETURN BOOLEAN IS
    v_total NUMBER;
BEGIN
    v_total := calculer_penalite_membre_fct(i_id_membre);
    o_montant_penalites := v_total;

    IF v_total > 0 THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END est_penalites_impayees_fct;


PROCEDURE emprunter_livre_prc( i_id_membre IN NUMBER, i_id_livre IN NUMBER ) IS
    v_penalites NUMBER;
    v_disponible BOOLEAN;
    v_date_retour_prevue DATE;
    v_count NUMBER;
    BEGIN
    -- Vérifier pénalités
    IF est_penalites_impayees_fct(i_id_membre, v_penalites) THEN
        DBMS_OUTPUT.PUT_LINE('Ce membre a des pénalités non payées.');
        RETURN;
    END IF;

    -- Vérifier que le livre existe
    SELECT COUNT(*) INTO v_count FROM BO.livres WHERE livres_id = i_id_livre;

    IF v_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Livre introuvable id=' || i_id_livre );
        RETURN;
    END IF;

    -- Vérifier disponibilité
    v_disponible := est_disponible_fct(i_id_livre, v_date_retour_prevue);

    IF v_disponible THEN
        INSERT INTO BO.emprunts(livres_id, membres_id, date_emprunt)
        VALUES (i_id_livre, i_id_membre, SYSDATE);

        DBMS_OUTPUT.PUT_LINE('Livre emprunté avec succès.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Livre indisponible. Date de retour prévue: '  || TO_CHAR(v_date_retour_prevue, 'DD/MM/YYYY'));
    END IF;

    EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Erreur dans emprunter_livre_prc: ' || SQLERRM);
END emprunter_livre_prc;

FUNCTION est_disponible_fct( i_id_livre IN NUMBER, o_date_retour_prevue OUT DATE ) RETURN BOOLEAN IS
    v_emprunt_existant NUMBER;
    BEGIN
    -- Vérifier si le livre est déjà emprunté et non retourné
    SELECT COUNT(*) INTO v_emprunt_existant FROM BO.emprunts WHERE livres_id = i_id_livre AND date_retour IS NULL;

    IF v_emprunt_existant > 0 THEN
        -- Livre indisponible
        SELECT MAX(date_retour_prevu) INTO o_date_retour_prevue FROM BO.emprunts WHERE livres_id = i_id_livre
        AND date_retour IS NULL;

        RETURN FALSE;
    ELSE
        o_date_retour_prevue := NULL;
        RETURN TRUE;
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        RAISE;
END est_disponible_fct;

-- Procédure D. retourner_livre_prc
PROCEDURE retourner_livre_prc (i_id_membre IN NUMBER, i_id_livre IN NUMBER) IS penalite NUMBER:= 0; v_bool BOOLEAN;
BEGIN
    -- Verifier sil y a des penalites non paye
    v_bool := est_penalites_impayees_fct(i_id_membre, penalite);

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

FUNCTION rechercher_livre_fct(io_id_livre IN OUT NUMBER) RETURN T_INFO_LIVRE IS rec_livre T_INFO_LIVRE;
BEGIN
    -- Recherche le livre avec l'id specifie
    SELECT l.livres_id, l.titre, l.isbn, l.auteurs_id, l.maison_edition, l.annee_publication, l.langage, s.nom AS nom_section, g.nom_genre AS nom_genre
    INTO rec_livre
    FROM bo.livres l
    INNER JOIN bo.sections s ON s.id = l.sections_id
    INNER JOIN bo.genres g ON g.genres_id = l.genres_id
    WHERE l.livres_id = io_id_livre;

    -- retourner le livre trouve
    RETURN rec_livre;

-- Gestion des exceptions
EXCEPTION
    -- Si aucun livre n'a ete trouve, on le dit a l'utilisateur
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Aucun livre a ete trouve avec le id specifie.');
        -- L'id devient 0 si il n'y a pas de livre trouve
        io_id_livre := 0;
    RETURN rec_livre;

    -- Gestion des autres erreurs
    WHEN OTHERS THEN
        -- On informe l'utilisateur quil y a eu une erreur
        DBMS_OUTPUT.PUT_LINE('Une erreur sest produite veuillez reesayer.');
    RETURN rec_livre;

END rechercher_livre_fct;

-- Fonction F. archiver_prc

PROCEDURE archiver_prc(i_annee IN NUMBER DEFAULT 2020, i_mois  IN NUMBER DEFAULT 12) IS nom_nouvelle_table VARCHAR2(100); chaine_sql VARCHAR2(500); mois_format VARCHAR2(2);

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
