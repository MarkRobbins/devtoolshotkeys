; #INDEX# =======================================================================================================================
 ; Title .........: DevTools Hotkeys v1.0.0.0
 ; AutoIt Version : 3.3
 ; Language ......: English (language independent)
 ; Description ...:
 ; Author(s) .....: MarkRobbins
 ; Copyright .....: Copyright (C) Mark C Robbins. All rights reserved.
 ; License .......: Artistic License 2.0, see Artistic.txt
 ;
 ; DevTools Menu1 Do is free software; you can redistribute it and/or modify
 ; it under the terms of the Artistic License as published by Larry Wall,
 ; either version 2.0, or (at your option) any later version.
 ;
 ; This program is distributed in the hope that it will be useful,
 ; but WITHOUT ANY WARRANTY; without even the implied warranty of
 ; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 ; See the Artistic License for more details.
 ;
 ; You should have received a copy of the Artistic License with this Kit,
 ; in the file named "Artistic.txt".  If not, you can get a copy from
 ; <http://www.perlfoundation.org/artistic_license_2_0> OR
 ; <http://www.opensource.org/licenses/artistic-license-2.0.php>
 ;
 ; ===============================================================================================================================

; #OVERVIEW# ===========================================================================================================
 ; SOURCE_______________________________________________________________________________________________________________
  ; Organization ..: Mark Robbins and Associates
  ; Author ........: Mark Robbins
 ; LOG__________________________________________________________________________________________________________________
  ; Created .......: 2015.06.05.16.51.02
  ; Modified ......: 2015.06.05.16.51.02
  ; Entries........: yyyy.mm.dd.hh.mm.ss Comments
 ; HEADER_______________________________________________________________________________________________________________
  ; Type ..........: Controller
  ; Subtype .......:
  ; Name ..........: DevTools Hotkeys
  ; Summary .......:
  ; Description ...:
  ;
  ; Remarks .......:
 ; DEVELOPMENT__________________________________________________________________________________________________________
  ; Issues ........:
  ; Status ........: [X] New
  ;                  [ ] Open
  ;                  [ ] InProgress
  ;                  [ ] Resolved
  ;                  [ ] Closed
 ; OTHER________________________________________________________________________________________________________________
  ; Related .......:
  ; Related Links .:
  ; Resources......:
 ; =====================================================================================================================
#NoTrayIcon
#include <Array.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>
;#include "C:\batch\devtools-menu1-scrolls.au3"
;#include "C:\batch\devtools-menu1-cmds.au3"
;#include "C:\batch\devtools-menu1-utils.au3"

;e C:\batch\devtools-menu1-utils.au3



Global Const $thisfile=@ScriptDir&"\devtoolshotkeys.au3"
Global Const $f_in=@ScriptDir&"\devtoolshotkeys.ini";
Global Const $f_ini=@ScriptDir&"\devtoolshotkeys-menu.ini"

Global $logg=@ScriptDir&"\devtoolshotkeys-log.txt";
Global $timestamp=@YEAR&"."&@MON&"."&@MDAY&"."&@HOUR&"."&@MIN&"."&@SEC&"."&@MSEC

Global $testing=True

If $CmdLine[0]<>0 Then
  $testing=False
EndIf
Global $p1='topbar-inspect'
$p1='topbar-elements'
$p1='cmd-poswin'
$p1='topbar-condrawer'
$p1='topbar-redirect'
;$p1='topbar-elements'
Global Const $fakezeroparams=True

If Not $testing Then
  If $CmdLine[0]>1 Then
    BadParams("Need 0 or 1 params, Exiting")
    Exit
  EndIf
  If $CmdLine[0]==1 Then
    $p1=$CmdLine[1]
  EndIf
EndIf


Global $_assigns='';
Global $doing=False;


Global $wh1='';
If FileExists($f_ini) Then
  $wh1=IniRead($f_ini,'data','hwnd','')
EndIf
;Msg($wh1)
Global $wh=WinGetHandle('[active]')
Global $wh0=WinGetHandle('[active]')
If $wh1<>'' Then
  $wh=HWnd($wh1)
