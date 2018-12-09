----ListExpelled
IF OBJECT_ID('dbo.ListExpelledByNumber') IS NOT NULL
BEGIN 
    DROP PROC dbo.ListExpelledByNumber 
END 
GO

CREATE PROC dbo.ListExpelledByNumber
    @number VARCHAR(15)
AS 
	SET XACT_ABORT, NOCOUNT ON;
		SELECT s.first_name, s.surname, ISNULL(s.patronymic,''), g.course, g.group_number, sp.short_name  
		FROM   dbo.ListExpelled l   inner join dbo.Student s on l.record_book=s.record_book
									inner join dbo.GroupStudent g on l.id_group = g.id_group
									inner join dbo.Speciality sp on g.kod_special = sp.kod_special
		WHERE  l.number_exp like @number;
GO

------------------------------------------------------------

IF OBJECT_ID('dbo.ListExpelledInsert') IS NOT NULL
BEGIN 
    DROP PROC dbo.ListExpelledInsert 
END 
GO

CREATE PROC dbo.ListExpelledInsert 
	@rc INT OUTPUT,
    @number VARCHAR(15),
    @record_book INT,
	@id_group NVARCHAR(15)
AS 
BEGIN TRY
	SET XACT_ABORT, NOCOUNT ON;
	SET @rc = 0;
	IF( EXISTS(SELECT record_book FROM dbo.Student WHERE record_book = @record_book) AND
		EXISTS(SELECT id_group FROM dbo.GroupStudent WHERE id_group = @id_group) AND
		EXISTS(SELECT number FROM dbo.Expelled WHERE number = @number))
	BEGIN
		BEGIN TRAN;
			INSERT INTO  dbo.ListExpelled (number_exp, record_book, id_group)
					VALUES( @number, @record_book, @id_group);
		SET @rc = 1;

		IF( (SELECT dismissed FROM dbo.Student WHERE record_book = @record_book) = 0)
			UPDATE dbo.Student SET dismissed = 1 WHERE  record_book = @record_book;

		COMMIT;
	END
END TRY
BEGIN CATCH
	SET @rc = -1;
	ROLLBACK;
	SELECT ERROR_NUMBER() AS ErrorNumber,ERROR_MESSAGE() AS ErrorMessage;
END CATCH
GO

------------------------------------------------------------------------------

IF OBJECT_ID('dbo.ListExpelledDelete') IS NOT NULL
BEGIN 
    DROP PROC dbo.ListExpelledDelete
END 
GO

CREATE PROC dbo.ListExpelledDelete 
    @rc INT OUTPUT,
    @number VARCHAR(15),
    @record_book INT,
	@id_group NVARCHAR(15)
AS 
BEGIN TRY
	SET XACT_ABORT, NOCOUNT ON;
	SET @rc = 0;
	IF( EXISTS(SELECT number_exp FROM dbo.ListExpelled WHERE number_exp = @number AND record_book = @record_book AND id_group = @id_group))
	BEGIN
		BEGIN TRAN;
			DELETE
			FROM  dbo.ListExpelled 
			WHERE  number_exp = @number AND record_book = @record_book AND id_group = @id_group;
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
