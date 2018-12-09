----GroupStudent

IF OBJECT_ID('dbo.GetGroupById') IS NOT NULL
BEGIN 
    DROP PROC dbo.GetGroupById
END 
GO

CREATE PROC dbo.GetGroupById
	@id NVARCHAR(15)
AS 
	SET XACT_ABORT, NOCOUNT ON;
		SELECT id_group, course, group_number,s.short_name, begin_learning, end_learning, disband
		FROM dbo.GroupStudent g inner join dbo.Speciality s on g.kod_special=s.kod_special
		WHERE  LOWER(g.id_group) like('%'+ LOWER(@id) + '%') ;
GO

exec dbo.GetGroupById '16/20ฯฮศา5';
-------------------------------------

IF OBJECT_ID('dbo.GetGroupByCourse') IS NOT NULL
BEGIN 
    DROP PROC dbo.GetGroupByCourse
END 
GO

CREATE PROC dbo.GetGroupByCourse
	@course INT
AS 
	SET XACT_ABORT, NOCOUNT ON;
		SELECT  id_group, course, group_number,s.short_name, begin_learning, end_learning, disband
		FROM dbo.GroupStudent g inner join dbo.Speciality s on g.kod_special=s.kod_special
		WHERE  g.course =@course;
GO
-------------------------------------

IF OBJECT_ID('dbo.GetGroupByCourseNum') IS NOT NULL
BEGIN 
    DROP PROC dbo.GetGroupByCourseNum
END 
GO

CREATE PROC dbo.GetGroupByCourseNum
	@course INT,
	@number INT
AS 
	SET XACT_ABORT, NOCOUNT ON;
		SELECT id_group, course, group_number,s.short_name, begin_learning, end_learning, disband
		FROM dbo.GroupStudent g inner join dbo.Speciality s on g.kod_special=s.kod_special
		WHERE  g.course =@course AND g.group_number = @number;
GO
-------------------------------------

IF OBJECT_ID('dbo.GetGroupIdByCourseNum') IS NOT NULL
BEGIN 
    DROP PROC dbo.GetGroupIdByCourseNum
END 
GO

CREATE PROC dbo.GetGroupIdByCourseNum
	@course INT,
	@number INT,
	@id NVARCHAR(15) OUTPUT
AS 
	SET XACT_ABORT, NOCOUNT ON;
		SELECT @id = id_group
		FROM dbo.GroupStudent
		WHERE  course = @course AND group_number = @number;
GO
-------------------------------------

IF OBJECT_ID('dbo.GetNotDisbandGroup') IS NOT NULL
BEGIN 
    DROP PROC dbo.GetNotDisbandGroup
END 
GO

CREATE PROC dbo.GetNotDisbandGroup
AS 
	SET XACT_ABORT, NOCOUNT ON;
		SELECT id_group, course, group_number,s.short_name, begin_learning, end_learning, disband
		FROM dbo.GroupStudent g inner join dbo.Speciality s on g.kod_special=s.kod_special
		WHERE g.disband=0;
GO
-------------------------------------

IF OBJECT_ID('dbo.GetDisbandGroup') IS NOT NULL
BEGIN 
    DROP PROC dbo.GetDisbandGroup
END 
GO

CREATE PROC dbo.GetDisbandGroup
AS 
	SET XACT_ABORT, NOCOUNT ON;
		SELECT id_group, course, group_number,s.short_name, begin_learning, end_learning, disband
		FROM dbo.GroupStudent g inner join dbo.Speciality s on g.kod_special=s.kod_special
		WHERE g.disband=1;
GO
-----------------------------------------------------------------------------


IF OBJECT_ID('dbo.GroupInsert') IS NOT NULL
BEGIN 
    DROP PROC dbo.GroupInsert
END 
GO

CREATE PROC dbo.GroupInsert
	@rc INT OUTPUT,
	@id NVARCHAR(15),
	@course INT = 1,
	@group_number INT,
	@special  NVARCHAR(10),
	@begin_learning DATE ,
	@end_learning DATE,
	@disband BIT =  0	
AS 
BEGIN TRY
	SET @rc = 0;
	SET XACT_ABORT, NOCOUNT ON;
	IF EXISTS(SELECT kod_special FROM dbo.Speciality WHERE LOWER(short_name) like LOWER(@special))
	BEGIN
		DECLARE @kod NVARCHAR(13);
		SELECT @kod=kod_special FROM dbo.Speciality WHERE LOWER(short_name) like LOWER(@special);
		BEGIN TRAN;
			INSERT INTO dbo.GroupStudent(id_group,course,group_number, kod_special, begin_learning, end_learning, disband)
				VALUES(@id,@course,@group_number, @kod, @begin_learning, @end_learning, @disband);
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
--------------------------------------------------------------------------------

IF OBJECT_ID('dbo.GroupDisbandUpdate') IS NOT NULL
BEGIN 
    DROP PROC dbo.GroupDisbandUpdate
END 
GO

CREATE PROC dbo.GroupDisbandUpdate
	@rc INT OUTPUT,
	@id NVARCHAR(15),
	@disband BIT	
AS 
BEGIN TRY
	SET XACT_ABORT, NOCOUNT ON;
	BEGIN TRAN;
		UPDATE dbo.GroupStudent	SET disband = @disband WHERE id_group= @id;
	COMMIT;
END TRY
BEGIN CATCH
	ROLLBACK;
	SELECT ERROR_NUMBER() AS ErrorNumber,ERROR_MESSAGE() AS ErrorMessage;
END CATCH
GO


IF OBJECT_ID('dbo.GroupCourseUpdate') IS NOT NULL
BEGIN 
    DROP PROC dbo.GroupCourseUpdate
END 
GO

CREATE PROC dbo.GroupCourseUpdate
	@id NVARCHAR(15),
	@course INT	
AS 
BEGIN TRY
	SET XACT_ABORT, NOCOUNT ON;
	IF(@course>0 AND @course<5)
	BEGIN
		BEGIN TRAN;
			UPDATE dbo.GroupStudent	SET course = @course WHERE id_group= @id;
		COMMIT;
	END
END TRY
BEGIN CATCH
	ROLLBACK;
	SELECT ERROR_NUMBER() AS ErrorNumber,ERROR_MESSAGE() AS ErrorMessage;
END CATCH
GO
----------------------------------------------------------------------------

IF OBJECT_ID('dbo.GroupDelete') IS NOT NULL
BEGIN 
    DROP PROC dbo.GroupDelete
END 
GO

CREATE PROC dbo.GroupDelete
	@id NVARCHAR(15)
AS 
BEGIN TRY
	SET XACT_ABORT, NOCOUNT ON;
	BEGIN TRAN;
		DELETE 
		FROM dbo.GroupStudent
		WHERE id_group= @id;
	COMMIT;
END TRY
BEGIN CATCH
	SELECT ERROR_NUMBER() AS ErrorNumber,ERROR_MESSAGE() AS ErrorMessage;
END CATCH


