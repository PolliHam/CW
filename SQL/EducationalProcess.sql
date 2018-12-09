--------EducationalProcess

IF OBJECT_ID('dbo.EducationalProcessSelectByYear') IS NOT NULL
BEGIN 
    DROP PROC dbo.EducationalProcessSelectByYear 
END 
GO

CREATE PROC dbo.EducationalProcessSelectByYear
    @academic_year CHAR(9)
AS 
	SET XACT_ABORT, NOCOUNT ON;
		SELECT f.name, e.course, e.date_start, e.date_end
		FROM   dbo.EducationalProcess e inner join dbo.FormProcess f on e.form = f.id_form
		WHERE  academic_year = @academic_year; 

GO

exec EducationalProcessSelectByYear '2018/2019';




IF OBJECT_ID('dbo.EducationalProcessSelectByCourse') IS NOT NULL
BEGIN 
    DROP PROC dbo.EducationalProcessSelectByCourse
END 
GO

CREATE PROC dbo.EducationalProcessSelectByCourse
    @academic_year CHAR(9),
	@course INT
AS 
	SET XACT_ABORT, NOCOUNT ON;
		SELECT f.name, e.course, e.date_start, e.date_end
		FROM   dbo.EducationalProcess e inner join dbo.FormProcess f on e.form = f.id_form
		WHERE  academic_year = @academic_year AND course=@course; 

GO

exec EducationalProcessSelectByCourse '2018/2019', 1;
------------------------------------------------------------

IF OBJECT_ID('dbo.EducationalProcessInsert') IS NOT NULL
BEGIN 
    DROP PROC dbo.EducationalProcessInsert 
END 
GO


CREATE PROC dbo.EducationalProcessInsert 
	@rc INT OUTPUT,
    @academic_year CHAR(9),
	@form NCHAR(2),
	@course INT,
	@date_start DATE, 
	@date_end DATE 
AS
BEGIN TRY 
	SET XACT_ABORT, NOCOUNT ON;
	SET @rc = 0;

	IF(EXISTS(SELECT id_form FROM dbo.FormProcess WHERE id_form = @form) AND
		DATEDIFF(day,@date_start, @date_end)>0 AND @course>0 AND @course<5)
	BEGIN;
	BEGIN TRAN;
		INSERT INTO  dbo.EducationalProcess (academic_year, form, course, date_start, date_end)
				VALUES( @academic_year, @form, @course, @date_start, @date_end);
	COMMIT;
	SET @rc = 1;
	END;
END TRY
BEGIN CATCH
	SET @rc = -1;
	ROLLBACK;
	SELECT ERROR_NUMBER() AS ErrorNumber,ERROR_MESSAGE() AS ErrorMessage;
END CATCH
GO


------------------------------------------------------------------------------

IF OBJECT_ID('dbo.EducationalProcessUpdate') IS NOT NULL
BEGIN 
    DROP PROC dbo.EducationalProcessUpdate
END 
GO

CREATE PROC dbo.EducationalProcessUpdate 
	@rc INT OUTPUT,
    @academic_year CHAR(9),
	@form NCHAR(2),
	@course INT,
	@date_start DATE = NULL,
	@date_end DATE = NULL 
AS 
BEGIN TRY 
	SET XACT_ABORT, NOCOUNT ON;	
	SET @rc = 0;

	DECLARE @d_start DATE = NULL;
	DECLARE @d_end DATE = NULL;

	SELECT @d_start= date_start, @d_end = date_end FROM dbo.EducationalProcess 
	WHERE academic_year = @academic_year AND course=@course AND form = @form; 

	IF((@d_start IS NOT NULL) AND  (@d_end IS NOT  NULL) )
	BEGIN
		IF((@date_start IS NOT NULL) AND DATEDIFF(day,@date_start, @d_end)>0)
			BEGIN
				BEGIN TRAN;
				UPDATE dbo.EducationalProcess 
				SET date_start = @date_start 
				WHERE academic_year = @academic_year AND course=@course AND form = @form; 
				COMMIT;
				SET @rc = 1;
			END

		IF((@date_end IS NOT NULL) AND DATEDIFF(day,@d_start, @date_end)>0)
			BEGIN
				BEGIN TRAN;
				UPDATE dbo.EducationalProcess 
				SET date_end = @date_end 
				WHERE academic_year = @academic_year AND course=@course AND form = @form; 
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

----------------------------------------------------------------------------------

IF OBJECT_ID('dbo.EducationalProcessDelete') IS NOT NULL
BEGIN 
    DROP PROC dbo.EducationalProcessDelete
END 
GO

CREATE PROC dbo.EducationalProcessDelete 
    @rc INT OUTPUT,
    @academic_year CHAR(9),
	@form NCHAR(2),
	@course INT
AS 
BEGIN TRY
	SET XACT_ABORT, NOCOUNT ON;
	SET @rc = 0;

	IF(EXISTS(SELECT id FROM dbo.EducationalProcess WHERE academic_year = @academic_year AND course=@course AND form = @form))
	BEGIN
		BEGIN TRAN;
			DELETE
			FROM dbo.EducationalProcess 
			WHERE academic_year = @academic_year AND course=@course AND form = @form;
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

exec ExpelledDelete '2017/18 01-10';