EndIf
If Not WinExists($wh) Then
  ;1 = Match the title from the start (default)
  Opt("WinTitleMatchMode",1)
  $wh=WinGetHandle('Developer Tools -');
EndIf
Global $w_p=WinGetPos($wh)
Global $right=$w_p[0]+$w_p[2];
Global $bottom=$w_p[1]+$w_p[3];
Global $width=$w_p[2]
Global $height=$w_p[3]
Global $left=$w_p[0]
Global $top=$w_p[1]
Global $title=WinGetTitle($wh)

Opt("MouseCoordMode",1)
Global $pos=MouseGetPos();
Global $mouse_x=$pos[0];
Global $mouse_y=$pos[1];

Global $type; toptab
Global $name; one of compressed

Global $xx

;Msg(@DesktopWidth)

Func Test1()
  Local $x
  Execute('xx="ss"');
  MsgBox(0,'x',$xx)
EndFunc
;Test1()
;Exit



Local $xx
;Local $var = Int($xx)
;MsgBox(0,$thisfile, IsInt($xx));

ReadConst()
ReadCfg()
ReadA()
ReadCtrl()
ReadDims()
ReadTypes()
ReadPoints()
;MsgBox(0,$thisfile, $types_s);
;MsgBox(0,$thisfile, $console_y);
;_ArrayDisplay($types_a)
;ClipPut($_assigns);

;MsgBox(0,$thisfile, $stylescroll_y);

If $testing Then
  If $fakezeroparams Then
    DoSelect()
    Exit
  EndIf
Else
  If $CmdLine[0]==0 Then
    DoSelect()
    Exit
  EndIf
EndIf


GetType()

;validate type
ValidateType()
;MsgBox(0,$thisfile, $type);
ValidateName()

;Msg('11')
Exit



Dispatch()

Exit

Func Dispatch()
  If $type=='cmd' Then
    TryCmd()
  Else
    DoName()
  EndIf
EndFunc


Func DoThis($t,$n)
  Local $wasdoing=$doing
  Local $t0=$type
  Local $n0=$name
  $doing=True;
  $type=$t;
  $name=$n;
  ValidateType()
  ValidateName()
  Dispatch()
  $name=$n0
  $type=$t0
  $doing=$wasdoing;
EndFunc

Func TryCmd()
  Local $a=IniReadSection($f_in,$name&'_cmd')
  If Not IsArray($a) Then
    MsgBox(0,$thisfile&' Command Section Not Found, Exiting',$name&'_cmd')
    Exit
  EndIf
  Local $dec=IniRead($f_in,$name&'_cmd','declare','');
  Local $__x
  Local $__v
  If $dec=='' Then
    ;MsgBox(0,$thisfile&' Command declare Not Found, Exiting',$name&'_cmd')
    ;Exit
  Else
    $dec=StringSplit($dec,' ',2)
    For $__x=0 To UBound($dec)-1
      $__v=IniRead($f_in,$name&'_cmd',$dec[$__x],'');
      $__v=Execute($__v)
      Assign($dec[$__x],$__v,1);local
    Next
  EndIf
  ;MsgBox(0,'vals:x,w',$x&' '&$w)
  $__x=0
  While True
    $__x=$__x+1
    $__v=IniRead($f_in,$name&'_cmd',''&$__x,'');
    If $__v=='' Then
      ExitLoop
    EndIf
    ;Msg($__v)
    $__v=Execute($__v)
  WEnd
  Util_mousehome()
EndFunc

Func Of($what,$d); _x _y _w _h _tabs
  Local $r=Eval($type&'_'&$name&'_'&$what)
  If @Error Then
    Return $d
  EndIf
  Return $r
EndFunc

Func OfType($what,$d); _x _y _w _h _tabs
  Local $r=Eval($type&'_'&$what)
  If @Error Then
    Return $d
  EndIf
  Return $r
EndFunc

Func Origin()
  Local $on=OriginName();
  If $on==-1 Then
    Return OriginType()
  EndIf
  Return $on;
