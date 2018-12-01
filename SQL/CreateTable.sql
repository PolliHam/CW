use Deanery;
--1 ������������ � ����������
CREATE TABLE Enrollment(
	number VARCHAR(15) NOT NULL,                            --����� ������������
	date_sig DATE NOT NULL,									--���� �������
	signed NVARCHAR(15) NOT NULL,							--��� ��������

	CONSTRAINT PK_EnrollmentNumber PRIMARY KEY (number)
);

--2 ������������ �� ����������
CREATE TABLE Expelled(
	number VARCHAR(15) NOT NULL,							--����� ������������
	date_sig DATE NOT NULL,									--���� �������
	signed NVARCHAR(15) NOT NULL,							--��� ��������

	CONSTRAINT PK_ExpelledNumber PRIMARY KEY (number)
);

--3 ���������� ������ 
CREATE TABLE Mark(
	id_mark INT IDENTITY(0, 1),								--��� ������
	name NVARCHAR(15) NOT NULL,								--������������(0-9, �������)
	type_mark BIT NOT NULL,									--��� (�������������-1, �������������-0)

	CONSTRAINT PK_MarkId PRIMARY KEY (id_mark)
);

--4 ���������� � ��������� � �������
CREATE TABLE Attribute(
	id_atr INT IDENTITY(1, 1),								--��� ��������
	name NVARCHAR(15) NOT NULL,								--������������(�����,�������, ��� �����, ������)

	CONSTRAINT PK_AttributeId PRIMARY KEY (id_atr)
);

--5 ���������� ���������
CREATE TABLE Profession(
	id_prof INT IDENTITY(1, 1),								--��� ���������
	name NVARCHAR(30) UNIQUE NOT NULL,						--������������
	 
	CONSTRAINT PK_ProfessionId PRIMARY KEY (id_prof)
);

--6 �������� ������� ���������
CREATE TABLE Discipline(
	id_disc INT IDENTITY(1, 1),								--��� ����������
	short_name NVARCHAR(10) UNIQUE NOT NULL,				--����������� ��������
	full_name NVARCHAR(50)  UNIQUE NOT NULL,				--������ ��������
	link NVARCHAR(500)										--������ �� �������

	CONSTRAINT PK_DisciplineId PRIMARY KEY (id_disc)
);

--7 �������� ������
CREATE TABLE Pulpit(
	short_name NVARCHAR(10)  NOT NULL,						--����������� ��������
	full_name NVARCHAR(50) UNIQUE  NOT NULL,				--������ ��������
	link NVARCHAR(300)										--������ �� �������

	CONSTRAINT PK_PulpitId PRIMARY KEY (short_name)
);

--8 �������� ���� ��������������
CREATE TABLE Teacher(
	id_teach INT IDENTITY(1, 1),							--��� �������������
	short_fio NVARCHAR(10)  NOT NULL,						--����������� ���
	full_fio NVARCHAR(50)  NOT NULL,						--������ ���
	pulpit NVARCHAR(10),									--�������
	work BIT NOT NULL,										--�������� �� ���(0-���, 1-��)

	CONSTRAINT PK_TeacherId PRIMARY KEY (id_teach),
	CONSTRAINT FK_Teacher_To_Pulpit FOREIGN KEY (pulpit) REFERENCES Pulpit (short_name) ON DELETE SET NULL
);

