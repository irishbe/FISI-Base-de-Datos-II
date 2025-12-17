CREATE TABLESPACE tarea_siete
DATAFILE 'tarea_siete.dbf'
SIZE 10M
AUTOEXTEND ON
NEXT 5M
MAXSIZE 20M;

-- CREACIÓN DE TABLAS

-- Tabla S (Suppliers)
CREATE TABLE "S" (
  "S#" CHAR(2) PRIMARY KEY,
  "SNAME" VARCHAR2(20) NOT NULL,
  "STATUS" NUMBER,
  "CITY" VARCHAR2(20) NOT NULL
)
TABLESPACE tarea_siete;

INSERT INTO "S" ("S#","SNAME","STATUS","CITY") VALUES ('S1','Smith',20,'London');
INSERT INTO "S" ("S#","SNAME","STATUS","CITY") VALUES ('S2','Jones',10,'Paris');
INSERT INTO "S" ("S#","SNAME","STATUS","CITY") VALUES ('S3','Blake',30,'Paris');
INSERT INTO "S" ("S#","SNAME","STATUS","CITY") VALUES ('S4','Clark',20,'London');
INSERT INTO "S" ("S#","SNAME","STATUS","CITY") VALUES ('S5','Adams',30,'Athens');

-- Tabla P (Parts)
CREATE TABLE "P" (
  "P#" CHAR(2) PRIMARY KEY,
  "PNAME" VARCHAR2(20) NOT NULL,
  "COLOR" VARCHAR2(10) NOT NULL,
  "WEIGHT" NUMBER(5,2),
  "CITY" VARCHAR2(20) NOT NULL
)
TABLESPACE tarea_siete;

INSERT INTO "P" ("P#","PNAME","COLOR","WEIGHT","CITY") VALUES ('P1','Nut','Red',12,'London');
INSERT INTO "P" ("P#","PNAME","COLOR","WEIGHT","CITY") VALUES ('P2','Bolt','Green',17,'Paris');
INSERT INTO "P" ("P#","PNAME","COLOR","WEIGHT","CITY") VALUES ('P3','Screw','Blue',17,'Rome');
INSERT INTO "P" ("P#","PNAME","COLOR","WEIGHT","CITY") VALUES ('P4','Screw','Red',14,'London');
INSERT INTO "P" ("P#","PNAME","COLOR","WEIGHT","CITY") VALUES ('P5','Cam','Blue',12,'Paris');
INSERT INTO "P" ("P#","PNAME","COLOR","WEIGHT","CITY") VALUES ('P6','Cog','Red',19,'London');

-- Tabla J (Projects)
CREATE TABLE "J" (
  "J#" CHAR(2) PRIMARY KEY,
  "JNAME" VARCHAR2(20) NOT NULL,
  "CITY" VARCHAR2(20) NOT NULL
)
TABLESPACE tarea_siete;

INSERT INTO "J" ("J#","JNAME","CITY") VALUES ('J1','Sorter','Paris');
INSERT INTO "J" ("J#","JNAME","CITY") VALUES ('J2','Display','Rome');
INSERT INTO "J" ("J#","JNAME","CITY") VALUES ('J3','OCR','Athens');
INSERT INTO "J" ("J#","JNAME","CITY") VALUES ('J4','Console','Athens');
INSERT INTO "J" ("J#","JNAME","CITY") VALUES ('J5','RAID','London');
INSERT INTO "J" ("J#","JNAME","CITY") VALUES ('J6','EDS','Oslo');
INSERT INTO "J" ("J#","JNAME","CITY") VALUES ('J7','Tape','London');

-- Tabla SP (Shipments entre S y P)
CREATE TABLE "SP" (
  "S#" CHAR(2) NOT NULL,
  "P#" CHAR(2) NOT NULL,
  "QTY" NUMBER NOT NULL,
  CONSTRAINT "PK_SP" PRIMARY KEY ("S#","P#"),
  CONSTRAINT "FK_SP_S" FOREIGN KEY ("S#") REFERENCES "S"("S#"),
  CONSTRAINT "FK_SP_P" FOREIGN KEY ("P#") REFERENCES "P"("P#")
)
TABLESPACE tarea_siete;

