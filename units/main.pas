unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  ComCtrls, Buttons, Menus, SynEdit, SynHighlighterPas, SynHighlighterHTML,
  SynHighlighterCpp, SynHighlighterJava, SynHighlighterVB, SynHighlighterCss,
  SynHighlighterJScript, SynHighlighterPHP, SynHighlighterPython, Tools,about;

type

  { Tfrmmain }

  Tfrmmain = class(TForm)
    cmdAddCat: TButton;
    cmdAddCode: TButton;
    cmdAddLan1: TButton;
    cmdDelLan: TButton;
    cmdDelCat: TButton;
    cmdDelCode: TButton;
    cmdCut: TButton;
    cmdCopy: TButton;
    cmdPaste: TButton;
    cmdCancel: TButton;
    cmdUndo: TButton;
    cmdSaveCode: TButton;
    cmdExport: TButton;
    cboLan: TComboBox;
    cmdAbout: TButton;
    Label1: TLabel;
    lstLan: TListBox;
    LstCats: TListBox;
    lstCodes: TListBox;
    mnuUndo: TMenuItem;
    mnuCut: TMenuItem;
    mnuCopy: TMenuItem;
    mnuPaste: TMenuItem;
    mnuSelectAll: TMenuItem;
    Separator2: TMenuItem;
    Separator1: TMenuItem;
    pCodeArea: TPanel;
    pLan: TPanel;
    pCat: TPanel;
    pCodes: TPanel;
    mnuEditMenu: TPopupMenu;
    StatusBar1: TStatusBar;
    SynCPlus: TSynCppSyn;
    SynCSS: TSynCssSyn;
    SynSource: TSynEdit;
    SynHtml: TSynHTMLSyn;
    SynJava: TSynJavaSyn;
    SynJS: TSynJScriptSyn;
    SynPas: TSynPasSyn;
    SynPHP: TSynPHPSyn;
    SynPython: TSynPythonSyn;
    SynBas: TSynVBSyn;
    procedure cboLanSelect(Sender: TObject);
    procedure cmdAboutClick(Sender: TObject);
    procedure cmdAddCatClick(Sender: TObject);
    procedure cmdAddCodeClick(Sender: TObject);
    procedure cmdAddLanClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure cmdCopyClick(Sender: TObject);
    procedure cmdCutClick(Sender: TObject);
    procedure cmdDelCatClick(Sender: TObject);
    procedure cmdDelCodeClick(Sender: TObject);
    procedure cmdDelLanClick(Sender: TObject);
    procedure cmdExportClick(Sender: TObject);
    procedure cmdPasteClick(Sender: TObject);
    procedure cmdSaveCodeClick(Sender: TObject);
    procedure cmdUndoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ErrorMsg(code: integer);
    procedure LoadItemsInList(lzPath: string; LBox: TListBox);
    procedure LstCatsClick(Sender: TObject);
    procedure lstCodesClick(Sender: TObject);
    procedure lstLanClick(Sender: TObject);
    procedure mnuCopyClick(Sender: TObject);
    procedure mnuCutClick(Sender: TObject);
    procedure mnuEditMenuPopup(Sender: TObject);
    procedure mnuPasteClick(Sender: TObject);
    procedure mnuSelectAllClick(Sender: TObject);
    procedure mnuUndoClick(Sender: TObject);
    procedure SetButtonEnable(A, B, C: boolean);
    procedure DeleteCatDir(lzPath: string);
    procedure DeleteLanDir(lzPath: string);
    procedure DeleteSourceFiles(lzPath: string);
    procedure SynSourceChange(Sender: TObject);
    procedure SynSourceChangeUpdating(ASender: TObject; AnUpdating: boolean);
    procedure EnableEditArea(Enable: boolean);
    procedure EnableItems(en: boolean);
  private
  public

  end;

var
  frmmain: Tfrmmain;
  m_SelectedFile: string;
  m_CodeFileList: TStringList;

implementation

{$R *.lfm}

{ Tfrmmain }

procedure Tfrmmain.EnableItems(en: boolean);
begin
  LstLan.Enabled := en;
  lstcats.Enabled := en;
  lstcodes.Enabled := en;
  cmdAddLan1.Enabled := en;
  cmdAddCat.Enabled := en;
  cmdAddCode.Enabled := en;
  cmdDelLan.Enabled := en;
  cmdDelCat.Enabled := en;
  cmdDelCode.Enabled := en;