--9 ��������� ��������� � �������
CREATE TABLE ExamCredit(
	number_statement VARCHAR(10) NOT NULL,					--����� ���������
	attribute INT  NOT NULL,								--�������
	date_sig DATE NOT NULL,									--���� ����������
	discipline INT  NOT NULL,								--��� ����������
	teacher_1 INT NOT NULL,									--��� �������������
	teacher_2 INT DEFAULT NULL,								--��� ������� �������������
	teacher_3 INT DEFAULT NULL,								--��� �������� �������������
	
	CONSTRAINT Pk_ExamCreditNum PRIMARY KEY (number_statement),
	CONSTRAINT FK_ExamCredit_To_Attribute FOREIGN KEY (attribute) REFERENCES  Attribute (id_atr),
	CONSTRAINT FK_ExamCredit_To_Discipline FOREIGN KEY (discipline) REFERENCES Discipline (id_disc),
	CONSTRAINT FK_ExamCredit_To_Teacher1 FOREIGN KEY (teacher_1) REFERENCES Teacher (id_teach),
	CONSTRAINT FK_ExamCredit_To_Teacher2 FOREIGN KEY (teacher_2) REFERENCES Teacher (id_teach),
	CONSTRAINT FK_ExamCredit_To_Teacher3 FOREIGN KEY (teacher_3) REFERENCES Teacher (id_teach)
);

--10 ������ ��������
CREATE TABLE District(
	id_distr INT IDENTITY(1, 1),							--��� �������
	name NVARCHAR(12)  UNIQUE,								--������������

	CONSTRAINT PK_DistrictId PRIMARY KEY (id_distr)
);

--11 �������� �������
CREATE TABLE Region(
	id_reg INT IDENTITY(1, 1),								--��� �������
	name NVARCHAR(20),										--������������
	district INT,											--�������

	CONSTRAINT PK_RegionId PRIMARY KEY (id_reg),			
	CONSTRAINT FK_Region_To_District FOREIGN KEY (district) REFERENCES District (id_distr)
);

--12 ���������� ��� ������� (��� ������)
CREATE TABLE TypeAddress(
	id_type INT IDENTITY(1, 1),								--��� ����
	name_type NVARCHAR(30) UNIQUE NOT NULL,					--������������ ����

	CONSTRAINT PK_TypeAddressId PRIMARY KEY (id_type)
);

--13 �������� ��������� ��
CREATE TABLE SubjectCT(
	id_subj INT IDENTITY(1, 1),								--��� ��������
	name NVARCHAR(20) UNIQUE NOT NULL,						--������������	
									
	CONSTRAINT PK_SubjectCTId PRIMARY KEY (id_subj)
);

--14 �������� ��������������
CREATE TABLE Speciality(
	kod_special NVARCHAR(13) NOT NULL,						--��� �������������
	short_name NVARCHAR(10) UNIQUE  NOT NULL,				--����������� ��������
	full_name NVARCHAR(90) UNIQUE  NOT NULL,				--������ ��������
	specialization NVARCHAR(35)  NOT NULL,					--�������������
	subject_lenguage1 INT NOT NULL ,						--������� �� ����
	subject_lenguage2 INT NOT NULL ,						--������� �� ����
	subject_2 INT NOT NULL,									--������� �� (���������)
	subject_3 INT NOT NULL,									--������� ��
	
	CONSTRAINT PK_SpecialityId PRIMARY KEY (kod_special),
	CONSTRAINT FK_SpecialityLen1_To_SubjectCT FOREIGN KEY (subject_lenguage1) REFERENCES SubjectCT (id_subj),
	CONSTRAINT FK_SpecialityLen2_To_SubjectCT FOREIGN KEY (subject_lenguage2) REFERENCES SubjectCT (id_subj),
	CONSTRAINT FK_Speciality2_To_SubjectCT FOREIGN KEY (subject_2) REFERENCES SubjectCT (id_subj),
	CONSTRAINT FK_Speciality3_To_SubjectCT FOREIGN KEY (subject_3) REFERENCES SubjectCT (id_subj)
);


--15 ������ �����
CREATE TABLE GroupStudent(
	id_group  NVARCHAR(15) NOT NULL,						--��� ������
	course INT NOT NULL,									--���� 
	group_number INT  NOT NULL,								--������
	kod_special NVARCHAR(13) NOT NULL,						--��� �������������
	begin_learning DATE NOT NULL,							--������ ��������
	end_learning DATE NOT NULL,								--����� ��������
	
	CONSTRAINT PK_GroupId PRIMARY KEY (id_group),
	CONSTRAINT FK_Group_To_SubjectCT FOREIGN KEY (kod_special) REFERENCES Speciality (kod_special)
);


