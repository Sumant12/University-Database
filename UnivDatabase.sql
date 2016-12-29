--Design changes:
--I have made the following changes to my design:
--1. Used Lookup Table for Union job which is not required as it is a boolean data. So removed it.
--2. Timetable and data table is not appropriate. No need of these tables.
--3. Relation between employees and Benefits. I didn't consider it as a m2m relation.
--4. I made Lecture daya m2m relation.

--Table Creation:
CREATE TABLE Address(
	AddressId		INT			    PRIMARY KEY
	IDENTITY(1,1),
	Street1			VARCHAR(50)		NOT NULL,
	Street2			VARCHAR(50),
	City			VARCHAR(50)		NOT NULL,
	State			VARCHAR(50)		NOT NULL,
	ZIP				CHAR(5)			NOT NULL
);


CREATE TABLE Person (
	PersonId		INT				PRIMARY KEY
	IDENTITY(1,1),
	NTID			VARCHAR(20)		NOT NULL,
	FirstName		VARCHAR(50)		NOT NULL,
	LastName		VARCHAR(50)		NOT NULL,
	EmailAddress	VARCHAR(50)		NOT NULL,
	Password		VARCHAR(50),
	SSN				VARCHAR(13) 	CHECK(SSN LIKE '%-%-%'),
	DOB				DATE			NOT NULL,
	HomeAddress		INT				REFERENCES Address(AddressId)	NOT NULL,
	LocalAddress	INT				REFERENCES Address(AddressId),
	IsActive		BIT				NOT NULL						DEFAULT 'Y'
);

CREATE TABLE StudentStatus(
	StudentStatusId		INT				PRIMARY KEY
	IDENTITY(1,1),
	StudentStatus		VARCHAR(20)		NOT NULL
);

CREATE TABLE Student(
	StudentId			INT				PRIMARY KEY
	IDENTITY(1,1),
	PersonId			INT				REFERENCES Person(PersonId)						NOT NULL,
	StudentStatusId		INT				REFERENCES StudentStatus(StudentStatusId)
);

CREATE TABLE College(
	CollegeId	    INT					PRIMARY KEY
	IDENTITY(1,1),
	CollegeName		VARCHAR(100)		NOT NULL
);

CREATE TABLE Discipline(
	DisciplineId	INT				PRIMARY KEY
	IDENTITY(1,1),
	DisciplineName  VARCHAR(100)	NOT NULL,
	CollegeId		INT				REFERENCES College(CollegeId)	NOT NULL
);

CREATE TABLE StudentDiscipline(
	StudentDisciplineId		INT				PRIMARY KEY
	IDENTITY(1,1),
	StudentId				INT				REFERENCES Student(StudentId)			NOT NULL,
	DisciplineId			INT				REFERENCES Discipline(DisciplineID)		NOT NULL,
	IsMajor					BIT				NOT NULL
);

CREATE TABLE CourseCatalog(
	CourseId				INT				PRIMARY KEY
	IDENTITY(1,1),
	CourseCode				VARCHAR(10)		NOT NULL,
	CourseNumber			INT				NOT NULL	CHECK(CourseNumber >= 0),
	CourseTitle				VARCHAR(100)	NOT NULL,
	CourseDesc				VARCHAR(1000)
);

CREATE TABLE Prerequisites(
	PrerequisiteID			INT				PRIMARY KEY
	IDENTITY(1,1),
	CoursePrerequisiteId	INT             REFERENCES CourseCatalog(CourseId)		NOT NULL,
	CourseId				INT				REFERENCES CourseCatalog(CourseId)		NOT NULL	
);

CREATE TABLE Building(
	BuildingId				INT				PRIMARY	KEY
	IDENTITY(1,1),
	BuildingName			VARCHAR(100)		NOT NULL
);

CREATE TABLE ProjectorStatus(
	ProjectorStatusId		INT				PRIMARY KEY
	IDENTITY(1,1),
	ProjectorStatus			VARCHAR(50)		NOT NULL
);
CREATE TABLE ClassRoom(
	ClassId					INT				PRIMARY KEY
	IDENTITY(1,1),
	BuildingId				INT				REFERENCES	Building(BuildingId)					NOT NULL,
	RoomNumber				VARCHAR(20)		NOT NULL,
	MaxSeating				INT				NOT NULL	CHECK(MaxSeating >= 0),
	ProjectorStatus			INT				REFERENCES	ProjectorStatus(ProjectorStatusId)		NOT NULL,
	NumberOfWhiteBoards		INT				NOT NULL	CHECK(NumberOfWhiteBoards >	0 AND NumberOfWhiteBoards<=10),
	OtherAV					VARCHAR(100)	
);

CREATE TABLE SemesterText(
	SemesterTextId				INT				PRIMARY KEY
	IDENTITY(1,1),
	SemesterText				VARCHAR(20)		NOT NULL
);

