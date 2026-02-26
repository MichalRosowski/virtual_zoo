CREATE TABLE Gatunki (
  GatunekID INT AUTO_INCREMENT PRIMARY KEY,
  Nazwa VARCHAR(50) NOT NULL,
  Rodzina VARCHAR(50),
  StatusOchrony ENUM('brak', 'zagrożony', 'krytycznie zagrożony') DEFAULT 'brak'
);

CREATE TABLE Habitaty (
  HabitatID INT AUTO_INCREMENT PRIMARY KEY,
  Nazwa VARCHAR(50) NOT NULL,
  TypSrodowiska VARCHAR(50),
  Powierzchnia DECIMAL(8,2)
);

CREATE TABLE Zwierzeta (
  ZwierzeID INT AUTO_INCREMENT PRIMARY KEY,
  GatunekID INT,
  Imie VARCHAR(50),
  Wiek INT,
  Plec ENUM('M', 'F'),
  Waga DECIMAL(6,2),
  DataPrzybycia DATE,
  OstatnieKarmienie DATETIME,
  HabitatID INT,
  FOREIGN KEY (GatunekID) REFERENCES Gatunki(GatunekID),
  FOREIGN KEY (HabitatID) REFERENCES Habitaty(HabitatID)
);

CREATE TABLE Pracownicy (
  PracownikID INT AUTO_INCREMENT PRIMARY KEY,
  Imie VARCHAR(50) NOT NULL,
  Nazwisko VARCHAR(50) NOT NULL,
  Stanowisko VARCHAR(50),
  HabitatID INT,
  FOREIGN KEY (HabitatID) REFERENCES Habitaty(HabitatID)
);

CREATE TABLE Bilety (
  BiletID INT AUTO_INCREMENT PRIMARY KEY,
  Typ VARCHAR(20),
  CenaBazowa DECIMAL(5,2)
);

CREATE TABLE Zamowienia (
  ZamowienieID INT AUTO_INCREMENT PRIMARY KEY,
  DataZamowienia DATE,
  BiletID INT,
  LiczbaSztuk INT,
  KwotaCalkowita DECIMAL(10,2),
  FOREIGN KEY (BiletID) REFERENCES Bilety(BiletID)
);

CREATE TABLE LogiSystemowe (
  LogID INT AUTO_INCREMENT PRIMARY KEY,
  Opis TEXT,
  DataLogowania DATETIME
);

CREATE TABLE Karmienie (
  KarmienieID INT AUTO_INCREMENT PRIMARY KEY,
  DataKarmienia DATETIME,
  ZwierzeID INT,
  PracownikID INT,
  FOREIGN KEY (ZwierzeID) REFERENCES Zwierzeta(ZwierzeID),
  FOREIGN KEY (PracownikID) REFERENCES Pracownicy(PracownikID)
);

CREATE TABLE Wydarzenia (
  WydarzenieID INT AUTO_INCREMENT PRIMARY KEY,
  Nazwa VARCHAR(100),
  DataPoczatku DATE,
  DataKonca DATE,
  Opis TEXT
);

-- 2. DANE

INSERT INTO Gatunki (Nazwa, Rodzina, StatusOchrony) VALUES 
('Tygrys Bengalski', 'Kotowate', 'zagrożony'),
('Słoń Afrykański', 'Słoniowate', 'krytycznie zagrożony'),
('Pingwin Cesarski', 'Pingwinowate', 'brak');

INSERT INTO Habitaty (Nazwa, TypSrodowiska, Powierzchnia) VALUES
('Sawanna', 'Tropikalne', 1500.00),
('Lodowa Kraina', 'Polarne', 5000.00);

INSERT INTO Zwierzeta (GatunekID, Imie, Wiek, Plec, Waga, DataPrzybycia, HabitatID) VALUES
(1, 'Shera', 5, 'F', 210.50, '2021-05-10', 1),
(2, 'Dumbo', 8, 'M', 5000.00, '2020-03-12', 1),
(3, 'Pingu', 3, 'M', 30.00, '2022-01-20', 2);

