unit about;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls;

type

  { TfrmAbout }

  TfrmAbout = class(TForm)
    cmdOK: TButton;
    ImgLogo: TImage;
    Label1: TLabel;
    lblTitle: TLabel;
    lblVersion: TLabel;
    lblInfo: TLabel;
    lblDevOp: TLabel;
    procedure cmdOKClick(Sender: TObject);
  private

  public

  end;

var
  frmAbout: TfrmAbout;

implementation

{$R *.lfm}

{ TfrmAbout }

procedure TfrmAbout.cmdOKClick(Sender: TObject);
begin
  Close;
end;

end.