CREATE TABLE Semester(
	SemesterId				INT				PRIMARY KEY
	IDENTITY(1,1),
	Semester				INT				REFERENCES	SemesterText(SemesterTextId)								NOT NULL,
	YearOfSemester			INT				NOT NULL	CHECK(YearOfSemester >= 1900 AND YearOfSemester<=2100),
	FirstDay				DATE			NOT NULL,
	LastDay					DATE			NOT NULL
);

CREATE TABLE WeekDayInfo(
	DayOfWeekId				INT				PRIMARY KEY
	IDENTITY(1,1),
	DayInfo					VARCHAR(12)		NOT NULL
);



CREATE TABLE CourseSchedule(
	CourseScheduleId		INT				PRIMARY KEY
	IDENTITY(1,1),
	CourseId				INT				REFERENCES CourseCatalog(CourseId)		NOT NULL,
	NumberOfSeats			INT				NOT NULL								CHECK(NumberOfSeats >= 0),
	Location				INT				REFERENCES ClassRoom(ClassId),
	Semester				INT				REFERENCES Semester(SemesterId)			NOT NULL
);

CREATE TABLE CourseDailySchedule(
	CourseDailyScheduleId				INT				PRIMARY KEY
	IDENTITY(1,1),
	CourseId							INT				REFERENCES CourseSchedule(CourseScheduleId)		NOT NULL,
	WeekDayInfoId						INT				REFERENCES WeekDayInfo(DayOfWeekId)				NOT NULL,
	StartTime							TIME			NOT NULL,
	EndTime								TIME			NOT NULL
	);

CREATE TABLE EnrollmentStatus(
	EnrollmentStatusId		INT				PRIMARY KEY
	IDENTITY(1,1),
	EnrollmentStatus		VARCHAR(20)		NOT NULL
);

CREATE TABLE Grade(
	GradeId					INT				PRIMARY KEY
	IDENTITY(1,1),
	Grade					CHAR(1)			NOT NULL,
	GradeDescription		VARCHAR(50)		NOT NULL
);
CREATE TABLE StudentEnrollment(
	StudentEnrollmentId			INT					PRIMARY KEY
	IDENTITY(1,1),
	CourseScheduleId			INT					REFERENCES CourseSchedule(CourseScheduleId)		NOT NULL,
	StudentId					INT					REFERENCES Student(StudentId)					NOT NULL,
	EnrollmentStatus			INT					REFERENCES EnrollmentStatus(EnrollmentStatusId)	NOT NULL	DEFAULT 'Regular',
	GradeId						INT					REFERENCES Grade(GradeId)											
);

CREATE TABLE BenefitSelection(
	BenefitSelectionId		INT				PRIMARY KEY
	IDENTITY(1,1),
	BenefitSelection		VARCHAR(12)		NOT NULL

);

CREATE TABLE Benefits(
	BenefitId				INT				PRIMARY KEY
	IDENTITY(1,1),
	BenefitSelection		INT				REFERENCES BenefitSelection(BenefitSelectionId)		NOT NULL,
	BenefitCost				INT				NOT NULL   CHECK(BenefitCost >= 0),
	BenefitDescription		VARCHAR(100)
);

CREATE TABLE JobInformation(
	JobId					INT				PRIMARY KEY
	IDENTITY(1,1),	
	JobTitle				VARCHAR(30)		NOT NULL,
	JobDescription			VARCHAR(200)	NOT NULL,
	JobRequirements			VARCHAR(200),
	MinPay					INT				NOT NULL	CHECK(MinPay >= 0),
	MaxPay					INT				NOT NULL	CHECK(MaxPay >= 0),
	UnionJob				BIT				NOT NULL	DEFAULT 'No'				
);

CREATE TABLE Employee(
	EmployeeId				INT				PRIMARY KEY
	IDENTITY(1,1),
	PersonId				INT				REFERENCES Person(PersonId)				NOT NULL,
	YearlyPay				INT				NOT NULL								CHECK(YearlyPay >= 0),
	HealthBenefits			INT				REFERENCES Benefits(BenefitId)			NOT NULL,
	VisionBenefits			INT				REFERENCES Benefits(BenefitId)			NOT NULL,
	DentalBenefits			INT				REFERENCES Benefits(BenefitId)			NOT NULL,
	JobId					INT				REFERENCES JobInformation(JobId)		NOT NULL
);
CREATE TABLE CourseInstructor(
	CourseInstructorId		INT				PRIMARY KEY
	IDENTITY(1,1),
	EmployeeId				INT				REFERENCES Employee(EmployeeId)					NOT NULL,
	CourseScheduleId		INT				REFERENCES CourseSchedule(CourseScheduleId)		NOT NULL
);

