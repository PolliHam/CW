-----AdditionalInfo

IF OBJECT_ID('dbo.AdditionalInfoByStudent') IS NOT NULL
BEGIN 
    DROP PROC dbo.AdditionalInfoByStudent 
END 
GO

CREATE PROC dbo.AdditionalInfoByStudent
    @record_book INT,
	@academic_year CHAR(9) = NULL
AS 
	SET XACT_ABORT, NOCOUNT ON;
	
	SELECT a.academic_year,s.first_name, s.surname, ISNULL(s.patronymic,'') as patronymic, hostel, orphan_state_support, orphan_with_guardians,
				invalid, lost_parent, incomplete_family, large_family, invalid_parent, victims_of_the_Chernobyl_accident, refugee_family,
				on_internal_control, underachieving_students, create_family, have_children, serious_chronic_disease, activist
	FROM   dbo.AdditionalInfo a	inner join dbo.Student s on a.record_book = s.record_book
	WHERE ( a.record_book = @record_book AND a.academic_year = @academic_year) OR (@academic_year IS NULL);
GO

exec dbo.AdditionalInfoByStudent 71600135;


IF OBJECT_ID('dbo.AdditionalInfoByGroup') IS NOT NULL
BEGIN 
    DROP PROC dbo.AdditionalInfoByGroup 
END 
GO

CREATE PROC dbo.AdditionalInfoByGroup
    @course INT,
	@group INT,
	@academic_year CHAR(9)
AS 
	SET XACT_ABORT, NOCOUNT ON;
	
	SELECT s.first_name, s.surname, ISNULL(s.patronymic,'') as patronymic, hostel, orphan_state_support, orphan_with_guardians,
				invalid, lost_parent, incomplete_family, large_family, invalid_parent, victims_of_the_Chernobyl_accident, refugee_family,
				on_internal_control, underachieving_students, create_family, have_children, serious_chronic_disease, activist
	FROM   dbo.AdditionalInfo a	inner join dbo.Student s on a.record_book = s.record_book
								inner join dbo.GroupStudent g on s.id_group = g.id_group
	WHERE  g.course = @course AND g.group_number = @group AND g.disband = 0 AND a.academic_year = @academic_year;
GO

exec dbo.AdditionalInfoByGroup 3,5, '2017/2018';

IF OBJECT_ID('dbo.AdditionalInfoByIdGroup') IS NOT NULL
BEGIN 
    DROP PROC dbo.AdditionalInfoByIdGroup 
END 
GO

CREATE PROC dbo.AdditionalInfoByIdGroup
    @id_group  NVARCHAR(15),
	@academic_year CHAR(9)
AS 
	SET XACT_ABORT, NOCOUNT ON;
	
	SELECT s.first_name, s.surname, ISNULL(s.patronymic,'') as patronymic, hostel, orphan_state_support, orphan_with_guardians,
				invalid, lost_parent, incomplete_family, large_family, invalid_parent, victims_of_the_Chernobyl_accident, refugee_family,
				on_internal_control, underachieving_students, create_family, have_children, serious_chronic_disease, activist
	FROM   dbo.AdditionalInfo a	inner join dbo.Student s on a.record_book = s.record_book
								inner join dbo.GroupStudent g on s.id_group = g.id_group
	WHERE  LOWER(g.id_group) like ('%'+LOWER(@id_group)+'%') AND a.academic_year = @academic_year ;
GO

exec dbo.AdditionalInfoByIdGroup '16/20ฯฮศา5', '2017/2018';

-----------------------------------------------------------

IF OBJECT_ID('dbo.AdditionalInfoInsert') IS NOT NULL
BEGIN 
    DROP PROC dbo.AdditionalInfoInsert 
END 
GO

CREATE PROC dbo.AdditionalInfoInsert  
	@rc INT OUTPUT,
    @record_book INT,
	@academic_year CHAR(9),
	@hostel BIT = 0,
	@orphan_state_support BIT = 0,
	@orphan_with_guardians BIT = 0,
	@invalid BIT = 0,
	@lost_parent BIT  = 0,
	@incomplete_family BIT = 0,
	@large_family  BIT = 0,
	@invalid_parent BIT = 0,
	@victims_of_the_Chernobyl_accident BIT = 0,
	@refugee_family BIT = 0,
	@on_internal_control BIT = 0,
	@underachieving_students BIT = 0,
	@create_family BIT = 0,
	@have_children BIT = 0,
	@serious_chronic_disease BIT = 0,
	@activist BIT = 0 	
