-----ResultAttestation

IF OBJECT_ID('dbo.ResultAttestationByNumber') IS NOT NULL
BEGIN 
    DROP PROC dbo.ResultAttestationByNumber 
END 
GO

CREATE PROC dbo.ResultAttestationByNumber
    @id_attestation INT
AS 
	SET XACT_ABORT, NOCOUNT ON;
	SELECT s.first_name, s.surname, ISNULL(s.patronymic,'') as patronymic, d.short_name as discipline, r.form, m.name as mark, r.hours_absent, t.short_fio as teacher 
		FROM   dbo.ResultAttestation r  inner join dbo.Student s on r.record_book = s.record_book
										inner join dbo.Mark m on r.mark = m.id_mark
										inner join dbo.Discipline d on r.discipline = d.id_disc
										inner join dbo.Teacher t on r.teacher = t.id_teach
		WHERE  r.id_attestation =  @id_attestation;
GO

exec dbo.ResultAttestationByNumber 1;
------------------------------------------------------------

IF OBJECT_ID('dbo.ResultAttestationByStydent') IS NOT NULL
BEGIN 
    DROP PROC dbo.ResultAttestationByStydent
END 
GO

CREATE PROC dbo.ResultAttestationByStydent
	@record_book INT,
    @id_attestation INT = NULL
AS 
	SET XACT_ABORT, NOCOUNT ON;
	SELECT a.date_begin, a.date_end, d.short_name, r.form, m.name as mark, r.hours_absent, t.short_fio 
		FROM   dbo.ResultAttestation r  inner join dbo.Attestation a on r.id_attestation = a.id_attestation
										inner join dbo.Student s on r.record_book = s.record_book
										inner join dbo.Mark m on r.mark = m.id_mark
										inner join dbo.Discipline d on r.discipline = d.id_disc
										inner join dbo.Teacher t on r.teacher = t.id_teach
		WHERE r.record_book=@record_book AND ( r.id_attestation =  @id_attestation OR (@id_attestation IS NULL))
GO
------------------------------------------------------------------


IF OBJECT_ID('dbo.ResultAttestationInsert') IS NOT NULL
BEGIN 
    DROP PROC dbo.ResultAttestationInsert 
END 
GO

CREATE PROC dbo.ResultAttestationInsert 
	@rc INT OUTPUT,
    @id_attestation INT ,	
	@record_book INT ,
	@discipline NVARCHAR(10) ,
	@teacher INT,
	@mark  NVARCHAR(15),										
	@hours_absent INT ,
	@form NCHAR(2) 			 
	
AS 
BEGIN TRY
	SET XACT_ABORT, NOCOUNT ON;
	SET @rc = 0;

	DECLARE @id_mark INT = -1;
	SELECT @id_mark = id_mark FROM dbo.Mark WHERE LOWER(name) like LOWER(@mark);

	DECLARE @id_disc INT = -1;
	SELECT @id_disc = id_disc FROM dbo.Discipline WHERE LOWER(short_name) like LOWER(@discipline);

	IF( EXISTS(SELECT id_attestation FROM dbo.ResultAttestation WHERE id_attestation = @id_attestation) AND
		EXISTS(SELECT record_book FROM dbo.Student WHERE record_book = @record_book) AND 
		EXISTS(SELECT id_teach FROM dbo.Teacher WHERE id_teach = @teacher) AND
		@id_mark != -1 AND @id_disc != -1 AND @hours_absent >=0 AND @form IN('ËÇ','ÏÇ','ÊÏ','ëç','ïç','êï') AND
		(SELECT id_group FROM dbo.Attestation WHERE id_attestation = @id_attestation)=(SELECT id_group FROM dbo.Student WHERE record_book = @record_book))
	BEGIN
		BEGIN TRAN;
			INSERT INTO  dbo.ResultAttestation (id_attestation, record_book, discipline, teacher, mark, hours_absent, form)
					VALUES( @id_attestation, @record_book, @id_disc, @teacher, @id_mark, @hours_absent, @form);
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

------------------------------------------------------------------------------

IF OBJECT_ID('dbo.ResultAttestationUpdate') IS NOT NULL
BEGIN 
    DROP PROC dbo.ResultAttestationUpdate
END 
GO

CREATE PROC dbo.ResultAttestationUpdate 
	@rc INT OUTPUT,
    @id_attestation INT ,	
	@record_book INT ,
	@discipline NVARCHAR(10) ,
	@teacher INT = NULL,
	@mark NVARCHAR(15) = NULL,										
	@hours_absent INT = NULL	
AS 
BEGIN TRY
	SET XACT_ABORT, NOCOUNT ON;
	SET @rc = 0;

	DECLARE @id_disc INT = -1;
	SELECT @id_disc = id_disc FROM dbo.Discipline WHERE LOWER(short_name) like LOWER(@discipline);

	IF(@id_disc!=-1 AND EXISTS(SELECT id_attestation FROM dbo.ResultAttestation WHERE id_attestation = @id_attestation AND record_book = @record_book AND discipline = @id_disc))
	BEGIN
		IF((@teacher IS NOT NULL) AND EXISTS(SELECT id_teach FROM dbo.Teacher WHERE id_teach = @teacher))
		BEGIN 
			BEGIN TRAN;
				UPDATE dbo.ResultAttestation
				SET teacher = @teacher
				WHERE id_attestation = @id_attestation AND record_book = @record_book AND discipline = @id_disc;
			COMMIT;
			SET @rc = 1;
		END	

		DECLARE @id_mark INT = -1;
		SELECT @id_mark = id_mark FROM dbo.Mark WHERE LOWER(name) like LOWER(@mark);

		IF(@id_mark !=-1)
		BEGIN 
			BEGIN TRAN;
				UPDATE dbo.ResultAttestation
				SET mark = @id_mark
				WHERE id_attestation = @id_attestation AND record_book = @record_book AND discipline = @id_disc;
			COMMIT;
			SET @rc = 1;
		END		
		
		IF((@hours_absent IS NOT NULL) AND @hours_absent >0)
		BEGIN 
			BEGIN TRAN;
				UPDATE dbo.ResultAttestation
				SET hours_absent = @hours_absent
				WHERE id_attestation = @id_attestation AND record_book = @record_book AND discipline = @id_disc;
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


----------------------------------------------------------------------

IF OBJECT_ID('dbo.ResultAttestationDelete') IS NOT NULL
BEGIN 
    DROP PROC dbo.ResultAttestationDelete
END 
GO

CREATE PROC dbo.ResultAttestationDelete 
    @rc INT OUTPUT,
    @id_attestation INT ,	
	@record_book INT ,
	@discipline NVARCHAR(10)
AS 
BEGIN TRY
	SET XACT_ABORT, NOCOUNT ON;
	SET @rc = 0;
	DECLARE @id_disc INT = -1;
	SELECT @id_disc = id_disc FROM dbo.Discipline WHERE LOWER(short_name) like LOWER(@discipline);

	IF(@id_disc!=-1 AND EXISTS(SELECT id_attestation FROM dbo.ResultAttestation WHERE id_attestation = @id_attestation AND record_book = @record_book AND discipline = @id_disc))
	BEGIN
		BEGIN TRAN;
			DELETE
			FROM  dbo.ResultAttestation 
			WHERE id_attestation = @id_attestation AND record_book = @record_book AND discipline = @id_disc;
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