end;

procedure Tfrmmain.EnableEditArea(Enable: boolean);
begin

  cmdCut.Enabled := Enable;
  cmdcopy.Enabled := Enable;
  cmdpaste.Enabled := Enable;
  cmdUndo.Enabled := Enable;
  SynSource.Enabled := Enable;

end;

procedure Tfrmmain.SetButtonEnable(A, B, C: boolean);
begin
  cmdDelLan.Enabled := A;
  cmdDelCat.Enabled := B;
  cmdDelCode.Enabled := C;
end;

procedure Tfrmmain.DeleteLanDir(lzPath: string);
var
  sr: TSearchRec;
  lPath: string;
begin

  //First delete all the codes in the folders.
  if FindFirst(lzPath + '*.*', faDirectory, sr) = 0 then
  begin
    repeat
      if Pos('.', sr.Name) = 0 then
      begin
        lPath := lzPath + sr.Name + PathDelim;
        //Delete the source files in the lPath location
        DeleteSourceFiles(lPath);
        //Remove the child folders
        RmDir(lPath);
      end;
    until FindNext(sr) <> 0;
  end;

  //Delete the parent folder.
  RmDir(lzPath);

  m_CodeFileList.Clear;
  m_SelectedFile := '';
  //Clear lists and other things
  LstCats.Items.Clear;
  lstCodes.Items.Clear;
  lstLan.Items.Delete(lstLan.ItemIndex);
  SynSource.Lines.Clear;

  //Disable command buttons
  cmdAddCat.Enabled := False;
  cmdAddCode.Enabled := False;
  cmdDelCat.Enabled := False;
  cmdDelCode.Enabled := False;

  //Select the first item in the list if count > 0
  if lstLan.Items.Count > 0 then
  begin
    lstLan.ItemIndex := 0;
    lstLanClick(nil);
  end
  else
  begin
    cmdDelLan.Enabled := False;
  end;

end;

procedure Tfrmmain.DeleteSourceFiles(lzPath: string);
var
  sr: TSearchRec;
  lzFile: string;
begin

  if FindFirst(lzPath + '*.dat', faAnyFile, sr) = 0 then
  begin
    repeat
      lzFile := lzPath + sr.Name;

      if FileExists(lzFile) then
      begin
        DeleteFile(lzFile);
      end;

    until FindNext(sr) <> 0;
  end;
  FindClose(sr);
end;

procedure Tfrmmain.SynSourceChange(Sender: TObject);
begin

  if m_SelectedFile <> '' then
  begin

    cmdUndo.Enabled := SynSource.CanUndo;
    EnableItems(False);

    cmdCancel.Enabled := True;
    cmdSaveCode.Enabled := True;
    cmdExport.Enabled := True;
  end;
end;

procedure Tfrmmain.SynSourceChangeUpdating(ASender: TObject; AnUpdating: boolean);
begin
  if m_SelectedFile <> '' then
  begin
       cmdCut.Enabled := (SynSource.SelText <> '');
       cmdcopy.Enabled := cmdcut.Enabled;
       cmdpaste.Enabled := synsource.CanPaste;
       cmdUndo.Enabled := SynSource.CanUndo;
  end;
end;

procedure Tfrmmain.DeleteCatDir(lzPath: string);
var
  lzFile: string;
  X: integer;
begin
  //Delete the source codes in the category folder.
  for X := 0 to m_CodeFileList.Count - 1 do
  begin
    //Code filename
    lzFile := m_CodeFileList[x];
    //Make sure the file is found
    if FileExists(lzFile) then
    begin
      //Delete the file.
      DeleteFile(lzFile);
    end;
  end;
  //Delete the folder.
  RmDir(lzPath);

  //Clear Lists
  m_CodeFileList.Clear;
  lstCodes.Clear;
  LstCats.Items.Delete(LstCats.ItemIndex);
  LstCats.Refresh;

  SynSource.Lines.Clear;
  //Disable command buttons
  cmdDelCode.Enabled := False;
  cmdDelcat.Enabled := False;
  cmdAddCode.Enabled := False;
  m_SelectedFile := '';

  //Select the first item in the list if it contains items
  if LstCats.Count > 0 then
  begin
    LstCats.ItemIndex := 0;
    LstCatsClick(nil);
  end;