--16 ������ ���� ���������
CREATE TABLE Student(
	record_book INT NOT NULL,								--����� �������� ������
	surname NVARCHAR(15) NOT NULL,							--�������
	first_name NVARCHAR(20) NOT NULL,						--���
	patronymic NVARCHAR(15),								--��������
	sex NCHAR(1) CHECK (sex in('�','�')),					--���
	date_birth DATE NOT NULL,								--���� ��������
	id_group  NVARCHAR(15) NOT NULL,						--��� ������
	form  NCHAR(1) CHECK (form in('�','�')),				--����� ��������
	dismissed BIT NOT NULL DEFAULT 0,						--��� �� �������� (0-���, 1-��)
	restored BIT NOT NULL DEFAULT 0,						--��� �� ������������ (0-���, 1-��)
	leader BIT NOT NULL DEFAULT 0,							--�������� �� ��������� (0-���, 1-��)
	
	CONSTRAINT PK_StudentId PRIMARY KEY (record_book),
	CONSTRAINT FK_Student_To_Group FOREIGN KEY (id_group) REFERENCES GroupStudent (id_group)
);

--17 ���������� �� ������� ��������
CREATE TABLE ResultCT(
	record_book INT NOT NULL,								--����� �������� ������
	id_subj INT NOT NULL,									--��� �������� ��
	score INT CHECK(score between 0 and 100),				--����
	year_ct INT NOT NULL,									--���
	
	CONSTRAINT PK_ResultCT PRIMARY KEY (record_book,id_subj),
	CONSTRAINT FK_ResultCT_To_Student FOREIGN KEY (record_book) REFERENCES Student (record_book),
	CONSTRAINT FK_ResultCT_To_SubjectCT FOREIGN KEY (id_subj) REFERENCES  SubjectCT (id_subj)
);

--18 ������ ����������� ��������� �� �������������
CREATE TABLE ListEnrollment(
	number_enrol VARCHAR(15) NOT NULL,						--����� ������������
	record_book INT NOT NULL,								--����� �������� ������
	id_group  NVARCHAR(15) NOT NULL,						--��� ������
	
	CONSTRAINT PK_ListEnrollment PRIMARY KEY (number_enrol,record_book,id_group),
	CONSTRAINT FK_ListEnrollment_To_SubjectCT FOREIGN KEY (number_enrol) REFERENCES  Enrollment (number),
	CONSTRAINT FK_ListEnrollment_To_Student FOREIGN KEY (record_book) REFERENCES Student (record_book),
	CONSTRAINT FK_ListEnrollment_To_GroupStudent FOREIGN KEY (id_group) REFERENCES  GroupStudent (id_group)
);

--19 ������ ����������� ��������� �� �������������
CREATE TABLE ListExpelled(
	number_exp VARCHAR(15) NOT NULL,						--����� ������������
	record_book INT NOT NULL,								--����� �������� ������
	id_group  NVARCHAR(15) NOT NULL,						--��� ������
	
	CONSTRAINT PK_ListExpelled PRIMARY KEY (number_exp,record_book,id_group),
	CONSTRAINT FK_ListExpelled_To_SubjectCT FOREIGN KEY (number_exp) REFERENCES  Expelled (number),
	CONSTRAINT FK_ListExpelled_To_Student FOREIGN KEY (record_book) REFERENCES Student (record_book),
	CONSTRAINT FK_ListExpelled_To_GroupStudent FOREIGN KEY (id_group) REFERENCES  GroupStudent (id_group)
);