AS 
BEGIN TRY
	SET XACT_ABORT, NOCOUNT ON;
	SET @rc = 0;
	
	IF(	EXISTS(SELECT record_book FROM dbo.Student WHERE record_book = @record_book) AND NOT
		EXISTS(SELECT record_book FROM dbo.AdditionalInfo WHERE record_book = @record_book AND academic_year = @academic_year)  )
	BEGIN
		BEGIN TRAN;
			INSERT INTO  dbo.AdditionalInfo(academic_year,record_book, hostel, orphan_state_support ,orphan_with_guardians, invalid,
			lost_parent,incomplete_family,large_family,invalid_parent,victims_of_the_Chernobyl_accident,refugee_family,
			on_internal_control,underachieving_students,create_family,have_children,serious_chronic_disease,activist)
				VALUES (@academic_year,@record_book, @hostel, @orphan_state_support,@orphan_with_guardians, @invalid,
			@lost_parent, @incomplete_family,@large_family,@invalid_parent,@victims_of_the_Chernobyl_accident,@refugee_family,
			@on_internal_control,@underachieving_students,@create_family,@have_children,@serious_chronic_disease,@activist);
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
EXEC dbo.AdditionalInfoInsert  @a OUT,71600135, '2016/2017'; 
select @a;

------------------------------------------------------------------------------

IF OBJECT_ID('dbo.AdditionalInfoUpdate') IS NOT NULL
BEGIN 
    DROP PROC dbo.AdditionalInfoUpdate 
END 
GO

CREATE PROC dbo.AdditionalInfoUpdate  
	@rc INT OUTPUT,
    @record_book INT,
	@academic_year CHAR(9),
	@hostel BIT = NULL,
	@orphan_state_support BIT = NULL,
	@orphan_with_guardians BIT = NULL,
	@invalid BIT = NULL,
	@lost_parent BIT  = NULL,
	@incomplete_family BIT = NULL,
	@large_family  BIT = NULL,
	@invalid_parent BIT = NULL,
	@victims_of_the_Chernobyl_accident BIT = NULL,
	@refugee_family BIT = NULL,
	@on_internal_control BIT = NULL,
	@underachieving_students BIT = NULL,
	@create_family BIT = NULL,
	@have_children BIT = NULL,
	@serious_chronic_disease BIT = NULL,
	@activist BIT = NULL 		
