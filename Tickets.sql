IF OBJECT_ID(N'[__EFMigrationsHistory]') IS NULL
BEGIN
    CREATE TABLE [__EFMigrationsHistory] (
        [MigrationId] nvarchar(150) NOT NULL,
        [ProductVersion] nvarchar(32) NOT NULL,
        CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY ([MigrationId])
    );
END;
GO

BEGIN TRANSACTION;
GO

CREATE TABLE [Tickets] (
    [Id] int NOT NULL IDENTITY,
    [Title] nvarchar(200) NOT NULL,
    [Description] nvarchar(2000) NOT NULL,
    [Priority] nvarchar(max) NOT NULL,
    [Status] nvarchar(450) NOT NULL,
    [CreatedAt] datetime2 NOT NULL,
    [ResolvedAt] datetime2 NULL,
    CONSTRAINT [PK_Tickets] PRIMARY KEY ([Id])
);
GO

CREATE INDEX [IX_Tickets_CreatedAt] ON [Tickets] ([CreatedAt]);
GO

CREATE INDEX [IX_Tickets_Status] ON [Tickets] ([Status]);
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20260613154215_Ticket', N'8.0.21');
GO

COMMIT;
GO
-- Get all tickts by prority
SELECT Priority, COUNT(*) AS TicketCount
FROM Tickets
GROUP BY Priority
ORDER BY TicketCount DESC;
--most recent tickets
SELECT TOP 5 *
FROM Tickets
ORDER BY CreatedAt DESC;
 -- get all
 select * from Tickets