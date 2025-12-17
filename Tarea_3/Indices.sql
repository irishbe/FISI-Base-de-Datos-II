-- Indices tabla Director
CREATE INDEX IDX_Director_name ON Director(name);
CREATE INDEX IDX_Director_last_name ON Director(last_name);

-- Indices tabla Cyclist
CREATE INDEX IDX_Cyclist_id_nationality ON Cyclist(id_nationality);
CREATE INDEX IDX_Cyclist_name ON Cyclist(name);
CREATE INDEX IDX_Cyclist_last_name ON Cyclist(last_name);

-- Indices tabla Team
CREATE INDEX IDX_Team_id_nationality ON Team(id_nationality);
CREATE INDEX IDX_Team_name ON Team(name);

-- Indices tabla Race
CREATE INDEX IDX_Race_id_winning_cyclist ON Race(id_winning_cyclist);
CREATE INDEX IDX_Race_edition_year ON Race(edition_year);
CREATE INDEX IDX_Race_winner_year ON Race(id_winning_cyclist, edition_year);

-- Indices tabla Team_Race
CREATE INDEX IDX_Team_Race_id_team ON Team_Race(id_team);
CREATE INDEX IDX_Team_Race_id_race ON Team_Race(id_race);
CREATE INDEX IDX_Team_Race_final_position ON Team_Race(final_position);

-- Indices tabla Director_Assignment
CREATE INDEX IDX_Director_Assignment_id_team ON Director_Assignment(id_team);
CREATE INDEX IDX_Director_Assignment_id_director ON Director_Assignment(id_director);
CREATE INDEX IDX_Director_Assignment_dates ON Director_Assignment(start_date, end_date);

-- Indices tabla Contract
CREATE INDEX IDX_Contract_id_cyclist ON Contract(id_cyclist);
CREATE INDEX IDX_Contract_id_team ON Contract(id_team);
CREATE INDEX IDX_Contract_dates ON Contract(start_date, end_date);
CREATE INDEX IDX_Contract_cyclist_team ON Contract(id_cyclist, id_team);