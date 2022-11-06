unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  ComCtrls, Buttons, Menus, EditBtn, Spin, SynEdit, SynHighlighterPas,
  SynHighlighterHTML, SynHighlighterCpp, SynHighlighterJava, SynHighlighterVB,
  SynHighlighterCss, SynHighlighterJScript, SynHighlighterPHP,
  SynHighlighterPython, SynHighlighterBat, SynHighlighterSQL, SynExportHTML,
  SynHighlighterIni, Tools, about, newlan;

type

  { Tfrmmain }

  Tfrmmain = class(TForm)
    cmdAddCat: TSpeedButton;
    cmdAddCode: TSpeedButton;
    cmdDelCode: TSpeedButton;
    cmdDelLan: TSpeedButton;
    cmdDelCat: TSpeedButton;
    cmdEditCode: TSpeedButton;
    cmdEditLan: TSpeedButton;
    cmdEdit: TSpeedButton;
    cmdEditCat: TSpeedButton;
    cmdFont: TSpeedButton;
    cmdPaste: TSpeedButton;
    cmdCut: TSpeedButton;
    cmdCopy: TSpeedButton;
    cmdAbout: TSpeedButton;
    cmdCancel: TSpeedButton;
    cmdImport: TSpeedButton;
    cmdUndo: TSpeedButton;
    cmdExport: TSpeedButton;
    cboLan: TComboBox;
    cmdAddLan: TSpeedButton;
    lblSyntext1: TLabel;
    pFind1: TPanel;
    pFind2: TPanel;
    SynINI: TSynIniSyn;
    txtInfo: TEdit;
    txtFind1: TEdit;
    pFind: TPanel;
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
    txtFind2: TEdit;
    txtFind3: TEdit;
    procedure cboLanSelect(Sender: TObject);
    procedure cmdAddLanClick(Sender: TObject);
    procedure cmdEditCatClick(Sender: TObject);
    procedure cmdEditCodeClick(Sender: TObject);
    procedure cmdEditLanClick(Sender: TObject);
    procedure cmdEditClick(Sender: TObject);
    procedure cmdAboutClick(Sender: TObject);
    procedure cmdAddCatClick(Sender: TObject);
    procedure cmdAddCodeClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure cmdCopyClick(Sender: TObject);
    procedure cmdCutClick(Sender: TObject);
    procedure cmdDelCatClick(Sender: TObject);
    procedure cmdDelCodeClick(Sender: TObject);
    procedure cmdDelLanClick(Sender: TObject);
    procedure cmdExportClick(Sender: TObject);
    procedure cmdFontClick(Sender: TObject);
    procedure cmdImportClick(Sender: TObject);
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
    procedure SynSourceChangeUpdating(ASender: TObject; AnUpdating: boolean);
    procedure EnableEditButtons(Enable: boolean);
    procedure EnableItems(en: boolean);
    function GetItemIndex(LBox: TListBox; sFind: string): integer;
    procedure LoadCodeExample(Filename: string);
    procedure SaveCodeExample(Filename: string);
    procedure txtAurthorKeyPress(Sender: TObject; var Key: char);
    procedure txtFind1Change(Sender: TObject);
    procedure txtFind1Enter(Sender: TObject);
    procedure txtFind1Exit(Sender: TObject);
    procedure txtFind2Change(Sender: TObject);
    procedure txtFind2Enter(Sender: TObject);
    procedure txtFind2Exit(Sender: TObject);
    procedure txtFind3Change(Sender: TObject);
    procedure txtFind3Enter(Sender: TObject);
    procedure txtFind3Exit(Sender: TObject);
    procedure UpdateButtons2;
    procedure FindInListBox(LBox: TListBox; sFind: TEdit);
    procedure UpdateSearchBox(TB: TEdit);
  private
  public

  end;

var
  frmmain: Tfrmmain;
  m_SelectedFile: string;
  m_CodeFileList: TStringList;
  UpdateTextBox: boolean;

implementation

{$R *.lfm}

{ Tfrmmain }

procedure Tfrmmain.UpdateSearchBox(TB: TEdit);
begin
  if Trim(TB.Text) = '' then
  begin
    UpdateTextBox := False;
    TB.Text := 'Search';
  end;
