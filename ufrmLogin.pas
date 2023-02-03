unit ufrmLogin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AdvPanel, ExtCtrls, StdCtrls, AdvEdit, jpeg;

type
  TfrmLogin = class(TForm)
    AdvPanel3: TAdvPanel;
    AdvPanel4: TAdvPanel;
    AdvPanel5: TAdvPanel;
    AdvPanel6: TAdvPanel;
    Image1: TImage;
    Label4: TLabel;
    Label6: TLabel;
    Label3: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    edtPassword: TEdit;
    edtUserName: TAdvEdit;
    btnLogin: TButton;
    btnBatal: TButton;
    Timer1: TTimer;
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLogin: TfrmLogin;

implementation

{$R *.dfm}

procedure TfrmLogin.FormShow(Sender: TObject);
begin
  edtUserName.SetFocus;
end;

procedure TfrmLogin.Timer1Timer(Sender: TObject);
begin
  Label4.Caption := FormatDateTime('dddd',Now) + ', ' + FormatDateTime('dd mmmm yyyy',Now);
  Label6.Caption := FormatDateTime('hh:nn:ss',Now);
end;

end.