end;

procedure Tfrmmain.LoadItemsInList(lzPath: string; LBox: TListBox);
var
  sr: TSearchRec;
begin
  //Find lan folders
  if FindFirst(lzPath + '*.*', faAnyFile, sr) = 0 then
  begin
    //Clear the items in the list
    LBox.Items.Clear;
    repeat
      //We don't want . or ..
      if Pos('.', sr.Name) = 0 then
      begin
        LBox.Items.Add(sr.Name);
      end;
    until FindNext(sr) <> 0;
  end;
  FindClose(sr);
end;

procedure LoadCodesInList(lzPath: string; LBox: TListBox);
var
  sr: TSearchRec;
  sPos: integer;
begin

  if FindFirst(lzPath + '*.dat', faAnyFile, sr) = 0 then
  begin
    repeat
      //Locate _ in the string we use this to split the sources title name
      sPos := pos('_', sr.Name);
      if sPos > 0 then
      begin
        //Add the source files filenames to the stringlist
        m_CodeFileList.Add(lzPath + sr.Name);
        //Add source code title to listbox.
        LBox.Items.Add(LeftStr(sr.Name, sPos - 1));
      end;
    until FindNext(sr) <> 0;
  end;
  FindClose(sr);
end;

procedure Tfrmmain.LstCatsClick(Sender: TObject);
begin
  lstCodes.Items.Clear;
  m_CodeFileList.Clear;

  if LstCats.ItemIndex > -1 then
  begin
    //category path
    LanCatPath := FixPath(LanPath + LstCats.Items[LstCats.ItemIndex]);
    //Load the source codes for the category
    LoadCodesInList(LanCatPath, lstCodes);
    //Enable command buttons
    cmdDelCat.Enabled := True;
    cmdAddCode.Enabled := True;
    SynSource.Lines.Clear;
    EnableEditArea(False);
  end;
end;

procedure Tfrmmain.lstCodesClick(Sender: TObject);
begin

  if lstCodes.ItemIndex > -1 then
  begin
    //Get selected code filename
    m_SelectedFile := m_CodeFileList[lstCodes.ItemIndex];
    //Make sure the file is here
    if FileExists(m_SelectedFile) then
    begin
      //Load the code file into the code editor
      SynSource.Lines.LoadFromFile(m_SelectedFile);
      SynSource.Modified := False;
      cmdDelCode.Enabled := True;
      EnableEditArea(True);
      SynSourceChangeUpdating(Sender, False);
    end;
  end;
end;

procedure Tfrmmain.lstLanClick(Sender: TObject);
begin

  lstCodes.Items.Clear;
  m_CodeFileList.Clear;

  if lstLan.ItemIndex > -1 then
  begin
    LanPath := FixPath(HomePath + lstLan.Items[lstLan.ItemIndex]);
    //Load items into listbox.
    LoadItemsInList(LanPath, LstCats);
    //Enable command buttons
    cmdAddCat.Enabled := True;
    cmdDelLan.Enabled := True;
    EnableEditArea(False);
    SynSource.Lines.Clear;
  end;
end;

procedure Tfrmmain.mnuCopyClick(Sender: TObject);
begin
  cmdCopyClick(Sender);
end;

procedure Tfrmmain.mnuCutClick(Sender: TObject);
begin
  cmdCutClick(Sender);
end;

procedure Tfrmmain.mnuEditMenuPopup(Sender: TObject);
begin
  mnuUndo.Enabled := cmdUndo.Enabled;
  mnuCut.Enabled := cmdcut.Enabled;
  mnucopy.Enabled := mnucut.Enabled;
  mnuPaste.Enabled := cmdPaste.Enabled;
end;

procedure Tfrmmain.mnuPasteClick(Sender: TObject);
begin
  cmdPasteClick(Sender);
end;

procedure Tfrmmain.mnuSelectAllClick(Sender: TObject);
begin
  SynSource.SelectAll;
end;

procedure Tfrmmain.mnuUndoClick(Sender: TObject);
begin
  cmdUndoClick(Sender);
end;

procedure Tfrmmain.ErrorMsg(code: integer);
var
  msg: string;
