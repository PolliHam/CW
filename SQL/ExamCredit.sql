-----ExamCredit

IF OBJECT_ID('dbo.ExamCreditByNumber') IS NOT NULL
BEGIN 
    DROP PROC dbo.ExamCreditByNumber 
END 
GO

CREATE PROC dbo.ExamCreditByNumber
    @number VARCHAR(10) 
AS 
	SET XACT_ABORT, NOCOUNT ON;
		SELECT e.number_statement,a.name, e.date_sig, d.full_name, g.course, g.group_number, 
			sp.short_name, t1.full_fio as teacher_1 , ISNULL(t2.full_fio,'-') as teacher_2, ISNULL(t3.full_fio,'-') as teacher_3  
		FROM   dbo.ExamCredit e inner join dbo.Attribute a on e.attribute = a.id_atr
									inner join dbo.Discipline d on e.discipline  = d.id_disc
									inner join dbo.GroupStudent g on e.id_group = g.id_group  
									inner join dbo.Speciality sp on g.kod_special = sp.kod_special
									inner join dbo.Teacher t1 on e.teacher_1 = t1.id_teach
									left outer join dbo.Teacher t2 on e.teacher_2 = t2.id_teach
									left outer join dbo.Teacher t3 on e.teacher_3 = t3.id_teach
		WHERE  e.number_statement like ('%'+ @number +'%');
GO

exec dbo.ExamCreditByNumber '7-21/551';
------------------------------------------------------------

IF OBJECT_ID('dbo.ExamCreditInsert') IS NOT NULL
BEGIN 
    DROP PROC dbo.ExamCreditInsert 
END 
GO

CREATE PROC dbo.ExamCreditInsert 
	@rc INT OUTPUT,
    @number_statement VARCHAR(10),
	@attribute_name NVARCHAR(15),
	@date_sig DATE,
	@disc_short_name NVARCHAR(10),
	@id_group  NVARCHAR(15),
	@teacher_1 INT,
	@teacher_2 INT = NULL,
	@teacher_3 INT = NULL
AS 
BEGIN TRY
	SET XACT_ABORT, NOCOUNT ON;
	SET @rc = 0;

	DECLARE @id_atr INT = 0;
	SELECT @id_atr = id_atr FROM dbo.Attribute WHERE LOWER(name) like LOWER(@attribute_name)

	DECLARE @id_discipline INT = 0;
	SELECT @id_discipline = id_disc FROM dbo.Discipline WHERE LOWER(short_name) like LOWER(@disc_short_name);

	DECLARE @id_g NVARCHAR(15) = '';
	SELECT  @id_g = id_group FROM dbo.GroupStudent WHERE LOWER(id_group) like LOWER(@id_group);

	IF( EXISTS(SELECT id_teach FROM dbo.Teacher WHERE id_teach=@teacher_1) AND
		@id_g!='' AND @id_atr!=0 AND @id_discipline!=0 AND
		((@teacher_2 IS NULL) OR EXISTS(SELECT id_teach FROM dbo.Teacher WHERE id_teach=@teacher_2)) AND 
		((@teacher_3 IS NULL) OR EXISTS(SELECT id_teach FROM dbo.Teacher WHERE id_teach=@teacher_3)))
	BEGIN
		BEGIN TRAN;
			INSERT INTO  dbo.ExamCredit(number_statement, attribute, date_sig, discipline, id_group, teacher_1, teacher_2, teacher_3)
					VALUES( @number_statement, @id_atr, @date_sig, @id_discipline, @id_g, @teacher_1, @teacher_2, @teacher_3);
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
EXEC dbo.ExamCreditInsert @a OUT,'7-21/552/1','экзамен','2018-09-20','БД','16/20поит5', 1; 
select @a;
------------------------------------------------------------------------------

IF OBJECT_ID('dbo.ExamCreditDelete') IS NOT NULL
BEGIN 
    DROP PROC dbo.ExamCreditDelete
END 
GO

CREATE PROC dbo.ExamCreditDelete 
    @rc INT OUTPUT,
    @number_statement VARCHAR(10)
AS 
BEGIN TRY
	SET XACT_ABORT, NOCOUNT ON;
	SET @rc = 0;
	IF( EXISTS(SELECT number_statement FROM dbo.ExamCredit WHERE number_statement = @number_statement))
	BEGIN
		BEGIN TRAN;
			DELETE
			FROM  dbo.ExamCredit
			WHERE  number_statement = @number_statement;
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
exec dbo.ExamCreditDelete @a out, '7-21/553/1';
select @a;


