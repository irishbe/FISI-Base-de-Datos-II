CREATE TABLE Nationality (
  id_nationality NUMBER(9) GENERATED ALWAYS AS IDENTITY,
  name VARCHAR2(50),
  PRIMARY KEY (id_nationality)
) TABLESPACE ts_data_cycling;

CREATE TABLE Director (
  id_director NUMBER(9) GENERATED ALWAYS AS IDENTITY,
  name VARCHAR2(50),
  last_name VARCHAR2(50),
  PRIMARY KEY (id_director)
) TABLESPACE ts_data_cycling;

CREATE TABLE Cyclist (
  id_cyclist NUMBER(9) GENERATED ALWAYS AS IDENTITY,
  id_nationality NUMBER(9),
  name VARCHAR2(50),
  last_name VARCHAR2(50),
  birthday DATE,
  PRIMARY KEY (id_cyclist),
  CONSTRAINT FK_Cyclist_id_nationality
    FOREIGN KEY (id_nationality)
      REFERENCES Nationality(id_nationality)
) TABLESPACE ts_data_cycling;

CREATE TABLE Team (
  id_team NUMBER(9) GENERATED ALWAYS AS IDENTITY,
  id_nationality NUMBER(9),
  name VARCHAR2(100),
  PRIMARY KEY (id_team),
  CONSTRAINT FK_Team_id_nationality
    FOREIGN KEY (id_nationality)
      REFERENCES Nationality(id_nationality)
) TABLESPACE ts_data_cycling;

CREATE TABLE Race (
  id_race NUMBER(9) GENERATED ALWAYS AS IDENTITY,
  id_winning_cyclist NUMBER(9),
  name VARCHAR2(150),
  edition_year NUMBER(4),
  stage_count NUMBER(2),
  total_kilometers NUMBER(8,3),
  PRIMARY KEY (id_race),
  CONSTRAINT FK_Race_id_winning_cyclist
    FOREIGN KEY (id_winning_cyclist)
      REFERENCES Cyclist(id_cyclist)
) TABLESPACE ts_data_cycling;

CREATE TABLE Team_Race (
  id_team NUMBER(9),
  id_race NUMBER(9),
  final_position NUMBER(3),
  PRIMARY KEY (id_team, id_race),
  CONSTRAINT FK_Team_Race_id_team
    FOREIGN KEY (id_team)
      REFERENCES Team(id_team),
  CONSTRAINT FK_Team_Race_id_race
    FOREIGN KEY (id_race)
      REFERENCES Race(id_race)
) TABLESPACE ts_data_cycling;

CREATE TABLE Director_Assignment (
  id_director_assignment NUMBER(9) GENERATED ALWAYS AS IDENTITY,
  id_team NUMBER(9),
  id_director NUMBER(9),
  start_date DATE,
  end_date DATE,
  PRIMARY KEY (id_director_assignment),
  CONSTRAINT FK_Director_Assignment_id_team
    FOREIGN KEY (id_team)
      REFERENCES Team(id_team),
  CONSTRAINT FK_Director_Assignment_id_director
    FOREIGN KEY (id_director)
      REFERENCES Director(id_director)
) TABLESPACE ts_data_cycling;

CREATE TABLE Contract (
  id_contract NUMBER(9) GENERATED ALWAYS AS IDENTITY,
  id_cyclist NUMBER(9),
  id_team NUMBER(9),
  start_date DATE,
  end_date DATE,
  PRIMARY KEY (id_contract),
  CONSTRAINT FK_Contract_id_team
    FOREIGN KEY (id_team)
      REFERENCES Team(id_team),
  CONSTRAINT FK_Contract_id_cyclist
    FOREIGN KEY (id_cyclist)
      REFERENCES Cyclist(id_cyclist)
) TABLESPACE ts_data_cycling;
