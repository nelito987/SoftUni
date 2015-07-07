-------------------------------------------
-- Problem 1
-------------------------------------------
SELECT p.PeakName FROM Peaks AS p
ORDER BY p.PeakName ASC

-------------------------------------------
-- Problem 2
-------------------------------------------
SELECT TOP 30
	c.CountryName, 
	c.Population 
FROM Countries AS c
WHERE c.ContinentCode = 'EU'
ORDER BY c.Population DESC

-------------------------------------------
-- Problem 3
-------------------------------------------
SELECT 
	c.CountryName, 
	c.CountryCode,
	CASE WHEN c.CurrencyCode = 'EUR' THEN 'Euro' ELSE 'Not Euro' END AS [Currency]
FROM Countries AS c
ORDER BY c.CountryName ASC

-------------------------------------------
-- Problem 4
-------------------------------------------
SELECT
	c.CountryName AS [Country Name],
	c.IsoCode AS [ISO Code]
FROM Countries AS c
WHERE c.CountryName LIKE '%A%A%A%'
ORDER BY c.IsoCode ASC

-------------------------------------------
-- Problem 5
-------------------------------------------
SELECT
	p.PeakName,
	m.MountainRange AS [Mountain],
	p.Elevation
FROM Peaks AS p
JOIN Mountains AS m
ON p.MountainId = m.Id
ORDER BY p.Elevation DESC, p.PeakName ASC

-------------------------------------------
-- Problem 6
-------------------------------------------
SELECT
	p.PeakName,
	m.MountainRange AS [Mountain],
	c.CountryName,
	cn.ContinentName
FROM Peaks AS p
JOIN Mountains AS m
	ON p.MountainId = m.Id
JOIN MountainsCountries AS mc
	ON m.Id = mc.MountainId
JOIN Countries AS c
	ON c.CountryCode = mc.CountryCode
JOIN Continents AS cn
	ON c.ContinentCode = cn.ContinentCode
ORDER BY p.PeakName ASC, c.CountryName ASC

-------------------------------------------
-- Problem 7
-------------------------------------------
SELECT 
	r.RiverName AS [River],
	COUNT(*) AS [Countries Count]
FROM Rivers AS r
JOIN CountriesRivers AS cr
	ON r.Id = cr.RiverId
JOIN Countries AS c
	ON c.CountryCode = cr.CountryCode
GROUP BY r.RiverName
	HAVING COUNT(DISTINCT c.CountryCode) >= 3
ORDER BY r.RiverName ASC

-------------------------------------------
-- Problem 8
-------------------------------------------
SELECT
	MAX(p.Elevation) AS [MaxElevation],
	MIN(p.Elevation) AS [MinElevation],
	AVG(p.Elevation) AS [AverageElevation]
FROM Peaks AS p

-------------------------------------------
-- Problem 9
-------------------------------------------
SELECT 
	c.CountryName,
	cn.ContinentName,
	COUNT(r.Id) AS RiversCount,
	ISNULL(SUM(r.Length), 0) AS TotalLength	
FROM Countries AS c
INNER JOIN Continents AS cn
ON c.ContinentCode = cn.ContinentCode
LEFT JOIN CountriesRivers AS cr
ON	c.CountryCode = cr.CountryCode
LEFT JOIN Rivers AS r
On cr.RiverId = r.Id
GROUP BY c.CountryName, cn.ContinentName
ORDER BY RiversCount DESC, TotalLength DESC, c.CountryName ASC

-------------------------------------------
-- Problem 10
-------------------------------------------
SELECT
	c.CurrencyCode AS CurrencyCode,
	c.Description AS Currency,
	COUNT(cr.CurrencyCode) AS NumberOfCountries
FROM Currencies AS c
LEFT JOIN Countries AS cr
ON c.CurrencyCode = cr.CurrencyCode
GROUP BY c.CurrencyCode, c.Description
ORDER BY NumberOfCountries DESC, c.Description

-------------------------------------------
-- Problem 11
-------------------------------------------
SELECT 
	cn.ContinentName,
	SUM(c.AreaInSqKm) AS CountriesArea,
	sum(cast(c.Population as bigint)) AS CountriesPopulation
FROM Continents AS cn
JOIN Countries AS c
ON cn.ContinentCode = c.ContinentCode
GROUP BY cn.ContinentName
ORDER BY CountriesPopulation DESC

-------------------------------------------
-- Problem 12
-------------------------------------------
SELECT 
	c.CountryName,
	MAX(p.Elevation) AS HighestPeakElevation,
	MAX(r.Length) as LongestRiverLength
FROM Countries AS c
LEFT JOIN CountriesRivers AS cr
ON c.CountryCode = cr.CountryCode
LEFT JOIN Rivers AS r
ON cr.RiverId = r.Id
LEFT JOIN MountainsCountries AS mc
ON mc.CountryCode = c.CountryCode
LEFT JOIN Mountains AS m
ON mc.MountainId = m.Id
LEFT JOIN Peaks AS p
ON p.MountainId = m.Id
GROUP BY c.CountryName
ORDER BY HighestPeakElevation DESC, LongestRiverLength DESC, c.CountryName ASC

-------------------------------------------
-- Problem 13
-------------------------------------------
SELECT 
	p.PeakName,
	r.RiverName,
	LOWER(SUBSTRING(p.PeakName, 1, LEN(p.PeakName) - 1) + r.RiverName) AS Mix
FROM Peaks AS p
JOIN Rivers as r
ON RIGHT(p.PeakName, 1) LIKE LEFT(r.RiverName, 1)
ORDER BY Mix ASC

