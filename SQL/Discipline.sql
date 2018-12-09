-----Discipline

IF OBJECT_ID('dbo.DisciplineSelect') IS NOT NULL
BEGIN 
    DROP PROC dbo.DisciplineSelect 
END 
GO

CREATE PROC dbo.DisciplineSelect
    @short_name NVARCHAR(10)
AS 
	SET XACT_ABORT, NOCOUNT ON;
	SELECT id_disc, short_name, full_name, link  
	FROM   dbo.Discipline
	WHERE  (LOWER(short_name) like('%'+ LOWER(@short_name) + '%') OR @short_name IS NULL); 
GO

exec DisciplineSelect null;
------------------------------------------------------------

IF OBJECT_ID('dbo.DisciplineInsert') IS NOT NULL
BEGIN 
    DROP PROC dbo.DisciplineInsert 
END 
GO

CREATE PROC dbo.DisciplineInsert 
	@short_name NVARCHAR(10),
	@full_name NVARCHAR(50),
	@link NVARCHAR(500)
AS 
BEGIN TRY
	SET XACT_ABORT, NOCOUNT ON;
	BEGIN TRAN;
		INSERT INTO  dbo.Discipline ( short_name, full_name, link)
				VALUES( @short_name, @full_name, @link );
	COMMIT;
		SELECT id_disc, short_name, full_name, link
		FROM   dbo.Discipline
		WHERE  id_disc= SCOPE_IDENTITY();
END TRY
BEGIN CATCH
	ROLLBACK;
	SELECT ERROR_NUMBER() AS ErrorNumber,ERROR_MESSAGE() AS ErrorMessage;
END CATCH
GO
exec DisciplineInsert 'БД', 'Базы данных', 'https://isit.belstu.by/uchebnaya-rabota/discipliny/bd.html';
------------------------------------------------------------------------------

IF OBJECT_ID('dbo.DisciplineUpdate') IS NOT NULL
BEGIN 
    DROP PROC dbo.DisciplineUpdate
END 
GO

CREATE PROC dbo.DisciplineUpdate 
	@id INT,
	@short_name NVARCHAR(10),
	@full_name NVARCHAR(50),
	@link NVARCHAR(500)
AS 
BEGIN TRY
	SET XACT_ABORT, NOCOUNT ON;
	BEGIN TRAN;
		UPDATE dbo.Discipline
		SET    short_name = @short_name, full_name = @full_name, link = @link
		WHERE  id_disc = @id;
	COMMIT;
		SELECT id_disc, short_name, full_name, link
		FROM   dbo.Discipline
		WHERE  id_disc = @id;	
END TRY
BEGIN CATCH
	ROLLBACK;
	SELECT ERROR_NUMBER() AS ErrorNumber,ERROR_MESSAGE() AS ErrorMessage;
END CATCH	
GO
----------------------------------------------------

IF OBJECT_ID('dbo.DisciplineDelete') IS NOT NULL
BEGIN 
    DROP PROC dbo.DisciplineDelete
END 
GO

CREATE PROC dbo.DisciplineDelete 
   @id INT
AS 
BEGIN TRY
	SET XACT_ABORT, NOCOUNT ON;
	BEGIN TRAN;
		DELETE
		FROM  dbo.Discipline
		WHERE  id_disc = @id;
	COMMIT;
END TRY
BEGIN CATCH
	ROLLBACK;
	SELECT ERROR_NUMBER() AS ErrorNumber,ERROR_MESSAGE() AS ErrorMessage;
END CATCH	
GO