--Data Insertion
INSERT INTO Address (Street1, Street2, City, State, ZIP)
	VALUES
		('212 Westcott Street',		'Apt#1',	'Syracuse',		'New York',		'13210'),
		('324 Mapple Street',		'Apt#54',	'New York City','New York',		'12344'),
		('234 Cherry Street',		'Apt#6',	'Rochester',	'New York',		'78665'),
		('176 Stevenson Street',	'Apt#2',	'San Diego',	'California',	'87665'),
		('786 Maddinson Street',	'Apt#45',	'Chicago',		'Illinois',		'90871'),
		('123 Lancaster Avenue',	'Apt#8',	'San Fransisco','California',	'56752'),
		('456 Wooden Street',		'Apt#12',	'Boulder',		'Colarado',		'33455'),
		('324 Artint Street',		'Apt#4',	'Albany',		'New York',		'34566'),
		('234 Frantin Street',		'Apt#61',	'Salem',		'Oregon',		'89665'),
		('897 Westcott Street',		'Apt#13',	'Syracuse',		'New York',		'13210'),
		('432 Mapple Street',		'Apt#4',	'New York City','New York',		'12344'),
		('987 Cherry Street',		'Apt#16',	'Rochester',	'New York',		'78665'),
		('123 Stevenson Street',	'Apt#12',	'San Diego',	'California',	'87665'),
		('345 Maddinson Street',	'Apt#5',	'Chicago',		'Illinois',		'90871'),
		('908 Lancaster Avenue',	'Apt#18',	'San Fransisco','California',   '56752'),
		('234 Wooden Street',		'Apt#2',	'Boulder',		'Colarado',		'33455'),
		('456 Artint Street',		'Apt#14',	'Albany',		'New York',		'34566'),
		('567 Frantin Street',		'Apt#1',	'Salem',		'Oregon',		'89665');




INSERT INTO Person (NTID, FirstName, LastName, EmailAddress, Password, SSN, DOB, HomeAddress, LocalAddress, IsActive)
	VALUES
		('678567437', 'Michael','Jackson',		'mjackson@syr.edu',		'mjackson123',		'324-765-9876', '1994-10-22', 1, 2,	   1),
		('987923723', 'Bob',	'Marley',		'bmarley@syr.edu',		'bmarley123',		'765-564-8976', '1993-12-7',  4, NULL, 1),
		('232456666', 'Taylor', 'Swift',		'tswift@syr.edu',		'tswift123',		'342-876-9876', '1994-8-3',   3, NULL, 1),
		('762490840', 'Britney','Spears',		'bspears@syr.edu',		'bspears123',		'987-678-3456', '1992-8-12',  5, NULL, 1),
		('988729277', 'Lady',	'Gaga',			'lgaga@syr.edu',		'lgaga123',			'456-098-4567', '1991-9-22',  6, NULL, 1),
		('214218899', 'Katy',	'Perry',		'kperry@syr.edu',		'kperry123',		'678-345-3456', '1997-4-15',  2, NULL, 1),
		('986522828', 'Bruno',	'Mars',			'bmars@syr.edu',		'bmars123',			'456-452-9087', '1993-4-15',  7, NULL, 1),
		('627280027', 'Janet',	'Jackon',	    'jjackson@syr.edu',		'kjjackson123',		'456-546-3456', '1990-8-18',  8, NULL, 0),
		('234444989', 'Donna',	'Summer',		'dsummer@syr.edu',		'kdsummer123',		'987-567-3412', '1992-4-15',  9, NULL, 1),
		('786556682', 'Elvis',	'Presley',		'epresley@syr.edu',		'epresley123',		'786-345-1267', '1965-11-22', 1, 2,	   1),
		('622890865', 'Mariah',	'Carey',		'mcarley@syr.edu',		'mcarley123',		'232-567-9854', '1957-12-7',  4, NULL, 1),
		('908976788', 'Jay',	'Z',			'jayz@syr.edu',			'jayz123',			'234-567-1267', '1963-8-3',   3, NULL, 1),
		('898979878', 'Bruce',  'Springsteen',  'bspringstreen@syr.edu','bspringstreen123', '567-267-8765', '1959-8-12',  5, NULL, 1),
		('354356679', 'Stevie', 'Wonder',		'swonder@syr.edu',		'swonder123',		'165-234-1313', '1971-9-22',  6, NULL, 1),
		('345667889', 'Aretha', 'Franklin',		'afranklin@syr.edu',	'afranklin123',		'212-323-6789', '1967-4-15',  2, NULL, 1),
		('988745647', 'Diana',  'Ross',			'dross@syr.edu',		'dross123',			'678-323-7544', '1968-4-15',  7, NULL, 1),
		('456788646', 'Billy',  'Joel',			'bjoel@syr.edu',		'bjoel123',			'783-341-9876', '1972-8-18',  8, NULL, 0),
		('547687899', 'Bob',    'Dylan',		'bdylan@syr.edu',		'bdylan123',		'298-544-9818',  '1973-4-15', 9, NULL, 1);



INSERT INTO StudentStatus (StudentStatus)
	VALUES
		('Undergraduate'),
		('Graduate'),
		('Non-Matriculated'),
		('Grduated');

INSERT INTO Student (PersonId, StudentStatusId)
	VALUES
		(1,1),
		(2,1),
		(3,1),
		(4,1),
		(5,2),
		(6,2);

INSERT INTO College (CollegeName)
	VALUES
		('Collge of Law'),
		('L.C.Smith Collge of Engineering'),
		('Newhouse School of Public Communications'),
		('Collge of Visual Arts'),
		('Collge of Arts and Sciences'),
		('David B.Falk College of Sports and Human Dynamics');