end;

procedure Tfrmmain.FindInListBox(LBox: TListBox; sFind: TEdit);
var
  X, Idx: integer;
  sVal: string;
begin
  Idx := -1;

  if (LBox.Count > 0) and (sFind.GetTextLen > 0) then
  begin
    for X := 0 to LBox.Count - 1 do
    begin
      //Check the left side of the string.
      sVal := LowerCase(LBox.Items[X]);
      if LeftStr(sVal, Length(sFind.Text)) = LowerCase(sFind.Text) then
      begin
        idx := X;
        Break;
      end;
    end;
    if Idx <> -1 then
    begin
      LBox.ItemIndex := Idx;
    end;
  end;
end;

procedure Tfrmmain.UpdateButtons2;
begin
  cmdEditLan.Enabled := lstLan.Count > 0;
  cmdEditCat.Enabled := LstCats.Count > 0;
  cmdEditCode.Enabled := lstCodes.Count > 0;
end;

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
  txtAurthor.Clear;
  txtInfo.Clear;
  txtDate.Text := FormatDateTime('DD/MM/YYYY', Now);
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
        txtAurthor.Text := StringReplace(info[1], '+', ' ', [rfReplaceAll]);
        txtDate.Text := info[2];
        SpnLikes.Value := StrToInt(info[3]);
        txtinfo.Text := info[4];
      end;

      SynSource.Lines := sl;
      SynSource.Modified := False;
      SynSourceChangeUpdating(nil, False);
      cboLanSelect(nil);
    end;
    cmdDelCode.Enabled := True;
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
    StringReplace(txtAurthor.Text, ' ', '+', [rfReplaceAll]) + ',' +
    txtDate.Text + ',' + IntToStr(SpnLikes.Value) + ',' +
    '"' + txtInfo.Text + '"';
  //The code data
  sl.Add(info);
  sl.Add(TrimRight(SynSource.Text));
  sl.SaveToFile(Filename);
  sl.Clear;
end;

procedure Tfrmmain.txtAurthorKeyPress(Sender: TObject; var Key: char);
begin
  if Key in ['+', ','] then Key := #0;
end;

procedure Tfrmmain.txtFind1Change(Sender: TObject);
begin
  if UpdateTextBox then
  begin
    FindInListBox(lstLan, txtFind1);
    lstLanClick(Sender);
  end;
end;

procedure Tfrmmain.txtFind1Enter(Sender: TObject);
begin
  UpdateTextBox := True;
  txtFind1.Font.Color := clWhite;
end;

procedure Tfrmmain.txtFind1Exit(Sender: TObject);
begin
  txtFind1.Font.Color := clBlack;
  UpdateSearchBox(txtFind1);
end;

procedure Tfrmmain.txtFind2Change(Sender: TObject);
begin
  if UpdateTextBox then
  begin
    FindInListBox(LstCats, txtFind2);
    LstCatsClick(Sender);
  end;
end;

procedure Tfrmmain.txtFind2Enter(Sender: TObject);
begin
  UpdateTextBox := True;
  txtFind2.Font.Color := clWhite;
end;

procedure Tfrmmain.txtFind2Exit(Sender: TObject);
begin
  txtFind2.Font.Color := clBlack;
  UpdateSearchBox(txtFind2);
end;

procedure Tfrmmain.txtFind3Change(Sender: TObject);
begin
  if UpdateTextBox then
  begin
    FindInListBox(lstCodes, txtFind3);
    lstCodesClick(Sender);
  end;
end;

procedure Tfrmmain.txtFind3Enter(Sender: TObject);
begin
  UpdateTextBox := True;
  txtFind3.Font.Color := clWhite;
end;

procedure Tfrmmain.txtFind3Exit(Sender: TObject);
begin
  UpdateSearchBox(txtFind3);
  txtFind3.Font.Color := clBlack;
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
  cmdAddLan.Enabled := en;
  cmdAddCat.Enabled := en;
  cmdAddCode.Enabled := en;
  cmdDelLan.Enabled := en;
  cmdDelCat.Enabled := en;
  cmdDelCode.Enabled := en;
  cmdEditLan.Enabled := en;
  cmdEditCat.Enabled := en;
  cmdEditCode.Enabled := en;
  pFind.Enabled := en;
  pFind1.Enabled := en;
  pFind2.Enabled := en;
