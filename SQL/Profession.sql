----Profession

IF OBJECT_ID('dbo.ProfessionSelect') IS NOT NULL
BEGIN 
    DROP PROC dbo.ProfessionSelect 
END 
GO

CREATE PROC dbo.ProfessionSelect
    @name NVARCHAR(30)
AS 
	SET XACT_ABORT, NOCOUNT ON;
		SELECT id_prof, name  
		FROM   dbo.Profession
		WHERE  (LOWER(name) like('%'+ LOWER(@name) + '%')  OR @name IS NULL);
GO

exec ProfessionSelect null;
------------------------------------------------------------

IF OBJECT_ID('dbo.ProfessionInsert') IS NOT NULL
BEGIN 
    DROP PROC dbo.ProfessionInsert 
END 
GO

CREATE PROC dbo.ProfessionInsert 
    @name NVARCHAR(30)
AS 
BEGIN TRY
	SET XACT_ABORT, NOCOUNT ON;
	BEGIN TRAN;
		INSERT INTO  dbo.Profession ( name )
				VALUES( @name );
	COMMIT;
		SELECT id_prof, name
		FROM   dbo.Profession
		WHERE  id_prof= SCOPE_IDENTITY();
END TRY
BEGIN CATCH
	ROLLBACK;
	SELECT ERROR_NUMBER() AS ErrorNumber,ERROR_MESSAGE() AS ErrorMessage;
END CATCH            
GO
------------------------------------------------------------------------------

IF OBJECT_ID('dbo.ProfessionUpdate') IS NOT NULL
BEGIN 
    DROP PROC dbo.ProfessionUpdate
END 
GO

CREATE PROC dbo.ProfessionUpdate 
	@id INT,
	@name NVARCHAR(30)
AS 
BEGIN TRY
	SET XACT_ABORT, NOCOUNT ON;
	BEGIN TRAN;
		UPDATE dbo.Profession
		SET    name=@name
		WHERE  id_prof = @id;
	COMMIT;
		SELECT id_prof, name
		FROM   dbo.Profession
		WHERE  id_prof = @id;
END TRY
BEGIN CATCH
	ROLLBACK;
	SELECT ERROR_NUMBER() AS ErrorNumber,ERROR_MESSAGE() AS ErrorMessage;
END CATCH
GO
----------------------------------------------------

IF OBJECT_ID('dbo.ProfessionDelete') IS NOT NULL
BEGIN 
    DROP PROC dbo.ProfessionDelete
END 
GO

CREATE PROC dbo.ProfessionDelete 
   @id INT
AS 
BEGIN TRY
	SET XACT_ABORT, NOCOUNT ON;
	BEGIN TRAN;
		DELETE
		FROM  dbo.Profession
		WHERE  id_prof = @id;
	COMMIT;
END TRY
BEGIN CATCH
	ROLLBACK;
	SELECT ERROR_NUMBER() AS ErrorNumber,ERROR_MESSAGE() AS ErrorMessage;
END CATCH
GO