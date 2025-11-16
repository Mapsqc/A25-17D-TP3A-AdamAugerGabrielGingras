CREATE OR REPLACE PACKAGE pkg_tp3 IS 

    -- Type livre record
    TYPE livre IS RECORD (
        livres_id bo.livres.livres_id%TYPE,
        sections_id bo.livres.sections_id%TYPE,
        auteurs_id bo.livres.auteurs_id%TYPE,
        genres_id bo.livres.genres_id%TYPE,
        isbn bo.livres.isbn%TYPE,
        titre bo.livres.titre%TYPE,
        maison_edition bo.livres.maison_edition%TYPE,
        annee_publication bo.livres.annee_publication%TYPE,
        langage bo.livres.langage%TYPE,
        prix bo.livres.prix%TYPE
    );

    -- Procédure D. retourner_livre_prc
    PROCEDURE retourner_livre_prc (i_id_membre IN NUMBER, i_id_livre IN NUMBER);

    -- Fonction E. rechercher_livre_fct
    FUNCTION rechercher_livre_fct(io_id_livre IN OUT NUMBER) RETURN livre;

    -- Fonction F. archiver_prc
    PROCEDURE archiver_prc(i_annee IN NUMBER DEFAULT 2020, i_mois IN NUMBER DEFAULT 12);

END pkg_tp3;