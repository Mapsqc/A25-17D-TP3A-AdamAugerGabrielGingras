CREATE OR REPLACE PACKAGE GESTION_EMPRUNTS_PKG IS 

    -- Type livre record
    TYPE T_INFO_LIVRE IS RECORD (
        livres_id bo.livres.livres_id%TYPE,
        titre bo.livres.titre%TYPE,
        isbn bo.livres.isbn%TYPE,
        auteurs_id bo.livres.auteurs_id%TYPE,
        maison_edition bo.livres.maison_edition%TYPE,
        annee_publication bo.livres.annee_publication%TYPE,
        langage bo.livres.langage%TYPE,
        nom_section bo.sections.nom%TYPE,
        nom_genre bo.genres.nom_genre%TYPE
    );

    -- Procédure D. retourner_livre_prc
    PROCEDURE retourner_livre_prc (i_id_membre IN NUMBER, i_id_livre IN NUMBER);

    -- Fonction E. rechercher_livre_fct
    FUNCTION rechercher_livre_fct(io_id_livre IN OUT NUMBER) RETURN T_INFO_LIVRE;

    -- Fonction F. archiver_prc
    PROCEDURE archiver_prc(i_annee IN NUMBER DEFAULT 2020, i_mois IN NUMBER DEFAULT 12);

END GESTION_EMPRUNTS_PKG;