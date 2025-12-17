-- Consultar todos los ciclistas y sus nacionalidades
SELECT c.name AS first_name, c.last_name AS last_name, n.name AS nationality
FROM Cyclist c
JOIN Nationality n ON c.id_nationality = n.id_nationality;

-- Consultar los equipos y sus directores
SELECT t.name AS team, d.name AS director_first_name, d.last_name AS director_last_name
FROM Team t
JOIN Director_Assignment da ON t.id_team = da.id_team
JOIN Director d ON da.id_director = d.id_director;

-- Consultar las carreras y el ciclista ganador
SELECT r.name AS race, r.edition_year, c.name AS winner_first_name, c.last_name AS winner_last_name
FROM Race r
JOIN Cyclist c ON r.id_winning_cyclist = c.id_cyclist;

-- Consultar los contratos vigentes (end_date NULL o mayor a SYSDATE)
SELECT c.name AS cyclist_first_name, c.last_name AS cyclist_last_name, 
       t.name AS team, ct.start_date, ct.end_date
FROM Contract ct
JOIN Cyclist c ON ct.id_cyclist = c.id_cyclist
JOIN Team t ON ct.id_team = t.id_team
WHERE ct.end_date IS NULL OR ct.end_date > SYSDATE;

-- Consultar posiciones finales de equipos en cada carrera
SELECT r.name AS race, r.edition_year, t.name AS team, tr.final_position
FROM Team_Race tr
JOIN Team t ON tr.id_team = t.id_team
JOIN Race r ON tr.id_race = r.id_race
ORDER BY r.edition_year DESC, tr.final_position ASC;