--20 ������ ������� 
CREATE TABLE AddressStudent(
	id_address INT IDENTITY(1, 1),							--id
	record_book INT NOT NULL,   							--����� �������� ������
	region INT NOT NULL,									--�����
	address_st NVARCHAR(150) NOT NULL,						--������
	type_addr INT NOT NULL,									--��� ������
	
	CONSTRAINT PK_AddressStudent PRIMARY KEY (id_address),
	CONSTRAINT FK_AddressStudent_To_Student FOREIGN KEY (record_book) REFERENCES Student (record_book),
	CONSTRAINT FK_AddressStudent_To_Region FOREIGN KEY (region) REFERENCES  Region (id_reg),
	CONSTRAINT FK_AddressStudent_To_TypeAddress FOREIGN KEY (type_addr) REFERENCES  TypeAddress (id_type)
);


--21 ���� ��������� 
CREATE TABLE PlanDiscipline(
	discipline INT NOT NULL,								--����������
	speciality NVARCHAR(13) NOT NULL,						--�������������
	semester INT CHECK(semester between 1 and 10),			--�������
	total INT NOT NULL ,									--����� ����� 
	lecture INT NOT NULL DEFAULT 0,							--������
	lab INT NOT NULL DEFAULT 0,								--������������ 
	practice INT NOT NULL DEFAULT 0,						--������������
	seminar INT NOT NULL DEFAULT 0,							--��������
	form INT NOT NULL,										--����� ���������� �� ���������(�������, �����)
	
	CONSTRAINT PK_PlanDiscipline PRIMARY KEY (discipline,speciality,semester),
	CONSTRAINT FK_PlanDiscipline_To_Discipline FOREIGN KEY (discipline) REFERENCES  Discipline (id_disc),
	CONSTRAINT FK_PlanDiscipline_To_Speciality FOREIGN KEY (speciality) REFERENCES  Speciality (kod_special),
	CONSTRAINT FK_PlanDiscipline_To_Attribute FOREIGN KEY (form) REFERENCES  Attribute (id_atr)
);

--22 ���������� ��������� � �������
CREATE TABLE ResultExam(
	number_statement VARCHAR(10) NOT NULL,					--����� ���������,
	record_book INT NOT NULL,								--����� �������� ������
	mark INT NOT NULL,  									--��� ������

	CONSTRAINT PK_ResultExam PRIMARY KEY (number_statement, record_book),
	CONSTRAINT FK_ResultExam_To_ExamCredit FOREIGN KEY (number_statement) REFERENCES  ExamCredit (number_statement),
	CONSTRAINT FK_ResultExam_To_Student FOREIGN KEY (record_book) REFERENCES  Student (record_book),
	CONSTRAINT FK_ResultExam_To_Mark FOREIGN KEY (mark) REFERENCES  Mark (id_mark)
);


--23 ���� ����������
CREATE TABLE Attestation(
	id_attestation INT NOT NULL,							--����� ����������	
	id_group  NVARCHAR(15) NOT NULL,						--��� ������
	date_begin DATE NOT NULL,								--������ ����������
	date_end DATE NOT NULL,									--����� ����������
	stat BIT NOT NULL DEFAULT 0,							--������ ����������( ��������� 1, � �������� 0)

	CONSTRAINT PK_Attestation PRIMARY KEY (id_attestation ),
	CONSTRAINT FK_Attestation_To_GroupStudent FOREIGN KEY (id_group) REFERENCES  GroupStudent (id_group)
);

