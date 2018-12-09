------ListNotAttestation

IF OBJECT_ID('dbo.CurentNotAttestation') IS NOT NULL
BEGIN 
    DROP PROC dbo.CurentNotAttestation 
END 
GO

CREATE PROC dbo.CurentNotAttestation
AS 
	SET XACT_ABORT, NOCOUNT ON;
	
	SELECT g.course, g.group_number, s.first_name, s.surname, ISNULL(s.patronymic,'') as patronymic, d.short_name as discipline,
			ISNULL(m.name,'') as mark, t.short_fio  
	FROM   dbo.ListNotAttestation l inner join dbo.Student s on l.record_book = s.record_book
									inner join dbo.Discipline d on l.discipline = d.id_disc
									inner join dbo.Teacher t on l.teacher = t.id_teach
									inner join dbo.GroupStudent g on s.id_group = g.id_group
									left outer join dbo.Mark m on l.mark = m.id_mark
	WHERE l.date_end<=GETDATE();
GO

exec dbo.CurentNotAttestation;
----------------------------------------

IF OBJECT_ID('dbo.CurentNotAttestationByIdGroup') IS NOT NULL
BEGIN 
    DROP PROC dbo.CurentNotAttestationByIdGroup 
END 
GO

CREATE PROC dbo.CurentNotAttestationByIdGroup
    @id_group  NVARCHAR(15)
AS 
	SET XACT_ABORT, NOCOUNT ON;
	SELECT s.first_name, s.surname, ISNULL(s.patronymic,'') as patronymic, d.short_name as discipline,
			ISNULL(m.name,'') as mark, t.short_fio  
	FROM   dbo.ListNotAttestation l inner join dbo.Student s on l.record_book = s.record_book
									inner join dbo.Discipline d on l.discipline = d.id_disc
									inner join dbo.Teacher t on l.teacher = t.id_teach
									inner join dbo.GroupStudent g on s.id_group = g.id_group
									left outer join dbo.Mark m on l.mark = m.id_mark
	WHERE  LOWER(s.id_group) like ('%'+LOWER(@id_group)+'%') AND l.date_end<=GETDATE();
GO

exec CurentNotAttestationByIdGroup '16/20ฯฮศา5';

-----------------------------------------------------------------
IF OBJECT_ID('dbo.CurenNotAttestationByGroupNum') IS NOT NULL
BEGIN 
    DROP PROC dbo.CurenNotAttestationByGroupNum 
END 
GO

CREATE PROC dbo.CurenNotAttestationByGroupNum
    @course INT,
	@group INT
AS 
	SET XACT_ABORT, NOCOUNT ON;
	DECLARE @id  NVARCHAR(15) = NULL;
	EXEC dbo.GetGroupIdByCourseNum @course, @group, @id OUT;
	IF(@id IS NOT NULL)
		EXEC dbo.CurentNotAttestationByIdGroup @id;
GO

-----------------------------------------------------------------
IF OBJECT_ID('dbo.NotAttestationById') IS NOT NULL
BEGIN 
    DROP PROC dbo.NotAttestationById 
END 
GO

CREATE PROC dbo.NotAttestationById
    @id_attestation INT
AS 
	SELECT s.first_name, s.surname, ISNULL(s.patronymic,'') as patronymic, d.short_name as discipline,
			ISNULL(m.name,'') as mark, t.short_fio  
	FROM   dbo.ListNotAttestation l inner join dbo.Student s on l.record_book = s.record_book
									inner join dbo.Discipline d on l.discipline = d.id_disc
									inner join dbo.Teacher t on l.teacher = t.id_teach
									left outer join dbo.Mark m on l.mark = m.id_mark
	WHERE l.id_attestation = @id_attestation;
GO

-----------------------------------------------------------------
IF OBJECT_ID('dbo.NotFixAttestationById') IS NOT NULL
BEGIN 
    DROP PROC dbo.NotFixAttestationById 
END 
GO

CREATE PROC dbo.NotFixAttestationById
    @id_attestation INT
AS 
	SELECT s.first_name, s.surname, ISNULL(s.patronymic,'') as patronymic, d.short_name as discipline,
			ISNULL(m.name,'') as mark, t.short_fio  
	FROM   dbo.ListNotAttestation l inner join dbo.Student s on l.record_book = s.record_book
									inner join dbo.Discipline d on l.discipline = d.id_disc
									inner join dbo.Teacher t on l.teacher = t.id_teach
									left outer join dbo.Mark m on l.mark = m.id_mark
	WHERE l.id_attestation = @id_attestation AND l.mark IS NULL;
GO
--------------------------------------------------------------------------------


IF OBJECT_ID('dbo.NotAttestationUpdateMark') IS NOT NULL
BEGIN 
    DROP PROC dbo.NotAttestationUpdateMark
END 
GO

CREATE PROC dbo.NotAttestationUpdateMark
	@rc INT OUTPUT,
	@id_attestation INT,
	@record_book INT,
	@discipline NVARCHAR(10),
	@mark NVARCHAR(15)
AS 
BEGIN TRY 
	SET XACT_ABORT, NOCOUNT ON;	
	SET @rc = 0;
	
	DECLARE @id_disc INT = -1;
	SELECT @id_disc = id_disc FROM dbo.Discipline WHERE LOWER(short_name) like LOWER(@discipline);
	
	DECLARE @id_mark INT = -1;
	SELECT @id_mark = id_mark FROM dbo.Mark WHERE LOWER(name) like LOWER(@mark);

	IF(@id_mark !=-1 AND @id_disc !=-1 AND EXISTS(SELECT id_attestation FROM dbo.ListNotAttestation WHERE id_attestation = @id_attestation AND record_book = @record_book AND discipline = @id_disc))
	BEGIN
		BEGIN TRAN;
			UPDATE dbo.ListNotAttestation
			SET mark = @id_mark
			WHERE id_attestation = @id_attestation AND record_book = @record_book AND discipline = @id_disc;
		COMMIT;
	END
END TRY
BEGIN CATCH
	SET @rc = -1;
	ROLLBACK;
	SELECT ERROR_NUMBER() AS ErrorNumber,ERROR_MESSAGE() AS ErrorMessage;
END CATCH
GO

----------------------------------------------------------------------------------

IF OBJECT_ID('dbo.NotAttestationDelete') IS NOT NULL
BEGIN 
    DROP PROC dbo.NotAttestationDelete
END 
GO

CREATE PROC dbo.NotAttestationDelete 
    @rc INT OUTPUT,
	@id_attestation INT,
	@record_book INT,
	@discipline NVARCHAR(10)
AS 
BEGIN TRY
	SET XACT_ABORT, NOCOUNT ON;
	SET @rc = 0;

	DECLARE @id_disc INT = -1;
	SELECT @id_disc = id_disc FROM dbo.Discipline WHERE LOWER(short_name) like LOWER(@discipline);
	
	IF(@id_disc !=-1 AND EXISTS(SELECT id_attestation FROM dbo.ListNotAttestation WHERE id_attestation = @id_attestation AND record_book = @record_book AND discipline = @id_disc))
	BEGIN
		BEGIN TRAN;
			DELETE
			FROM dbo.ListNotAttestation
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
