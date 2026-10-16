
# Mini-projet : Conception et développement d’une base de données- PARTIE 1

## Etape 1 : Analyser les besoins
Pour ce projet, nous avons décidé de concevoir une base de données pour une entreprise spécialisée dans le suivi de la performance sportive, en modélisant la collecte de données métriques issues de capteurs connectés ainsi que l'historique médical et d'entraînement d'athlètes de haut niveau

# Prompt envoyé à l'ia
Tu travailles dans le domaine du sport. Ton entreprise a comme activité de mesurer les performances sportives des athlètes de haut niveau. C’est une entreprise comme Sportech et Kinexon, STATSport, FirstBeat, Zone7. Les données sont collectées sur des athlètes de haut niveau (individuels et en équipe), lors de leurs séances d'entraînement, de tests physiques et de compétitions. Elles portent sur leurs performances mesurées par des capteurs et autres outils numérique et leur historique de blessures. Inspire-toi des sites web suivant : Statsport: STATSports | Athlete Monitoring For Teams, kinexon: Land a Career in Sports Data | KINEXON SPORTS, insep: Laboratoire Sport, Expertise et Performance | Laboratoires de recherche de l'INSEP et sportech: SporTech. Articles: Wearable Sensors for Real-Time Kinematics Analysis in Sports: A Review | IEEE Journals & Magazine | IEEE Xplore.
Ton entreprise veut appliquer MERISE pour concevoir un système d'information. Tu es chargé de la partie analyse, c’est-à-dire de collecter les besoins auprès de l’entreprise. Elle a fait appel à un étudiant en ingénierie informatique pour réaliser ce projet, tu dois lui fournir les informations nécessaires pour qu’il applique ensuite lui-même les étapes suivantes de conception et développement de la base de données. 
D’abord, établis les règles de gestions des données de ton entreprise, sous la forme d'une liste à puce. Elle doit correspondre aux informations que fournit quelqu’un qui connaît le fonctionnement de l’entreprise, mais pas comment se construit un système d’information.
Ensuite, à partir de ces règles, fournis un dictionnaire de données brutes avec les colonnes suivantes, regroupées dans un tableau : signification de la donnée, type, taille en nombre de caractères ou de chiffres. Il doit y avoir entre 25 et 35 données. Il sert à fournir des informations supplémentaires sur chaque donnée (taille et type) mais sans a priori sur comment les données vont être modélisées ensuite.
Fournis donc les règles de gestion et le dictionnaire de données.

 Document word du prompt [Mini_Projet_1_Base_Prompt-modifié (1).docx](https://github.com/user-attachments/files/33534944/Mini_Projet_1_Base_Prompt-modifie.1.docx)


# Réponse renvoyé par l'IA

1. Règles de gestion

Les athlètes

Notre entreprise suit des athlètes de haut niveau. Chacun est identifié par son numéro de licence et on enregistre son nom, son prénom, sa date de naissance, son sexe et sa taille.
Un athlète pratique une discipline principale (football, athlétisme, natation, rugby, etc.). Une discipline est soit individuelle, soit collective.
Un athlète d’une discipline collective appartient à une équipe, où il occupe un poste (gardien, ailier, pilier, etc.). Il peut changer d’équipe au cours de sa carrière, et on conserve la date de son arrivée dans chaque équipe. Une équipe regroupe plusieurs athlètes.
Les athlètes d’une discipline individuelle n’ont pas d’équipe.

Les séances

Les données sont collectées lors de séances. Chaque séance a un code unique, une date et une heure de début, une durée en minutes et un lieu (stade, piste, salle, etc.).
Une séance est de l’un de ces trois types : entraînement, test physique ou compétition.
Une séance concerne un ou plusieurs athlètes. Une séance collective réunit toute une équipe, une séance individuelle un seul athlète. Un athlète participe à de nombreuses séances au fil du temps.

Les capteurs et les mesures

Nous disposons d’un parc de capteurs (GPS, cardiofréquencemètres, centrales inertielles, etc.). Chaque capteur a un numéro de série, un type, un modèle et une date de dernier étalonnage.
Pendant une séance, chaque athlète porte un ou plusieurs capteurs. Un même capteur peut être porté par des athlètes différents lors de séances différentes, mais jamais par deux athlètes en même temps.
À la fin de chaque séance, on obtient pour chaque athlète un bilan de performance : distance totale parcourue (en mètres), vitesse maximale (en km/h), fréquence cardiaque moyenne et maximale (en battements par minute) et charge d’entraînement (une valeur calculée qui résume l’effort fourni).
Ce bilan est propre à un athlète pour une séance donnée. S’il n’a pas porté de capteur, il n’a pas de bilan.

Les tests physiques

Lors d’une séance de type test, l’athlète passe un ou plusieurs tests physiques (sprint de 30 m, saut vertical, test d’endurance, etc.). Chaque test a un nom.
Pour chaque test passé, on enregistre le résultat obtenu et son unité (secondes, centimètres, etc.). Un même test peut être passé par de nombreux athlètes, à des dates différentes.

Les blessures

On conserve l’historique des blessures de chaque athlète. Une blessure a une date, une zone du corps touchée (genou, cuisse, cheville, etc.) et un niveau de gravité (légère, modérée, grave).
Une blessure concerne un seul athlète, mais un athlète peut avoir eu plusieurs blessures, y compris au même endroit. Quand il est rétabli, on note sa date de reprise. Tant qu’il n’a pas repris, elle reste vide.
Une blessure peut survenir pendant une séance (compétition ou entraînement) ou en dehors.

Le personnel

Des intervenants (préparateurs physiques, analystes de données, médecins du sport, etc.) encadrent les séances et suivent les blessures. Chacun a un nom et une fonction.
Une séance est encadrée par au moins un intervenant. Un intervenant encadre plusieurs séances.
Chaque blessure est suivie par un intervenant (le médecin ou le kinésithérapeute qui s’en occupe).
2. Dictionnaire de données (34 données)
N°	Signification de la donnée	Type	Taille
1	Numéro de licence de l’athlète	Alphanumérique	10
2	Nom de l’athlète	Alphabétique	30
3	Prénom de l’athlète	Alphabétique	30
4	Date de naissance de l’athlète	Date (JJ/MM/AAAA)	10
5	Sexe de l’athlète (F/M)	Alphabétique	1
6	Taille de l’athlète (en cm)	Numérique entier	3
7	Nom de la discipline	Alphabétique	40
8	Mode de pratique de la discipline (individuel / collectif)	Alphabétique	10
9	Nom de l’équipe	Alphanumérique	50
10	Poste occupé par l’athlète dans l’équipe	Alphabétique	30
11	Date d’arrivée de l’athlète dans l’équipe	Date (JJ/MM/AAAA)	10
12	Numéro de série du capteur	Alphanumérique	12
13	Type de capteur (GPS, cardiofréquencemètre, centrale inertielle…)	Alphabétique	30
14	Modèle du capteur	Alphanumérique	40
15	Date du dernier étalonnage du capteur	Date (JJ/MM/AAAA)	10
16	Code de la séance	Alphanumérique	8
17	Date et heure de début de la séance	Date et heure (JJ/MM/AAAA HH:MM)	16
18	Durée de la séance (en minutes)	Numérique entier	3
19	Type de séance (entraînement / test / compétition)	Alphabétique	15
20	Nom du lieu de la séance	Alphanumérique	50
21	Distance totale parcourue (en mètres)	Numérique entier	6
22	Vitesse maximale atteinte (en km/h)	Numérique décimal	4 (ex. 34,5)
23	Fréquence cardiaque moyenne (en bpm)	Numérique entier	3
24	Fréquence cardiaque maximale (en bpm)	Numérique entier	3
25	Charge d’entraînement (valeur calculée)	Numérique décimal	6 (ex. 452,3)
26	Nom du test physique	Alphanumérique	40
27	Résultat obtenu au test	Numérique décimal	6 (ex. 12,45)
28	Unité du résultat du test (s, cm, m, kg…)	Alphanumérique	10
29	Date de la blessure	Date (JJ/MM/AAAA)	10
30	Zone du corps touchée par la blessure	Alphabétique	40
31	Gravité de la blessure (légère / modérée / grave)	Alphabétique	10
32	Date de reprise de l’entraînement après blessure	Date (JJ/MM/AAAA)	10
33	Nom de l’intervenant	Alphabétique	30
34	Fonction de l’intervenant (préparateur physique, médecin, analyste…)	Alphabétique	40

Remarques pour la suite de la conception

Les formats de dates, la précision des décimales et les valeurs possibles indiquées entre parenthèses sont des contraintes fournies par l’entreprise.
Aucun regroupement de ces données n’est imposé. C’est à toi de décider comment les organiser, quels identifiants retenir et comment les relier.
Pense aux données propres à un lien entre deux éléments plutôt qu’à un seul (résultat d’un athlète à un test, bilan d’un athlète lors d’une séance, date d’arrivée dans une équipe).

Fichier de la réponse renvoyé par l'IA [réponse renvoyé par l'IA.pdf](https://github.com/user-attachments/files/33536693/reponse.renvoye.par.l.IA.pdf)

L’IAG nous renvoyer le nombre de données attendues, et correspondant aux exigences formulées dans notre prompt, nous avons donc décider de ne pas y apporter de modifications.








