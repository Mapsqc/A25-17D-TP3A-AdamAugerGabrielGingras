# A25-17D-TP3A-AdamAugerGabrielGingras

# PROJET DE GESTION DES EMPRUNTS CHEZ BIBLIORG
## DESCRIPTION
Consiste a creer un package en GESTION_EMPRUNTS_PKG en PLSQL pour gerer les emprunts de livres dans uen bibliotheque. Le projet inclut egalement des tests afin de tester le fonctionnement des procedures et fonctions.

## STRUCTURE DU PROJET
Il y a plusieurs fichiers, 
- users.sql pour les users,
- drop.sql pour drop la bd,
- objects.sql pour les tables,
- data.sql pour remplir la bd (fournit par le prof),
- pks
- pkb
- tests

## ÉQUIPE
Lettre d’équipe : Z
Étudiant 1 : Adam Auger
Étudiant 2 : Gabriel Gingras

## REPO GITHUB
[Lien Repo](https://github.com/Mapsqc/A25-17D-TP3A-AdamAugerGabrielGingras/)

## TÂCHES
### Etudiant 1
- Convertir 02_drop en bloc anonyme avec collections (liste d’objets à supprimer/créer)
- Fonction A. est_penalites_impayees_fct
- Procédure B. emprunter_livre_prc 
- Fonction C. est_disponible_fct
- Compléter les tests fonctionnels en lien avec les fonctions / procédures (idéalement celles de votre collègue pour faire un genre de code review et voir d’autres exemples). Voir BO_50_tests_fonctionnels_tp3a.sql
- Création des SPECS et BODY d’un package renfermant ces fonctions / procédures uniquement (fichier séparé)

### Etudiant 2
- Convertir 01_users en bloc anonyme avec collections (liste d’utilisateurs à supprimer/créer et liste de privilèges)
- Procédure D. retourner_livre_prc 
- Fonction E. rechercher_livre_fct
- Procédure F. archiver_prc
- Compléter les tests fonctionnels en lien avec les fonctions / procédures (idéalement celles de votre collègue pour faire un genre de code review et voir d’autres exemples). Voir BO_50_tests_fonctionnels_tp3a.sql 
- Création des SPECS et BODY d’un package renfermant ces fonctions / procédures uniquement (fichier séparé)

## Commentaires
Les commit avec dans le titre 'adam' est le code de Adam. Il n'a pas reussi a push.

## INSTRUCTIONS
1. Cloner le dépôt :
Faire un git clone <https://github.com/Mapsqc/A25-17D-TP3A-AdamAugerGabrielGingras.git>

2. Lancer les scripts 1 par 1
