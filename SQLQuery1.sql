CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,

    -- Basic Info
    Name NVARCHAR(100),
    Username NVARCHAR(50),
    Email NVARCHAR(100) UNIQUE,
    Phone NVARCHAR(15),

    PasswordHash NVARCHAR(200),
    RFID NVARCHAR(200) NULL,

    -- Personal Details
    Nationality NVARCHAR(50),
    Gender NVARCHAR(10),
    Height DECIMAL(5,2),
    Qualification NVARCHAR(100),

    -- Identification
    GovtIDType NVARCHAR(50),
    GovtIDNumber NVARCHAR(100),
    IDCardFile NVARCHAR(200),
    PassportNumber NVARCHAR(50),

    -- Agreement
    Signature NVARCHAR(200),
    AgreementDate DATE,

    -- Health Info
    HasChronicIllness BIT DEFAULT 0,
    ChronicIllnessDetails NVARCHAR(250),
    HasAllergies BIT DEFAULT 0,
    AllergyDetails NVARCHAR(250),
    MedicalDocument NVARCHAR(200),

    PhysicianName NVARCHAR(100),
    
    PhysicianPhone NVARCHAR(20),

    InsuranceCompany NVARCHAR(100),
    InsurancePolicy NVARCHAR(100),
    InsuranceGroup NVARCHAR(100),

    -- Emergency Contact
    GuardianName NVARCHAR(150),
    GuardianRelationship NVARCHAR(100),
    GuardianEmail NVARCHAR(100),
    GuardianPhone NVARCHAR(20),

    -- Address (single address only)
    Address NVARCHAR(250),
    City NVARCHAR(50),
    State NVARCHAR(50),
    Country NVARCHAR(50),
    Pincode NVARCHAR(10),

    CreatedDate DATETIME DEFAULT GETDATE()
);

ALTER TABLE Users
ADD IsActive BIT NOT NULL DEFAULT 1;


ALTER TABLE Users
ADD
    DOB DATE NULL,
    ProfilePhoto NVARCHAR(200) NULL;

    ALTER TABLE Users DROP COLUMN RFID;


CREATE TABLE Tournaments (
    TournamentID INT IDENTITY PRIMARY KEY,
    TournamentName NVARCHAR(200),
    Venue NVARCHAR(200),
    TournamentDate DATE,
    MinAge INT NULL,
    MaxAge INT NULL,
    DistanceMeters INT,
    Status NVARCHAR(50),
    CreatedDate DATETIME DEFAULT GETDATE()
);

CREATE TABLE TournamentMembers
(
    TournamentMemberID INT IDENTITY(1,1) PRIMARY KEY,
    TournamentID INT NOT NULL,
    UserID INT NOT NULL,
    MemberName NVARCHAR(100) NOT NULL,
    EPC NVARCHAR(50) NULL,

    CONSTRAINT FK_TM_Tournament
        FOREIGN KEY (TournamentID)
        REFERENCES Tournaments(TournamentID)
        ON DELETE CASCADE,

    CONSTRAINT FK_TM_User
        FOREIGN KEY (UserID)
        REFERENCES Users(UserID),

    CONSTRAINT UQ_TournamentUser
        UNIQUE (TournamentID, UserID)
);

CREATE UNIQUE INDEX UX_TournamentMembers_EPC
ON TournamentMembers (TournamentID, EPC)
WHERE EPC IS NOT NULL;


SELECT * FROM TournamentMembers;

CREATE TABLE Admins (
AdminID INT IDENTITY PRIMARY KEY,
Email NVARCHAR(150) UNIQUE NOT NULL,
PasswordHash NVARCHAR(255) NOT NULL,
IsActive BIT DEFAULT 1,
CreatedAt DATETIME DEFAULT GETDATE()
);
 