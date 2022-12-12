--Tablice
--1
CREATE TABLE Podrucja(
	Id SERIAL PRIMARY KEY,
	Name VARCHAR(30) NOT NULL
)

CREATE TABLE Clan(
	Id SERIAL PRIMARY KEY,
	FirstName VARCHAR(30) NOT NULL,
	LastName VARCHAR(30) NOT NULL,
	Oib VARCHAR(11),
	BirthDate TIMESTAMP NOT NULL,
	Rod VARCHAR(1) NOT NULL,
	ResidenceCity VARCHAR(30) NOT NULL,
	PodrucjeId INT REFERENCES Podrucja(Id)
)

--2
CREATE TABLE Predavanja(
	Id SERIAL PRIMARY KEY,
	Name VARCHAR(30) NOT NULL,
	PodrucjeID INT REFERENCES Podrucja(Id),
	ClanId INT REFERENCES Clan(Id)
)

CREATE TABLE Pripravnici(
	Id SERIAL PRIMARY KEY,
	FirstName VARCHAR(30) NOT NULL,
	LastName VARCHAR(30) NOT NULL,
	Oib VARCHAR(11),
	BirthDate TIMESTAMP NOT NULL,
	Rod VARCHAR(1) NOT NULL,
	ResidenceCity VARCHAR(30) NOT NULL
)


CREATE TABLE Internship(
	Id SERIAL PRIMARY KEY,
	BeginDate TIMESTAMP,
	EndDate TIMESTAMP,
	PodrucjeId INT REFERENCES Podrucja(Id)
)


--3
CREATE TABLE PripravnikPodrucje(
	PripravnikId INT REFERENCES Pripravnici(Id),
	PodrucjeId INT REFERENCES Podrucja(Id),
	PRIMARY KEY(PripravnikId,PodrucjeId)
)

CREATE TABLE PripravnikPredavanje(
	Id SERIAL PRIMARY KEY,
	PripravnikId INT REFERENCES Pripravnici(Id),
	PredavanjeId INT REFERENCES Predavanja(Id)
)

CREATE TABLE VoditeljProjekta(
	InternshipId INT REFERENCES Internship(Id),
	ClanId INT REFERENCES Clan(Id),
	PRIMARY KEY(InternshipId,ClanId)
)

--4
CREATE TABLE Domaci(
	Id SERIAL PRIMARY KEY,
	Ocjena INT NOT NULL,
	PripravnikPredavanjeId INT REFERENCES PripravnikPredavanje(Id),
	ClanId INT REFERENCES Clan(Id)
)

--restrikcije
alter table Projekti
	add column TrenutnaFaza VARCHAR CHECK(TrenutnaFaza in ('u pripremi', 'u tijeku', 'zavrsen'))

alter table PripravnikPodrucje
	add column Status varchar check(Status in ('pripravnik','izbacen','zavrsen internship'))

alter table Pripravnici
	add constraint Age check((DATE_PART('year', NOW()) - DATE_PART('year', BirthDate))>=16 and (DATE_PART('year', NOW()) - DATE_PART('year', BirthDate))<=24)

alter table Domaci
	add constraint Grades check(Ocjena in(1,2,3,4,5))

ALTER TABLE Pripravnici
	ADD CONSTRAINT OibLength CHECK(LENGTH(Oib)=11)
	
ALTER TABLE Clan
	ADD CONSTRAINT OibLength CHECK(LENGTH(Oib)=11)
	
alter table Pripravnici
	add constraint Gender check(lower(Rod) in ('m','z'))
	
alter table Clan
	add constraint Gender check(lower(Rod) in ('m','z'))

--testni podaci
insert into Podrucja(Name) values
('Programiranje'),
('Marketing'),
('Dizajn'),
('Multimedija')

select * from Podrucja

insert into Clan(FirstName,LastName,Oib,BirthDate,Rod,ResidenceCity,PodrucjeId) values
('Ana','Pin','12312312312','2002-3-3','z','Split',3),
('Ante','Antic','12121212123','1997-1-1','m','Split',1),
('Ivo','Ivic','13131313123','2000-2-2','m','Omis',2)

select * from Clan

insert into Predavanja(Name,PodrucjeId,ClanId) values
('Prvo predavanje',1,1),
('Prvo predavanje',2,2)

insert into Pripravnici(FirstName,LastName,Oib,BirthDate,Rod,ResidenceCity) values
('Ana','Antic','12312312312','2002-3-3','z','Split'),
('Ante','Horvat','12121212123','2005-1-1','m','Split'),
('Marija','Ivic','13131313123','2000-2-2','z','Omis')


insert into PripravnikPodrucje(PripravnikId,PodrucjeId,status) values
(2,3,'pripravnik'),
(2,1,'izbacen'),
(3,1,'pripravnik')

--ispis
--1)
SELECT FirstName as Ime, LastName as Prezime FROM Pripravnici
	WHERE ResidenceCity NOT LIKE 'Split'
	
--2)
SELECT BeginDate, EndDate FROM Internship
	ORDER BY BeginDate DESC
	
--4)
SELECT COUNT(*) FROM Pripravnici
	WHERE LOWER(PodrucjeId)='programiranje' and LOWER(Rod)='z'
	
--5)
SELECT Count(*) as BrojIzbacenih FROM PripravnikPodrucje pp
	where lower(pp.status)='izbacen'
	
--6)
UPDATE Clan
	SET ResidenceCity='Moskva'
	WHERE LastName LIKE '%in'

--7)
DELETE FROM Clan
	WHERE (DATE_PART('year', NOW()) - DATE_PART('year', BirthDate))>25
	
--8)
DELETE FROM Pripravnici p
	where (select avg(ocjena) from Domaci where PripravnikId=p.Id)<2.4