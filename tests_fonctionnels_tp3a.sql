set serveroutput on;


/************************************* Fait par ÉTUDIANT 1, à tester par ÉTUDIANT 2 *******************************************/
-- A. TEST FONCTIONNEL POUR est_penalites_impayees_fct
DECLARE
    ID_MEMBRE NUMBER;
    v_amende NUMBER;
    v_a_penalites BOOLEAN;
BEGIN
 
    -- LIVRES TOUS RETOURNÉS, SANS AMENDE À PAYER
    DBMS_OUTPUT.PUT_LINE('*** CAS DE TEST no. 1 : LIVRES TOUS RETOURNÉS, SANS AMENDE À PAYER');
    ID_MEMBRE := 7; -- Membre 7 : Aucune amende à payer
    v_a_penalites := BO.gestion_emprunts_pkg.est_penalites_impayees_fct(ID_MEMBRE, v_amende);
    IF v_a_penalites THEN
        DBMS_OUTPUT.PUT_LINE('Membre ' || ID_MEMBRE || ' a un total de : ' || v_amende || ' a payer');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Membre ' || ID_MEMBRE || ' a un total de : ' || v_amende || ' a payer');
    END IF;


    -- LIVRES TOUS RETOURNÉS, MAIS AVEC AMENDE À PAYER
    DBMS_OUTPUT.PUT_LINE('*** CAS DE TEST no. 2 : LIVRES TOUS RETOURNÉS, MAIS AVEC AMENDE À PAYER');
    ID_MEMBRE := 2;
    v_a_penalites := BO.gestion_emprunts_pkg.est_penalites_impayees_fct(ID_MEMBRE, v_amende);
    IF v_a_penalites THEN
        DBMS_OUTPUT.PUT_LINE('Membre ' || ID_MEMBRE || ' a un total de : ' || v_amende || ' a payer');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Membre ' || ID_MEMBRE || ' a un total de : ' || v_amende || ' a payer');
    END IF;

    -- AFFICHER LES AMENDES TOTALES À PAYER POUR LE MEMBRE. Un paramètre de sortie doit avoir été prévu à cette fin. 

    -- LIVRE PAS TOUS RETOURNÉS, AVEC AMENDE À PAYER
    DBMS_OUTPUT.PUT_LINE('*** CAS DE TEST no. 3 : LIVRE PAS TOUS RETOURNÉS, AVEC AMENDE À PAYER');
    ID_MEMBRE := 3;
    v_a_penalites := BO.gestion_emprunts_pkg.est_penalites_impayees_fct(ID_MEMBRE, v_amende);
    IF v_a_penalites THEN
        DBMS_OUTPUT.PUT_LINE('Membre ' || ID_MEMBRE || ' a un total de : ' || v_amende || ' a payer');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Membre ' || ID_MEMBRE || ' a un total de : ' || v_amende || ' a payer');
    END IF;
    
    -- AFFICHER LES AMENDES TOTALES À PAYER POUR LE MEMBRE. Un paramètre de sortie doit avoir été prévu à cette fin.
 

    -- LIVRE PAS TOUS RETOURNÉS, MAIS SANS AMENDE À PAYER
    DBMS_OUTPUT.PUT_LINE('*** CAS DE TEST no. 4 : LIVRE PAS TOUS RETOURNÉS, MAIS SANS AMENDE À PAYER');
    ID_MEMBRE := 6;
    v_a_penalites := BO.gestion_emprunts_pkg.est_penalites_impayees_fct(ID_MEMBRE, v_amende);
    IF v_a_penalites THEN
        DBMS_OUTPUT.PUT_LINE('Membre ' || ID_MEMBRE || ' a un total de : ' || v_amende || ' a payer');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Membre ' || ID_MEMBRE || ' a un total de : ' || v_amende || ' a payer');
    END IF;

END;
/