--24 ���������� ����������
CREATE TABLE ResultAttestation(
	id_attestation INT NOT NULL,							--����� ����������	
	record_book INT NOT NULL,								--����� �������� ������
	discipline INT NOT NULL,								--��� ����������
	teacher INT NOT NULL,									--��� �������������
	mark INT NOT NULL,										--��� ������
	hours_absent INT NOT NULL,								--���� ��������
	form NCHAR(2) CHECK(form IN('��','��','��')),			--����� 
	
	CONSTRAINT PK_ResultAttestation PRIMARY KEY (id_attestation, record_book),
	CONSTRAINT FK_ResultAttestation_To_Attestation FOREIGN KEY (id_attestation) REFERENCES Attestation(id_attestation),
	CONSTRAINT FK_ResultAttestation_To_Student FOREIGN KEY (record_book) REFERENCES  Student (record_book),
	CONSTRAINT FK_ResultAttestation_To_Teacher FOREIGN KEY (teacher) REFERENCES Teacher (id_teach),
	CONSTRAINT FK_ResultAttestation_To_Discipline FOREIGN KEY (discipline) REFERENCES Discipline (id_disc),
	CONSTRAINT FK_ResultAttestation_To_Mark FOREIGN KEY (mark) REFERENCES  Mark (id_mark)
);

--25 �������� ������� ������� �������
CREATE TABLE Absents(
	id_abs BIGINT IDENTITY(1,1),		     				--id
	record_book INT NOT NULL,								--����� �������� ������
	discipline INT NOT NULL,								--��� ����������
	form NCHAR(2) CHECK(form IN('��','��','��','��')),		--����� 
	date_abs DATE NOT NULL,									--����
	reason BIT NOT NULL DEFAULT 0,							--������� ��������(0-��������������, 1-������������)
	work_out BIT NOT NULL DEFAULT 0,						--���������� �� �������(0-���, 1-��)
	
	CONSTRAINT PK_Absenteeism PRIMARY KEY (id_abs),
	CONSTRAINT FK_Absenteeism_To_Student FOREIGN KEY (record_book) REFERENCES  Student (record_book),
	CONSTRAINT FK_Absenteeism_To_Discipline FOREIGN KEY (discipline) REFERENCES Discipline (id_disc)
);


--26 �����������
CREATE TABLE Messenger(
	record_book INT NOT NULL,								--����� �������� ������
	mess NVARCHAR(100) NOT NULL,							--����������

	CONSTRAINT PK_Messenger PRIMARY KEY (record_book,mess),
	CONSTRAINT FK_Messenger_To_Student FOREIGN KEY (record_book) REFERENCES  Student (record_book)
);


--27 ���������� ������
CREATE TABLE Lenguage(
	short_name NVARCHAR(4) UNIQUE NOT NULL ,				--����������
	full_name NVARCHAR(100) UNIQUE NOT NULL,				--������ ��������
	
	CONSTRAINT PK_Lenguage PRIMARY KEY (short_name)
);

--28 ��������
CREATE TABLE CertificateSt(
	number INT NOT NULL,									--��������������� ����� ���������
	record_book INT NOT NULL,								--����� �������� ������
	school NVARCHAR(50) NOT NULL,							--����������� �����������
	gpa DECIMAL(2,2) NOT NULL,								--������� ����
	belarusian_language INT CHECK(belarusian_language between 0 and 10),
	belarusian_literature INT CHECK(belarusian_literature between 0 and 10),
	russian_language INT CHECK(russian_language between 0 and 10),
	russian_literature INT CHECK(russian_literature between 0 and 10),
	foreign_language INT CHECK(foreign_language between 0 and 10),
	f_language  NVARCHAR(4),                                 --���������� ������
	mathematics INT CHECK(mathematics between 0 and 10),
	informatics INT CHECK(informatics between 0 and 10),
	history_of_belarus INT CHECK(history_of_belarus between 0 and 10),
	world_history INT CHECK(world_history between 0 and 10),
	social_science INT CHECK(social_science between 0 and 10),
	geography_subj INT CHECK(geography_subj between 0 and 10),
	biology INT CHECK(biology between 0 and 10),
	physics INT CHECK(physics between 0 and 10),
	astronomy INT CHECK(astronomy between 0 and 10),
	chemistry INT CHECK(chemistry between 0 and 10),
	physical_culture INT CHECK(physical_culture between 0 and 10),
	preliminary_medical INT CHECK(preliminary_medical between 0 and 10),
	gold_medal BIT NOT NULL DEFAULT 0,						--������� ������� ������(0-���, 1-����)
	silver_medal BIT NOT NULL  DEFAULT 0,					--������� ���������� ������(0-���, 1-����)

	CONSTRAINT PK_CertificateSt PRIMARY KEY (number),
	CONSTRAINT FK_CertificateSt_To_Student FOREIGN KEY (record_book) REFERENCES  Student (record_book),
	CONSTRAINT FK_CertificateSt_To_Lenguage FOREIGN KEY (f_language) REFERENCES  Lenguage (short_name)
);


