#!MC 1120
# Created by Tecplot 360 build 11.3.29.563
$!Varset |blocks| = 1
$!Varset |body| = 100
$!Varset |fint| = 500

$!Loop |blocks|

$!NEWLAYOUT 

$!Varset |bnum| = (|Loop|+|body|-1)
$!Varset |fnum| = (|Loop|+|fint|-1)

$!READDATASET  ' "fort.|bnum|.plt" '
  READDATAOPTION = APPEND
  RESETSTYLE = YES
  INCLUDETEXT = NO
  INCLUDEGEOM = NO
  INCLUDECUSTOMLABELS = NO
  VARLOADMODE = BYNAME
  ASSIGNSTRANDIDS = YES
  INITIALPLOTTYPE = CARTESIAN3D
  VARNAMELIST = '"x" "y" "p" "u" "v"'

$!Varset |first| = (|NUMZONES|+1)

$!READDATASET  ' "fort.|fnum|.plt" '
  READDATAOPTION = APPEND
  RESETSTYLE = YES
  INCLUDETEXT = NO
  INCLUDEGEOM = NO
  INCLUDECUSTOMLABELS = NO
  VARLOADMODE = BYNAME
  ASSIGNSTRANDIDS = YES
  INITIALPLOTTYPE = CARTESIAN3D
  VARNAMELIST = '"x" "y" "p" "u" "v"'

$!Varset |steps| = (|NUMZONES|-1)

$!ALTERDATA
  EQUATION = '{p} = {p}[1]'

$!WRITEDATASET  "./bodyInfo.|bnum|.plt"
  INCLUDETEXT = NO
  INCLUDEGEOM = NO
  INCLUDECUSTOMLABELS = NO
  ASSOCIATELAYOUTWITHDATAFILE = NO
  ZONELIST =  [|first|-|NUMZONES|]
  INCLUDEDATASHARELINKAGE = YES
  BINARY = YES
  USEPOINTFORMAT = NO
  PRECISION = 9

$!Endloop

$!NEWLAYOUT 
$!Varset |current| = (|body|-1)

$!Loop |blocks|
$!Varset |current| += 1

$!READDATASET  ' "bodyInfo.|current|.plt" '
  READDATAOPTION = APPEND
  RESETSTYLE = YES
  INCLUDETEXT = NO
  INCLUDEGEOM = NO
  INCLUDECUSTOMLABELS = NO
  VARLOADMODE = BYNAME
  ASSIGNSTRANDIDS = YES
  INITIALPLOTTYPE = CARTESIAN3D
  VARNAMELIST = '"x" "y" "p" "u" "v"'
$!Endloop

$!VarSet |first| = (|NUMZONES|+1)

$!GLOBALCONTOUR 1  VAR = 3
$!FIELDLAYERS SHOWCONTOUR = YES
$!FIELDMAP CONTOUR{CONTOURTYPE = LINES}
$!CONTOURLEVELS NEW
  RAWDATA
1
0

$!ADDONCOMMAND ADDONID='Extend Time MCR' 
  COMMAND='QUERY.NUMTIMESTEPS NUMTIMESTEPS'

$!LOOP |NUMTIMESTEPS|
   $!EXTENDEDCOMMAND 
     COMMANDPROCESSORID='extend time mcr' 
     COMMAND='SET.CURTIMESTEP |LOOP|'
   $!CREATECONTOURLINEZONES 
     CONTLINECREATEMODE = ONEZONEPERCONTOURLEVEL
$!ENDLOOP

$!ALTERDATA 
  EQUATION = '{mag} = 0'
$!ALTERDATA
  EQUATION = '{x2} = 0'
$!ALTERDATA
  EQUATION = '{cf} = 0'
$!ALTERDATA  [|first|-|NUMZONES|]
  EQUATION = '{mag} = sqrt({u}**2+{v}**2)*sign({u})'
$!ALTERDATA  [|first|-|NUMZONES|]
  EQUATION = '{x2} = cos(4/180*3.14159)*{x}-sin(4/180*3.14159)*{y}'

$!LOOP |NUMTIMESTEPS|
$!VarSet |curr| = (|first|+|loop|-1)
  $!ALTERDATA [|first|-|NUMZONES|]
    EQUATION = '{cf} = {cf}+{mag}[|curr|]'
$!ENDLOOP
$!ALTERDATA [|first|-|NUMZONES|]
  EQUATION = '{cf} = {cf}/|NUMTIMESTEPS|'


$!WRITEDATASET  "bodyInfo.dat"
  INCLUDETEXT = NO
  INCLUDEGEOM = NO
  INCLUDECUSTOMLABELS = NO
  INCLUDEDATASHARELINKAGE = YES
  ASSOCIATELAYOUTWITHDATAFILE = NO
  ZONELIST =  [|first|-|NUMZONES|]
  BINARY = NO
  USEPOINTFORMAT = NO
  PRECISION = 9

$!WRITEDATASET  "bodyInfo.plt"
  INCLUDETEXT = NO
  INCLUDEGEOM = NO
  INCLUDECUSTOMLABELS = NO
  INCLUDEDATASHARELINKAGE = YES
  ASSOCIATELAYOUTWITHDATAFILE = NO
  ZONELIST =  [|first|-|NUMZONES|]
  BINARY = YES
  USEPOINTFORMAT = NO
  PRECISION = 9