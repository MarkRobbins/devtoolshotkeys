; #INDEX# =======================================================================================================================
 ; Title .........: DevTools Hotkeys Menu v1.0.0.0
 ; AutoIt Version : 3.3
 ; Language ......: English (language independent)
 ; Description ...:
 ; Author(s) .....: MarkRobbins
 ; Copyright .....: Copyright (C) Mark C Robbins. All rights reserved.
 ; License .......: Artistic License 2.0, see Artistic.txt
 ;
 ; DevTools Hotkeys is free software; you can redistribute it and/or modify
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
  ; Created .......: 2015.06.05.16.40.58
  ; Modified ......: 2015.06.05.16.40.58
  ; Entries........: yyyy.mm.dd.hh.mm.ss Comments
 ; HEADER_______________________________________________________________________________________________________________
  ; Type ..........: Driver
  ; Subtype .......:
  ; Name ..........: DevTools Hotkeys Menu
  ; Summary .......: Copies Window Info and launches MenuApp
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

Global $thisfile=@ScriptDir&"\devtoolshotkeys-menu.au3"
Global $dofile=@ScriptDir&"\devtoolshotkeys.au3"
Global $logg=@ScriptDir&"\devtoolshotkeys-menu-log.txt";
Global $timestamp=@YEAR&"."&@MON&"."&@MDAY&"."&@HOUR&"."&@MIN&"."&@SEC&"."&@MSEC
Global Const $f_ini=@ScriptDir&"\devtoolshotkeys-menu.ini"
Global Const $f_in=@ScriptDir&"\devtoolshotkeys.ini"
Global $testing=True
Global Const $menuappexe=IniRead($f_in,'_cfg','menuapp','')
Global Const $menudir=@ScriptDir&"\menu";

If $CmdLine[0]<>0 Then
  $testing=False
EndIf


If Not $testing Then
  If $CmdLine[0]<>0 Then
    BadParams($thisfile&":Need 0 params - exiting")
    Exit
  EndIf
EndIf

If Not FileExists($menuappexe) Then
  MsgBox(0,$thisfile,"Cannot find MenuApp at '"&$menuappexe&"', Check ini settings, Exiting...")
  Exit 1
EndIf
If Not FileExists($menudir) Then
  MsgBox(0,$thisfile,"Cannot find Menu Directory at '"&$menudir&"', Run "&$dofile&" with no params and select 'Generate Menu', Exiting...")
  Exit 1
EndIf

;MsgBox(0,'ok',$thisfile);
Opt("MouseCoordMode",1)
Local $pos=MouseGetPos();
Global $wh=WinGetHandle('[active]')
Global $w_p=WinGetPos($wh)
Global $w_t=WinGetTitle($wh)



If Not AmUndocked() Then
  IniWrite($f_ini,'data','hwnd',String($wh))
  DoDocked()
Else
  DoUndocked()
EndIf

Exit


Func AmUndocked()
  Return StringInStr($w_t,'Developer Tools - ')<>0;
EndFunc


Func DoUndocked()
  MouseMove($w_p[0]+10,$w_p[1]+52,0)
  ShellExecute($menuappexe,$menudir)
  Sleep(500)
  MouseMove($pos[0],$pos[1],0);
EndFunc


Func DoDocked()
  MsgBox(0,$thisfile,"Does not work currently with Docked DevTools, Exiting");
  Exit
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

