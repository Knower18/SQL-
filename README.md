# Helpdesk Database (SQL Server)

SQL Server schema and query scripts for the Helpdesk Ticket Management system, generated via **Entity Framework Core 8** migrations.

## Overview

This script creates the `Tickets` table along with the EF Core migrations history table, plus a set of useful reporting queries.

## Schema

### Tickets Table

| Column      | Type           | Constraints                  |
|-------------|----------------|-------------------------------|
| Id          | int            | Primary Key, Identity (auto-increment) |
| Title       | nvarchar(200)  | NOT NULL                      |
| Description | nvarchar(2000) | NOT NULL                      |
| Priority    | nvarchar(max)  | NOT NULL (`Low`, `Medium`, `High`, `Critical`) |
| Status      | nvarchar(450)  | NOT NULL (`Open`, `InProgress`, `Resolved`, `Closed`) |
| CreatedAt   | datetime2      | NOT NULL                      |
| ResolvedAt  | datetime2      | NULL                           |

### Indexes
- `IX_Tickets_CreatedAt` — speeds up sorting/filtering by creation date
- `IX_Tickets_Status` — speeds up filtering tickets by status

### __EFMigrationsHistory Table
Tracks applied EF Core migrations (`MigrationId`, `ProductVersion`) so the framework knows which migrations have already run.

## How to Run

1. Open the script in **SQL Server Management Studio (SSMS)** or **Azure Data Studio**
2. Connect to your target database
3. Execute the full script — it will:
   - Create `__EFMigrationsHistory` if it doesn't exist
   - Create the `Tickets` table and its indexes inside a transaction
   - Record the migration as applied

> This script is idempotent for the migrations history table (`IF OBJECT_ID ... IS NULL`), but re-running the `CREATE TABLE [Tickets]` section will fail if the table already exists. Drop the table first if you need to recreate it.

## Included Queries

### 1. Ticket count by priority
```sql
SELECT Priority, COUNT(*) AS TicketCount
FROM Tickets
GROUP BY Priority
ORDER BY TicketCount DESC;
```
Returns the number of tickets for each priority level, highest first.

### 2. Five most recent tickets
```sql
SELECT TOP 5 *
FROM Tickets
ORDER BY CreatedAt DESC;
```
Returns the latest 5 tickets created, useful for a dashboard "recent activity" widget.

### 3. Get all tickets
```sql
SELECT * FROM Tickets;
```
Returns every ticket in the table.

## Notes

- This schema is generated from the EF Core `Ticket` entity (see backend repo) using `dotnet ef migrations add` + `dotnet ef database update`.
- `Priority` and `Status` are stored as strings (via EF Core's `HasConversion<string>()`) rather than integers, for readability in raw SQL queries.

## Related Repos
- [Backend API](https://github.com/Knower18/TICKETAPI)
- [Frontend (Angular)](https://github.com/Knower18/helpdesk-frontend)

## License
MIT