begin
  case code of
    0:
    begin
      msg := 'Language Name Not Found.';
    end;
    2:
    begin
      msg := 'Invalid Language Name.' + sLineBreak +
        'Please use valid alpha or numbers.';
    end;
    3:
    begin
      msg := 'Language Name Already Exists.' + sLineBreak +
        'Please try a different name.';
    end;
    4:
    begin
      msg := 'Category Name Not Found.';
    end;
    5:
    begin
      msg := 'Invalid Language Category Name.' + sLineBreak +
        'Please use valid alpha or numbers.';
    end;
    6:
    begin
      msg := 'Language Category Name Already Exists.' + sLineBreak +
        'Please try a different name.';
    end;
    7:
    begin
      msg := 'Source code Name Not Found.';
    end;
    8:
    begin
      msg := 'Invalid Source code Name.' + sLineBreak +
        'Please use valid alpha or numbers or spaces.';
    end;
    9:
    begin
      msg := 'There Was An Error Creating The Filename.';
    end;
    else
    begin
      msg := 'Unknown Error Occurred.';
    end;
  end;

  MessageDlg(Text, msg, mtInformation, [mbOK], 0);
end;

procedure Tfrmmain.FormCreate(Sender: TObject);
begin
  m_CodeFileList := TStringList.Create;
  Tools.HomePath := FixPath(ExtractFilePath(Application.ExeName)) + 'home' + PathDelim;

  //Check if home folder is found
  if not DirectoryExists(Tools.HomePath) then
  begin
    //Make a default home folder
    CreateDir(Tools.HomePath);
  end;
  //Get a list of folders in the home path
  LoadItemsInList(HomePath, lstLan);
  EnableEditArea(False);
end;

procedure Tfrmmain.cmdAddLanClick(Sender: TObject);
var
  S: string;
  isOk: boolean;
  RetVal: integer;
begin
  S := '';
  isOk := InputQuery(Text, 'Enter a new name for the language:', S);

  if isOk and (Length(S) > 0) then
  begin
    RetVal := NewLanFolder(S);

    if RetVal <> 1 then
    begin
      ErrorMsg(RetVal);
    end
    else
    begin
      lstLan.Items.Add(S);
      lstLan.ItemIndex := 0;
      lstLanClick(Sender);
    end;
  end;
end;

procedure Tfrmmain.cmdCancelClick(Sender: TObject);
begin
  EnableItems(True);
  cmdSaveCode.Enabled := False;
end;

procedure Tfrmmain.cmdCopyClick(Sender: TObject);
begin
  SynSource.CopyToClipboard;
end;

procedure Tfrmmain.cmdCutClick(Sender: TObject);
begin
  SynSource.CutToClipboard;
end;

procedure Tfrmmain.cmdDelCatClick(Sender: TObject);
begin
  if LstCats.ItemIndex > -1 then
  begin
    if MessageDlg(Text, 'Are you sure you want to delete the category "' +
      LstCats.Items[LstCats.ItemIndex] + '"' + sLineBreak + sLineBreak +
      'Warning this will also delete the sources code inside the category.',
      mtInformation, [mbYes, mbNo], 0) = mrYes then
    begin
      DeleteCatDir(LanCatPath);
    end;
  end;
end;

procedure Tfrmmain.cmdDelCodeClick(Sender: TObject);
begin
  if lstCodes.ItemIndex > -1 then
  begin
    if MessageDlg(Text, 'Are you sure you want to delete' + sLineBreak +
      sLineBreak + '"' + lstCodes.Items[lstCodes.ItemIndex] + '"',
      mtInformation, [mbYes, mbNo], 0) = mrYes then
    begin
      //Delete the filename from the files string list
      m_CodeFileList.Delete(lstCodes.ItemIndex);
      //Delete the item from the listbox.
      lstCodes.Items.Delete(lstCodes.ItemIndex);
      //Delete the source code filename
      DeleteFile(m_SelectedFile);
      lstCodes.Refresh;
      cmdDelCode.Enabled := False;

      if lstCodes.Items.Count > 0 then
      begin
        lstCodes.ItemIndex := 0;
        lstCodesClick(Sender);
      end;
    end;
  end;
end;

