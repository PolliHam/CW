-----Pulpit

IF OBJECT_ID('dbo.PulpitSelect') IS NOT NULL
BEGIN 
    DROP PROC dbo.PulpitSelect 
END 
GO

CREATE PROC dbo.PulpitSelect
    @short_name NVARCHAR(10)
AS 
	SET XACT_ABORT, NOCOUNT ON;
		SELECT short_name, full_name, link  
		FROM   dbo.Pulpit
		WHERE  (LOWER(short_name) like('%'+ LOWER(@short_name) + '%') OR @short_name IS NULL);
GO

exec PulpitSelect 'ИсИТ';
------------------------------------------------------------

IF OBJECT_ID('dbo.PulpitInsert') IS NOT NULL
BEGIN 
    DROP PROC dbo.PulpitInsert 
END 
GO

CREATE PROC dbo.PulpitInsert 
	@short_name NVARCHAR(10),
	@full_name NVARCHAR(50),
	@link NVARCHAR(500)
AS 
BEGIN TRY
	SET XACT_ABORT, NOCOUNT ON;
	BEGIN TRAN;
		INSERT INTO  dbo.Pulpit ( short_name, full_name, link)
				VALUES(@short_name, @full_name, @link );
	COMMIT;
		SELECT short_name, full_name, link
		FROM   dbo.Pulpit
		WHERE  short_name = @short_name;
END TRY
BEGIN CATCH
	ROLLBACK;
	SELECT ERROR_NUMBER() AS ErrorNumber,ERROR_MESSAGE() AS ErrorMessage;
END CATCH
GO
exec PulpitInsert 'ИСиТ', 'Информационные системы и технологии ', 'https://isit.belstu.by/';
------------------------------------------------------------------------------

IF OBJECT_ID('dbo.PulpitUpdate') IS NOT NULL
BEGIN 
    DROP PROC dbo.PulpitUpdate
END 
GO

CREATE PROC dbo.PulpitUpdate 
	@short_name NVARCHAR(10),
	@short_name_new NVARCHAR(10),
	@full_name NVARCHAR(50),
	@link NVARCHAR(500)
AS 
BEGIN TRY
	SET XACT_ABORT, NOCOUNT ON;
	BEGIN TRAN;
		UPDATE dbo.Pulpit
		SET    short_name = @short_name_new, full_name = @full_name, link = @link
		WHERE  short_name = @short_name;
	COMMIT;
		SELECT short_name, full_name, link
		FROM   dbo.Pulpit
		WHERE  short_name = @short_name_new;	
END TRY
BEGIN CATCH
	ROLLBACK;
	SELECT ERROR_NUMBER() AS ErrorNumber,ERROR_MESSAGE() AS ErrorMessage;
END CATCH
GO
----------------------------------------------------

IF OBJECT_ID('dbo.PulpitDelete') IS NOT NULL
BEGIN 
    DROP PROC dbo.PulpitDelete
END 
GO

CREATE PROC dbo.PulpitDelete 
	@short_name NVARCHAR(10)
AS 
BEGIN TRY
	SET XACT_ABORT, NOCOUNT ON;
	BEGIN TRAN;
		DELETE
		FROM  dbo.Pulpit
		WHERE  short_name = @short_name;
	COMMIT;
END TRY
BEGIN CATCH
	ROLLBACK;
	SELECT ERROR_NUMBER() AS ErrorNumber,ERROR_MESSAGE() AS ErrorMessage;
END CATCH
GO