--29 ������ ��������� ���������
CREATE TABLE Parents(
	id_parent INT IDENTITY(1, 1),							--id ��������
	record_book INT NOT NULL,								--����� �������� ������ ��������
	fio NVARCHAR(15) NOT NULL,					     		--������� ��� ��������
	sex NCHAR(1) CHECK (sex in('�','�')),					--���
	date_birth DATE NOT NULL,								--���� ��������
	address_perent NVARCHAR(150) NOT NULL,					--�����
	messenger NVARCHAR(50) NOT NULL,						--�������(�)
	proffesion INT NOT NULL,								--����� ���������
	workplace NVARCHAR(150) NOT NULL,						--����� ������
	post NVARCHAR(30) NOT NULL,								--���������

	CONSTRAINT PK_ParentsId PRIMARY KEY (id_parent),
	CONSTRAINT FK_Parents_To_Student FOREIGN KEY (record_book) REFERENCES  Student (record_book),
	CONSTRAINT FK_Parents_To_Profession FOREIGN KEY (proffesion) REFERENCES Profession (id_prof)
);

--30 �������������� ���� � ���������
CREATE TABLE AdditionalInfo(
	id_addit INT IDENTITY(1, 1),							--id ��� ����
	record_book INT NOT NULL,								--����� �������� ������ ��������
	hostel BIT  NOT NULL  DEFAULT 0,						--��������� (0-���, 1-����)
	orphan_state_support  BIT  NOT NULL DEFAULT 0,			--������ �� ��� ����������� (0-���, 1-����)
	orphan_with_guardians BIT  NOT NULL DEFAULT 0,			--������ � ��������� (0-���, 1-����)
	invalid BIT  NOT NULL DEFAULT 0,						--������� (0-���, 1-����)
	lost_parent BIT  NOT NULL DEFAULT 0,					--������� ���������� �� ��������� �� ����� ����� (0-���, 1-����)
	incomplete_family BIT  NOT NULL DEFAULT 0,				--�������� ����� (0-���, 1-����)
	large_family  BIT  NOT NULL DEFAULT 0,				    --����������� ����� (0-���, 1-����)
	invalid_parent BIT  NOT NULL DEFAULT 0,				    --�������� ������� (0-���, 1-����)
	victims_of_the_Chernobyl_accident BIT  NOT NULL DEFAULT 0,	    --������������ �� ������ �� ���� (0-���, 1-����)
	refugee_family BIT  NOT NULL DEFAULT 0,				    --����� �������� (0-���, 1-����)
	on_internal_control BIT  NOT NULL DEFAULT 0,			--��������� �� ���������� �������� (0-���, 1-����)
	underachieving_students BIT  NOT NULL DEFAULT 0,		--������������ ������� (0-���, 1-����)
	create_family BIT  NOT NULL DEFAULT 0,					--�������, ��������� ����� (0-���, 1-����)
	have_children BIT  NOT NULL DEFAULT 0,					--����� ����� (0-���, 1-����)
	serious_chronic_disease BIT  NOT NULL DEFAULT 0,		--������ ����������� ����������� (0-���, 1-����)
	activist BIT  NOT NULL DEFAULT 0,						--�������� ��������� ������������ ����������� (0-���, 1-����)

	CONSTRAINT PK_AdditionalInfoId PRIMARY KEY (id_addit),
	CONSTRAINT FK_AdditionalInfo_To_Student FOREIGN KEY (record_book) REFERENCES  Student (record_book)
);