EndFunc

Func OriginType()
  Local $v=IniRead($f_in,$type,'origin','')
  If $v=='' Then
    Local $a[2];
    $a[0]=$left;
    $a[1]=$top;
    Return $a;
    Exit
  EndIf
  $v=StringSplit($v,'|',2)
  If Not IsArray($v) Then
    MsgBox(0,$thisfile&'Origin Does not parse to Array[2] with vertical bar',$v)
    Exit
  EndIf
  $v[0]=Execute($v[0])
  $v[1]=Execute($v[1])
  Return $v
EndFunc

Func OriginName()
  Local $v=IniRead($f_in,$type&'_'&$name,'origin','')
  If $v=='' Then
    Return -1;
  EndIf
  $v=StringSplit($v,'|',2)
  If Not IsArray($v) Then
    MsgBox(0,$thisfile&'Origin Does not parse to Array[2] with vertical bar',$v)
    Exit
  EndIf
  $v[0]=Execute($v[0])
  $v[1]=Execute($v[1])
  Return $v
EndFunc



Func IsCtrl()
  Local $v=Eval($type&'_ctrl_a');
  If @Error Then
    Return False
  EndIf
  Local $i=_ArraySearch($v,$name);
  If $i<>-1 Then
    Return True
  EndIf
  Return False
EndFunc

Func CheckValid($nx,$ny)
  If $nx<$left Or $nx>$right Or $ny<$top Or $ny>$bottom Then
    ToolTip("Out of Bounds:"&$type&' '&$name);
    Return False;
  EndIf
  Return True;
EndFunc

Func AfterKeys()
  Local $v=IniRead($f_in,$type&'_'&$name,'afterkeys','');
  If $v<>'' Then
    Sleep(500)
    Send($v)
  EndIf
EndFunc


Func DoName()
  Local $tx=OfType('x',0);
  Local $ty=OfType('y',0)
  Local $ix=Of('x',0);
  Local $iy=Of('y',0)
  Local $o=Origin()
  Local $nx=$tx+$ix+$o[0];
  Local $ny=$ty+$iy+$o[1];
  ;WinActivate($wh)
  ;ToolTip($type&' '&$name,$nx,$ny)
  ;Sleep(3000)
  Local $demo=True;
  $demo=False;
  Local $s='';
  $s=$s&$tx&' '&$ty&@CRLF;
  $s=$s&$ix&' '&$iy&@CRLF;
  $s=$s&$o[0]&' '&$o[1]&@CRLF;
  If Not CheckValid($nx,$ny) Then
    Exit
  EndIf
  MouseMove($nx,$ny,0)
  If IsCtrl() Then
    If $demo Then
      ToolTip('{Ctrldown}');
      Sleep(2000)
    Else
      Send('{Ctrldown}');
    EndIf
  EndIf
  If $demo Then
    ToolTip('Mouse:Left');
    Sleep(2000)
  Else
    MouseClick('left');
  EndIf
  If IsCtrl() Then
    If $demo Then
      ToolTip('{Ctrlup}');
      Sleep(2000)
    Else
      Send('{Ctrlup}');
    EndIf
  EndIf
  If Not $doing Then
    AfterKeys()
  EndIf
  Util_mousehome()
  ;ClipPut($s)
  ;0 0
  ;0 0
  ;-1820 136
  ;ClipPut($_assigns)

;19 0
;19 0
;-1820 136


  ;MouseMove($w_left+$px,$w_top+$topbar_y,0);
  ;MouseClick('left')
  ;Util_mousehome()
  ;Sleep(1000)
  ;OnTopTab()
EndFunc










Func Read_($sec,$k,$silent)
  Local $a=IniReadSection($f_in,$sec)
  If IsArray($a) Then
    IniItems($a,$sec,$k)
  Else
    If $silent Then
    Else
      MsgBox(0,$thisfile&' Section Missing, Exit',$sec);
      Exit;
    EndIf
  EndIf
EndFunc