INSERT INTO Discipline (DisciplineName, CollegeId)
	VALUES
		('BioMedical And Chemical Engineering',2),
		('Civil And Environmental Engineering',2),
		('Electrical Engineering and Computer Science',2),
		('Applied Law Sciences',1),
		('Gymnastics',6),
		('Arts of Eighteenth Century',5);


INSERT INTO StudentDiscipline (StudentId, DisciplineId, IsMajor)
	VALUES
		(1,1,1),
		(1,2,0),
		(2,1,1),
		(2,3,0),
		(3,2,1),
		(3,5,0),
		(4,3,1),
		(5,4,1),
		(6,5,1);

INSERT INTO CourseCatalog (CourseCode, CourseNumber, CourseTitle, CourseDesc)
	VALUES
		('CSE', 235, 'Basic Data Structures',					'Deals with Basic Data Structures and Algoritms'),
		('CSE', 421, 'Computer Architecture',					'Introduction to Computer Architecture'),
		('CSE', 410, 'Operating Systems',						'Deals with Operating Systems'),
		('CSE', 612, 'Advanced Data Structures and Algoritms',  'Deals with advanced topics of Data Structures and Algorithms'),
		('CSE', 643, 'Advanced Computer Architecture',			'Insights into advanced computer architecture concepts'),
		('CSE', 678, 'Advanced Operating Systems',				'Deals with advanced OS Concepts'),
		('EEE', 243, 'Basic Electronics',						'Insights into Basic Electronic Concepts'),
		('EEE', 445, 'Advanced Electronics',					'Deals with Advanced Electronics'),
		('MEC', 345, 'Machines',								'Deals with the functionality of Machines');

INSERT INTO Prerequisites (CoursePrerequisiteId, CourseId)
	VALUES
		(1,4),
		(2,5),
		(3,6),
		(7,8);

INSERT INTO Building (BuildingName)
	VALUES
		('Boland'),
		('Brewster'),
		('Slocum'),
		('SkyHall'),
		('Ernie Davis'),
		('Haven');

INSERT INTO ProjectorStatus (ProjectorStatus)
	VALUES
		('Yes-Basic'),
		('Yes-SmartBoard'),
		('No');

INSERT INTO ClassRoom (BuildingId, RoomNumber, MaxSeating, ProjectorStatus, NumberOfWhiteBoards, OtherAV)
	VALUES
		(1, 'Bol-564',	70,	 2, 2, 'Wireless Microphone'),
		(2, 'Brew-342', 120, 2, 3, 'Podium with Microphone'),
		(3, 'Sloc-765', 130, 1, 3, 'Powered Speakers'),
		(4, 'Sky-134',	70,  3, 1,  NULL),
		(5, 'Ernie-234',80,  2, 2, 'Data Projectors'),
		(6, 'Hav-345',	120, 2, 2, 'Powered Speakers'),
		(1, 'Bol-453',	89,  1, 3, 'Podium with Microphone'),
		(2, 'Bre-342',	58,  3, 1,  NULL),
		(3, 'Sloc-345', 145, 3, 3, 'Powered Speakers');

INSERT INTO SemesterText (SemesterText)
	VALUES
		('Fall'),
		('Spring'),
		('Summer');

INSERT INTO Semester (Semester, YearOfSemester, FirstDay, LastDay)
	VALUES
		(1, 2016, '2016-08-12', '2016-12-6'),
		(2, 2016, '2016-01-12', '2016-05-16'),
		(1, 2015, '2015-08-06', '2015-12-9'),
		(2, 2015, '2015-01-07', '2015-05-17');

INSERT INTO WeekDayInfo (DayInfo)
	VALUES
		('Monday'),
		('Tuesday'),
		('Wednesday'),
		('Thursday'),
		('Friday'),
		('Saturday'),
		('Sunday');


INSERT INTO CourseSchedule (CourseId, NumberOfSeats, Location, Semester)
	VALUES
		(1, 120, 1, 1),
		(2, 140, 2, 1),
		(3, 85,	 3, 1),
		(4, 120, 1, 2),
		(5, 140, 2, 2),
		(6, 85,  3, 2),
		(7, 105, 4, 1),
		(8, 105, 4, 2),
		(9, 110, 6, 1);



INSERT INTO CourseDailySchedule (CourseId, WeekDayInfoId, StartTime, EndTime)
	VALUES
		(1, 1, '08:00', '09:20'),
		(1, 3, '08:00', '09:20'),
		(2, 2, '10:00', '11:20'),
		(2, 4, '10:00', '11:20'),
		(3, 1, '10:00', '11:20'),
		(3, 3, '10:00', '11:20'),
		(4, 3, '12:00', '13:20'),
		(4, 4, '12:00', '13:20'),
		(5, 1, '18:00', '19:20'),
		(5, 3, '18:00', '19:20'),
		(6, 2, '18:00', '19:20'),
		(6, 4, '18:00', '19:20'),
		(7, 5, '08:00', '09:20'),
		(8, 5, '10:00', '11:20'),
		(9, 5, '18:00', '19:20');

