#!MC 1120
# Created by Tecplot 360 build 11.3.29.563
$!Varset |blocks| = 12
$!Varset |body| = 100
$!Varset |press| = 300
$!Varset |fint| = 500

$!Loop |blocks|

$!NEWLAYOUT 

$!Varset |bnum| = (|Loop|+|body|-1)
$!Varset |pnum| = (|Loop|+|press|-1)
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
  VARNAMELIST = '"x" "y" "z" "p" "f" "dis"'

$!READDATASET  ' "fort.|fnum|.plt" '
  READDATAOPTION = APPEND
  RESETSTYLE = YES
  INCLUDETEXT = NO
  INCLUDEGEOM = NO
  INCLUDECUSTOMLABELS = NO
  VARLOADMODE = BYNAME
  ASSIGNSTRANDIDS = YES
  INITIALPLOTTYPE = CARTESIAN3D
  VARNAMELIST = '"x" "y" "z" "p" "f" "dis"'

$!Varset |steps| = (|NUMZONES|-1)
$!Varset |first| = (|NUMZONES|+1)

$!READDATASET  ' "fort.|pnum|.plt" '
  READDATAOPTION = APPEND
  RESETSTYLE = YES
  INCLUDETEXT = NO
  INCLUDEGEOM = NO
  INCLUDECUSTOMLABELS = NO
  VARLOADMODE = BYNAME
  ASSIGNSTRANDIDS = YES
  INITIALPLOTTYPE = CARTESIAN3D
  VARNAMELIST = '"x" "y" "z" "p" "f" "dis"'

$!ALTERDATA
  EQUATION = '{dis} = {p}[1]'
$!Loop |steps|
$!Varset |fzone| = (1+|Loop|)
$!Varset |pzone| = (1+|Loop|+|steps|)
$!ALTERDATA  [|pzone|]
  EQUATION = '{f} = {p}[|fzone|]'
$!Endloop

$!WRITEDATASET  "./bodyInfo.|pnum|.plt"
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
$!Varset |current| = (|press|-1)

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
  VARNAMELIST = '"x" "y" "z" "p" "f" "dis"'
$!Endloop

$!GLOBALCONTOUR 1  VAR = 6
$!ISOSURFACELAYERS SHOW = YES
$!ISOSURFACEATTRIBUTES 1  ISOVALUE1 = 0.01
$!ISOSURFACEATTRIBUTES 1  OBEYSOURCEZONEBLANKING = YES

$!RUNMACROFUNCTION  "IJKBlank"

$!VarSet |first| = (|NUMZONES|+1)
$!EXTENDEDCOMMAND 
  COMMANDPROCESSORID = 'Extract Over Time'
  COMMAND = 'ExtractIsoSurfaceOverTime'

#$!DELETEVARS [6,7]
#$!CREATEMIRRORZONES 
#  SOURCEZONES =  [|first|-|NUMZONES|]
#  MIRRORVAR = 'Y'

$!WRITEDATASET  "bodyInfo.plt"
  INCLUDETEXT = NO
  INCLUDEGEOM = NO
  INCLUDECUSTOMLABELS = NO
  INCLUDEDATASHARELINKAGE = YES
  ASSOCIATELAYOUTWITHDATAFILE = NO
  ZONELIST =  [|first|-|NUMZONES|]
  VARPOSITIONLIST =  [1-5]
  BINARY = YES
  USEPOINTFORMAT = NO
  PRECISION = 9