--31 ��������� ������������
CREATE TABLE ListNotAttestation(
	id_notattest INT IDENTITY(1, 1),					    --����� ������������
	record_book INT NOT NULL,								--����� �������� ������ ��������
	discipline INT NOT NULL,								--��� ����������
	teacher INT NOT NULL,									--��� �������������
	mark INT NOT NULL,										--��� ������
	date_start DATE NOT NULL,								--���� ������ �����
	date_end DATE NOT NULL,									--���� ����� �����

	CONSTRAINT PK_ListNotAttestationId PRIMARY KEY (id_notattest),
	CONSTRAINT FK_ListNotAttestation_To_Discipline FOREIGN KEY (discipline) REFERENCES Discipline (id_disc),
	CONSTRAINT FK_ListNotAttestation_To_Teacher FOREIGN KEY (teacher) REFERENCES Teacher (id_teach),
	CONSTRAINT FK_ListNotAttestation_To_Mark FOREIGN KEY (mark) REFERENCES  Mark (id_mark),
);

--32 �������� ���� �������� ��������
CREATE TABLE FormProcess(
	id_form NCHAR(2) NOT NULL,								-- '��','��','��','��','��','��','��'
	name NVARCHAR(30) UNIQUE NOT NULL,						-- ��������

	CONSTRAINT PK_FormProcessId PRIMARY KEY (id_form)
);

--33 ������ �������� ��������  
CREATE TABLE EducationalProcess(
	id INT IDENTITY(1, 1),					                --id 
	academic_year CHAR(9) NOT NULL,							--����� �������� ����
	form NCHAR(2) NOT NULL,									--��������
	course INT CHECK(course  between 1 and 4),				--����
	date_start DATE NOT NULL,								--���� ������
	date_end DATE NOT NULL,									--���� �����

	CONSTRAINT PK_EducationalProcessId PRIMARY KEY (id),
	CONSTRAINT FK_EducationalProcess_To_Discipline FOREIGN KEY (form) REFERENCES FormProcess(id_form)
);


--34 ������������
CREATE TABLE Users(
    id INT IDENTITY(1, 1),					                --id 
	user_login NVARCHAR(16) UNIQUE NOT NULL,				--�����
	user_password NVARCHAR(20) NOT NULL,					--������
    user_admin BIT NOT NULL DEFAULT 0,						--�� �������?(0-�������, 1-�����)

	CONSTRAINT PK_UsersId PRIMARY KEY (id)
);


DROP TABLE Enrollment;
DROP TABLE Expelled;
DROP TABLE Mark;
DROP TABLE Attribute;
DROP TABLE Profession;
DROP TABLE Discipline;
DROP TABLE Pulpit;
DROP TABLE Teacher;
DROP TABLE ExamCredit;
DROP TABLE District;
DROP TABLE Region;
DROP TABLE TypeAddress;
DROP TABLE SubjectCT;
DROP TABLE Speciality;
DROP TABLE GroupStudent;
DROP TABLE Student;
DROP TABLE ResultCT;
DROP TABLE ListEnrollment;
DROP TABLE ListExpelled;
DROP TABLE AddressStudent;
DROP TABLE PlanDiscipline;
DROP TABLE ResultExam;
DROP TABLE Attestation;
DROP TABLE ResultAttestation;
DROP TABLE Absents;
DROP TABLE Messenger;
DROP TABLE Lenguage;
DROP TABLE CertificateSt;
DROP TABLE Parents;
DROP TABLE AdditionalInfo;
DROP TABLE ListNotAttestation;
DROP TABLE FormProcess;
DROP TABLE EducationalProcess;
DROP TABLE Users;
	
	