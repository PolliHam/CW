CREATE PROC dbo.UserIsAdmin
	@login NVARCHAR(16),
	@password NVARCHAR(20),
	@rc INT OUTPUT
AS 
BEGIN
	DECLARE @admin BIT = 0;
	SELECT @admin = user_admin FROM dbo.Users WHERE user_login like @login and user_password like @password;
	IF(@admin=1)							
		SET @rc = 1;
	ELSE
		SET @rc = 0;
END
GO


CREATE PROC dbo.StudentIsLeader
	@login NVARCHAR(16),
	@rc INT OUTPUT
AS 
BEGIN
	DECLARE @leader BIT = 0;
	SELECT @leader = leader FROM dbo.Student WHERE record_book = CAST( @login as INT);
	IF(@leader=1)							
		SET @rc = 1;
	ELSE
		SET @rc = 0;
END
GO


CREATE PROC dbo.Authorisation
	@login NVARCHAR(16),
	@password NVARCHAR(20),
	@rc INT OUTPUT
AS BEGIN
	SET @rc = -1;
	DECLARE @admin INT;
	DECLARE @leader INT;
	IF EXISTS(SELECT user_login FROM dbo.Users WHERE user_login like @login and user_password like @password)
	BEGIN							
		exec dbo.UserIsAdmin @login, @password, @admin out;
		IF (@admin = 1)
			SET @rc = 2;
		ELSE
		BEGIN
			exec dbo.StudentIsLeader @login, @leader out;
			IF (@leader=1)
				SET @rc = 1;
			ELSE
				SET @rc = 0;
		END
	END		
END
GO




DECLARE @a int;
exec dbo.UserIsAdmin '71600', 'pashka', @a out;
select @a;

DECLARE @a int;
exec dbo.StudentIsLeader '71600097', @a out;
select @a;

DECLARE @a int;
exec dbo.Authorisation 'admin', 'admin', @a out;
select @a;