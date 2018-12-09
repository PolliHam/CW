----ListEnrollment
IF OBJECT_ID('dbo.ListEnrollmentByNumber') IS NOT NULL
BEGIN 
    DROP PROC dbo.ListEnrollmentByNumber 
END 
GO

CREATE PROC dbo.ListEnrollmentByNumber
    @number VARCHAR(15)
AS 
	SET XACT_ABORT, NOCOUNT ON;
		SELECT s.first_name, s.surname,ISNULL(s.patronymic,''), g.course, g.group_number, sp.short_name  
		FROM   dbo.ListEnrollment l inner join dbo.Student s on l.record_book=s.record_book
									inner join dbo.GroupStudent g on l.id_group = g.id_group
									inner join dbo.Speciality sp on g.kod_special = sp.kod_special
		WHERE  l.number_enrol like @number;
GO

------------------------------------------------------------

IF OBJECT_ID('dbo.ListEnrollmentInsert') IS NOT NULL
BEGIN 
    DROP PROC dbo.ListEnrollmentInsert 
END 
GO

CREATE PROC dbo.ListEnrollmentInsert 
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
		EXISTS(SELECT number FROM dbo.Enrollment WHERE number = @number))
	BEGIN
		BEGIN TRAN;
			INSERT INTO  dbo.ListEnrollment (number_enrol, record_book, id_group)
					VALUES( @number, @record_book, @id_group);
		SET @rc = 1;

		UPDATE dbo.Student SET id_group = @id_group WHERE  record_book = @record_book;

		IF( (SELECT dismissed FROM dbo.Student WHERE record_book = @record_book) = 1)
			UPDATE dbo.Student SET restored = 1, dismissed = 0 WHERE  record_book = @record_book;

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

IF OBJECT_ID('dbo.ListEnrollmentDelete') IS NOT NULL
BEGIN 
    DROP PROC dbo.ListEnrollmentDelete
END 
GO

CREATE PROC dbo.ListEnrollmentDelete 
    @rc INT OUTPUT,
    @number VARCHAR(15),
    @record_book INT,
	@id_group NVARCHAR(15)
AS 
BEGIN TRY
	SET XACT_ABORT, NOCOUNT ON;
	SET @rc = 0;
	IF( EXISTS(SELECT number_enrol FROM dbo.ListEnrollment WHERE number_enrol = @number AND record_book = @record_book AND id_group = @id_group))
	BEGIN
		BEGIN TRAN;
			DELETE
			FROM  dbo.ListEnrollment 
			WHERE  number_enrol = @number AND record_book = @record_book AND id_group = @id_group;
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
