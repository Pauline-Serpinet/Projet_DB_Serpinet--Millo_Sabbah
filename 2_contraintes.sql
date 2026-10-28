ALTER TABLE Discipline  MODIFY mode_pratique VARCHAR(10) NOT NULL;
ALTER TABLE Athlete  MODIFY sexe   CHAR(1)   NOT NULL, MODIFY taille SMALLINT UNSIGNED, MODIFY nom_athlete VARCHAR(30) NOT NULL, MODIFY prenom_athlete VARCHAR(30) NOT NULL, MODIFY date_naissance DATE NOT NULL;
ALTER TABLE Appartenir  MODIFY poste_occupe VARCHAR(30) NOT NULL, MODIFY date_arrivee DATE NOT NULL;
ALTER TABLE Modele_capteur  MODIFY nom_modele VARCHAR(40) NOT NULL, MODIFY type_capteur VARCHAR(30) NOT NULL;
ALTER TABLE Capteur  MODIFY date_etalonnage DATE NOT NULL;
ALTER TABLE Seance  MODIFY duree SMALLINT UNSIGNED NOT NULL, MODIFY date_heure_debut DATETIME NOT NULL, MODIFY type_seance VARCHAR(15) NOT NULL, MODIFY nom_lieu VARCHAR(50) NOT NULL;
ALTER TABLE Participer  MODIFY distance_totale INT UNSIGNED, MODIFY vitesse_max DECIMAL(4,1), MODIFY fc_moyenne SMALLINT UNSIGNED, MODIFY fc_max SMALLINT UNSIGNED, MODIFY charge_entrainement DECIMAL(6,1);
ALTER TABLE Test_physique  MODIFY unite_resultat VARCHAR(10) NOT NULL;
ALTER TABLE Passer  MODIFY resultat_test DECIMAL(6,2) NOT NULL;
ALTER TABLE Blessure  MODIFY date_blessure DATE NOT NULL, MODIFY zone_corps VARCHAR(40) NOT NULL, MODIFY gravite VARCHAR(10) NOT NULL;
ALTER TABLE Intervenant  MODIFY fonction VARCHAR(40) NOT NULL, MODIFY nom_intervenant VARCHAR(30) NOT NULL;

ALTER TABLE Discipline
  ADD CONSTRAINT ck_discipline_mode
  CHECK (mode_pratique IN ('individuel', 'collectif'));

ALTER TABLE Athlete
  ADD CONSTRAINT ck_athlete_sexe   CHECK (sexe IN ('F', 'M')),
  ADD CONSTRAINT ck_athlete_taille CHECK (taille BETWEEN 100 AND 250);

ALTER TABLE Seance
  ADD CONSTRAINT ck_seance_type
  CHECK (type_seance IN ('entrainement', 'test', 'competition')),
  ADD CONSTRAINT ck_seance_duree CHECK (duree > 0);

ALTER TABLE Participer
  ADD CONSTRAINT ck_part_distance CHECK (distance_totale >= 0),
  ADD CONSTRAINT ck_part_vitesse  CHECK (vitesse_max >= 0),
  ADD CONSTRAINT ck_part_fc       CHECK (fc_moyenne BETWEEN 30 AND 250 AND fc_max     BETWEEN 30 AND 250 AND fc_max >= fc_moyenne),
  ADD CONSTRAINT ck_part_charge   CHECK (charge_entrainement >= 0);

ALTER TABLE Blessure
  ADD CONSTRAINT ck_blessure_gravite
  CHECK (gravite IN ('legere', 'moderee', 'grave')),
  ADD CONSTRAINT ck_blessure_reprise
  CHECK (date_reprise IS NULL OR date_reprise >= date_blessure);

DELIMITER $$
CREATE TRIGGER trg_appartenir_collectif
BEFORE INSERT ON Appartenir
FOR EACH ROW
BEGIN
    DECLARE v_mode VARCHAR(10);
    DECLARE v_disc_athlete VARCHAR(40);
    DECLARE v_disc_equipe  VARCHAR(40);

    SELECT a.nom_discipline, d.mode_pratique INTO v_disc_athlete, v_mode
    FROM Athlete a JOIN Discipline d ON d.nom_discipline = a.nom_discipline
    WHERE a.numero_licence = NEW.numero_licence;

    SELECT nom_discipline INTO v_disc_equipe
    FROM Equipe 
    WHERE nom_equipe = NEW.nom_equipe;

    IF v_mode <> 'collectif' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Un athlete de discipline individuelle n''a pas d''equipe';
    END IF;
    IF v_disc_athlete <> v_disc_equipe THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'L''equipe doit etre de la discipline de l''athlete';
    END IF;
END$$

CREATE TRIGGER trg_equipe_collectif
BEFORE INSERT ON Equipe
FOR EACH ROW
BEGIN
    DECLARE v_mode VARCHAR(10);
    SELECT mode_pratique INTO v_mode
    FROM Discipline 
    WHERE nom_discipline = NEW.nom_discipline;
    IF v_mode <> 'collectif' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Une equipe appartient a une discipline collective';
    END IF;
END$$

CREATE TRIGGER trg_passer_seance_test
BEFORE INSERT ON Passer
FOR EACH ROW
BEGIN
    DECLARE v_type VARCHAR(15);
    SELECT type_seance INTO v_type 
    FROM Seance 
    WHERE code_seance = NEW.code_seance;
    IF v_type <> 'test' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Un test physique ne peut etre passe que pendant une seance de type test';
    END IF;
END$$

CREATE TRIGGER trg_blessure_seance
BEFORE INSERT ON Blessure
FOR EACH ROW
BEGIN
    DECLARE v_type VARCHAR(15);
    IF NEW.code_seance IS NOT NULL THEN
        SELECT type_seance INTO v_type 
        FROM Seance 
        WHERE code_seance = NEW.code_seance;
        IF v_type = 'test' THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Une blessure survient en entrainement ou en competition';
        END IF;
    END IF;
END$$

CREATE TRIGGER trg_porter_pas_de_chevauchement
BEFORE INSERT ON Porter
FOR EACH ROW
BEGIN
    DECLARE v_conflit INT;
    SELECT COUNT(*) INTO v_conflit
    FROM Porter p JOIN Seance s ON s.code_seance = p.code_seance JOIN Seance n ON n.code_seance = NEW.code_seance
    WHERE p.numero_serie = NEW.numero_serie AND p.numero_licence <> NEW.numero_licence AND s.date_heure_debut < n.date_heure_debut + INTERVAL n.duree MINUTE AND n.date_heure_debut < s.date_heure_debut + INTERVAL s.duree MINUTE;
    IF v_conflit > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ce capteur est deja porte par un autre athlete sur ce creneau';
    END IF;
END$$

CREATE TRIGGER trg_participer_avec_capteur
BEFORE INSERT ON Participer
FOR EACH ROW
BEGIN
    DECLARE v_nb INT;
    SELECT COUNT(*) INTO v_nb 
    FROM Porter
    WHERE numero_licence = NEW.numero_licence AND code_seance = NEW.code_seance;
    IF v_nb = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Pas de bilan sans capteur porte pendant la seance';
    END IF;
END$$
DELIMITER ;