INSERT INTO "SP" ("S#","P#","QTY") VALUES ('S1','P1',300);
INSERT INTO "SP" ("S#","P#","QTY") VALUES ('S1','P2',200);
INSERT INTO "SP" ("S#","P#","QTY") VALUES ('S1','P3',400);
INSERT INTO "SP" ("S#","P#","QTY") VALUES ('S1','P4',200);
INSERT INTO "SP" ("S#","P#","QTY") VALUES ('S1','P5',100);
INSERT INTO "SP" ("S#","P#","QTY") VALUES ('S1','P6',100);
INSERT INTO "SP" ("S#","P#","QTY") VALUES ('S2','P1',300);
INSERT INTO "SP" ("S#","P#","QTY") VALUES ('S2','P2',400);
INSERT INTO "SP" ("S#","P#","QTY") VALUES ('S3','P2',200);
INSERT INTO "SP" ("S#","P#","QTY") VALUES ('S4','P2',200);
INSERT INTO "SP" ("S#","P#","QTY") VALUES ('S4','P4',300);
INSERT INTO "SP" ("S#","P#","QTY") VALUES ('S4','P5',400);

-- Tabla SPJ (Shipments a Proyectos)
CREATE TABLE "SPJ" (
  "S#" CHAR(2) NOT NULL,
  "P#" CHAR(2) NOT NULL,
  "J#" CHAR(2) NOT NULL,
  "QTY" NUMBER NOT NULL,
  CONSTRAINT "PK_SPJ" PRIMARY KEY ("S#","P#","J#"),
  CONSTRAINT "FK_SPJ_S" FOREIGN KEY ("S#") REFERENCES "S"("S#"),
  CONSTRAINT "FK_SPJ_P" FOREIGN KEY ("P#") REFERENCES "P"("P#"),
  CONSTRAINT "FK_SPJ_J" FOREIGN KEY ("J#") REFERENCES "J"("J#")
)
TABLESPACE tarea_siete;

INSERT INTO "SPJ" ("S#","P#","J#","QTY") VALUES ('S1','P1','J1',200);
INSERT INTO "SPJ" ("S#","P#","J#","QTY") VALUES ('S1','P1','J4',700);
INSERT INTO "SPJ" ("S#","P#","J#","QTY") VALUES ('S2','P3','J1',400);
INSERT INTO "SPJ" ("S#","P#","J#","QTY") VALUES ('S2','P3','J2',200);
INSERT INTO "SPJ" ("S#","P#","J#","QTY") VALUES ('S2','P3','J3',200);
INSERT INTO "SPJ" ("S#","P#","J#","QTY") VALUES ('S2','P3','J4',500);
INSERT INTO "SPJ" ("S#","P#","J#","QTY") VALUES ('S2','P3','J5',600);
INSERT INTO "SPJ" ("S#","P#","J#","QTY") VALUES ('S2','P3','J6',400);
INSERT INTO "SPJ" ("S#","P#","J#","QTY") VALUES ('S2','P3','J7',800);
INSERT INTO "SPJ" ("S#","P#","J#","QTY") VALUES ('S2','P5','J2',100);
INSERT INTO "SPJ" ("S#","P#","J#","QTY") VALUES ('S3','P3','J1',200);
INSERT INTO "SPJ" ("S#","P#","J#","QTY") VALUES ('S3','P4','J2',500);
INSERT INTO "SPJ" ("S#","P#","J#","QTY") VALUES ('S4','P6','J3',300);
INSERT INTO "SPJ" ("S#","P#","J#","QTY") VALUES ('S4','P6','J7',300);
INSERT INTO "SPJ" ("S#","P#","J#","QTY") VALUES ('S5','P2','J2',200);
INSERT INTO "SPJ" ("S#","P#","J#","QTY") VALUES ('S5','P2','J4',100);
INSERT INTO "SPJ" ("S#","P#","J#","QTY") VALUES ('S5','P5','J5',500);
INSERT INTO "SPJ" ("S#","P#","J#","QTY") VALUES ('S5','P5','J7',100);
INSERT INTO "SPJ" ("S#","P#","J#","QTY") VALUES ('S5','P6','J2',200);
INSERT INTO "SPJ" ("S#","P#","J#","QTY") VALUES ('S5','P1','J4',100);
INSERT INTO "SPJ" ("S#","P#","J#","QTY") VALUES ('S5','P3','J4',200);
INSERT INTO "SPJ" ("S#","P#","J#","QTY") VALUES ('S5','P4','J4',800);
INSERT INTO "SPJ" ("S#","P#","J#","QTY") VALUES ('S5','P5','J4',400);
INSERT INTO "SPJ" ("S#","P#","J#","QTY") VALUES ('S5','P6','J4',500);

COMMIT;