INSERT INTO Pracownicy (Imie, Nazwisko, Stanowisko, HabitatID) VALUES 
('Jan', 'Kowalski', 'Opiekun', 1);

INSERT INTO Bilety (Typ, CenaBazowa) VALUES
('Normalny', 50.00),
('Ulgowy', 30.00),
('Rodzinny', 120.00);

-- 3. FUNKCJE I TRIGGERY (OneCompiler obsługuje DELIMITER poprawnie)

DELIMITER //

CREATE FUNCTION ObliczCeneBiletu(TypBiletu VARCHAR(20), CenaStandardowa DECIMAL(5,2), DataSprzedazy DATE) 
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
  DECLARE CenaFinalna DECIMAL(5,2);
  SET CenaFinalna = CenaStandardowa;

  IF MONTH(DataSprzedazy) = 6 AND TypBiletu = 'Ulgowy' THEN
    SET CenaFinalna = CenaStandardowa * 0.5;
  END IF;

  RETURN CenaFinalna;
END //

CREATE TRIGGER PrzedWstawieniemZamowienia
BEFORE INSERT ON Zamowienia
FOR EACH ROW
BEGIN
  DECLARE CenaJednostkowa DECIMAL(5,2);
  DECLARE TypB VARCHAR(20);

  SELECT CenaBazowa, Typ INTO CenaJednostkowa, TypB 
  FROM Bilety WHERE BiletID = NEW.BiletID;

  SET CenaJednostkowa = ObliczCeneBiletu(TypB, CenaJednostkowa, NEW.DataZamowienia);

  SET NEW.KwotaCalkowita = CenaJednostkowa * NEW.LiczbaSztuk;
END //

CREATE TRIGGER PoKarmieniu
AFTER INSERT ON Karmienie
FOR EACH ROW
BEGIN
  UPDATE Zwierzeta 
  SET OstatnieKarmienie = NEW.DataKarmienia 
  WHERE ZwierzeID = NEW.ZwierzeID;

  INSERT INTO LogiSystemowe (Opis, DataLogowania)
  VALUES (CONCAT('Narmiono zwierze ID: ', NEW.ZwierzeID), NOW());
END //

CREATE FUNCTION DochodZoo(DataOd DATE, DataDo DATE)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
  DECLARE Dochod DECIMAL(10,2);
  
  SELECT SUM(KwotaCalkowita) INTO Dochod
  FROM Zamowienia
  WHERE DataZamowienia BETWEEN DataOd AND DataDo;
  
  RETURN IFNULL(Dochod, 0);
END //

DELIMITER ;

-- 4. TESTY

-- Kupujemy bilet ulgowy w CZERWCU (powinna wejść zniżka 50%)
INSERT INTO Zamowienia (DataZamowienia, BiletID, LiczbaSztuk) VALUES ('2023-06-01', 2, 2);

-- Kupujemy bilet normalny w MAJU (cena normalna)
INSERT INTO Zamowienia (DataZamowienia, BiletID, LiczbaSztuk) VALUES ('2023-05-15', 1, 1);

-- Test karmienia (powinno zaktualizować zwierzę i dodać log)
INSERT INTO Karmienie (DataKarmienia, ZwierzeID, PracownikID) VALUES (NOW(), 1, 1);

-- WYNIKI
SELECT '--- ZAMÓWIENIA (Sprawdź ceny) ---' AS Raport;
SELECT * FROM Zamowienia;

SELECT '--- DOCHÓD ZOO ---' AS Raport;
SELECT DochodZoo('2023-01-01', '2023-12-31') AS RocznyDochod;

SELECT '--- LOGI SYSTEMOWE ---' AS Raport;
SELECT * FROM LogiSystemowe;