end;

procedure Tfrmmain.EnableEditButtons(Enable: boolean);
begin

  cmdCut.Enabled := Enable;
  cmdcopy.Enabled := Enable;
  cmdpaste.Enabled := Enable;
  cmdUndo.Enabled := Enable;
  cmdCancel.Enabled := Enable;
  cmdsavecode.Enabled := Enable;
  cmdImport.Enabled := Enable;
  SynSource.ReadOnly := not Enable;
  pToolbar.Enabled := Enable;
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

procedure Tfrmmain.SynSourceChangeUpdating(ASender: TObject; AnUpdating: boolean);
begin
  if (m_SelectedFile <> '') then
  begin
    cmdcopy.Enabled := SynSource.SelText <> '';
    if cmdSaveCode.Enabled then
    begin
      cmdCut.Enabled := (SynSource.SelText <> '');
      cmdpaste.Enabled := synsource.CanPaste;
      cmdUndo.Enabled := SynSource.CanUndo;
    end;
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
  txtAurthor.Text := '';
  txtInfo.Text := '';
  if LstCats.ItemIndex > -1 then
  begin
    //category path
    LanCatPath := FixPath(LanPath + LstCats.Items[LstCats.ItemIndex]);
    //Load the source codes for the category
    LoadCodesInList(LanCatPath, lstCodes);
    //Enable command buttons
    cmdeditcat.Enabled := True;
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
    cmdeditcode.Enabled := True;
    cmdedit.Enabled := True;
    cmdCopy.Enabled := True;
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
  txtAurthor.Text := '';
  txtInfo.Text := '';

  if lstLan.ItemIndex > -1 then
  begin
    LanPath := FixPath(HomePath + lstLan.Items[lstLan.ItemIndex]);
    //Load items into listbox.
    LoadItemsInList(LanPath, LstCats);
    //Enable command buttons
    cmdAddCat.Enabled := True;
    cmdEditLan.Enabled := True;
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
  mnuUndo.Enabled := SynSource.CanUndo;
  mnuCut.Enabled := cmdCut.Enabled;
  mnucopy.Enabled := SynSource.SelText <> '';
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
  txtDate.Text := FormatDateTime('DD/MM/YYYY', Now);

  UpdateTextBox := False;

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
  frm.Caption := 'New';
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

procedure Tfrmmain.cmdEditCatClick(Sender: TObject);
var
  S: string;
  isOk: boolean;
  RetVal: integer;
begin

  if LstCats.ItemIndex > -1 then
  begin

    S := LstCats.Items[LstCats.ItemIndex];
    isOk := InputQuery(Text, 'Enter a new name for the language category:', S);

    if isOk and (Length(S) > 0) then
    begin
      RetVal := RenameLanCatFolder(LanPath, LstCats.Items[LstCats.ItemIndex], S);
      if RetVal <> 1 then
      begin
        ErrorMsg(RetVal);
      end
      else
      begin
        LstCats.Sorted := False;
        LstCats.Items[LstCats.ItemIndex] := S;
        LstCats.Sorted := True;
        LstCats.ItemIndex := GetItemIndex(LstCats, S);
        LstCatsClick(Sender);
      end;
    end;
  end;
end;

procedure Tfrmmain.cmdEditCodeClick(Sender: TObject);
var
  isOk: boolean;
  RetVal, sPos: integer;
  sFileId, sNewFile: string;
  S: string;
begin
  if lstCodes.ItemIndex > -1 then
  begin
    sNewFile := '';

    S := lstCodes.Items[lstCodes.ItemIndex];

    isOk := InputQuery(Text, 'Enter a new code name:', S);
    if isOk and (Length(S) > 0) then
    begin
      //RetVal := NewCodeFile(LanCatPath, S);

      sPos := Pos('_', m_SelectedFile);
      if sPos > 0 then
      begin
        sFileId := Copy(m_SelectedFile, sPos + 1);
        sNewFile := LanCatPath + S + '_' + sFileId;
      end;

      RetVal := RenameCodeFile(S, m_SelectedFile, sNewFile);

      if RetVal <> 1 then
      begin
        ErrorMsg(RetVal);
      end
      else
      begin
        lstCodes.Items[lstCodes.ItemIndex] := S;
        m_CodeFileList[lstCodes.ItemIndex] := sNewFile;
        lstCodes.ItemIndex := GetItemIndex(lstCodes, S);
        lstCodesClick(Sender);
      end;
    end;
  end;
