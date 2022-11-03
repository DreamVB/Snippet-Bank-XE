unit newlan;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Tools;

type

  { TfrmNewLan }

  TfrmNewLan = class(TForm)
    cmdOk: TButton;
    cmdClose: TButton;
    cboLan: TComboBox;
    lblTitle: TLabel;
    R1: TRadioButton;
    R2: TRadioButton;
    txtLan: TEdit;
    procedure cmdCloseClick(Sender: TObject);
    procedure cmdOkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure R1Change(Sender: TObject);
    procedure R2Change(Sender: TObject);
  private

  public

  end;

var
  frmNewLan: TfrmNewLan;
  LanType: boolean;


implementation

{$R *.lfm}

{ TfrmNewLan }

procedure TfrmNewLan.cmdCloseClick(Sender: TObject);
begin
  tools.ButtonPress := 0;
  Close;
end;

procedure TfrmNewLan.cmdOkClick(Sender: TObject);
begin
  if LanType then
  begin
    tools.SelectedLanguage := cboLan.Items[cboLan.ItemIndex];
  end
  else
  begin
    tools.SelectedLanguage := txtLan.Text;
  end;

  if Tools.SelectedLanguage = '' then
  begin
    MessageDlg(Text, 'Please choose or enter a languages.',
      mtInformation, [mbOK], 0);
  end
  else
  begin
    Tools.ButtonPress := 1;
    Close;
  end;
end;

procedure TfrmNewLan.FormCreate(Sender: TObject);
begin
  LanType := True;
  cboLan.ItemIndex := 0;
end;

procedure TfrmNewLan.R1Change(Sender: TObject);
begin
  LanType := True;
  txtLan.Enabled := False;
  cboLan.Enabled := True;
end;

procedure TfrmNewLan.R2Change(Sender: TObject);
begin
  LanType := False;
  txtLan.Enabled := True;
  cboLan.Enabled := False;
end;

end.
