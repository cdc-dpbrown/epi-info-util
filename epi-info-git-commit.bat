@ECHO OFF
COLOR 0A

ECHO :: ===============================================================
ECHO :: UPDATE VERSION
ECHO :: [BUILD] 7.2.2.V M/D/20YY 
ECHO :: ===============================================================
ECHO .
SET /P V=Minor Version(V): 
SET /P M=Month(M): 
SET /P D=Date(D): 
SET /P Y=Year(YY):
SET commit_message=[BUILD] 7.2.2.%V% %M%/%D%/20%Y%
ECHO %commit_message%
ECHO .

CD Epi-Info-Community-Edition
@ECHO ON
git status
git add SolutionInfo.cs .\EpiInfoPlugin\Properties\AssemblyInfo.cs ".\StatisticsRepository\My Project\AssemblyInfo.vb"
git status
git commit -m "%commit_message%"
git status
git pull --rebase

@ECHO OFF
CD ..

PAUSE
EXIT
