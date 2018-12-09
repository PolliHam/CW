-----Users

IF OBJECT_ID('dbo.UsersSelect') IS NOT NULL
BEGIN 
    DROP PROC dbo.UsersSelect
END 
GO

CREATE PROC dbo.UsersSelect
AS 
	SET XACT_ABORT, NOCOUNT ON;
		SELECT user_login, user_password, user_admin
		FROM   dbo.Users
GO

exec dbo.UsersSelect;


------------------------------------------------------------

IF OBJECT_ID('dbo.UsersInsert') IS NOT NULL
BEGIN 
    DROP PROC dbo.UsersInsert 
END 
GO

CREATE PROC dbo.UsersInsert  
	@rc INT OUTPUT,
	@login NVARCHAR(16),
	@password NVARCHAR(20),
	@admin BIT	
AS 
BEGIN TRY
	SET XACT_ABORT, NOCOUNT ON;
	SET @rc = 0;
	
	IF(NOT EXISTS(SELECT user_login FROM dbo.Users WHERE user_login = @login) AND LEN(@password)<4)
	BEGIN
		IF((@admin = 0 AND EXISTS(SELECT record_book FROM dbo.Student WHERE record_book = CAST( @login as INT))) OR @admin = 1 )
		BEGIN 
			BEGIN TRAN;
				INSERT INTO  dbo.Users( user_login, user_password, user_admin)
					VALUES (@login, @password, @admin);
			COMMIT;
			SET @rc = 1;	
		END
	END
END TRY
BEGIN CATCH
	SET @rc = -1;
	ROLLBACK;
	SELECT ERROR_NUMBER() AS ErrorNumber,ERROR_MESSAGE() AS ErrorMessage;
END CATCH
GO

DECLARE @a INT;
EXEC dbo.UsersInsert @a OUT,'admin', 'admin', 1; 
select @a;

------------------------------------------------------------------------------

IF OBJECT_ID('dbo.UsersUpdate') IS NOT NULL
BEGIN 
    DROP PROC dbo.UsersUpdate 
END 
GO

CREATE PROC dbo.UsersUpdate  
	@rc INT OUTPUT,
	@login NVARCHAR(16),
	@password NVARCHAR(20),
	@password_new NVARCHAR(20)		
AS 
BEGIN TRY
	SET XACT_ABORT, NOCOUNT ON;
	SET @rc = 0;
	
	IF(	EXISTS(SELECT user_login FROM dbo.Users WHERE user_login = @login AND user_password = @password) AND LEN(@password_new)>3)
	BEGIN	
		BEGIN TRAN;
				UPDATE dbo.Users
				SET user_password = @password_new
				WHERE user_login = @login AND user_password = @password;
			COMMIT;
			SET @rc = 1;	
	END
END TRY
BEGIN CATCH
	SET @rc = -1;
	ROLLBACK;
	SELECT ERROR_NUMBER() AS ErrorNumber,ERROR_MESSAGE() AS ErrorMessage;
END CATCH
GO

DECLARE @a INT;
EXEC dbo.UsersUpdate @a OUT, '71600135', 'pashka', '123456'; 
select @a;
---------------------------------------------------------------------------------------------

IF OBJECT_ID('dbo.UsersDelete') IS NOT NULL
BEGIN 
    DROP PROC dbo.UsersDelete
END 
GO

CREATE PROC dbo.UsersDelete 
	@rc INT OUTPUT,
	@login NVARCHAR(16),
	@password NVARCHAR(20)
AS 
BEGIN TRY
	SET XACT_ABORT, NOCOUNT ON;
	SET @rc = 0;
	IF(	EXISTS(SELECT user_login FROM dbo.Users WHERE user_login = @login AND user_password = @password))
	BEGIN	
		BEGIN TRAN;
			DELETE
			FROM dbo.Users WHERE user_login = @login AND user_password = @password;
		COMMIT;
		SET @rc = 1;
	END
END TRY
BEGIN CATCH
	SET @rc = -1;
	ROLLBACK;
	SELECT ERROR_NUMBER() AS ErrorNumber,ERROR_MESSAGE() AS ErrorMessage;
END CATCH
GO