Func ReadType($n)
  Local $x;
  For $x=0 To UBound($typesecsfx_a)-1
    Read_($n&''&$typesecsfx_a[$x],'type',True); _x _y _w _h _tabs
  Next
EndFunc

Func ReadTypes()
  Local $x;
  For $x=0 To UBound($types_a)-1
    ReadType($types_a[$x]);
  Next
EndFunc

Func ReadCtrl()
  Return Read_('_ctrl','',False);
EndFunc

Func ReadPoints()
  Return Read_('_pt','',False);
EndFunc



Func ReadDims()
  Local $x;
  For $x=0 To UBound($dimsecsfx_a)-1
    Read_($dimsecsfx_a[$x],'',False);
  Next
EndFunc


Func ReadConst()
  Return Read_('_const','',False);
EndFunc
Func ReadCfg()
  Return Read_('_cfg','',False);
EndFunc
Func ReadA()
  Return Read_('_a','',False);
EndFunc

Func IniItems($a,$sec,$k)
  Local $x;
  For $x=1 To $a[0][0]
    IniItem($a[$x][0],$a[$x][1],$sec,$k)
  Next
EndFunc

Func DoAssign($n,$v)
  $_assigns=$_assigns&@CRLF&$n;
  Assign($n,$v,2)
EndFunc

Func IniItem($n,$v,$sec,$k)
  Local $scope=2
  If IsInt($v) Then
    $v=Int($v)
  EndIf
  ;ToolTip(StringInStr($k,'_a'))
  ;Sleep(1000)
  If $k=='type' Then
    Local $name=StringSplit($sec,'_',2);
    DoAssign($name[0]&'_'&$n&'_'&$name[1],$v)
    Return
  EndIf
  If $sec=='_a' Then
    Local $temp=StringSplit($v,' ',2)
    DoAssign($n&$sec,$temp)
    Return
  EndIf
  If $sec=='_ctrl' Then
    Local $temp=StringSplit($v,' ',2)
    DoAssign($n&$sec&'_a',$temp)
    Return
  EndIf
  If $sec=='_x' Or $sec=='_y' Or $sec=='_w' Or $sec=='_h' Then
    DoAssign($n&$sec,$v)
    Return
  EndIf
  If $sec=='_pt' Then
    Local $temp=StringSplit($v,'|',2)
    If Not IsArray($temp) Then
      MsgBox(0,$thisfile&' syntax error does not parse to array[2] with vertical bar delimiter, exiting',$v)
      Exit
    Else
      $temp[0]=Execute($temp[0])
      $temp[1]=Execute($temp[1])
      DoAssign($n&$sec,$temp)
      DoAssign($n&'_x',$temp[0])
      DoAssign($n&'_y',$temp[1])
    EndIf
    ;$temp[0]
    Return
  EndIf
  DoAssign($n,$v)
EndFunc

Func ValidateType()
  Local $type_idx=_ArraySearch($types_a,$type);
  If $type_idx<>-1 Then
    Return True;Call('Do_'&$type);
  Else
    MsgBox(0,'Type Not Found: Exiting',$type);
    Exit
  EndIf
EndFunc

Func ValidateName()
  Local $test=Eval($type&'_a')
  If IsArray($test) Then
    ;_ArrayDisplay($test)
    Local $i=_ArraySearch($test,$name);
    If $i<>-1 Then
      Return True;
    Else
      MsgBox(0,'Name Not Found for Type '&$type&': Exiting',$name);
      Exit;
    EndIf
  Else
    MsgBox(0,'Cmd Name Array Not Found for Type '&$type&': Exiting',$name);
    Exit
  EndIf
EndFunc

Func DoSelect()
  Local $l='Help|Clip Commandline params';
  Local $t='Select'
  Local $d=''
  If True Then
    Local $r=DoSelect_($t,$l,$d)
    If $r<>'' Then
      $r=StringReplace($r,' ','_');
      $r=StringLower($r)
      Call('Do_'&$r);
    EndIf
  EndIf
  ;ClipPut(Lib_typenamelist())
  ;Msg('r:'&$r)