INSERT INTO EnrollmentStatus (EnrollmentStatus)
	VALUES
		('Regular'),
		('Audit'),
		('Pass'),
		('Fail');

INSERT INTO Grade (Grade, GradeDescription)
	VALUES
		('O','Outstanding'),
		('E','Exceeds Expectations'),
		('A','Acceptable'),
		('P','Poor'),
		('D','Dreadful'),
		('T','Troll');
		
INSERT INTO StudentEnrollment (CourseScheduleId, StudentId, EnrollmentStatus, GradeId)
	VALUES
		(1, 1, 1, 1),
		(2, 1, 1, 2),
		(3, 1, 1, 1),
		(4, 2, 1, NULL),
		(5, 2, 1, 1),
		(1, 3, 1, NULL),
		(2, 3, 1, 3),
		(6, 2, 1, 4),
		(7, 4, 1, NULL),
		(7, 5, 1, 1),
		(8, 6, 1, 1);

INSERT INTO BenefitSelection (BenefitSelection)
	VALUES
		('Single'),
		('Family'),
		('Op-out');

INSERT INTO Benefits (BenefitSelection, BenefitCost, BenefitDescription)
	VALUES
		(1,75000, 'Single-Luxery'),
		(2,175000,'Family-Luxery'),
		(1,30000, 'Single-Normal'),
		(2,70000, 'Family-Normal'),
		(3,67000, 'opout'),
		(1,15000, 'Single-Premium');

INSERT INTO JobInformation (JobTitle, JobDescription, JobRequirements, MinPay, MaxPay, UnionJob)
	VALUES
		('Teaching Assistant',	 'Helps the Proffesor to manage the Course', 'Graduate Student',				'20', '25', 1),
		('Research Assistant',	 'Helps the Proffesor in his research',		 'PhD Student',						'25', '35', 1),
		('Grader',				 'Grades the Assisgnements',				 'Graduate Student',				'12', '20', 1),
		('Junior Professor',	 'Less than 5 years of experience',			 'PhD',								'60', '85', 1),
		('Senior Professor',	 '5 to 15 years of experience',              'PhD and 5 years of experience',  '100', '125',0),
		('Senior Most Professor','More than 25 years of experience',         'PhD and 25 years of experience', '175', '200',0);

INSERT INTO Employee (PersonId, YearlyPay, HealthBenefits, VisionBenefits, DentalBenefits, JobId)
	VALUES
		(10, 75000,	 4, 1, 1, 4),
		(11, 75000,  4, 1, 1, 4),
		(12, 125000, 2, 1, 1, 5),
		(13, 125000, 2, 1, 1, 5),
		(14, 175000, 4, 1, 1, 6),
		(15, 175000, 4, 1, 1, 6),
		(16, 75000,  2, 1, 1, 4),
		(17, 125000, 2, 1, 1, 5),
		(18, 175000, 2, 1, 1, 6),
		(6, 30000,   3, 3, 3, 1),
		(5, 40000,   3, 3, 3, 2),
		(4, 25000,   3, 3, 3, 3);

INSERT INTO CourseInstructor (EmployeeId, CourseScheduleId)
	VALUES
		(1, 1),
		(2, 2),
		(3, 3),
		(4, 4),
		(5,	5),
		(6,	5),
		(7,	7),
		(10,4),
		(11,5),
		(12,6);

--Views
--View1
--The view gives the Details of all the Employees,thier corresponding Health Benefit information
--who have chosen Health Benefit type as 'Family'

CREATE VIEW EmployeeDetails AS
	SELECT Employee.EmployeeId, Person.FirstName+' '+ Person.LastName AS EmployeeName,
	JobInformation.JobTitle, Benefits.BenefitCost AS HealthBenefitCost, Benefits.BenefitDescription AS HealthBenefitDescription,
	BenefitSelection.BenefitSelection AS HealthBenefitSelectionType	
		FROM Employee,Person,JobInformation,Benefits,BenefitSelection
		WHERE Employee.PersonId = Person.PersonId
			AND Employee.JobId = JobInformation.JobId
			AND Employee.HealthBenefits = Benefits.BenefitId
			AND Benefits.BenefitSelection = BenefitSelection.BenefitSelectionId
			AND BenefitSelection.BenefitSelection = 'Family';
--View2
--This view gives the details of all the Students and the majors they are enrolled in
CREATE VIEW StudentDetails AS
	SELECT Student.StudentId, Person.FirstName+' '+ Person.LastName AS StudentName,
	Person.EmailAddress, Address.City, Address.State,StudentDiscipline.IsMajor,
	Discipline.DisciplineName	
		FROM Student,Person,Address,StudentDiscipline,Discipline
		WHERE Student.PersonId = Person.PersonId
			AND Student.StudentId = StudentDiscipline.StudentId
			AND StudentDiscipline.DisciplineId = Discipline.DisciplineId
			AND Person.HomeAddress = Address.AddressId
			AND StudentDiscipline.IsMajor =1;

