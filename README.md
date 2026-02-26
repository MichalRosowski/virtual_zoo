# Virtual Zoo Database System 🦁

A relational database project designed for comprehensive zoo management. 
The system handles key business processes, including ticket sales, animal care monitoring, food logistics, and staff management.

## 🚀 Key Features
* **Relational Architecture:** Optimized database schema (3NF) connecting tables for Species, Habitats, Employees, and Orders.
* **Automation (SQL Triggers):**
  * Automated event logging (e.g., feeding history).
  * Real-time calculation of ticket order totals.
  * Automatic updates for animal statuses and timestamps.
* **Business Logic (Stored Functions):**
  * Dynamic seasonal promotion system (e.g., 50% discount on concession tickets for Children's Day).
  * Revenue reporting within a specified date range.
* **Event Management:** Handling special events and schedules.

## 🛠️ Tech Stack
* **Engine:** MySQL 8.0 / MariaDB
* **Language:** SQL (DDL, DML, DQL, procedural elements)

## 📂 File Structure
* `virtual_zoo.sql` - The main database initialization script. It contains table creation, seed data insertion, and definitions for all stored procedures and triggers. The script is written to be idempotent (using `DROP ... IF EXISTS`), allowing for safe, repeated executions.

## ⚙️ How to Run
The code is compatible with most MySQL environments (e.g., DBeaver, MySQL Workbench) as well as online compilers (e.g., OneCompiler).
Simply import the `.sql` file or copy its contents into your query execution window and run it.

------------------------------------------------------------------------------------

Projekt relacyjnej bazy danych do kompleksowego zarządzania ogrodem zoologicznym. 
System obsługuje kluczowe procesy biznesowe: sprzedaż biletów, opiekę nad zwierzętami, logistykę żywności oraz zarządzanie personelem.

## 🚀 Główne funkcjonalności
* **Architektura Relacyjna:** Zoptymalizowany schemat bazy danych łączący tabele Gatunków, Habitatów, Pracowników i Zamówień.
* **Automatyzacja (SQL Triggers):**
  * Automatyczne logowanie zdarzeń (np. historia karmienia).
  * Przeliczanie wartości koszyka biletowego w czasie rzeczywistym.
  * Aktualizacja statusów i dat dla zwierząt.
* **Logika Biznesowa (Stored Functions):**
  * Dynamiczny system promocji sezonowych (np. 50% zniżki na bilety ulgowe w Dniu Dziecka).
  * Raportowanie dochodów z biletów w zadanym przedziale czasowym.
* **Zarządzanie Eventami:** Obsługa wydarzeń specjalnych i harmonogramów.

## 🛠️ Technologie
* **Silnik:** MySQL 8.0 / MariaDB
* **Język:** SQL (DDL, DML, DQL, elementy proceduralne)

## 📂 Struktura Plików
* `virtual_zoo.sql` - Główny skrypt inicjalizujący bazę. Zawiera tworzenie tabel, wstawianie danych testowych (Seed Data) oraz definicje wszystkich procedur i triggerów. Skrypt jest napisany w sposób idempotentny (używa `DROP ... IF EXISTS`), co pozwala na jego bezpieczne, wielokrotne uruchamianie.

## ⚙️ Jak uruchomić?
Kod jest kompatybilny z większością środowisk MySQL (np. DBeaver, MySQL Workbench) oraz kompilatorami online (np. OneCompiler).
Wystarczy zaimportować plik `.sql` lub skopiować jego zawartość do okna zapytań i uruchomić.

---
**Autor:** [Twoje Imię i Nazwisko]
