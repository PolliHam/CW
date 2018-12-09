-----Certificate

IF OBJECT_ID('dbo.CertificateByStudent') IS NOT NULL
BEGIN 
    DROP PROC dbo.CertificateByStudent 
END 
GO

CREATE PROC dbo.CertificateByStudent
    @record_book INT
AS 
	SET XACT_ABORT, NOCOUNT ON;
		SELECT c.number, s.first_name, s.surname, ISNULL(s.patronymic,'') as patronymic, c.school,
		 c.belarusian_language, c.belarusian_literature, c.russian_language, c.russian_literature, c.foreign_language, l.full_name as [language],
		 c.mathematics, c.informatics, c.history_of_belarus, c.world_history, c.social_science,  c.geography_subj, c.biology, c.physics, c.astronomy,
		 c.chemistry, c.physical_culture, c.preliminary_medical,c.gpa, c.gold_medal, c.silver_medal
		FROM   dbo.[Certificate] c	inner join dbo.Student s on c.record_book = s.record_book
									inner join dbo.Lenguage l on c.f_language = l.short_name 
		WHERE  c.record_book = @record_book;
GO

exec dbo.CertificateByStudent 71600135;


------------------------------------------------------------

IF OBJECT_ID('dbo.CertificateInsert') IS NOT NULL
BEGIN 
    DROP PROC dbo.CertificateInsert 
END 
GO

CREATE PROC dbo.CertificateInsert  
	@rc INT OUTPUT,
    @number INT,
	@record_book INT,
	@school NVARCHAR(50),
	@gpa FLOAT,
	@belarusian_language INT,
	@belarusian_literature INT,
	@russian_language INT,
	@russian_literature INT,
	@foreign_language INT,
	@language NVARCHAR(20),                                 --справочник языков
	@mathematics INT,
	@informatics INT,
	@history_of_belarus INT,
	@world_history INT,
	@social_science INT,
	@geography_subj INT,
	@biology INT,
	@physics INT,
	@astronomy INT,
	@chemistry INT,
	@physical_culture INT,
	@preliminary_medical INT,
	@gold_medal BIT = 0,						
	@silver_medal BIT = 0			
AS 
BEGIN TRY
	SET XACT_ABORT, NOCOUNT ON;
	SET @rc = 0;
	
	DECLARE @short_leng  NVARCHAR(20) = '';
	SELECT @short_leng = short_name FROM dbo.Lenguage WHERE LOWER(full_name) like LOWER(@language);

	DECLARE @check_gpa FLOAT = -1;
	SET @check_gpa =  ROUND((@belarusian_language + @belarusian_literature + @russian_language + @russian_literature + @foreign_language + 
						@mathematics + @informatics + @history_of_belarus + @world_history + @social_science + @geography_subj + @biology + 
						@physics + @astronomy + @chemistry + @physical_culture + @preliminary_medical)/17.,1);
	IF(	EXISTS(SELECT record_book FROM dbo.Student WHERE record_book = @record_book) AND
		@short_leng!=''				AND		@check_gpa = @gpa				AND  
		@gpa>=0.0					AND		@gpa<=10.0						AND 
		@belarusian_language >=0.0	AND 	@belarusian_language <=10.0 	AND 
		@belarusian_literature>=0.0	AND 	@belarusian_literature<=10.0	AND 
		@russian_language >=0.0		AND 	@russian_language <=10.0		AND 
		@russian_literature >=0.0	AND 	@russian_literature <=10.0		AND 
		@foreign_language >=0.0		AND 	@foreign_language <=10.0		AND  
		@mathematics >=0.0			AND 	@mathematics <=10.0				AND 
		@informatics >=0.0			AND 	@informatics <=10.0				AND 
		@history_of_belarus >=0.0	AND 	@history_of_belarus <=10.0		AND 
		@world_history >=0.0		AND 	@world_history <=10.0			AND 
		@social_science >=0.0		AND 	@social_science <=10.0			AND 
		@geography_subj >=0.0		AND 	@geography_subj <=10.0			AND 
		@biology >=0.0				AND 	@biology <=10.0					AND 
		@physics >=0.0				AND 	@physics <=10.0					AND 
		@astronomy >=0.0			AND 	@astronomy <=10.0				AND 
		@chemistry >=0.0			AND 	@chemistry <=10.0				AND 
		@physical_culture >=0.0		AND 	@physical_culture <=10.0		AND 
		@preliminary_medical>=0.0	AND 	@preliminary_medical <=10.0	      )
	BEGIN
		BEGIN TRAN;
			INSERT INTO  dbo.[Certificate](number,record_book,school,gpa,belarusian_language,belarusian_literature,russian_language,
							russian_literature,foreign_language,f_language,mathematics,informatics,history_of_belarus,world_history,
							social_science,geography_subj,biology,physics,astronomy,chemistry,physical_culture,preliminary_medical,
							gold_medal,silver_medal)
				VALUES (@number,@record_book,@school,@gpa,@belarusian_language,@belarusian_literature,@russian_language,
							@russian_literature,@foreign_language,@short_leng,@mathematics,@informatics,@history_of_belarus,@world_history,
							@social_science,@geography_subj,@biology,@physics,@astronomy,@chemistry,@physical_culture,@preliminary_medical,
							@gold_medal,@silver_medal);
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
EXEC dbo.CertificateInsert @a OUT,'91234', 71600135, 'Брестский областной лицей имени П.М.Машерова', 9, 9, 10, 9, 9, 9,'АНГЛИЙСКИЙ', 8, 9, 10, 9, 9, 9, 8, 9, 9, 9, 9, 9 ; 
select @a;

