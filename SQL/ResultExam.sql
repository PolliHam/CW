-----ResultExam

IF OBJECT_ID('dbo.ResultExamByNumber') IS NOT NULL
BEGIN 
    DROP PROC dbo.ResultExamByNumber 
END 
GO

CREATE PROC dbo.ResultExamByNumber
    @number_statement VARCHAR(10)
AS 
	SET XACT_ABORT, NOCOUNT ON;
		SELECT r.number_statement, s.first_name, s.surname, ISNULL(s.patronymic,'') as patronymic, r.record_book, m.name as mark, m.type_mark 
		FROM   dbo.ResultExam r  inner join dbo.ExamCredit e on r.number_statement = e.number_statement
									inner join dbo.Student s on r.record_book = s.record_book
									inner join dbo.Mark m on r.mark = m.id_mark
		WHERE  r.number_statement like ('%'+ @number_statement +'%') ;
GO

exec dbo.ResultExamByNumber '7-21/552';
------------------------------------------------------------

IF OBJECT_ID('dbo.ResultExamInsert') IS NOT NULL
BEGIN 
    DROP PROC dbo.ResultExamInsert 
END 
GO

CREATE PROC dbo.ResultExamInsert 
	@rc INT OUTPUT,
    @number_statement VARCHAR(10),
	@record_book INT,
	@mark NVARCHAR(15)
AS 
BEGIN TRY
	SET XACT_ABORT, NOCOUNT ON;
	SET @rc = 0;

	DECLARE @id_mark INT = -1;
	SELECT @id_mark = id_mark FROM dbo.Mark WHERE LOWER(name) like LOWER(@mark)

	IF( EXISTS(SELECT number_statement FROM dbo.ExamCredit WHERE number_statement = @number_statement) AND
		EXISTS(SELECT record_book FROM dbo.Student WHERE record_book = @record_book) AND @id_mark != -1)
	BEGIN
		BEGIN TRAN;
			INSERT INTO  dbo.ResultExam(number_statement, record_book, mark)
					VALUES( @number_statement, @record_book, @id_mark);
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
EXEC dbo.ResultExamInsert @a OUT,'7-21/552/1', 71600135, '4'; 
select @a;
------------------------------------------------------------------------------

IF OBJECT_ID('dbo.ResultExamUpdate') IS NOT NULL
BEGIN 
    DROP PROC dbo.ResultExamUpdate
END 
GO

CREATE PROC dbo.ResultExamUpdate 
	@rc INT OUTPUT,
    @number_statement VARCHAR(10),
	@record_book INT,
	@mark NVARCHAR(15)
AS 
BEGIN TRY
	SET XACT_ABORT, NOCOUNT ON;
	SET @rc = 0;

	DECLARE @id_mark INT = -1;
	SELECT @id_mark = id_mark FROM dbo.Mark WHERE LOWER(name) like LOWER(@mark)

	IF( EXISTS(SELECT number_statement FROM dbo.ExamCredit WHERE number_statement = @number_statement) AND
		EXISTS(SELECT record_book FROM dbo.Student WHERE record_book = @record_book) AND @id_mark != -1 AND
		EXISTS(SELECT number_statement FROM dbo.ResultExam WHERE number_statement = @number_statement AND record_book = @record_book))
	BEGIN
		BEGIN TRAN;
			UPDATE dbo.ResultExam
			SET mark = @id_mark
			WHERE number_statement = @number_statement AND record_book = @record_book;
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
EXEC dbo.ResultExamUpdate @a OUT,'7-21/552', 71600135, '2'; 
select @a;
----------------------------------------------------------------------

IF OBJECT_ID('dbo.ResultExamDelete') IS NOT NULL
BEGIN 
    DROP PROC dbo.ResultExamDelete
END 
GO

CREATE PROC dbo.ResultExamDelete 
    @rc INT OUTPUT,
    @number_statement VARCHAR(10),
	@record_book INT
AS 
BEGIN TRY
	SET XACT_ABORT, NOCOUNT ON;
	SET @rc = 0;
	IF( EXISTS(SELECT number_statement FROM dbo.ExamCredit WHERE number_statement = @number_statement) AND
		EXISTS(SELECT record_book FROM dbo.Student WHERE record_book = @record_book) AND 
		EXISTS(SELECT number_statement FROM dbo.ResultExam WHERE number_statement = @number_statement AND record_book = @record_book))
	BEGIN
		BEGIN TRAN;
			DELETE
			FROM  dbo.ResultExam
			WHERE number_statement = @number_statement AND record_book = @record_book;
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