EndFunc
Func DoSelect_($t,$l,$d)
  Local $la=StringSplit($l,'|',2);
  Local $di=_ArraySearch($la,$d)
  If $di<>-1 Then
    _ArrayDelete($la,$di);
    $l=_ArrayToString($la,'|')
  EndIf
  ;$ch=StringSplit($ch,'|',2)
  ;GUICreate ( "title" [, width [, height [, left [, top [, style [, exStyle [, parent]]]]]]] )
  Local $ww=500
  Local $hh=400
  Local $h=GUICreate($t, $ww, $hh, (@DesktopWidth/2) - ($ww/2), (@DesktopHeight/2) - ($hh/2))
  Local $msg
  ;GUICtrlCreateCombo ( "text", left, top [, width [, height [, style [, exStyle]]]] )
  Local $list=GUICtrlCreateList($d, 0, 0, $ww,$hh-50)
  GUICtrlSetData(-1, $l, $d)
  Local $cancel=GUICtrlCreateButton ( "Cancel", 10, $hh-50, ($ww-30)/2 , 50)
  Local $ok=GUICtrlCreateButton ( "Ok", ($ww/2)+4, $hh-50, ($ww-30)/2 , 50,$BS_DEFPUSHBUTTON)
  GUISetState(@SW_SHOW)
  Local $r
  While True
    $msg = GUIGetMsg()
    If $msg = $GUI_EVENT_CLOSE Then
      $r='cancel'
      ExitLoop
    EndIf
    If $msg = $ok Then
      $r='ok'
      ExitLoop
    EndIf
    If $msg = $cancel Then
      $r='cancel'
      ExitLoop
    EndIf
  WEnd
  If $r='ok' Then
    $r=GUICtrlRead($list)
    GUIDelete()
    Return $r
  EndIf
  GUIDelete()
  Return ''
EndFunc


Func Do_clip_commandline_params()
  ClipPut(Lib_typenamelist())
  ToolTip('CommandLine Params on Clipboard')
  Sleep(2000)
EndFunc

Func Lib_typenamelist()
  Local $x;
  Local $y;
  Local $s='';
  Local $d=@CR;
  For $x=0 To UBound($types_a)-1
    ;$s=$s&@TAB
    Local $aa=Eval($types_a[$x]&'_a')
    For $y=0 To UBound($aa)-1
      If $s<>'' Then
        $s=$s&$d
      EndIf
      $s=$s&$types_a[$x]&'-'&$aa[$y]
    Next
  Next
  Return $s
EndFunc




Func Msg($s)
  MsgBox(0,$thisfile,$s)
EndFunc


Func GetType()
  Local $x;
  For $x=0 To UBound($types_a)-1
    GetTypeWith($types_a[$x]);
  Next
EndFunc
Func GetTypeWith($n)
  If StringInStr($p1,$n&'-')<>0 Then
    $type=$n;
    $name=StringReplace($p1,$n&'-','');
    $name=StringReplace($name,'-','');
    Return
  EndIf
EndFunc

Func AmUndocked()
  Return StringInStr($w_t,'Developer Tools - ')<>0;
EndFunc





;;;;;;functions
Func ts()
  Return @YEAR&"."&@MON&"."&@MDAY&"."&@HOUR&"."&@MIN&"."&@SEC&"."&@MSEC
EndFunc
Func logline($line)
  Local $fh1=FileOpen($logg,1);
  If $fh1<>-1 Then
    FileWriteLine($fh1,$line)
    FileClose($fh1)
  EndIf
EndFunc
Func snarl($i,$t,$s)
  $snarl="C:\batch\Snarl_CMD.exe";
  $s1=StringReplace($s,'"',"'")
  $t1=StringReplace($t,'"',"'")
  $cmd=$snarl&' snShowMessage '&$i&' "'&$t1&'" "'&$s1&'"';
  Run($cmd)
EndFunc
Func BadParams($msg)
  SplashTextOn("Bad parameters",$msg, 700, 200, 10, 10, 0, "Arial", 10)
  Sleep(5*1000)
  SplashOff()
  Exit
EndFunc





