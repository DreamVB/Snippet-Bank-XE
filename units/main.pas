unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  ComCtrls, Buttons, Menus, EditBtn, Spin, SynEdit, SynHighlighterPas,
  SynHighlighterHTML, SynHighlighterCpp, SynHighlighterJava, SynHighlighterVB,
  SynHighlighterCss, SynHighlighterJScript, SynHighlighterPHP,
  SynHighlighterPython, SynHighlighterBat, SynHighlighterSQL, SynExportHTML,
  Tools, about, newlan;

type

  { Tfrmmain }

  Tfrmmain = class(TForm)
    cmdEdit: TSpeedButton;
    cmdAddCat: TButton;
    cmdAddCode: TButton;
    cmdAddLan1: TButton;
    cmdFont: TSpeedButton;
    cmdPaste: TSpeedButton;
    cmdCut: TSpeedButton;
    cmdCopy: TSpeedButton;
    cmdDelLan: TButton;
    cmdDelCat: TButton;
    cmdDelCode: TButton;
    cmdAbout: TSpeedButton;
    cmdCancel: TSpeedButton;
    cmdUndo: TSpeedButton;
    cmdExport: TSpeedButton;
    cboLan: TComboBox;
    txtDate: TDateEdit;
    txtAurthor: TEdit;
    lblAurthor: TLabel;
    lblDate: TLabel;
    lblLikes: TLabel;
    lblSyntext: TLabel;
    lstLan: TListBox;
    LstCats: TListBox;
    lstCodes: TListBox;
    mnuUndo: TMenuItem;
    mnuCut: TMenuItem;
    mnuCopy: TMenuItem;
    mnuPaste: TMenuItem;
    mnuSelectAll: TMenuItem;
    pToolbar: TPanel;
    Separator2: TMenuItem;
    Separator1: TMenuItem;
    pCodeArea: TPanel;
    pLan: TPanel;
    pCat: TPanel;
    pCodes: TPanel;
    mnuEditMenu: TPopupMenu;
    cmdSaveCode: TSpeedButton;
    SpnLikes: TSpinEdit;
    StatusBar1: TStatusBar;
    SynBat: TSynBatSyn;
    SynCPlus: TSynCppSyn;
    SynCSS: TSynCssSyn;
    HtmlExport: TSynExporterHTML;
    SynSource: TSynEdit;
    SynHtml: TSynHTMLSyn;
    SynJava: TSynJavaSyn;
    SynJS: TSynJScriptSyn;
    SynPas: TSynPasSyn;
    SynPHP: TSynPHPSyn;
    SynPython: TSynPythonSyn;
    SynBas: TSynVBSyn;
    SynSQL: TSynSQLSyn;
    procedure Button1Click(Sender: TObject);
    procedure cboLanChange(Sender: TObject);
    procedure cboLanSelect(Sender: TObject);
    procedure cmdEditClick(Sender: TObject);
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
    procedure cmdFontClick(Sender: TObject);
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
    procedure pCodeAreaClick(Sender: TObject);
    procedure SetButtonEnable(A, B, C: boolean);
    procedure DeleteCatDir(lzPath: string);
    procedure DeleteLanDir(lzPath: string);
    procedure DeleteSourceFiles(lzPath: string);
    procedure SynSourceChange(Sender: TObject);
    procedure SynSourceChangeUpdating(ASender: TObject; AnUpdating: boolean);
    procedure EnableEditButtons(Enable: boolean);
    procedure EnableItems(en: boolean);
    function GetItemIndex(LBox: TListBox; sFind: string): integer;
    procedure LoadCodeExample(Filename: string);
    procedure SaveCodeExample(Filename: string);
    procedure txtAurthorKeyPress(Sender: TObject; var Key: char);
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

procedure Tfrmmain.LoadCodeExample(Filename: string);
var
  sl: TStringList;
  info: TStringList;
  sInfo: string;
begin
  sl := TStringList.Create;
  info := TStringList.Create;
  sInfo := '';

  //Defaults info
  cboLan.ItemIndex := 0;
  txtAurthor.Text := 'NoName';
  txtDate.Text := FormatDateTime('DD/MM/YYYY',Now);
  SpnLikes.Value := 0;

  if FileExists(Filename) then
  begin
    sl.LoadFromFile(Filename);
    if sl.Count > 0 then
    begin

      sInfo := sl[0];
      //Delete the line from the code
      if leftstr(sInfo, 5) = '#Info' then
      begin
        sl.Delete(0);
        Delete(sInfo, 1, 5);
        //Display the info for the code example.
        info.Delimiter := ',';
        info.DelimitedText := sInfo;
        cboLan.ItemIndex := StrToInt(info[0]);
        txtAurthor.Text := StringReplace(info[1],'+',' ',[rfReplaceAll]);
        txtDate.Text := info[2];
        SpnLikes.Value := StrToInt(info[3]);
      end;

      SynSource.Lines := sl;
      SynSource.Modified := False;
      SynSourceChangeUpdating(nil, False);
    end;
    cmdDelCode.Enabled := True;
    //EnableEditButtons(True);
    sl.Clear;
    info.Clear;
  end;