--View3
--This View gives details of all Course Schedules, their timings,Location that are scheduled in Fall
CREATE VIEW CourseScheduleDetails AS
	SELECT CourseSchedule.CourseScheduleId, CourseCatalog.CourseCode,CourseCatalog.CourseNumber,
	CourseCatalog.CourseTitle, WeekDayInfo.DayInfo AS Day, CourseDailySchedule.StartTime,CourseDailySchedule.EndTime,
	ClassRoom.RoomNumber,Building.BuildingName,SemesterText.SemesterText AS Semester	
		FROM CourseSchedule,CourseCatalog,WeekDayInfo,CourseDailySchedule,ClassRoom,Building,SemesterText,Semester
		WHERE CourseSchedule.CourseScheduleId = CourseCatalog.CourseId
			AND CourseSchedule.CourseScheduleId =CourseDailySchedule.CourseId
			AND CourseDailySchedule.WeekDayInfoId = WeekDayInfo.DayOfWeekId
			AND CourseSchedule.Location = ClassRoom.ClassId
			AND CourseSchedule.Semester= Semester.SemesterId
			AND Semester.Semester=SemesterText.SemesterTextId
			AND ClassRoom.BuildingId= Building.BuildingId
			AND SemesterText.SemesterText='Fall';

--View4
--I assumed that Graduate Students are allowed to take only Courses above 500 level
--This view gives the details of all Graduate students who are enrolled in various Courses
CREATE VIEW StudentEnrollmentDetails AS
	SELECT StudentEnrollment.StudentEnrollmentId, Person.FirstName+' '+Person.LastName AS StudnetName,CourseCatalog.CourseNumber,
	CourseCatalog.CourseTitle,SemesterText.SemesterText AS Semester,Semester.YearOfSemester,Grade.Grade,
	Grade.GradeDescription
		FROM StudentEnrollment,Person,CourseCatalog,SemesterText,Semester,Grade,Student,CourseSchedule
		WHERE StudentEnrollment.StudentId = Student.StudentId
			AND StudentEnrollment.CourseScheduleId =CourseSchedule.CourseScheduleId
			AND CourseSchedule.CourseId = CourseCatalog.CourseId
			AND CourseSchedule.Semester = Semester.SemesterId
			AND Semester.Semester=SemesterText.SemesterTextId
			AND StudentEnrollment.GradeId= Grade.GradeId
			AND Student.PersonId = Person.PersonId
			AND CourseNumber>500;
			
--Stored Procedure1
--This SP is capable of doing the following things while a studnet wants to enroll in a Course
--1. Checks if a Student is active person of the University. If not, Transaction is rolled back.
--2. Checks if a Student has already enrolled in the class. If so, Transaction is rolled back.
--3. Checks if a Student has taken the prerequisite Course of the Course. If not,Transaction is rolled back
--4. If all the conditions are met, the Transaction is commited and the Student is enrolled in the Course.


CREATE PROCEDURE dbo.CheckPrerequistes(@StudentId AS INT, @courseId AS INT)
AS
	BEGIN TRAN
	DECLARE @PersonStatus AS BIT
	SET @PersonStatus = (SELECT IsActive FROM Person
							WHERE Person.PersonId = (SELECT PersonId FROM Student
													WHERE StudentId = @StudentId))
	--Check if the Person is active in the University			
	IF (@PersonStatus = 0)
		BEGIN
			PRINT 'Error: You are not active member of the University.';
			ROLLBACK TRAN
			PRINT 'Transaction rolledback'
			RETURN
		END	
	--Check if the student is already enrolled in the Course
	ELSE IF (EXISTS(SELECT * FROM StudentEnrollment WHERE StudentId= @StudentId AND CourseScheduleId=
				(SELECT CourseScheduleId FROM CourseSchedule WHERE CourseId=@CourseId)))
		BEGIN
		PRINT 'Error: You have already been enrolled in this Course';
		ROLLBACK TRAN
		PRINT 'Transaction rolledback'
		RETURN		
		END	
	ELSE 
		BEGIN
			DECLARE @PrerequisiteId AS INT
			SET @PrerequisiteId = (SELECT CoursePrerequisiteId FROM Prerequisites
											WHERE CourseId = @CourseId)
			--Check if the student has taken the prerequisite Course 
			IF EXISTS(SELECT * FROM StudentEnrollment WHERE StudentId= @StudentId AND CourseScheduleId=
							(SELECT CourseScheduleId FROM CourseSchedule WHERE CourseId=@PrerequisiteId))
				BEGIN
				DECLARE @CourseScheduleId AS INT
				SET  @CourseScheduleId = (SELECT CourseScheduleId FROM CourseSchedule
															WHERE CourseId = @CourseId)
				INSERT INTO StudentEnrollment (CourseScheduleId, StudentId, EnrollmentStatus, GradeId)
				VALUES (@CourseScheduleId, @StudentId, 1, NULL)
				PRINT 'SUCCESS: You have been enrolled in the course';
				END	
			ELSE
				BEGIN
				PRINT 'Error: You didnt take the Prerequisite course';
				ROLLBACK TRAN
				PRINT 'Transaction rolledback'
				RETURN		
				END				
		END
	COMMIT TRAN 
