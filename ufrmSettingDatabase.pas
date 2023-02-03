unit ufrmSettingDatabase;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmSettingDatabase = class(TForm)
    lbledtHostname: TLabeledEdit;
    lbledtUser: TLabeledEdit;
    lbledtPassword: TLabeledEdit;
    btnSimpan: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnSimpanClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSettingDatabase: TfrmSettingDatabase;

implementation

uses ufrmAdmin;

{$R *.dfm}

procedure TfrmSettingDatabase.btnSimpanClick(Sender: TObject);
begin
  {IniFile.WriteString('MainApp','DBIP',frmAdmin.EnkripText(lbledtHostname.Text));
  IniFile.WriteString('MainApp','DBUser',frmAdmin.EnkripText(lbledtUser.Text));
  IniFile.WriteString('MainApp','DBPass',frmAdmin.EnkripText(lbledtPassword.Text));}
  IniFile.WriteString('MainApp','DBIP',lbledtHostname.Text);
  IniFile.WriteString('MainApp','DBUser',lbledtUser.Text);
  IniFile.WriteString('MainApp','DBPass',lbledtPassword.Text);
end;

procedure TfrmSettingDatabase.FormShow(Sender: TObject);
begin
  {lbledtHostname.Text   := frmAdmin.DekripText(IniFile.ReadString('MainApp','DBIP','localhost'));
  lbledtUser.Text       := frmAdmin.DekripText(IniFile.ReadString('MainApp','DBUser','root'));
  lbledtPassword.Text   := frmAdmin.DekripText(IniFile.ReadString('MainApp','DBPass',''));}
  lbledtHostname.Text   := IniFile.ReadString('MainApp','DBIP','localhost');
  lbledtUser.Text       := IniFile.ReadString('MainApp','DBUser','root');
  lbledtPassword.Text   := IniFile.ReadString('MainApp','DBPass','');
end;

end.