end;

procedure Tfrmmain.SaveCodeExample(Filename: string);
var
  sl: TStringList;
  info: string;
begin
  sl := TStringList.Create;
  //Code header info
  info := '#Info ' + IntToStr(cboLan.ItemIndex) + ',' +
  StringReplace(txtAurthor.Text,' ','+',[rfReplaceAll]) +
    ',' + txtDate.Text + ',' + IntToStr(SpnLikes.Value);
  //The code data
  sl.Add(info);
  sl.Add(TrimRight(SynSource.Text));
  sl.SaveToFile(Filename);
  sl.Clear;
end;

procedure Tfrmmain.txtAurthorKeyPress(Sender: TObject; var Key: char);
begin
  if Key in ['+',','] then Key := #0;
end;

function Tfrmmain.GetItemIndex(LBox: TListBox; sFind: string): integer;
var
  X: integer;
  idx: integer;
begin
  idx := -1;

  for X := 0 to LBox.Count - 1 do
  begin
    if lowercase(LBox.Items[X]) = lowercase(sFind) then
    begin
      idx := X;
      Break;
    end;
  end;
  Result := idx;
end;

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

procedure Tfrmmain.EnableEditButtons(Enable: boolean);
begin

  cmdCut.Enabled := Enable;
  cmdcopy.Enabled := Enable;
  cmdpaste.Enabled := Enable;
  cmdUndo.Enabled := Enable;
  cmdCancel.Enabled := Enable;
  cmdsavecode.Enabled := Enable;
  SynSource.ReadOnly := not Enable;
  cbolan.Enabled := Enable;
  SpnLikes.ReadOnly := not Enable;
  txtDate.ReadOnly := not Enable;
  txtAurthor.ReadOnly := not Enable;

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

end;

procedure Tfrmmain.SynSourceChangeUpdating(ASender: TObject; AnUpdating: boolean);
begin
  if (m_SelectedFile <> '') and (cmdSaveCode.Enabled) then
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
  m_SelectedFile := '';

  if LstCats.ItemIndex > -1 then
  begin
    //category path
    LanCatPath := FixPath(LanPath + LstCats.Items[LstCats.ItemIndex]);
    //Load the source codes for the category
    LoadCodesInList(LanCatPath, lstCodes);
    //Enable command buttons
    cmdedit.Enabled := False;
    cmdExport.Enabled := False;
    cmdDelCat.Enabled := True;
    cmdAddCode.Enabled := True;
    SynSource.Lines.Clear;
    EnableEditButtons(False);
  end;
end;

procedure Tfrmmain.lstCodesClick(Sender: TObject);
begin

  if lstCodes.ItemIndex > -1 then
  begin
    cmdedit.Enabled := True;
    cmdExport.Enabled := True;
    //Get selected code filename
    m_SelectedFile := m_CodeFileList[lstCodes.ItemIndex];
    //Make sure the file is here
    if FileExists(m_SelectedFile) then
    begin
      //Load the code file into the code editor
      //SynSource.Lines.LoadFromFile(m_SelectedFile);
      LoadCodeExample(m_SelectedFile);
    end;
  end;
end;

procedure Tfrmmain.lstLanClick(Sender: TObject);
begin

  lstCodes.Items.Clear;
  m_CodeFileList.Clear;
  m_SelectedFile := '';

  if lstLan.ItemIndex > -1 then
  begin
    LanPath := FixPath(HomePath + lstLan.Items[lstLan.ItemIndex]);
    //Load items into listbox.
    LoadItemsInList(LanPath, LstCats);
    //Enable command buttons
    cmdedit.Enabled := False;
    cmdExport.Enabled := False;
    cmdAddCat.Enabled := True;
    cmdDelLan.Enabled := True;
    EnableEditButtons(False);
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

procedure Tfrmmain.pCodeAreaClick(Sender: TObject);
begin

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
  txtDate.Text := FormatDateTime('DD/MM/YYYY',Now);

  //Check if home folder is found
  if not DirectoryExists(Tools.HomePath) then
  begin
    //Make a default home folder
    CreateDir(Tools.HomePath);
  end;
  //Get a list of folders in the home path
  LoadItemsInList(HomePath, lstLan);
  EnableEditButtons(False);
