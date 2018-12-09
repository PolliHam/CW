------Attestation

IF OBJECT_ID('dbo.CurentAttestation') IS NOT NULL
BEGIN 
    DROP PROC dbo.CurentAttestation 
END 
GO

CREATE PROC dbo.CurentAttestation
AS 
	SET XACT_ABORT, NOCOUNT ON;
	
	SELECT a.id_attestation, g.course, g.group_number, date_begin, date_end
	FROM   dbo.Attestation a inner join dbo.GroupStudent g on a.id_group= g.id_group
	WHERE ( a.stat = 0);
GO

exec dbo.CurentAttestation;
----------------------------------------

IF OBJECT_ID('dbo.AttestationByIdGroup') IS NOT NULL
BEGIN 
    DROP PROC dbo.AttestationByIdGroup 
END 
GO

CREATE PROC dbo.AttestationByIdGroup
    @id_group  NVARCHAR(15)
AS 
	SET XACT_ABORT, NOCOUNT ON;
	
	SELECT a.id_attestation, date_begin, date_end, stat
	FROM   dbo.Attestation a inner join dbo.GroupStudent g on a.id_group = g.id_group
	WHERE  LOWER(g.id_group) like ('%'+LOWER(@id_group)+'%');
GO

exec AttestationByIdGroup '16/20ฯฮศา5';

-----------------------------------------------------------------

IF OBJECT_ID('dbo.AttestationByGroupNum') IS NOT NULL
BEGIN 
    DROP PROC dbo.AttestationByGroupNum 
END 
GO

CREATE PROC dbo.AttestationByGroupNum
    @course INT,
	@group INT
AS 
	SET XACT_ABORT, NOCOUNT ON;
	DECLARE @id  NVARCHAR(15) = NULL;
	EXEC dbo.GetGroupIdByCourseNum @course, @group, @id OUT;
	IF(@id IS NOT NULL)
		EXEC dbo.AttestationByIdGroup @id;
GO

exec dbo.AttestationByGroupNum 3,5;
-----------------------------------------------------


IF OBJECT_ID('dbo.AttestationInsert') IS NOT NULL
BEGIN 
    DROP PROC dbo.AttestationInsert 
END 
GO

CREATE PROC dbo.AttestationInsert 
	@rc INT OUTPUT,
    @id_attestation INT,	
	@id_group  NVARCHAR(15),
	@date_begin DATE, 
	@date_end DATE,
	@stat BIT = 0
AS
BEGIN TRY 
	SET XACT_ABORT, NOCOUNT ON;
	SET @rc = 0;

	IF(EXISTS(SELECT id_group FROM dbo.GroupStudent WHERE id_group = @id_group) AND
		DATEDIFF(day,@date_begin, @date_end)>0)
	BEGIN;
		BEGIN TRAN;
			INSERT INTO  dbo.Attestation(id_attestation,id_group,date_begin, date_end, stat)
					VALUES(@id_attestation,@id_group,@date_begin,@date_end,@stat);
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

IF OBJECT_ID('dbo.AttestationUpdate') IS NOT NULL
BEGIN 
    DROP PROC dbo.AttestationUpdate
END 
GO

CREATE PROC dbo.AttestationUpdate 
	@rc INT OUTPUT,
	@id_attestation INT,	
	@date_begin DATE = NULL, 
	@date_end DATE = NULL
AS 
BEGIN TRY 
	SET XACT_ABORT, NOCOUNT ON;	
	SET @rc = 0;

	DECLARE @d_begin DATE = NULL;
	DECLARE @d_end DATE = NULL;

	SELECT @d_begin= date_begin, @d_end = date_end FROM dbo.Attestation 
	WHERE id_attestation = @id_attestation; 

	IF( (@d_begin IS NOT NULL) AND  (@d_end IS NOT NULL) )
	BEGIN
		IF((@date_begin IS NOT NULL) AND DATEDIFF(day,@date_begin, @d_end)>0)
			BEGIN
				BEGIN TRAN;
				UPDATE dbo.Attestation
				SET date_begin = @date_begin 
				WHERE id_attestation = @id_attestation; 
				COMMIT;
				SET @rc = 1;
			END

		IF((@date_end IS NOT NULL) AND DATEDIFF(day,@d_begin, @date_end)>0)
			BEGIN
				BEGIN TRAN;
				UPDATE dbo.Attestation
				SET date_end = @date_end 
				WHERE id_attestation = @id_attestation; 
				COMMIT;
				SET @rc = 1;
			END
		IF((@date_end IS NOT NULL) AND DATEDIFF(day,@d_begin, @date_end)>0)
			BEGIN
				BEGIN TRAN;
				UPDATE dbo.Attestation
				SET date_end = @date_end 
				WHERE id_attestation = @id_attestation; 
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

------------------

IF OBJECT_ID('dbo.AlterAttestationStatus') IS NOT NULL
BEGIN 
    DROP PROC dbo.AlterAttestationStatus
END 
GO

CREATE PROC dbo.AlterAttestationStatus
	@rc INT OUTPUT,
	@id_attestation INT,
	@date_end_fix DATE 
AS 
BEGIN TRY 
	SET XACT_ABORT, NOCOUNT ON;	
	SET @rc = 0; 
	 
	IF(EXISTS(SELECT id_attestation FROM dbo.Attestation WHERE id_attestation = @id_attestation) )
	BEGIN
		BEGIN TRAN;
			UPDATE dbo.Attestation
			SET stat = 1 
			WHERE id_attestation = @id_attestation; 
		COMMIT;

		DECLARE	@record_book INT,@discipline INT, @teacher INT,@mark INT;
		DECLARE curs CURSOR LOCAL DYNAMIC  
		FOR
		SELECT record_book, discipline, teacher, mark
		FROM dbo.ResultAttestation
		WHERE id_attestation = @id_attestation;

		OPEN curs;
		FETCH NEXT FROM curs   
		INTO   @record_book, @discipline, @teacher, @mark; 
		WHILE @@fetch_status = 0   
		BEGIN
			IF((SELECT type_mark FROM dbo.Mark WHERE id_mark = @mark) = 0)
			BEGIN
				BEGIN TRAN;
					INSERT INTO dbo.ListNotAttestation (id_attestation, record_book, discipline, teacher, mark, date_end)
							VALUES(@id_attestation, @record_book, @discipline, @teacher, NULL, @date_end_fix);
				COMMIT;
			END
		FETCH NEXT FROM curs   
		INTO   @record_book, @discipline, @teacher, @mark; 
		END;
		CLOSE curs;
		SET @rc = 1;
	END
END TRY
BEGIN CATCH
	SET @rc = -1;
	ROLLBACK;
	SELECT ERROR_NUMBER() AS ErrorNumber,ERROR_MESSAGE() AS ErrorMessage;
END CATCH
GO

----------------------------------------------------------------------------------

IF OBJECT_ID('dbo.AttestationDelete') IS NOT NULL
BEGIN 
    DROP PROC dbo.AttestationDelete
END 
GO

CREATE PROC dbo.AttestationDelete 
    @rc INT OUTPUT,
    @id_attestation INT
AS 
BEGIN TRY
	SET XACT_ABORT, NOCOUNT ON;
	SET @rc = 0;

	IF(EXISTS(SELECT id_attestation FROM dbo.Attestation WHERE id_attestation = @id_attestation))
	BEGIN
		BEGIN TRAN;
			DELETE
			FROM dbo.Attestation 
			WHERE id_attestation = @id_attestation;
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