--Sample Exec Statement
EXEC dbo.CheckPrerequistes @StudentId=1 ,@CourseId =4;

--Stored Procedure2
--Checks if the password is less than 6 Characters. If so, Transaction is rolled back.
--Checks if the password has atleast 3 letters,3 numbers and 3 Special characters. If any of the constraint is violated,
--Transaction is rolled back
--Else, The Transaction is committed.
CREATE PROCEDURE dbo.PasswordAnalyzer(@NTID AS VARCHAR(20), 
									  @FirstName AS VARCHAR(50),
									  @LastName AS VARCHAR(50),
									  @EmailAddress AS VARCHAR(50),
									  @Password AS VARCHAR(50),
									  @SSN AS VARCHAR(13),
									  @DOB AS DATE,
									  @HomeAddress AS INT,
									  @LocalAddress AS INT,
									  @IsActive AS BIT)
									  													  
	AS
		BEGIN TRAN
		IF(LEN(@Password)<=6)
			BEGIN
				PRINT 'Error: The password length is less than 6 characters, Please choose a Strong Password';
				ROLLBACK TRAN
				PRINT 'Transaction rolledback'
				RETURN
			END	
		DECLARE @Pos AS INT
		DECLARE @CountOfLetters AS INT
		DECLARE @CountOfNumbers AS INT
		DECLARE @CountOfSpecialCharacters AS INT
		DECLARE @Weight AS DECIMAL(9,2)

		SET @Pos =1
		SET @CountOfLetters =0
		SET @CountOfNumbers =0
		SET @CountOfSpecialCharacters =0
		SET @Weight =0

		WHILE @Pos <= DATALENGTH(@Password)
			BEGIN
				IF SUBSTRING(@Password,@Pos,1) LIKE '[a-z]'
				BEGIN
					SET @CountOfLetters = @CountOfLetters+1
					SET @Pos = @Pos+1
				END

				IF SUBSTRING(@Password,@Pos,1) LIKE '[0-9]'
				BEGIN
					SET @CountOfNumbers = @CountOfNumbers+1
					SET @Pos = @Pos+1
				END

				IF SUBSTRING(@Password,@Pos,1) NOT LIKE '[a-z]'
					AND SUBSTRING(@Password,@Pos,1) NOT LIKE '[0-9]'
				BEGIN
					SET @CountOfSpecialCharacters = @CountOfSpecialCharacters+1
					SET @Pos = @Pos+1
				END
			END
		IF(@CountOfLetters < 3)
			BEGIN
				PRINT 'Error: The Number of Letters in Password is less than 3';
				ROLLBACK TRAN
				PRINT 'Transaction rolledback'
				RETURN
			END
			
		ELSE IF(@CountOfNumbers < 3)
			BEGIN
				PRINT 'Error: The Number of Numerical Characters in Password is less than 3';
				ROLLBACK TRAN
				PRINT 'Transaction rolledback'
				RETURN
			END	
		ELSE IF(@CountOfSpecialCharacters < 3)
			BEGIN
				PRINT 'Error: The Number of Special Characters in Password is less than 3';
				ROLLBACK TRAN
				PRINT 'Transaction rolledback'
				RETURN
			END	
		ELSE
			BEGIN
				INSERT INTO Person (NTID, FirstName, LastName, EmailAddress, Password, SSN, DOB, HomeAddress, LocalAddress, IsActive)
	            VALUES	
				(@NTID, @FirstName,@LastName, @EmailAddress, @Password, @SSN,@DOB, @HomeAddress,@LocalAddress,@IsActive)
				PRINT 'Success: The Password is strong and the data is inserted';
			END
		COMMIT TRAN

--Sample Exec Statement
EXEC dbo.PasswordAnalyzer @NTID=123456789 ,@FirstName ='Yuvraj',@LastName = 'Singh',@EmailAddress='Yuvraj12@gmail.com',
					@Password = '123', @SSN = '324-765-9876', @DOB = '1994-10-22', @HomeAddress =1,@LocalAddress = 3,
					@IsActive =1;

--Stored Procedure3
--This view can validate registration/deregistration from a Course for a student
--1.While registering, Checks if seats are full. If so, Transaction is rolled back.
--2.While registering, Checks if the student is already enrolled in the Course. If so, Transaction is rolled back.
--3.If all the conditions are satisfied,the student is registered and the Number of seats is updated.
--4.While deregistering, If the student is enrolled in the Course. If Not, Transaction is rolled back.
--5.If all the conditions are satisfied, the student is deregistered and the Number of seats is updated.
CREATE PROCEDURE dbo.RegisterorDeregister(@StudentId AS INT, 
										  @CourseScheduleId AS INT,
										  @EnrollmentStatus AS INT,
										  @GradeId AS INT,
										  @Type AS VARCHAR(20))