end;

procedure Tfrmmain.cmdAddLanClick(Sender: TObject);
var
  frm: TfrmNewLan;
  RetVal: integer;
begin
  Tools.ButtonPress := 0;
  frm := TfrmNewLan.Create(self);
  frm.ShowModal;
  if Tools.ButtonPress = 1 then
  begin
    RetVal := NewLanFolder(tools.SelectedLanguage);

    if RetVal <> 1 then
    begin
      ErrorMsg(RetVal);
    end
    else
    begin
      lstLan.Items.Add(tools.SelectedLanguage);
      lstLan.ItemIndex := GetItemIndex(lstLan, Tools.SelectedLanguage);
      lstLanClick(Sender);
    end;

  end;
  frm.Destroy;
end;

procedure Tfrmmain.cmdCancelClick(Sender: TObject);
begin
  EnableItems(True);
  EnableEditButtons(False);
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
      m_SelectedFile := '';
      if lstCodes.Items.Count > 0 then
      begin
        lstCodes.ItemIndex := 0;
        lstCodesClick(Sender);
      end
      else
      begin
        EnableEditButtons(False);
        SynSource.Lines.Clear;
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

  if lstCodes.ItemIndex > -1 then
  begin
  sd := TSaveDialog.Create(self);
  sd.Title := 'Export';
  sd.Filter := 'Text Files(*.txt)|*.txt|HTML Files(*.html)|*.html|All Files(*.*)|*.*';
  sd.DefaultExt := 'txt';
  if sd.Execute then
  begin
    //Export as text
    if sd.FilterIndex <> 2 then
    begin
      SynSource.Lines.SaveToFile(sd.FileName);
    end
    else
    begin
      //Export as html
      HtmlExport.Highlighter := SynSource.Highlighter;
      HtmlExport.ExportAll(SynSource.Lines);
      HtmlExport.SaveToFile(sd.FileName);
    end;
  end;
  sd.Destroy;
  end;
end;

procedure Tfrmmain.cmdFontClick(Sender: TObject);
var
  fd: TFontDialog;
begin
  fd := TFontDialog.Create(self);
  fd.Font := SynSource.Font;
  if fd.Execute then
  begin
    SynSource.Font := fd.Font;
  end;
  fd.Destroy;
end;

procedure Tfrmmain.cmdPasteClick(Sender: TObject);
begin
  SynSource.PasteFromClipboard();
end;

procedure Tfrmmain.cmdSaveCodeClick(Sender: TObject);
begin
  SaveCodeExample(m_SelectedFile);
  SynSource.Modified := False;
  cmdUndo.Enabled := SynSource.CanUndo;
  EnableItems(True);
  EnableEditButtons(False);
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
      LstCats.ItemIndex := GetItemIndex(LstCats, S);
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
        lstCodes.ItemIndex := GetItemIndex(lstCodes, S);
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
      SynSource.Highlighter := SynBat;
    end;
    2:
    begin
      //c/c++
      SynSource.Highlighter := SynCPlus;
    end;
    3:
    begin
      //CSS
      SynSource.Highlighter := SynCSS;
    end;
    4:
    begin
      //Html
      SynSource.Highlighter := SynHtml;
    end;
    5:
    begin
      //Java
      SynSource.Highlighter := SynJava;
    end;
    6:
    begin
      //JS
      SynSource.Highlighter := SynJS;
    end;
    7:
    begin
      //Pascal
      SynSource.Highlighter := SynPas;
    end;
    8:
    begin
      //Php
      SynSource.Highlighter := SynPHP;
    end;
    9:
    begin
      //Python
      SynSource.Highlighter := SynPython;
    end;
    10:
    begin
      //SQL
      SynSource.Highlighter := SynSQL;
    end;
  end;
end;

procedure Tfrmmain.cmdEditClick(Sender: TObject);
begin
  if (FileExists(m_SelectedFile)) and (lstCodes.ItemIndex > -1) then;
  begin
    EnableItems(False);
    EnableEditButtons(True);
  end;
end;

procedure Tfrmmain.cboLanChange(Sender: TObject);
begin

end;

procedure Tfrmmain.Button1Click(Sender: TObject);
begin

end;

procedure Tfrmmain.cmdAboutClick(Sender: TObject);
var
  frm: TfrmAbout;
begin
  frm := TfrmAbout.Create(self);
  frm.ShowModal;
  frm.Destroy;
end;

end.
