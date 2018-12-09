---------Messenger

IF OBJECT_ID('dbo.MessengerByStudent') IS NOT NULL
BEGIN 
    DROP PROC dbo.MessengerByStudent 
END 
GO

CREATE PROC dbo.MessengerByStudent
    @record_book INT
AS 
	SET XACT_ABORT, NOCOUNT ON;
		SELECT s.first_name, s.surname, ISNULL(s.patronymic,'') as patronymic, m.mess 
		FROM   dbo.Messenger m  inner join dbo.Student s on m.record_book = s.record_book
		WHERE  m.record_book = @record_book;
GO



IF OBJECT_ID('dbo.MessengerByCourseGroup') IS NOT NULL
BEGIN 
    DROP PROC dbo.MessengerByCourseGroup 
END 
GO

CREATE PROC dbo.MessengerByCourseGroup
    @course INT,
	@group INT
AS 
	SET XACT_ABORT, NOCOUNT ON;
		SELECT s.first_name, s.surname, ISNULL(s.patronymic,'') as patronymic, m.mess 
		FROM   dbo.Messenger m  inner join dbo.Student s on m.record_book = s.record_book
								inner join dbo.GroupStudent g on s.id_group = g.id_group
		WHERE  g.course = @course AND g.group_number=@group;
GO
------------------------------------------------------------

IF OBJECT_ID('dbo.MessengerInsert') IS NOT NULL
BEGIN 
    DROP PROC dbo.MessengerInsert 
END 
GO

CREATE PROC dbo.MessengerInsert 
	@rc INT OUTPUT,
	@record_book INT,
	@mess NVARCHAR(100)
AS 
BEGIN TRY
	SET XACT_ABORT, NOCOUNT ON;
	SET @rc = 0;

	IF( EXISTS(SELECT record_book FROM dbo.Student WHERE record_book = @record_book))
	BEGIN
		BEGIN TRAN;
			INSERT INTO  dbo.Messenger(record_book, mess)
					VALUES( @record_book, @mess);
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
----------------------------------------------------------------------

IF OBJECT_ID('dbo.MessengerDelete') IS NOT NULL
BEGIN 
    DROP PROC dbo.MessengerDelete
END 
GO

CREATE PROC dbo.MessengerDelete 
    @rc INT OUTPUT,
	@record_book INT,
	@mess NVARCHAR(100) = NULL
AS 
BEGIN TRY
	SET XACT_ABORT, NOCOUNT ON;
	SET @rc = 0;
	IF( EXISTS(SELECT record_book FROM dbo.Messenger WHERE record_book = @record_book))
	BEGIN
		BEGIN TRAN;
			DELETE
			FROM  dbo.Messenger
			WHERE (record_book = @record_book AND mess=@mess) OR(record_book = @record_book AND @mess IS NULL) ;
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