end;

procedure Tfrmmain.cmdEditLanClick(Sender: TObject);
var
  frm: TfrmNewLan;
  RetVal: integer;
begin

  if lstLan.ItemIndex > -1 then
  begin

    Tools.ButtonPress := 0;
    frm := TfrmNewLan.Create(self);
    frm.Caption := 'Edit';
    frm.R2.Checked := True;
    frm.txtLan.Text := lstLan.Items[lstLan.ItemIndex];
    frm.ShowModal;

    if Tools.ButtonPress = 1 then
    begin
      //Rename the lan folder
      RetVal := RenameLanFolder(lstLan.Items[lstLan.ItemIndex], tools.SelectedLanguage);
      //Check result
      if RetVal <> 1 then
      begin
        ErrorMsg(RetVal);
      end
      else
      begin
        //Turn off sorted
        lstLan.Sorted := False;
        //Set the lists item text to new lan folder name
        lstLan.Items[lstLan.ItemIndex] := tools.SelectedLanguage;
        lstLan.ItemIndex := GetItemIndex(lstLan, Tools.SelectedLanguage);
        //Turn back on sorting
        lstLan.Sorted := True;
        lstLanClick(Sender);
      end;
    end;
    frm.Destroy;
  end;
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
      txtAurthor.Text := '';
      txtInfo.Text := '';
      DeleteCatDir(LanCatPath);
      UpdateButtons2;
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
      txtAurthor.Text := '';
      txtInfo.Text := '';
      //Delete the filename from the files string list
      m_CodeFileList.Delete(lstCodes.ItemIndex);
      //Delete the item from the listbox.
      lstCodes.Items.Delete(lstCodes.ItemIndex);
      //Delete the source code filename
      DeleteFile(m_SelectedFile);
      lstCodes.Refresh;
      cmdDelCode.Enabled := False;
      UpdateButtons2;
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
      'Warning this will also delete the categories and source files inside the language folder.',
      mtInformation, [mbYes, mbNo], 0) = mrYes then
    begin
      txtAurthor.Text := '';
      txtInfo.Text := '';
      DeleteLanDir(LanPath);
      cmdAddCat.Enabled := (lstLan.Items.Count > 0);
      UpdateButtons2;
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

procedure Tfrmmain.cmdImportClick(Sender: TObject);
var
  od : TOpenDialog;
  sl : TStringList;
begin
  od := TOpenDialog.Create(self);
  od.Title := 'Import';
  od.Filter := 'Text Files(*.txt)|*.txt|All Files(*.*)|*.*';
  od.DefaultExt := 'txt';
  if od.Execute then
  begin
    sl := TStringList.Create;
    sl.LoadFromFile(od.FileName);
    SynSource.SelText := TrimRight(sl.Text);
    od.Destroy;
    sl.Clear;
  end;
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

    isOk := InputQuery(Text, 'Enter a new code name:', S);
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
      //Batch
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
      //INI
      SynSource.Highlighter := SynINI;
    end;
    6:
    begin
      //Java
      SynSource.Highlighter := SynJava;
    end;
    7:
    begin
      //JS
      SynSource.Highlighter := SynJS;
    end;
    8:
    begin
      //Pascal
      SynSource.Highlighter := SynPas;
    end;
    9:
    begin
      //Php
      SynSource.Highlighter := SynPHP;
    end;
    10:
    begin
      //Python
      SynSource.Highlighter := SynPython;
    end;
    11:
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

procedure Tfrmmain.cmdAboutClick(Sender: TObject);
var
  frm: TfrmAbout;
begin
  frm := TfrmAbout.Create(self);
  frm.ShowModal;
  frm.Destroy;
end;

end.
