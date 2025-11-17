set serveroutput on;


/************************************* Fait par ÉTUDIANT 1, à tester par ÉTUDIANT 2 *******************************************/
-- A. TEST FONCTIONNEL POUR est_penalites_impayees_fct
DECLARE
    ID_MEMBRE NUMBER;
BEGIN
 
    -- LIVRES TOUS RETOURNÉS, SANS AMENDE À PAYER
    DBMS_OUTPUT.PUT_LINE('*** CAS DE TEST no. 1 : LIVRES TOUS RETOURNÉS, SANS AMENDE À PAYER');
    ID_MEMBRE := 7; -- Membre 7 : Aucune amende à payer


    -- LIVRES TOUS RETOURNÉS, MAIS AVEC AMENDE À PAYER
    DBMS_OUTPUT.PUT_LINE('*** CAS DE TEST no. 2 : LIVRES TOUS RETOURNÉS, MAIS AVEC AMENDE À PAYER');

    -- AFFICHER LES AMENDES TOTALES À PAYER POUR LE MEMBRE. Un paramètre de sortie doit avoir été prévu à cette fin. 

    -- LIVRE PAS TOUS RETOURNÉS, AVEC AMENDE À PAYER
    DBMS_OUTPUT.PUT_LINE('*** CAS DE TEST no. 3 : LIVRE PAS TOUS RETOURNÉS, AVEC AMENDE À PAYER');
    
    -- AFFICHER LES AMENDES TOTALES À PAYER POUR LE MEMBRE. Un paramètre de sortie doit avoir été prévu à cette fin.
 

    -- LIVRE PAS TOUS RETOURNÉS, MAIS SANS AMENDE À PAYER
    DBMS_OUTPUT.PUT_LINE('*** CAS DE TEST no. 4 : LIVRE PAS TOUS RETOURNÉS, MAIS SANS AMENDE À PAYER');


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


    ROLLBACK; -- Pour annuler les modifications de la transaction (retrouver les données d'origine)
 
    -- LIVRE INEXISTANT
    DBMS_OUTPUT.PUT_LINE ('*** CAS DE TEST no. 2 : LIVRE INEXISTANT');


    ROLLBACK;
 
    -- LIVRE EXISTANT, MAIS DÉJÀ EMPRUNTÉ
    DBMS_OUTPUT.PUT_LINE('*** CAS DE TEST no. 3 : LIVRE EXISTANT, MAIS DÉJÀ EMPRUNTÉ');


    ROLLBACK;
 
    -- CAS DE TEST no. 4 : ON PEUT EMPRUNTER LE LIVRE
    DBMS_OUTPUT.PUT_LINE('*** CAS DE TEST no. 4 : ON PEUT EMPRUNTER LE LIVRE');



    ROLLBACK;
END;
/

--C. TEST FONCTIONNEL POUR est_disponible_fct
DECLARE
    ID_LIVRE     NUMBER;
    RETOUR_PREVU DATE;
BEGIN
 
    -- LIVRE DISPONIBLE POUR EMPRUNT
    DBMS_OUTPUT.PUT_LINE('*** CAS DE TEST no. 1 : LIVRE DISPONIBLE POUR EMPRUNT');


 

    -- LIVRE DÉJÀ EMPRUNTÉ
    DBMS_OUTPUT.PUT_LINE('*** CAS DE TEST no. 2 : LIVRE DÉJÀ EMPRUNTÉ');


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

    ROLLBACK; -- Pour annuler les modifications de la transaction (retrouver les données d'origine)


    -- RETOUR AVEC AMENDES À PAYER
    DBMS_OUTPUT.PUT_LINE('*** CAS DE TEST no. 2 : RETOUR AVEC AMENDES À PAYER');
    ID_MEMBRE := 4; -- Membre 4 : Amendes à payer
    ID_LIVRE := 4; -- Livre 4 : Livre à retourner

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
DECLARE
    VERIF VARCHAR2(1000);
BEGIN
 
    -- Création EMPRUNTS_ARCHIVE_202012 (valeurs par défaut)
    DBMS_OUTPUT.PUT_LINE('*** CAS DE TEST no. 1 : Création de la table EMPRUNTS_ARCHIVE_202012 (valeurs par défaut)');

    
 
    -- Création EMPRUNTS_ARCHIVE_202104
    DBMS_OUTPUT.PUT_LINE('*** CAS DE TEST no. 2 : Création de la table EMPRUNTS_ARCHIVE_202104 (Avril 2024)');




    --drop table EMPRUNTS_ARCHIVE_202012;
    --drop table EMPRUNTS_ARCHIVE_202104;
END;
/