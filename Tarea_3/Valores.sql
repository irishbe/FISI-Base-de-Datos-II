-- Inserciones en Nationality
INSERT INTO Nationality(name) VALUES ('Spain');
INSERT INTO Nationality(name) VALUES ('France');
INSERT INTO Nationality(name) VALUES ('Italy');
INSERT INTO Nationality(name) VALUES ('Colombia');

-- Inserciones en Director
INSERT INTO Director(name, last_name) VALUES ('John', 'Perez');
INSERT INTO Director(name, last_name) VALUES ('Michel', 'Durand');
INSERT INTO Director(name, last_name) VALUES ('Luca', 'Bianchi');

-- Inserciones en Cyclist
INSERT INTO Cyclist(id_nationality, name, last_name, birthday) 
VALUES (1, 'Carlos', 'Martinez', DATE '1990-05-12');
INSERT INTO Cyclist(id_nationality, name, last_name, birthday) 
VALUES (2, 'Pierre', 'Moreau', DATE '1988-09-23');
INSERT INTO Cyclist(id_nationality, name, last_name, birthday) 
VALUES (4, 'Andres', 'Gomez', DATE '1995-02-14');

-- Inserciones en Team
INSERT INTO Team(id_nationality, name) VALUES (1, 'Team Sun');
INSERT INTO Team(id_nationality, name) VALUES (2, 'Team Light');
INSERT INTO Team(id_nationality, name) VALUES (4, 'Colombia Coffee');

-- Inserciones en Race
INSERT INTO Race(id_winning_cyclist, name, edition_year, stage_count, total_kilometers)
VALUES (1, 'Vuelta a España', 2023, 21, 3300.500);
INSERT INTO Race(id_winning_cyclist, name, edition_year, stage_count, total_kilometers)
VALUES (2, 'Tour de France', 2022, 21, 3400.200);
INSERT INTO Race(id_winning_cyclist, name, edition_year, stage_count, total_kilometers)
VALUES (3, 'Giro d Italia', 2023, 21, 3450.700);

-- Inserciones en Team_Race
INSERT INTO Team_Race(id_team, id_race, final_position) VALUES (1, 1, 1);
INSERT INTO Team_Race(id_team, id_race, final_position) VALUES (2, 2, 2);
INSERT INTO Team_Race(id_team, id_race, final_position) VALUES (3, 3, 1);

-- Inserciones en Director_Assignment
INSERT INTO Director_Assignment(id_team, id_director, start_date, end_date)
VALUES (1, 1, DATE '2020-01-01', DATE '2023-12-31');
INSERT INTO Director_Assignment(id_team, id_director, start_date, end_date)
VALUES (2, 2, DATE '2021-01-01', NULL);

-- Inserciones en Contract
INSERT INTO Contract(id_cyclist, id_team, start_date, end_date)
VALUES (1, 1, DATE '2020-01-01', DATE '2022-12-31');
INSERT INTO Contract(id_cyclist, id_team, start_date, end_date)
VALUES (2, 2, DATE '2021-01-01', DATE '2023-12-31');
INSERT INTO Contract(id_cyclist, id_team, start_date, end_date)
VALUES (3, 3, DATE '2022-01-01', NULL);