--B. TEST FONCTIONNEL POUR emprunter_livre_prc
DECLARE
    ID_MEMBRE NUMBER;
    ID_LIVRE  NUMBER;
    VERIF     VARCHAR2(1000); -- Pratique pour afficher les dates lors de transactions (longue concaténation des données de dates)
BEGIN
 
    -- EMPRUNT IMPOSSIBLE, CAR AMENDES
    DBMS_OUTPUT.PUT_LINE ('*** CAS DE TEST no. 1 : EMPRUNT IMPOSSIBLE, CAR AMENDES');
    ID_MEMBRE := 2;
    ID_LIVRE := 1;
    BO.gestion_emprunts_pkg.emprunter_livre_prc(ID_MEMBRE, ID_LIVRE);


    ROLLBACK; -- Pour annuler les modifications de la transaction (retrouver les données d'origine)
 
    -- LIVRE INEXISTANT
    DBMS_OUTPUT.PUT_LINE ('*** CAS DE TEST no. 2 : LIVRE INEXISTANT');
    ID_MEMBRE := 7;
    ID_LIVRE := 999;
    BO.gestion_emprunts_pkg.emprunter_livre_prc(ID_MEMBRE, ID_LIVRE);


    ROLLBACK;
 
    -- LIVRE EXISTANT, MAIS DÉJÀ EMPRUNTÉ
    DBMS_OUTPUT.PUT_LINE('*** CAS DE TEST no. 3 : LIVRE EXISTANT, MAIS DÉJÀ EMPRUNTÉ');
    ID_MEMBRE := 7;
    ID_LIVRE := 7;
    BO.gestion_emprunts_pkg.emprunter_livre_prc(ID_MEMBRE, ID_LIVRE);

    ROLLBACK;
 
    -- CAS DE TEST no. 4 : ON PEUT EMPRUNTER LE LIVRE
    DBMS_OUTPUT.PUT_LINE('*** CAS DE TEST no. 4 : ON PEUT EMPRUNTER LE LIVRE');
    ID_MEMBRE := 7;
    ID_LIVRE := 1;
    BO.gestion_emprunts_pkg.emprunter_livre_prc(ID_MEMBRE, ID_LIVRE);

    ROLLBACK;
END;
/

--C. TEST FONCTIONNEL POUR est_disponible_fct
DECLARE
    ID_LIVRE     NUMBER;
    RETOUR_PREVU DATE;
    v_disponible BOOLEAN;
BEGIN
 
    -- LIVRE DISPONIBLE POUR EMPRUNT
    DBMS_OUTPUT.PUT_LINE('*** CAS DE TEST no. 1 : LIVRE DISPONIBLE POUR EMPRUNT');
    ID_LIVRE := 1;
    v_disponible := BO.gestion_emprunts_pkg.est_disponible_fct(ID_LIVRE, RETOUR_PREVU);
    IF v_disponible THEN
        DBMS_OUTPUT.PUT_LINE('Livre ' || ID_LIVRE || ' est disponible.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Livre ' || ID_LIVRE || ' n''est pas disponible.');
    END IF;

    -- LIVRE DÉJÀ EMPRUNTÉ
    DBMS_OUTPUT.PUT_LINE('*** CAS DE TEST no. 2 : LIVRE DÉJÀ EMPRUNTÉ');
    ID_LIVRE := 7;
    v_disponible := BO.gestion_emprunts_pkg.est_disponible_fct(ID_LIVRE, RETOUR_PREVU);
    IF v_disponible THEN
        DBMS_OUTPUT.PUT_LINE('Livre ' || ID_LIVRE || ' est disponible.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Livre ' || ID_LIVRE || ' n''est pas disponible. Date de retour prévue : ' || TO_CHAR(RETOUR_PREVU, 'DD/MM/YYYY'));
    END IF;

END;
/

/************************************* Fait par ÉTUDIANT 2, à tester par ÉTUDIANT 1 *******************************************/
--D. TEST FONCTIONNEL POUR retourner_livre_prc
DECLARE
    ID_MEMBRE NUMBER;
    ID_LIVRE  NUMBER;
    VERIF     VARCHAR2(1000);
BEGIN
 
    -- RETOUR SANS AMENDES À PAYER
    DBMS_OUTPUT.PUT_LINE('*** CAS DE TEST no. 1 : RETOUR SANS AMENDES À PAYER');
    ID_MEMBRE := 6; -- Membre 6 : Aucune amende à payer
    ID_LIVRE := 18; -- Livre 18 : Livre à retourner
    BO.gestion_emprunts_pkg.retourner_livre_prc(ID_MEMBRE, ID_LIVRE);

    ROLLBACK; -- Pour annuler les modifications de la transaction (retrouver les données d'origine)


    -- RETOUR AVEC AMENDES À PAYER
    DBMS_OUTPUT.PUT_LINE('*** CAS DE TEST no. 2 : RETOUR AVEC AMENDES À PAYER');
    ID_MEMBRE := 4; -- Membre 4 : Amendes à payer
    ID_LIVRE := 4; -- Livre 4 : Livre à retourner
    BO.gestion_emprunts_pkg.retourner_livre_prc(ID_MEMBRE, ID_LIVRE);

    rollback;
END;
/

--E. TEST FONCTIONNEL POUR rechercher_livre_fct
DECLARE
    ID_LIVRE     NUMBER;
    REC_INFO_LIVRE GESTION_EMPRUNTS_PKG.T_INFO_LIVRE;
BEGIN
 
    -- LIVRE EXISTANT
    DBMS_OUTPUT.PUT_LINE('*** CAS DE TEST no. 1 : LIVRE EXISTANT');
    ID_LIVRE := 1; -- Livre 1 qui existe
    REC_INFO_LIVRE := GESTION_EMPRUNTS_PKG.rechercher_livre_fct(ID_LIVRE);
 

    -- LIVRE INEXISTANT
    DBMS_OUTPUT.PUT_LINE('*** CAS DE TEST no. 2 : LIVRE INEXISTANT');
    ID_LIVRE := 0; -- Livre 0 qui n'existe pas
    REC_INFO_LIVRE := GESTION_EMPRUNTS_PKG.rechercher_livre_fct(ID_LIVRE);


END;
/




--F.  TEST FONCTIONNEL POUR archiver_prc

-- Ne fonctionne pas, je crois que la table n'est jamais creer mais je n'ai pas trouve pourquoi.
DECLARE
    VERIF VARCHAR2(1000);
    nb_enregistrements NUMBER;
BEGIN
 
    -- Création EMPRUNTS_ARCHIVE_202012 (valeurs par défaut)
    DBMS_OUTPUT.PUT_LINE('*** CAS DE TEST no. 1 : Création de la table EMPRUNTS_ARCHIVE_202012 (valeurs par défaut)');
    BO.gestion_emprunts_pkg.archiver_prc();

    -- Validation
    SELECT COUNT(*)
    INTO nb_enregistrements
    FROM bo.emprunts_archive_202012;


    VERIF := 'Table bo.emprunts_archive_202012 créée avec ' || nb_enregistrements || ' enregistrements.';
    DBMS_OUTPUT.PUT_LINE(VERIF);
    
 
    -- Création EMPRUNTS_ARCHIVE_202104
    DBMS_OUTPUT.PUT_LINE('*** CAS DE TEST no. 2 : Création de la table EMPRUNTS_ARCHIVE_202104 (Avril 2024)');
    BO.gestion_emprunts_pkg.archiver_prc(2021, 4);

    -- Validation
    SELECT COUNT(*)
    INTO nb_enregistrements
    FROM bo.emprunts_archive_202104;


    VERIF := 'Table bo.emprunts_archive_202104 créée avec ' || nb_enregistrements || ' enregistrements.';
    DBMS_OUTPUT.PUT_LINE(VERIF);




    --drop table EMPRUNTS_ARCHIVE_202012;
    --drop table EMPRUNTS_ARCHIVE_202104;
END;
/