procedure Tfrmmain.cmdDelLanClick(Sender: TObject);
begin

  if lstLan.ItemIndex <> -1 then;
  begin
    if MessageDlg(Text, 'Are you sure you want to delete the language "' +
      lstLan.Items[lstLan.ItemIndex] + '"' + sLineBreak + sLineBreak +
      'Warning this will also delete the categories and sources files inside the language folder.',
      mtInformation, [mbYes, mbNo], 0) = mrYes then
    begin
      DeleteLanDir(LanPath);
    end;
  end;
end;

procedure Tfrmmain.cmdExportClick(Sender: TObject);
var
  sd: TSaveDialog;
begin
  sd := TSaveDialog.Create(self);
  sd.Title := 'Export';
  sd.Filter := 'Text Files(*.txt)|*.txt|All Files(*.*)|*.*';
  sd.DefaultExt := 'txt';
  if sd.Execute then
  begin
    SynSource.Lines.SaveToFile(sd.FileName);
  end;
  sd.Destroy;
end;

procedure Tfrmmain.cmdPasteClick(Sender: TObject);
begin
  SynSource.PasteFromClipboard();
end;

procedure Tfrmmain.cmdSaveCodeClick(Sender: TObject);
begin
  if (lstCodes.ItemIndex > -1) and (FileExists(m_SelectedFile)) then
  begin
    SynSource.Lines.SaveToFile(m_SelectedFile);
    SynSource.Modified := False;
    cmdCancel.Enabled := False;
    cmdUndo.Enabled := SynSource.CanUndo;
    cmdSaveCode.Enabled := False;
    EnableItems(True);
  end;
end;

procedure Tfrmmain.cmdUndoClick(Sender: TObject);
begin
  if SynSource.CanUndo then
  begin
    SynSource.Undo;
  end;
end;

procedure Tfrmmain.cmdAddCatClick(Sender: TObject);
var
  S: string;
  isOk: boolean;
  RetVal: integer;
begin
  S := '';
  isOk := InputQuery(Text, 'Enter a new language category:', S);
  if isOk and (Length(S) > 0) then
  begin
    RetVal := NewLanCatFolder(LanPath, S);
    if RetVal <> 1 then
    begin
      ErrorMsg(RetVal);
    end
    else
    begin
      LstCats.Items.Add(S);
      LstCats.ItemIndex := (LstCats.Count - 1);
      LstCatsClick(Sender);
    end;
  end;
end;

procedure Tfrmmain.cmdAddCodeClick(Sender: TObject);
var
  isOk: boolean;
  RetVal: integer;
  S: string;
begin
  if LstCats.ItemIndex > -1 then
  begin
    S := '';

    isOk := InputQuery(Text, 'Enter a new category name:', S);
    if isOk and (Length(S) > 0) then
    begin
      RetVal := NewCodeFile(LanCatPath, S);

      if RetVal <> 1 then
      begin
        ErrorMsg(RetVal);
      end
      else
      begin
        //Select the cats
        LstCatsClick(Sender);
        //Select first code in list
        lstCodes.ItemIndex := 0;
        lstCodesClick(Sender);
      end;
    end;
  end;
end;

procedure Tfrmmain.cboLanSelect(Sender: TObject);
begin
  case cboLan.ItemIndex of
    0:
    begin
      //Bas
      SynSource.Highlighter := SynBas;
    end;
    1:
    begin
      //c/c++
      SynSource.Highlighter := SynCPlus;
    end;
    2:
    begin
      //CSS
      SynSource.Highlighter := SynCSS;
    end;
    3:
    begin
      //Html
      SynSource.Highlighter := SynHtml;
    end;
    4:
    begin
      //Java
      SynSource.Highlighter := SynJava;
    end;
    5:
    begin
      //JS
      SynSource.Highlighter := SynJS;
    end;
    6:
    begin
      //Pascal
      SynSource.Highlighter := SynPas;
    end;
    7:
    begin
      //Php
      SynSource.Highlighter := SynPHP;
    end;
    8:
    begin
      //Python
      SynSource.Highlighter := SynPython;
    end;
  end;
end;

procedure Tfrmmain.cmdAboutClick(Sender: TObject);
var
  frm : TfrmAbout;
begin
   frm := TfrmAbout.Create(self);
   frm.ShowModal;
   frm.Destroy;
end;

end.
