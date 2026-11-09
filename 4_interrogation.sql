-- Requète 1. Données recherchées : nom, prénom et taille des athlètes nés entre 2000 et 2005 mesurant plus de 1,80 m, triés par taille décroissante.
SELECT nom_athlete, prenom_athlete, taille
FROM Athlete
WHERE date_naissance BETWEEN '2000-01-01' AND '2005-12-31'
  AND taille > 1.80
ORDER BY taille DESC, nom_athlete;

-- Requète 2. Données recherchées : la liste (sans doublon) des zones du corps touchées par des blessures de gravité "Grave" ou "Modérée".
SELECT DISTINCT zone_corps
FROM Blessure
WHERE gravite IN ('Grave', 'Modérée')
ORDER BY zone_corps;

-- Requète 3. Données recherchées : athlètes dont le nom commence par "M" et dont le prénom contient la lettre "a" (utilisation de masques LIKE).
SELECT numero_licence, nom_athlete, prenom_athlete
FROM Athlete
WHERE nom_athlete LIKE 'M%'
  AND prenom_athlete LIKE '%a%'
ORDER BY nom_athlete, prenom_athlete;

-- Requète 4. Données recherchées : séances de type "Match" ou "Compétition" jouées dans un stade, sur la saison 2025-2026, de la plus récente à la plus ancienne.
SELECT code_seance, date_heure_debut, type_seance, nom_lieu
FROM Seance
WHERE type_seance IN ('Match', 'Compétition')
  AND nom_lieu LIKE '%Stade%'
  AND date_heure_debut BETWEEN '2025-09-01' AND '2026-06-30'
ORDER BY date_heure_debut DESC;

-- Requète 5. Données recherchées : blessures dont l'athlète n'a pas encore repris (date de reprise non renseignée), de la plus ancienne à la plus récente.
SELECT numero_licence, numero_blessure, date_blessure, zone_corps, gravite
FROM Blessure
WHERE date_reprise IS NULL
ORDER BY date_blessure;

-- Requète 6. Données recherchées : capteurs dont l'étalonnage date d'avant 2025 (à recalibrer), du plus ancien au plus récent.
SELECT numero_serie, date_etalonnage, nom_modele
FROM Capteur
WHERE date_etalonnage < '2025-01-01'
ORDER BY date_etalonnage;

-- Requète 7. Données recherchées : nombre d'athlètes par discipline, pour les disciplines comptant au moins 5 athlètes.
SELECT nom_discipline, COUNT(*) AS nb_athletes
FROM Athlete
GROUP BY nom_discipline
HAVING COUNT(*) >= 5
ORDER BY nb_athletes DESC;

-- Requète 8 . Données recherchées : par athlète, la distance totale parcourue, la charge d'entraînement moyenne et la fréquence cardiaque max atteinte, pour ceux dont la charge moyenne dépasse 500.
SELECT numero_licence,
       SUM(distance_totale)       AS distance_cumulee,
       AVG(charge_entrainement)   AS charge_moyenne,
       MAX(fc_max)                AS fc_max_atteinte
FROM Participer
GROUP BY numero_licence
HAVING AVG(charge_entrainement) > 500
ORDER BY charge_moyenne DESC;

-- Requète 9. Données recherchées : nombre de blessures par zone du corps et par niveau de gravité, en ne gardant que les groupes de 3 blessures ou plus.
SELECT zone_corps, gravite, COUNT(*) AS nb_blessures
FROM Blessure
GROUP BY zone_corps, gravite
HAVING COUNT(*) >= 3
ORDER BY nb_blessures DESC;

-- Requète 10. Données recherchées : par test physique, le nombre de passages, le résultat moyen, minimum et maximum.
SELECT nom_test,
       COUNT(*)           AS nb_passages,
       AVG(resultat_test) AS moyenne,
       MIN(resultat_test) AS minimum,
       MAX(resultat_test) AS maximum
FROM Passer
GROUP BY nom_test
ORDER BY nb_passages DESC;

-- Requète 11. Données recherchées : par type de séance, la vitesse max moyenne et la fréquence cardiaque moyenne des athlètes (jointure + agrégation).
SELECT s.type_seance,
       COUNT(*)           AS nb_participations,
       AVG(p.vitesse_max) AS vitesse_max_moyenne,
       AVG(p.fc_moyenne)  AS fc_moyenne
FROM Participer p
JOIN Seance s ON s.code_seance = p.code_seance
GROUP BY s.type_seance
HAVING COUNT(*) > 10
ORDER BY vitesse_max_moyenne DESC;

-- Requète 12. Données recherchées : nombre de séances et d'athlètes distincts par lieu d'entraînement.
SELECT s.nom_lieu,
       COUNT(DISTINCT s.code_seance)    AS nb_seances,
       COUNT(DISTINCT p.numero_licence) AS nb_athletes_distincts
FROM Seance s
JOIN Participer p ON p.code_seance = s.code_seance
GROUP BY s.nom_lieu
ORDER BY nb_seances DESC;

-- Requète 13. Jointure interne simple.
--     Données recherchées : chaque athlète avec sa discipline et le mode de pratique de celle-ci.
SELECT a.nom_athlete, a.prenom_athlete, d.nom_discipline, d.mode_pratique
FROM Athlete a
JOIN Discipline d ON d.nom_discipline = a.nom_discipline
ORDER BY d.nom_discipline, a.nom_athlete;

-- Requète 14. Jointure multiple (4 tables).
--     Données recherchées : pour chaque blessure, l'athlète concerné, la zone touchée, la gravité et l'intervenant (soignant) qui l'a prise en charge.
SELECT a.nom_athlete, a.prenom_athlete,
       b.date_blessure, b.zone_corps, b.gravite,
       i.nom_intervenant, i.fonction
