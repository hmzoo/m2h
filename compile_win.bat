cd src
haxe  m2h.hxml 
cd ..

COPY .\build\cpp\Main.exe .\bin\m2h.exe

COPY .\bin\m2h.exe .\documents\download

.\bin\m2h.exe  documents

pause

