unit Tools;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

var
  HomePath: string;
  LanPath: string;
  LanCatPath: string;

  SelectedLanguage: string;
  ButtonPress: integer;

function GetUId: string;
function IsAlphaNum(S: string): boolean;
function FixPath(S: string): string;
function NewLanFolder(sName: string): integer;
function NewLanCatFolder(sLanPath, sName: string): integer;
function NewCodeFile(sLanPath, sName: string): integer;

implementation

function GetUId: string;
begin
  Result := FormatDateTime('hhnnsszzzMMDD', Now);
end;

function IsGoodName(S: string): boolean;
var
  X: integer;
  flag: boolean;
begin
  flag := True;

  for X := 1 to Length(S) do
  begin
    if not (S[X] in ['A'..'Z', 'a'..'z', '0'..'9', '-', '+', ' ']) then
    begin
      flag := False;
      Break;
    end;
  end;
  Result := flag;
end;

function IsAlphaNum(S: string): boolean;
var
  X: integer;
  flag: boolean;
begin
  flag := True;
  for X := 1 to Length(S) do
  begin
    if not (S[X] in ['A'..'Z', 'a'..'z', '0'..'9']) then
    begin
      flag := False;
      Break;
    end;
  end;
  Result := flag;
end;

function FixPath(S: string): string;
begin
  if RightStr(S, 1) <> PathDelim then
  begin
    Result := S + PathDelim;
  end
  else
  begin
    Result := S;
  end;
end;

function NewLanFolder(sName: string): integer;
var
  rCode: integer;
  sDir: string;
begin
  rCode := 1;
  sDir := HomePath + sName;

  if Length(sName) = 0 then
  begin
    rCode := 0;
  end
  else if not IsGoodName(sName) then
  begin
    rCode := 2;
  end
  else if DirectoryExists(sDir) then
  begin
    rCode := 3;
  end
  else
  begin
    CreateDir(HomePath + sName);
  end;
  Result := rCode;
end;

function NewLanCatFolder(sLanPath, sName: string): integer;
var
  rCode: integer;
  sDir: string;
begin
  rCode := 1;
  sDir := sLanPath + sName;

  if Length(sName) = 0 then
  begin
    rCode := 4;
  end
  else if not IsAlphaNum(sName) then
  begin
    rCode := 5;
  end
  else if DirectoryExists(sDir) then
  begin
    rCode := 6;
  end
  else
  begin
    CreateDir(sDir);
  end;
  Result := rCode;
end;

function NewCodeFile(sLanPath, sName: string): integer;
var
  rCode: integer;
  tf: TextFile;
  lzFile: string;
begin
  rCode := 1;
  lzFile := sLanPath + sName + '_' + GetUId + '.dat';

  if Length(sName) = 0 then
  begin
    rCode := 7;
  end
  else if not IsGoodName(sName) then
  begin
    rCode := 8;
  end
  else if FileExists(lzFile) then
  begin
    rCode := 9;
  end
  else
  begin
    AssignFile(tf, lzFile);
    Rewrite(tf);
    CloseFile(tf);
  end;

  Result := rCode;
end;

end.