-------------------------------------------
-- Problem 14
-------------------------------------------
;WITH chp AS
    (SELECT
	    c.CountryName,
        p.PeakName,
        p.Elevation,
        m.MountainRange,
        ROW_NUMBER() OVER (PARTITION BY c.CountryName ORDER BY p.Elevation DESC) AS rn
    FROM Countries AS c
    LEFT JOIN CountriesRivers AS cr
    ON c.CountryCode = cr.CountryCode
    LEFT JOIN MountainsCountries AS mc
    ON mc.CountryCode = c.CountryCode
    LEFT JOIN Mountains AS m
    ON mc.MountainId = m.Id
    LEFT JOIN Peaks p
    ON p.MountainId = m.Id)

SELECT
    chp.CountryName AS [Country],
    ISNULL(chp.PeakName, '(no highest peak)') AS [Highest Peak Name],
    ISNULL(chp.Elevation, 0)  AS [Highest Peak Elevation],
    CASE WHEN chp.PeakName IS NOT NULL THEN chp.MountainRange ELSE '(no mountain)' END AS [Mountain]
FROM chp
WHERE rn = 1

-------------------------------------------
-- Problem 15
-------------------------------------------
USE Geography
GO

CREATE TABLE Monasteries(
	Id INT IDENTITY PRIMARY KEY,
	Name NVARCHAR(50) NOT NULL,
	CountryCode CHAR(2) FOREIGN KEY REFERENCES Countries(CountryCode))
GO

INSERT INTO Monasteries(Name, CountryCode) VALUES
('Rila Monastery “St. Ivan of Rila”', 'BG'), 
('Bachkovo Monastery “Virgin Mary”', 'BG'),
('Troyan Monastery “Holy Mother''s Assumption”', 'BG'),
('Kopan Monastery', 'NP'),
('Thrangu Tashi Yangtse Monastery', 'NP'),
('Shechen Tennyi Dargyeling Monastery', 'NP'),
('Benchen Monastery', 'NP'),
('Southern Shaolin Monastery', 'CN'),
('Dabei Monastery', 'CN'),
('Wa Sau Toi', 'CN'),
('Lhunshigyia Monastery', 'CN'),
('Rakya Monastery', 'CN'),
('Monasteries of Meteora', 'GR'),
('The Holy Monastery of Stavronikita', 'GR'),
('Taung Kalat Monastery', 'MM'),
('Pa-Auk Forest Monastery', 'MM'),
('Taktsang Palphug Monastery', 'BT'),
('Sümela Monastery', 'TR')
GO

ALTER TABLE Countries ADD IsDeleted BIT NOT NULL DEFAULT 0
GO

UPDATE Countries
SET IsDeleted = 1
WHERE CountryCode IN 
	(SELECT
	    c.CountryCode
    FROM Countries AS c
    LEFT JOIN CountriesRivers AS cr
    ON c.CountryCode = cr.CountryCode
	GROUP BY c.CountryCode
	HAVING COUNT(*) > 3)
GO

SELECT 
	m.Name AS [Monastery],
	c.CountryName AS [Country]
FROM Monasteries AS m
JOIN Countries AS c
	ON m.CountryCode = c.CountryCode AND c.IsDeleted = 0
ORDER BY m.Name
GO

-------------------------------------------
-- Problem 16
-------------------------------------------
USE Geography
GO

UPDATE Countries
SET CountryName = 'Burma'
WHERE CountryName = 'Myanmar'
GO

INSERT INTO Monasteries(Name, CountryCode) VALUES
	('Hanga Abbey', (SELECT c.CountryCode FROM Countries AS c WHERE c.CountryName = 'Tanzania')),
	('Myin-Tin-Daik', (SELECT c.CountryCode FROM Countries AS c WHERE c.CountryName = 'Myanmar'))
GO

SELECT
	cn.ContinentName,
	c.CountryName,
	COUNT(m.Id) AS [MonasteriesCount]
FROM Countries AS c
JOIN Continents AS cn
	ON c.ContinentCode = cn.ContinentCode
LEFT JOIN Monasteries AS m
	ON c.CountryCode = m.CountryCode
GROUP BY cn.ContinentName, c.CountryName, c.IsDeleted
HAVING c.IsDeleted = 0
ORDER BY [MonasteriesCount] DESC, c.CountryName ASC

-------------------------------------------
-- Problem 17
-------------------------------------------
USE Geography
GO

USE Geography
GO

CREATE FUNCTION fn_MountainsPeaksJSON () RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @json NVARCHAR(MAX)
	DECLARE @res TABLE(mi INT, MountainRange NVARCHAR(50), pi INT, PeakName NVARCHAR(50), Elevation INT) 
	INSERT INTO @res
		SELECT
			m.Id,
			m.MountainRange,
			p.Id,
			p.PeakName,
			p.Elevation
		FROM Mountains AS m
		LEFT JOIN Peaks AS p
			ON m.Id = p.MountainId	

	SET @json = '{"mountains":[' + 
		STUFF((
			SELECT 
				',{"name":"' + t1.Name
				+ '","peaks":' + ISNULL(t1.Peaks, '[]') + '}'
			FROM 		
				(SELECT
					t.mi,  
					t.MountainRange AS Name,
					'[{' + 
					STUFF(ISNULL(
						(SELECT 
							',{"name":"' + 
							x.PeakName + '","elevation":' + 
							CAST(x.Elevation AS NVARCHAR(MAX)) + '}'
						FROM @res x
						WHERE x.MountainRange = t.MountainRange
						GROUP BY x.pi, x.PeakName, x.Elevation
						FOR XML PATH (''), TYPE).value('.','NVARCHAR(max)'), ''), 1, 2, '') + 
					']' AS [Peaks]
				FROM @res t
				GROUP BY t.mi, t.MountainRange) AS t1
			FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(max)'), 1, 1, '')
	 + ']}'

	RETURN @json
END
GO

SELECT dbo.fn_MountainsPeaksJSON()