AS 
BEGIN TRY
	SET XACT_ABORT, NOCOUNT ON;
	SET @rc = 0;
	
	IF(	EXISTS(SELECT record_book FROM dbo.AdditionalInfo WHERE record_book = @record_book AND academic_year = @academic_year ))
	BEGIN	
		IF(@hostel IS NOT NULL)
		BEGIN
			BEGIN TRAN;
			UPDATE dbo.AdditionalInfo SET hostel = @hostel WHERE record_book = @record_book AND academic_year = @academic_year;
			COMMIT;
			SET @rc = 1;
		END	

		IF(@orphan_state_support IS NOT NULL)
		BEGIN
			BEGIN TRAN;
			UPDATE dbo.AdditionalInfo SET orphan_state_support = @orphan_state_support 
			WHERE record_book = @record_book AND academic_year = @academic_year;
			COMMIT;
			SET @rc = 1;
		END	

		IF(@orphan_with_guardians IS NOT NULL)
		BEGIN
			BEGIN TRAN;
			UPDATE dbo.AdditionalInfo SET orphan_with_guardians = @orphan_with_guardians 
			WHERE record_book = @record_book AND academic_year = @academic_year;
			COMMIT;
			SET @rc = 1;
		END	

		IF(@invalid IS NOT NULL)
		BEGIN
			BEGIN TRAN;
			UPDATE dbo.AdditionalInfo SET invalid = @invalid WHERE record_book = @record_book AND academic_year = @academic_year;
			COMMIT;
			SET @rc = 1;
		END	

		IF(@lost_parent IS NOT NULL)
		BEGIN
			BEGIN TRAN;
			UPDATE dbo.AdditionalInfo SET lost_parent = @lost_parent WHERE record_book = @record_book AND academic_year = @academic_year;
			COMMIT;
			SET @rc = 1;
		END	

		IF(@incomplete_family IS NOT NULL)
		BEGIN
			BEGIN TRAN;
			UPDATE dbo.AdditionalInfo SET incomplete_family = @incomplete_family
			WHERE record_book = @record_book AND academic_year = @academic_year;
			COMMIT;
			SET @rc = 1;
		END	

		IF(@large_family IS NOT NULL)
		BEGIN
			BEGIN TRAN;
			UPDATE dbo.AdditionalInfo SET large_family = @large_family WHERE record_book = @record_book AND academic_year = @academic_year;
			COMMIT;
			SET @rc = 1;
		END	

		IF(@invalid_parent IS NOT NULL)
		BEGIN
			BEGIN TRAN;
			UPDATE dbo.AdditionalInfo SET invalid_parent = @invalid_parent WHERE record_book = @record_book AND academic_year = @academic_year;
			COMMIT;
			SET @rc = 1;
		END	

		IF(@victims_of_the_Chernobyl_accident IS NOT NULL)
		BEGIN
			BEGIN TRAN;
			UPDATE dbo.AdditionalInfo SET victims_of_the_Chernobyl_accident = @victims_of_the_Chernobyl_accident
			WHERE record_book = @record_book AND academic_year = @academic_year;
			COMMIT;
			SET @rc = 1;
		END	

		IF((@refugee_family IS NULL))
		BEGIN
			BEGIN TRAN;
			UPDATE dbo.AdditionalInfo SET refugee_family = @refugee_family WHERE record_book = @record_book AND academic_year = @academic_year;
			COMMIT;
			SET @rc = 1;
		END

		IF(@on_internal_control IS NOT NULL)
		BEGIN
			BEGIN TRAN;
			UPDATE dbo.AdditionalInfo SET on_internal_control = @on_internal_control 
			WHERE record_book = @record_book AND academic_year = @academic_year;
			COMMIT;
			SET @rc = 1;
		END
	
		IF(@underachieving_students IS NOT NULL)
		BEGIN
			BEGIN TRAN;
			UPDATE dbo.AdditionalInfo SET underachieving_students = @underachieving_students 
			WHERE record_book = @record_book AND academic_year = @academic_year;
			COMMIT;
			SET @rc = 1;
		END

		IF(@create_family IS NOT NULL)
		BEGIN
			BEGIN TRAN;
			UPDATE dbo.AdditionalInfo SET create_family = @create_family WHERE record_book = @record_book AND academic_year = @academic_year;
			COMMIT;
			SET @rc = 1;
		END

		IF(NOT (@have_children IS NULL))
		BEGIN
			BEGIN TRAN;
			UPDATE dbo.AdditionalInfo SET have_children = @have_children WHERE record_book = @record_book AND academic_year = @academic_year;
			COMMIT;
			SET @rc = 1;
		END

		IF(@serious_chronic_disease IS NOT NULL)
		BEGIN
			BEGIN TRAN;
			UPDATE dbo.AdditionalInfo SET serious_chronic_disease = @serious_chronic_disease 
			WHERE record_book = @record_book AND academic_year = @academic_year;
			COMMIT;
			SET @rc = 1;
		END

		IF(@activist IS NOT NULL)
		BEGIN
			BEGIN TRAN;
			UPDATE dbo.AdditionalInfo SET activist = @activist WHERE record_book = @record_book AND academic_year = @academic_year;
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
EXEC dbo.AdditionalInfoUpdate @a OUT, 71600135,'2016/2017', @hostel=1; 
select @a;
---------------------------------------------------------------------------------------------

IF OBJECT_ID('dbo.AdditionalInfoDelete') IS NOT NULL
BEGIN 
    DROP PROC dbo.AdditionalInfoDelete
END 
GO

CREATE PROC dbo.AdditionalInfoDelete 
    @rc INT OUTPUT,
	@record_book INT,
	@academic_year CHAR(9)
AS 
BEGIN TRY
	SET XACT_ABORT, NOCOUNT ON;
	SET @rc = 0;
	IF(	EXISTS(SELECT record_book FROM dbo.AdditionalInfo WHERE record_book = @record_book AND academic_year = @academic_year ))
	BEGIN	
		BEGIN TRAN;
			DELETE
			dbo.AdditionalInfo WHERE record_book = @record_book AND academic_year = @academic_year ;
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
