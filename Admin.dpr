program Admin;

uses
  Forms,
  ufrmAdmin in 'ufrmAdmin.pas' {frmAdmin},
  ufrmLogin in 'ufrmLogin.pas' {frmLogin},
  ufrmHakAkses in 'ufrmHakAkses.pas' {frmHakAkses},
  ufrmSettingDatabase in 'ufrmSettingDatabase.pas' {frmSettingDatabase},
  ufrmHakAksesOld in 'ufrmHakAksesOld.pas' {frmHakAksesOld},
  ufrmBantuan in 'ufrmBantuan.pas' {frmBantuan};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Administrator';
  Application.CreateForm(TfrmAdmin, frmAdmin);
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.CreateForm(TfrmSettingDatabase, frmSettingDatabase);
  Application.CreateForm(TfrmHakAksesOld, frmHakAksesOld);
  Application.CreateForm(TfrmBantuan, frmBantuan);
  Application.Run;
end.