AS
	BEGIN TRAN
		IF(@Type = 'Register')
			BEGIN
				DECLARE @NumberofSeats AS INT
				SET @NumberOfSeats = (SELECT NumberOfSeats FROM CourseSchedule
									WHERE CourseScheduleId = @CourseScheduleId)
				IF(@NumberOfSeats <= 0)
					BEGIN
						PRINT 'Error: The Seats are Full.';
						ROLLBACK TRAN
						PRINT 'Transaction rolledback'
						RETURN
					END	
				ELSE
					BEGIN
						IF(NOT EXISTS(SELECT * FROM StudentEnrollment WHERE
											StudentId = @StudentId AND CourseScheduleId =@CourseScheduleId))
							BEGIN
								INSERT INTO StudentEnrollment (CourseScheduleId, StudentId, EnrollmentStatus, GradeId)
																VALUES (@CourseScheduleId, @StudentId, 1, 1)
								UPDATE CourseSchedule
										SET NumberOfSeats = NumberOfSeats-1
							END
						ELSE
							BEGIN
								PRINT 'Error: You have already enrolled in this Course.';
								ROLLBACK TRAN
								PRINT 'Transaction rolledback'
								RETURN
							END
					END
			END
		ELSE IF(@Type = 'deregister')
			BEGIN
				IF(NOT EXISTS(SELECT * FROM StudentEnrollment WHERE
									StudentId = @StudentId AND CourseScheduleId =@CourseScheduleId))
					BEGIN
						PRINT 'Error: You are not enrolled in this Course.';
						ROLLBACK TRAN
						PRINT 'Transaction rolledback'
						RETURN
				   END
				ELSE
					BEGIN
						DELETE FROM StudentEnrollment WHERE StudentId = @StudentId AND CourseScheduleId =@CourseScheduleId
						UPDATE CourseSchedule
									SET NumberOfSeats = NumberOfSeats+1
					END
			END
	COMMIT TRAN	

--Sample Exec Statement	
EXEC dbo.RegisterorDeregister @StudentId=1 ,@CourseScheduleId =7, @EnrollmentStatus =1, @GradeId = NULL,@Type= 'register';
EXEC dbo.RegisterorDeregister @StudentId=1 ,@CourseScheduleId =7, @EnrollmentStatus =1, @GradeId = NULL,@Type= 'deregister';


--Function1
--This Function returns a table which contains the details of all the employees whose Yearly Pay is less than average.
CREATE FUNCTION BenefitAnalyzer ()
	RETURNS @return TABLE(EmployeeId INT,EmployeeName VARCHAR(50), YearlyPay INT, JobId INT)
	AS
	BEGIN
		DECLARE @YearlyPay INTEGER=0
		DECLARE @CumulativePay INTEGER=0
		DECLARE @Count INTEGER=0
		DECLARE @Average INTEGER=0
		DECLARE MyCursor CURSOR FOR
			SELECT YearlyPay 
				FROM Employee
		OPEN Mycursor;
		FETCH NEXT FROM Mycursor INTO @YearlyPay
		WHILE @@FETCH_STATUS = 0
		BEGIN 
			BEGIN
				SET @CumulativePay = @CumulativePay+@YearlyPay
				SET @Count = @Count+1
			END
			FETCH NEXT FROM Mycursor INTO @YearlyPay
		END
		SET @Average = @CumulativePay/@Count
		CLOSE Mycursor
		DEALLOCATE MyCursor
		INSERT INTO @return
		SELECT EmployeeId,Person.FirstName+' '+Person.LastName AS EmployeeName, YearlyPay, JobId
			FROM Employee INNER JOIN Person ON Employee.PersonId = Person.PersonId
			WHERE YearlyPay < @Average
		RETURN
	END
--Sample Exec Statement	
SELECT * FROM dbo.BenefitAnalyzer()

--Function2
--This Function validates the Credentials of an User in two layers.
--1.If the User is not in the table, Appropraite error is thrown to the User that he is not aunthenticated user.
--2.If the User exists and the password is incorrect, Appropriate error is thrown that password is incorrect 
CREATE FUNCTION dbo.ValidateCredentials(@EmailAddress AS VARCHAR(50),@Password AS VARCHAR(50))
	RETURNS VARCHAR(500)
	BEGIN
		DECLARE @Output AS VARCHAR(500)
		IF (NOT EXISTS(SELECT * FROM Person WHERE EmailAddress = @EmailAddress))
			BEGIN
				SET @Output = 'You are not a valid user'
			END
		ELSE
			BEGIN
				IF(NOT EXISTS(SELECT * FROM Person WHERE EmailAddress=@EmailAddress AND
								Password = @Password))
				BEGIN
					SET @Output = 'Please enter the correct password'
				END
				ELSE
				BEGIN
					SET @Output = 'You are an authenticated User'
				END
			END	
	RETURN @Output				
	END;

--Sample Exec Statement	
SELECT dbo.ValidateCredentials('mjackson@syr.edu','mjackson123') AS Result