------------------------------------------------------------------------------

IF OBJECT_ID('dbo.CertificateUpdate') IS NOT NULL
BEGIN 
    DROP PROC dbo.CertificateUpdate 
END 
GO

CREATE PROC dbo.CertificateUpdate  
	@rc INT OUTPUT,
	@record_book INT,
	@school NVARCHAR(50) = '',
	@belarusian_language INT = -1,
	@belarusian_literature INT = -1,
	@russian_language INT = -1,
	@russian_literature INT = -1,
	@foreign_language INT = -1,
	@language   NVARCHAR(20) = '',                                 --справочник языков
	@mathematics INT = -1,
	@informatics INT = -1,
	@history_of_belarus INT = -1,
	@world_history INT = -1,
	@social_science INT = -1,
	@geography_subj INT = -1,
	@biology INT = -1,
	@physics INT= -1,
	@astronomy INT = -1,
	@chemistry INT = -1,
	@physical_culture INT = -1,
	@preliminary_medical INT = -1,
	@gold_medal BIT = NULL,						
	@silver_medal BIT = NULL			
AS 
BEGIN TRY
	SET XACT_ABORT, NOCOUNT ON;
	SET @rc = 0;
	
	IF(	EXISTS(SELECT record_book FROM dbo.[Certificate] WHERE record_book = @record_book))
	BEGIN	
		IF(@school !='')
		BEGIN
			BEGIN TRAN;
			UPDATE dbo.[Certificate] SET school = @school WHERE record_book = @record_book;
			COMMIT;
			SET @rc = 1;
		END	

		IF(@belarusian_language >=0 AND @belarusian_language<=10)
		BEGIN
			BEGIN TRAN;
			UPDATE dbo.[Certificate] SET belarusian_language = @belarusian_language WHERE record_book = @record_book;
			COMMIT;
			SET @rc = 1;
		END	

		IF(@belarusian_literature >=0 AND @belarusian_literature<=10)
		BEGIN
			BEGIN TRAN;
			UPDATE dbo.[Certificate] SET belarusian_literature = @belarusian_literature WHERE record_book = @record_book;
			COMMIT;
			SET @rc = 1;
		END	

		IF(@russian_language >=0 AND @russian_language<=10)
		BEGIN
			BEGIN TRAN;
			UPDATE dbo.[Certificate] SET russian_language = @russian_language WHERE record_book = @record_book;
			COMMIT;
			SET @rc = 1;
		END	

		IF(@russian_literature >=0 AND @russian_literature<=10)
		BEGIN
			BEGIN TRAN;
			UPDATE dbo.[Certificate] SET russian_literature = @russian_literature WHERE record_book = @record_book;
			COMMIT;
			SET @rc = 1;
		END	

		IF(@foreign_language >=0 AND @foreign_language <=10)
		BEGIN
			BEGIN TRAN;
			UPDATE dbo.[Certificate] SET foreign_language = @foreign_language WHERE record_book = @record_book;
			COMMIT;
			SET @rc = 1;
		END	

		DECLARE @short_leng  NVARCHAR(20) = '';
		SELECT @short_leng = short_name FROM dbo.Lenguage WHERE LOWER(full_name) like LOWER(@language);

		IF(@short_leng !='')
		BEGIN
			BEGIN TRAN;
			UPDATE dbo.[Certificate] SET f_language = @short_leng WHERE record_book = @record_book;
			COMMIT;
			SET @rc = 1;
		END	

		IF(@mathematics >=0 AND @mathematics <=10)
		BEGIN
			BEGIN TRAN;
			UPDATE dbo.[Certificate] SET mathematics = @mathematics WHERE record_book = @record_book;
			COMMIT;
			SET @rc = 1;
		END	

		IF(@informatics >=0 AND @informatics <=10)
		BEGIN
			BEGIN TRAN;
			UPDATE dbo.[Certificate] SET informatics = @informatics WHERE record_book = @record_book;
			COMMIT;
			SET @rc = 1;
		END	

		IF(@history_of_belarus >=0 AND @history_of_belarus <=10)
		BEGIN
			BEGIN TRAN;
			UPDATE dbo.[Certificate] SET history_of_belarus = @history_of_belarus WHERE record_book = @record_book;
			COMMIT;
			SET @rc = 1;
		END

		IF(@world_history>=0 AND @world_history <=10)
		BEGIN
			BEGIN TRAN;
			UPDATE dbo.[Certificate] SET world_history = @world_history WHERE record_book = @record_book;
			COMMIT;
			SET @rc = 1;
		END
	
		IF(@social_science>=0 AND @social_science <=10)
		BEGIN
			BEGIN TRAN;
			UPDATE dbo.[Certificate] SET social_science = @social_science WHERE record_book = @record_book;
			COMMIT;
			SET @rc = 1;
		END

		IF(@geography_subj>=0 AND @geography_subj <=10)
		BEGIN
			BEGIN TRAN;
			UPDATE dbo.[Certificate] SET geography_subj = @geography_subj WHERE record_book = @record_book;
			COMMIT;
			SET @rc = 1;
		END

		IF(@biology>=0 AND @biology <=10)
		BEGIN
			BEGIN TRAN;
			UPDATE dbo.[Certificate] SET biology = @biology WHERE record_book = @record_book;
			COMMIT;
			SET @rc = 1;
		END

		IF(@physics>=0 AND @physics <=10)
		BEGIN
			BEGIN TRAN;
			UPDATE dbo.[Certificate] SET physics = @physics WHERE record_book = @record_book;
			COMMIT;
			SET @rc = 1;
		END

		IF(@astronomy>=0 AND @astronomy<=10)
		BEGIN
			BEGIN TRAN;
			UPDATE dbo.[Certificate] SET astronomy = @astronomy WHERE record_book = @record_book;
			COMMIT;
			SET @rc = 1;
		END

		IF(@chemistry>=0 AND @chemistry<=10)
		BEGIN
			BEGIN TRAN;
			UPDATE dbo.[Certificate] SET chemistry = @chemistry WHERE record_book = @record_book;
			COMMIT;
			SET @rc = 1;
		END

		IF(@physical_culture>=0 AND @physical_culture<=10)
		BEGIN
			BEGIN TRAN;
			UPDATE dbo.[Certificate] SET physical_culture = @physical_culture WHERE record_book = @record_book;
			COMMIT;
			SET @rc = 1;
		END

		IF(@preliminary_medical >=0 AND @preliminary_medical<=10)
		BEGIN
			BEGIN TRAN;
			UPDATE dbo.[Certificate] SET preliminary_medical = @preliminary_medical WHERE record_book = @record_book;
			COMMIT;
			SET @rc = 1;
		END

		IF(@gold_medal IS NOT NULL)
		BEGIN
			BEGIN TRAN;
			UPDATE dbo.[Certificate] SET gold_medal = @gold_medal WHERE record_book = @record_book;
			COMMIT;
			SET @rc = 1;
		END

		IF(@silver_medal IS NOT NULL)
		BEGIN
			BEGIN TRAN;
			UPDATE dbo.[Certificate] SET silver_medal = @silver_medal WHERE record_book = @record_book;
			COMMIT;
			SET @rc = 1;
		END
							
	  
		DECLARE @gpa FLOAT;
		SELECT @gpa = ROUND((belarusian_language + belarusian_literature + russian_language + russian_literature + foreign_language + 
							mathematics + informatics + history_of_belarus + world_history + social_science + geography_subj + biology + 
							physics + astronomy + chemistry + physical_culture + preliminary_medical)/17.,1)
							FROM dbo.[Certificate] WHERE record_book = @record_book;
		BEGIN TRAN;
			UPDATE dbo.[Certificate] SET gpa = @gpa WHERE record_book = @record_book;
		COMMIT;	
	END
END TRY
BEGIN CATCH
	SET @rc = -1;
	ROLLBACK;
	SELECT ERROR_NUMBER() AS ErrorNumber,ERROR_MESSAGE() AS ErrorMessage;
END CATCH
GO

DECLARE @a INT;
EXEC dbo.CertificateUpdate @a OUT, 71600135, @astronomy=9; 
select @a;
---------------------------------------------------------------------------------------------

IF OBJECT_ID('dbo.CertificateDelete') IS NOT NULL
BEGIN 
    DROP PROC dbo.CertificateDelete
END 
GO

CREATE PROC dbo.CertificateDelete 
    @rc INT OUTPUT,
	@record_book INT
AS 
BEGIN TRY
	SET XACT_ABORT, NOCOUNT ON;
	SET @rc = 0;
	IF(EXISTS(SELECT record_book FROM dbo.[Certificate] WHERE record_book = @record_book))
	BEGIN
		BEGIN TRAN;
			DELETE
			dbo.[Certificate] WHERE record_book = @record_book;
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