FROM Blessure b
JOIN Athlete a      ON a.numero_licence = b.numero_licence
JOIN Intervenant i  ON i.id_intervenant = b.id_intervenant
ORDER BY b.date_blessure DESC;

-- Requète 15. Jointure externe gauche (avec comptage).
--     Données recherchées : tous les athlètes avec leur nombre de blessures, y compris ceux qui n'en ont jamais eu (0).
SELECT a.numero_licence, a.nom_athlete, a.prenom_athlete,
       COUNT(b.numero_blessure) AS nb_blessures
FROM Athlete a
LEFT JOIN Blessure b ON b.numero_licence = a.numero_licence
GROUP BY a.numero_licence, a.nom_athlete, a.prenom_athlete
ORDER BY nb_blessures DESC;

-- Requète 16. Auto-jointure.
--     Données recherchées : chaque intervenant avec son superviseur (les intervenants sans superviseur apparaissent avec NULL).
SELECT i.nom_intervenant   AS intervenant,
       i.fonction,
       sup.nom_intervenant AS superviseur
FROM Intervenant i
LEFT JOIN Intervenant sup ON sup.id_intervenant = i.id_intervenant_superviseur
ORDER BY superviseur, intervenant;

-- Requète 17. Jointure multiple (5 tables) sur les capteurs.
--     Données recherchées : pour chaque séance, quel athlète portait quel capteur (numéro de série, modèle et type de capteur).
SELECT s.code_seance, s.date_heure_debut,
       a.nom_athlete, a.prenom_athlete,
       c.numero_serie, m.nom_modele, m.type_capteur
FROM Porter po
JOIN Athlete a        ON a.numero_licence = po.numero_licence
JOIN Seance s         ON s.code_seance    = po.code_seance
JOIN Capteur c        ON c.numero_serie   = po.numero_serie
JOIN Modele_capteur m ON m.nom_modele     = c.nom_modele
ORDER BY s.date_heure_debut, a.nom_athlete;

-- Requète 18. Jointure externe gauche + filtre sur NULL.
--     Données recherchées : les équipes n'ayant organisé aucune séance.
SELECT e.nom_equipe, e.nom_discipline
FROM Equipe e
LEFT JOIN Seance s ON s.nom_equipe = e.nom_equipe
WHERE s.code_seance IS NULL;



-- Requète 19. IN Données recherchées : athlètes ayant participé à au moins une séance de type "Match".
SELECT numero_licence, nom_athlete, prenom_athlete
FROM Athlete
WHERE numero_licence IN (
    SELECT p.numero_licence
    FROM Participer p
    JOIN Seance s ON s.code_seance = p.code_seance
    WHERE s.type_seance = 'Match'
);

-- Requète 20. NOT EXISTS.
--     Données recherchées : athlètes qui n'ont jamais été blessés.
SELECT a.numero_licence, a.nom_athlete, a.prenom_athlete
FROM Athlete a
WHERE NOT EXISTS (
    SELECT 1
    FROM Blessure b
    WHERE b.numero_licence = a.numero_licence
);

-- Requète 21. NOT IN (avec précaution sur les NULL).
--     Données recherchées : équipes sans aucune séance. Seance.nom_equipe est facultative (NULL possible) : sans le filtre IS NOT NULL, le
--     NOT IN ne renverrait aucune ligne.
SELECT nom_equipe
FROM Equipe
WHERE nom_equipe NOT IN (
    SELECT nom_equipe
    FROM Seance
    WHERE nom_equipe IS NOT NULL
);

-- Requète 22. ALL. Données recherchées : participations dont la charge d'entraînement dépasse toutes les charges enregistrées lors des séances de "Récupération".
SELECT numero_licence, code_seance, charge_entrainement
FROM Participer
WHERE charge_entrainement > ALL (
    SELECT p2.charge_entrainement
    FROM Participer p2
    JOIN Seance s ON s.code_seance = p2.code_seance
    WHERE s.type_seance = 'Récupération'
);

-- Requète 23. ANY. Données recherchées : intervenants ayant pris en charge au moins une blessure de gravité "Grave".
SELECT id_intervenant, nom_intervenant, fonction
FROM Intervenant
WHERE id_intervenant = ANY (
    SELECT id_intervenant
    FROM Blessure
    WHERE gravite = 'Grave'
);

-- Requète 24. EXISTS corrélée.
--     Données recherchées : séances au cours desquelles au moins un test physique a été passé.
SELECT s.code_seance, s.date_heure_debut, s.type_seance
FROM Seance s
WHERE EXISTS (
    SELECT 1
    FROM Passer ps
    WHERE ps.code_seance = s.code_seance
);

-- Requète 25. Sous-requête scalaire dans un HAVING.
--     Données recherchées : athlètes dont la charge d'entraînement moyenne est supérieure à la charge moyenne de l'ensemble du club.
SELECT numero_licence, AVG(charge_entrainement) AS charge_moyenne
FROM Participer
GROUP BY numero_licence
HAVING AVG(charge_entrainement) > (
    SELECT AVG(charge_entrainement) FROM Participer
)
ORDER BY charge_moyenne DESC;

-- Requète 26. Données recherchées : nom et prénom des athlètes ayant atteint une fréquence cardiaque max > 190 bpm lors d'une séance de type "Match".
SELECT DISTINCT a.nom_athlete, a.prenom_athlete
FROM Athlete a
JOIN Participer p ON p.numero_licence = a.numero_licence
JOIN Seance s     ON s.code_seance    = p.code_seance
WHERE s.type_seance = 'Match'
  AND p.fc_max > 190;