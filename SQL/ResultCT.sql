----ResultCT
IF OBJECT_ID('dbo.ResultCTByStudent') IS NOT NULL
BEGIN 
    DROP PROC dbo.ResultCTByStudent
END 
GO

CREATE PROC dbo.ResultCTByStudent
	@record_book INT
AS 
	SET XACT_ABORT, NOCOUNT ON;
		SELECT r.record_book, s.name,  r.score, r.year_ct
		FROM dbo.ResultCT r inner join dbo.SubjectCT s on r.id_subj = s.id_subj
		WHERE  record_book = @record_book;
GO
-----------------------------------------------------------------------------

IF OBJECT_ID('dbo.ResultCTInsert') IS NOT NULL
BEGIN 
    DROP PROC dbo.ResultCTInsert
END 
GO

CREATE PROC dbo.ResultCTInsert
	@rc INT OUTPUT,
	@record_book INT,
	@name1 NVARCHAR(20),
	@score1 INT,
	@year1 INT,
	@name2 NVARCHAR(20),
	@score2 INT,
	@year2 INT,
	@name3 NVARCHAR(20),
	@score3 INT,
	@year3 INT
AS 
BEGIN TRY
	SET XACT_ABORT, NOCOUNT ON;
	SET @rc = 0;
	IF( EXISTS(SELECT record_book FROM dbo.Student WHERE record_book = @record_book))
	BEGIN
		DECLARE @id1 INT = 0; 
		DECLARE @id2 INT = 0; 
		DECLARE @id3 INT = 0; 
		SELECT @id1=id_subj FROM dbo.SubjectCT 	WHERE LOWER(name) like LOWER(@name1);
		SELECT @id2=id_subj FROM dbo.SubjectCT 	WHERE LOWER(name) like LOWER(@name2);
		SELECT @id3=id_subj FROM dbo.SubjectCT 	WHERE LOWER(name) like LOWER(@name3);
	
		IF( @id1 != 0 AND @id2 != 0 AND @id3 != 0 AND
			@score1>0 AND @score1<101 AND @score2>0 AND @score2<101 AND @score3>0 AND @score3<101 AND
			@year1>2003 AND @year1 <= YEAR(GETDATE()) AND @year2>2003 AND @year2 <= YEAR(GETDATE()) AND @year3>2003 AND @year3 <= YEAR(GETDATE())      )
		BEGIN	
			BEGIN TRAN;
			INSERT INTO dbo.ResultCT (record_book, id_subj, score, year_ct)
				VALUES  (@record_book, @id1, @score1, @year1),
						(@record_book, @id2, @score2, @year2),
						(@record_book, @id3, @score3, @year3);
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

DECLARE @a int;
EXEC dbo.ResultCTInsert @a out, 71600135, 'ФизИКА', 56, 2016, 'Математика', 31,2016,'Белорусский язык', 80, 2016;
select @a;
--------------------------------------------------------------------------------

IF OBJECT_ID('dbo.ResultCTUpdate') IS NOT NULL
BEGIN 
    DROP PROC dbo.ResultCTUpdate
END 
GO

CREATE PROC dbo.ResultCTUpdate
	@rc INT OUTPUT,
	@record_book INT,
	@name NVARCHAR(20),
	@score INT,
	@year INT
AS 
BEGIN TRY
	SET XACT_ABORT, NOCOUNT ON;
	SET @rc = 0;
	DECLARE @id INT = 0;
	SELECT @id=id_subj FROM dbo.SubjectCT 	WHERE LOWER(name) like LOWER(@name);

	IF( EXISTS(SELECT record_book FROM dbo.ResultCT WHERE record_book = @record_book AND id_subj = @id)
		AND @score>0 AND @score<101 AND @year>2003 AND @year <= YEAR(GETDATE()))
	BEGIN
		BEGIN TRAN;
		UPDATE dbo.ResultCT SET score = @score, year_ct=@year WHERE record_book = @record_book AND id_subj = @id;
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
------------------------------------------------------------------------

IF OBJECT_ID('dbo.ResultCTDelete') IS NOT NULL
BEGIN 
    DROP PROC dbo.ResultCTDelete
END 
GO

CREATE PROC dbo.ResultCTDelete
	@rc INT OUTPUT,
	@record_book INT,
	@name NVARCHAR(20)
AS 
BEGIN TRY
	SET XACT_ABORT, NOCOUNT ON;
	SET @rc = 0;
	DECLARE @id INT = 0;
	SELECT @id=id_subj FROM dbo.SubjectCT 	WHERE LOWER(name) like LOWER(@name);

	IF( EXISTS(SELECT record_book FROM dbo.ResultCT WHERE record_book = @record_book AND id_subj = @id))
	BEGIN
		BEGIN TRAN;
			DELETE 
			FROM dbo.ResultCT 
			WHERE record_book = @record_book AND id_subj = @id;
		COMMIT;
		SET @rc = 1;
	END
END TRY
BEGIN CATCH
	SET @rc = -1;
	ROLLBACK;
	SELECT ERROR_NUMBER() AS ErrorNumber,ERROR_MESSAGE() AS ErrorMessage;
END CATCH


