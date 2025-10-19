-- Hämta moon_mission
SELECT *
FROM moon_mission;

-- Hämta successful_mission
SELECT *
FROM successful_mission;

-- Hämta alla account
SELECT *
FROM account;

-- Hämta all data från båda tabeller
SELECT *
FROM moon_mission, successful_mission;

/*    Uppgift 1
Använd ”CREATE TABLE..AS SELECT” för att ta ut alla kolumner för alla lyckade uppdrag
(Successful outcome) i “moonmission” och sätt in i en ny tabell med namn ”successful_mission”. */
CREATE TABLE successful_mission AS
SELECT *
FROM moon_mission
WHERE moon_mission.outcome = 'Successful';

/*    Uppgift 2
Skriv en query som ändrar tabellen “successful_mission” så att kolumnen “mission_id” blir en
primärnyckel och auto inkrementerar. Ta inte bort tabellen och skapa den på nytt, enbart
egenskaperna för mission_id ska ändras. */
ALTER TABLE successful_mission ADD PRIMARY KEY (mission_id);
ALTER TABLE successful_mission MODIFY mission_id INT NOT NULL AUTO_INCREMENT;


/*    Uppgift 3
I kolumnen ‘operator’ har det smugit sig in ett eller flera mellanslag i operatörens namn. Skriv
queries som uppdaterar och tar bort mellanslagen kring operatören för både “successful_mission”
och “moon_missions”. */
UPDATE moon_mission
SET operator = REPLACE(operator, ' ', '');

UPDATE successful_mission
SET operator = REPLACE(operator, ' ', '');


/*    Uppgift 4
Skriv en query som tar bort alla uppdrag utförda 2010 eller senare från “successful_mission”. */
DELETE FROM successful_mission
WHERE launch_date >= '2010-01-01';


/*    Uppgift 5
Gör en SELECT för att ta ut samtliga rader och kolumner från tabellen “account”, men slå ihop
‘first_name’ och ‘last_name’ till en ny kolumn ‘name’, samt lägg till en extra kolumn ‘gender’ som
du ger värdet ‘female’ för alla användare vars näst sista siffra i personnumret är jämn, och värdet
‘male’ för de användare där siffran är udda. */
SELECT
    *,
    CONCAT(first_name, ' ', last_name) AS name,
    CASE
        WHEN CAST(SUBSTRING(ssn, -2, 1) AS UNSIGNED) % 2 = 0 THEN 'female'
        ELSE 'male'
        END AS gender
FROM account;

/*    Uppgift 6
Skriv en query som tar bort alla kvinnor födda före 1970. */
DELETE FROM account
WHERE
    CAST(SUBSTRING(ssn, 1, 2) AS UNSIGNED) < 70
  AND CAST(SUBSTRING(ssn, -2, 1) AS UNSIGNED) % 2 = 0;

/*    Uppgift 7
Skriv en query som returnerar två kolumner ‘gender’ och ‘average_age’, och två rader där ena
visar medelåldern för män, och den andra medelåldern för kvinnor för alla användare i tabellen
‘account’. */
SELECT IF(
               (CAST(SUBSTRING(REPLACE(ssn, '-', ''), LENGTH(REPLACE(ssn, '-', '')) - 1, 1) AS UNSIGNED) % 2) = 0,
               'female',
               'male'
       ) AS gender,
       ROUND(AVG(
                     TIMESTAMPDIFF(
                         YEAR,
                             STR_TO_DATE(
                                     CASE
                                         WHEN CAST(SUBSTRING(REPLACE(ssn, '-', ''), 1, 2) AS UNSIGNED) <=
                                         RIGHT(YEAR(CURDATE()), 2)
                                         THEN CONCAT('20', SUBSTRING(REPLACE(ssn, '-', ''), 1, 6))
                                         ELSE CONCAT('19', SUBSTRING(REPLACE(ssn, '-', ''), 1, 6))
                                         END,
                                     '%Y%m%d'
                             ), CURDATE())
             ), 1) AS average_age
FROM account
GROUP BY gender;