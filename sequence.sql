



-- 1) nombre d'emprunts par genre au cours des trois derniers mois
SELECT g.NOM_GENRE AS "GENRE", COUNT(e.id_emprunt) AS "NombreEmprunts"
    FROM BO.EMPRUNTS e JOIN BO.LIVRES l ON e.LIVRES_ID = l.LIVRES_ID
    JOIN BO.GENRES g ON g.GENRES_ID = l.GENRES_ID
    WHERE e.DATE_EMPRUNT >= ADD_MONTHS(
        (SELECT MAX(DATE_EMPRUNT) FROM BO.EMPRUNTS), -3)

    GROUP BY g.NOM_GENRE ORDER BY COUNT(e.ID_EMPRUNT), GENRE;


-- 2) Quantité de livres par genre et part (%)
SELECT
    g.nom_genre AS Genre,
    COUNT(l.livres_id) AS Nb_Livres,
    ROUND(COUNT(l.livres_id) / (SELECT COUNT(*) FROM BO.LIVRES), 2) || ' %' AS Part
FROM BO.LIVRES l
JOIN BO.GENRES g ON l.genres_id = g.genres_id
GROUP BY g.nom_genre
ORDER BY COUNT(l.livres_id) / (SELECT COUNT(*) FROM BO.LIVRES) DESC;

-- 3) Livre le plus populaire chez les hommes,
SELECT g.NOM_GENRE AS "GENRE", COUNT(e.id_emprunt) AS "NombreEmprunt"
FROM BO.EMPRUNTS e JOIN BO.LIVRES l ON l.LIVRES_ID = e.LIVRES_ID
    JOIN BO.GENRES g ON g.GENRES_ID = l.GENRES_ID
    JOIN BO.MEMBRES m ON e.MEMBRES_ID = m.ID
    WHERE m.GENRE = 'M'
    GROUP BY g.NOM_GENRE
    ORDER BY "NombreEmprunt" DESC
    FETCH FIRST 1 ROWS ONLY;

-- 4) Membres avec plus de 3 emprunts sur les 6 derniers mois
SELECT
    m.PRENOM || ' ' || m.NOM AS Membre,
    COUNT(e.id_emprunt) AS Nb_Emprunts
FROM BO.MEMBRES m
JOIN BO.EMPRUNTS e ON m.id = e.membres_id
WHERE e.date_emprunt >= ADD_MONTHS(
        (SELECT MAX(date_emprunt) FROM BO.EMPRUNTS), -6)
GROUP BY m.PRENOM, m.NOM
HAVING COUNT(e.id_emprunt) > 3
ORDER BY Membre;

-- 5) Membres avec livres en retard supérieurs à la moyenne // pas encore faite
SELECT m.PRENOM || ' ' || m.NOM AS Membre, e.DATE_EMPRUNT, l.TITRE, (SYSDATE - e.DATE_RETOUR_PREVU) AS Jours_Retard
    FROM BO.EMPRUNTS e
    JOIN BO.MEMBRES m ON e.MEMBRES_ID = m.ID
    JOIN BO.LIVRES l ON e.LIVRES_ID = l.LIVRES_ID
    WHERE e.DATE_RETOUR IS NULL AND (SYSDATE - e.DATE_RETOUR_PREVU) > (
        SELECT AVG(SYSDATE - e2.DATE_RETOUR_PREVU)
        FROM BO.EMPRUNTS e2
        WHERE e2.DATE_RETOUR IS NULL
      )
    ORDER BY Jours_Retard DESC, l.TITRE ASC;

-- 6)
    SELECT
    m.code AS CODE,
    m.NOM || ', ' || SUBSTR(m.PRENOM,1,1) || '.' AS Nom_Complet FROM BO.MEMBRES m
    LEFT JOIN BO.EMPRUNTS e ON m.id = e.membres_id
    WHERE e.id_emprunt IS NULL
    ORDER BY Nom_Complet;

-- 7)
SELECT l.TITRE, COUNT(l.LIVRES_ID) AS "Nombre d'emprunts" FROM BO.LIVRES l
    JOIN BO.EMPRUNTS e ON e.LIVRES_ID = l.LIVRES_ID
    WHERE EXTRACT(YEAR FROM e.DATE_EMPRUNT) = 2022
    GROUP BY l.TITRE
    ORDER BY "Nombre d'emprunts" desc
    FETCH FIRST 3 ROWS ONLY;

-- 8) Valeur totale des livres perdus
SELECT
    SUM(l.prix) AS Valeur_Totale
    FROM BO.LIVRES l
    JOIN BO.EMPRUNTS e ON l.livres_id = e.livres_id
    JOIN BO.MEMBRES m ON e.membres_id = m.id
    WHERE e.date_retour IS NULL
    AND m.STATUT_MEMBRE = 'Expiré';



-- 9)
SELECT s.SECTIONS_ID,s.NOM, g.NOM_GENRE , COUNT(l.LIVRES_ID) FROM BO.SECTIONS s
    JOIN BO.LIVRES l ON l.SECTIONS_ID = s.SECTIONS_ID
    JOIN BO.GENRES g ON l.GENRES_ID = g.GENRES_ID
    GROUP BY s.SECTIONS_ID, s.NOM, g.NOM_GENRE
    ORDER BY s.NOM, g.NOM_GENRE;


-- 10) Création de la vue RETARDS_MEMBRES
CREATE OR REPLACE VIEW BO.RETARDS_MEMBRES AS
    SELECT
    m.code AS CODE,
    COUNT(e.id_emprunt) AS NB_LIVRES,
    SUM(CASE WHEN SYSDATE > e.date_retour_prevu THEN 1 ELSE 0 END) AS NB_J_RETARD,
    '$' || TO_CHAR(ROUND(SUM(CASE WHEN SYSDATE > e.date_retour_prevu THEN SYSDATE - e.date_retour_prevu ELSE 0 END) * 0.25, 2), 'FM9999990.00') AS FRAIS
    FROM BO.MEMBRES m
    JOIN BO.EMPRUNTS e ON m.id = e.membres_id
    GROUP BY m.code
    ORDER BY FRAIS DESC;
