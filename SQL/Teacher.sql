SET ANSI_NULLS ON;

----Teacher
IF OBJECT_ID('dbo.TeacherSelect') IS NOT NULL
BEGIN 
    DROP PROC dbo.TeacherSelect 
END 
GO

CREATE PROC dbo.TeacherSelect
	@name NVARCHAR(50)
AS 
	SET XACT_ABORT, NOCOUNT ON;
		SELECT id_teach, short_fio, full_fio, pulpit, work
		FROM dbo.Teacher
		WHERE  (LOWER(full_fio) like('%'+ LOWER(@name) + '%') OR @name IS NULL);
GO

EXEC dbo.TeacherSelect NULL;
-----------------------------------------------------------------------------
IF OBJECT_ID('dbo.TeacherInsert') IS NOT NULL
BEGIN 
    DROP PROC dbo.TeacherInsert
END 
GO

CREATE PROC dbo.TeacherInsert
	@rc INT OUTPUT,
	@short_fio NVARCHAR(10),
	@full_fio NVARCHAR(50),
	@pulpit NVARCHAR(10),
	@work BIT = 1
AS 
BEGIN TRY
	SET @rc = 0;
	SET XACT_ABORT, NOCOUNT ON
	IF EXISTS(SELECT short_name FROM dbo.Pulpit WHERE short_name like @pulpit)
	BEGIN	
		BEGIN TRAN;
		INSERT INTO dbo.Teacher (short_fio, full_fio, pulpit, work)
			VALUES(@short_fio, @full_fio, @pulpit, @work);
		SET @rc = 1;
	    COMMIT;
	END
END TRY
BEGIN CATCH
	SET @rc = -1;
	ROLLBACK;
	SELECT ERROR_NUMBER() AS ErrorNumber,ERROR_MESSAGE() AS ErrorMessage;
END CATCH
GO


DECLARE @a int;
EXEC dbo.TeacherInsert @a output, 'Смелов В.В.', 'Смелов Владимир Владиславович', 'ИСиТ';
select @a;
--------------------------------------------------------------------------------
IF OBJECT_ID('dbo.TeacherUpdate') IS NOT NULL
BEGIN 
    DROP PROC dbo.TeacherUpdate
END 
GO

CREATE PROC dbo.TeacherUpdate
	@rc BIT OUTPUT,
	@id INT,
	@short_fio NVARCHAR(10) = NULL,
	@full_fio NVARCHAR(50) = NULL,
	@pulpit NVARCHAR(10) = NULL,
	@work BIT = NULL
AS 
BEGIN TRY
	SET XACT_ABORT, NOCOUNT ON;
	SET @rc = 0;

	IF(@short_fio IS NOT NULL)
	BEGIN
		BEGIN TRAN;
		UPDATE dbo.Teacher SET short_fio = @short_fio WHERE id_teach = @id;
		COMMIT;
		SET @rc = 1;
	END	

	IF(@full_fio IS NOT NULL)
	BEGIN
		BEGIN TRAN;
		UPDATE dbo.Teacher SET full_fio = @full_fio WHERE id_teach = @id;
		COMMIT;
		SET @rc = 1;
	END	

	IF(@pulpit IS NOT NULL)
	BEGIN
		IF EXISTS(SELECT short_name FROM dbo.Pulpit WHERE short_name like @pulpit)
		BEGIN
			BEGIN TRAN;
			UPDATE dbo.Teacher SET pulpit = @pulpit WHERE id_teach = @id;
			COMMIT;
			SET @rc = 1;
		END
		ELSE SET @rc = -1;
	END

END TRY
BEGIN CATCH
	SET @rc = -1;
	ROLLBACK;
	SELECT ERROR_NUMBER() AS ErrorNumber,ERROR_MESSAGE() AS ErrorMessage;
END CATCH
GO

DECLARE @a int;
exec dbo.TeacherUpdate @a out, 1,'СВВ';
select @a;
------------------------------------------------------------------------



IF OBJECT_ID('dbo.TeacherDelete') IS NOT NULL
BEGIN 
    DROP PROC dbo.TeacherDelete
END 
GO

CREATE PROC dbo.TeacherDelete
	@id INT
AS 
BEGIN TRY
	SET XACT_ABORT, NOCOUNT ON;
	BEGIN TRAN;
		DELETE 
		FROM dbo.Teacher 
		WHERE id_teach = @id;
	COMMIT;
END TRY
BEGIN CATCH
	ROLLBACK;
	SELECT ERROR_NUMBER() AS ErrorNumber,ERROR_MESSAGE() AS ErrorMessage;
END CATCH


DECLARE @a int;
EXEC dbo.TeacherDelete 1;
select @a;
