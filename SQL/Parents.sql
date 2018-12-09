----------Parents

IF OBJECT_ID('dbo.ParentsByStudent') IS NOT NULL
BEGIN 
    DROP PROC dbo.ParentsByStudent 
END 
GO

CREATE PROC dbo.ParentsByStudent
    @record_book INT
AS 
	SET XACT_ABORT, NOCOUNT ON;
	
	SELECT fio, sex, date_birth, address_perent, messenger, name as profession, workplace, post
	FROM   dbo.Parents p inner join dbo.Profession pr on p.profession = pr.id_prof
	WHERE p.record_book = @record_book;
GO

exec dbo.ParentsByStudent 71600135;



-----------------------------------------------------------

IF OBJECT_ID('dbo.ParentsInsert') IS NOT NULL
BEGIN 
    DROP PROC dbo.ParentsInsert 
END 
GO

CREATE PROC dbo.ParentsInsert  
	@rc INT OUTPUT,
    @record_book INT,
	@fio NVARCHAR(50),
	@sex NCHAR(1) = 'Ж',
	@date_birth DATE,
	@address_perent NVARCHAR(150),
	@messenger NVARCHAR(50),
	@profession INT,
	@workplace NVARCHAR(150),
	@post NVARCHAR(30)
AS 
BEGIN TRY
	SET XACT_ABORT, NOCOUNT ON;
	SET @rc = 0;
	
	IF(	EXISTS(SELECT record_book FROM dbo.Student WHERE record_book = @record_book) AND 
		EXISTS(SELECT id_prof FROM dbo.Profession WHERE id_prof = @profession) AND 
		(@sex in( 'М' ,'м','Ж','ж')))
	BEGIN
		BEGIN TRAN;
			INSERT INTO  dbo.Parents(record_book, fio, sex, date_birth, address_perent, messenger,profession,workplace,post)
				VALUES (@record_book, @fio, LOWER(@sex), @date_birth, @address_perent, @messenger, @profession, @workplace, @post);
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
EXEC dbo.ParentsInsert  @a OUT, 71600135, 'Демосюк Алексей Валентинович','м','1979-05-05', 'г.Кобрин, ул.17 сентября, д.15, кв.1', '+375299876543',3,'Кобринский мсз', 'главный инженер'; 
select @a;

------------------------------------------------------------------------------

IF OBJECT_ID('dbo.ParentsUpdate') IS NOT NULL
BEGIN 
    DROP PROC dbo.ParentsUpdate 
END 
GO

CREATE PROC dbo.ParentsUpdate  
	@rc INT OUTPUT,
    @record_book INT,
	@sex NCHAR(1),
	@fio NVARCHAR(20) = NULL,
	@date_birth DATE = NULL,
	@address_perent NVARCHAR(150) = NULL,
	@messenger NVARCHAR(50) = NULL,
	@profession INT = NULL,
	@workplace NVARCHAR(150) = NULL,
	@post NVARCHAR(30) = NULL	
AS 
BEGIN TRY
	SET XACT_ABORT, NOCOUNT ON;
	SET @rc = 0;
	
	IF(	EXISTS(SELECT record_book FROM dbo.Parents WHERE record_book = @record_book AND LOWER(sex) like LOWER(@sex)))
	BEGIN	
		IF(@fio IS NOT NULL)
		BEGIN
			BEGIN TRAN;
			UPDATE dbo.Parents SET fio = @fio WHERE record_book = @record_book AND LOWER(sex) like LOWER(@sex);
			COMMIT;
			SET @rc = 1;
		END	

		IF(@date_birth IS NOT NULL)
		BEGIN
			BEGIN TRAN;
			UPDATE dbo.Parents SET date_birth = @date_birth WHERE record_book = @record_book AND LOWER(sex) like LOWER(@sex);
			COMMIT;
			SET @rc = 1;
		END	

		IF(@address_perent IS NOT NULL)
		BEGIN
			BEGIN TRAN;
			UPDATE dbo.Parents SET address_perent = @address_perent WHERE record_book = @record_book AND LOWER(sex) like LOWER(@sex);
			COMMIT;
			SET @rc = 1;
		END	

		IF(@messenger IS NOT NULL)
		BEGIN
			BEGIN TRAN;
			UPDATE dbo.Parents SET messenger = @messenger WHERE record_book = @record_book AND LOWER(sex) like LOWER(@sex);
			COMMIT;
			SET @rc = 1;
		END	

		IF(@profession IS NOT NULL)
		BEGIN
			BEGIN TRAN;
			UPDATE dbo.Parents SET profession = @profession WHERE record_book = @record_book AND LOWER(sex) like LOWER(@sex);
			COMMIT;
			SET @rc = 1;
		END	

		IF(@workplace IS NOT NULL)
		BEGIN
			BEGIN TRAN;
			UPDATE dbo.Parents SET workplace = @workplace WHERE record_book = @record_book AND LOWER(sex) like LOWER(@sex);
			COMMIT;
			SET @rc = 1;
		END	

		IF(@post IS NOT NULL)
		BEGIN
			BEGIN TRAN;
			UPDATE dbo.Parents SET post = @post WHERE record_book = @record_book AND LOWER(sex) like LOWER(@sex);
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
EXEC dbo.ParentsUpdate @a OUT, 71600135, 'ж', @profession=1; 
select @a;
---------------------------------------------------------------------------------------------

IF OBJECT_ID('dbo.ParentsDelete') IS NOT NULL
BEGIN 
    DROP PROC dbo.ParentsDelete
END 
GO

CREATE PROC dbo.ParentsDelete 
    @rc INT OUTPUT,
	@record_book INT,
	@sex NCHAR(1)
AS 
BEGIN TRY
	SET XACT_ABORT, NOCOUNT ON;
	SET @rc = 0;
	IF(	EXISTS(SELECT record_book FROM dbo.Parents WHERE record_book = @record_book AND LOWER(sex) like LOWER(@sex)))
	BEGIN		
		BEGIN TRAN;
			DELETE
			dbo.Parents WHERE record_book = @record_book AND LOWER(sex) like LOWER(@sex) ;
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


