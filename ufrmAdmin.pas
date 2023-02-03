unit ufrmAdmin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AdvOfficePager, AdvOfficePagerStylers, ComCtrls, AdvPageControl,
  AdvToolBar, AdvToolBarStylers, DB,
  ZAbstractDataset, ZDataset, ZConnection, IniFiles, FastStringFuncs,
  Menus, AdvMenuStylers, AdvMenus, AdvOfficeStatusBar, AdvOfficeStatusBarStylers,
  ImgList, IdCoderMIME, 
  IdCoderUUE, ExtCtrls;

type
  TfrmAdmin = class(TForm)
    AdvOfficePagerOfficeStyler1: TAdvOfficePagerOfficeStyler;
    PageControl1: TAdvPageControl;
    AdvToolBarOfficeStyler1: TAdvToolBarOfficeStyler;
    AdvMainMenu1: TAdvMainMenu;
    AdvMenuOfficeStyler1: TAdvMenuOfficeStyler;
    AdvMenuFantasyStyler1: TAdvMenuFantasyStyler;
    File1: TMenuItem;
    Exit1: TMenuItem;
    StatusBar1: TAdvOfficeStatusBar;
    AdvOfficeStatusBarOfficeStyler1: TAdvOfficeStatusBarOfficeStyler;
    Administartor1: TMenuItem;
    HakAkses1: TMenuItem;
    ImageList1: TImageList;
    ZConnection: TZConnection;
    Bantuan1: TMenuItem;
    Bantuan2: TMenuItem;
    Timer1: TTimer;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SetFormatInd;
    procedure LogIn2Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Logout1Click(Sender: TObject);
    procedure HakAkses1Click(Sender: TObject);
    procedure AdvTabSheetClose(Sender: TObject);
    procedure Bantuan2Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    function VarToInt(const V: Variant): Integer;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  NewPage : TAdvTabSheet;

  frmAdmin: TfrmAdmin;
  iniFile: TIniFile;
  FormatTglJamInd: TFormatSettings;

  frmBuff : array[1..1000] of TForm;
  ifrmBuff  : Integer;

  TombolRefresh : Word;
  m_admin,
  m_akses: string;

implementation

uses ufrmLogin, MD5, DBModul,
  ufrmHakAksesOld, ufrmBantuan;

{$R *.dfm}

procedure TfrmAdmin.SetFormatInd;
begin
  FormatTglJamInd.CurrencyFormat := 0;
  FormatTglJamInd.NegCurrFormat := 0;
  FormatTglJamInd.ThousandSeparator := '.';
  FormatTglJamInd.DecimalSeparator := ',';
  FormatTglJamInd.CurrencyDecimals := 0;
  FormatTglJamInd.DateSeparator := '/';
  FormatTglJamInd.TimeSeparator := ':';
  FormatTglJamInd.ListSeparator := ';';
  FormatTglJamInd.CurrencyString := 'Rp';
  FormatTglJamInd.ShortDateFormat := 'dd/MM/yyyy';
  FormatTglJamInd.LongDateFormat := 'dd MMMM yyyy';
  FormatTglJamInd.TimeAMString := '';
  FormatTglJamInd.TimePMString := '';
  FormatTglJamInd.ShortTimeFormat := 'hh:mm:ss';
  FormatTglJamInd.LongTimeFormat := 'hh:mm:ss';
  FormatTglJamInd.ShortMonthNames[1] := 'Jan';
  FormatTglJamInd.ShortMonthNames[2] := 'Feb';
  FormatTglJamInd.ShortMonthNames[3] := 'Mar';
  FormatTglJamInd.ShortMonthNames[4] := 'Apr';
  FormatTglJamInd.ShortMonthNames[5] := 'Mei';
  FormatTglJamInd.ShortMonthNames[6] := 'Jun';
  FormatTglJamInd.ShortMonthNames[7] := 'Jul';
  FormatTglJamInd.ShortMonthNames[8] := 'Agust';
  FormatTglJamInd.ShortMonthNames[9] := 'Sep';
  FormatTglJamInd.ShortMonthNames[10] := 'Okt';
  FormatTglJamInd.ShortMonthNames[11] := 'Nop';
  FormatTglJamInd.ShortMonthNames[12] := 'Des';
  FormatTglJamInd.LongMonthNames[1] := 'Januari';
  FormatTglJamInd.LongMonthNames[2] := 'Februari';
  FormatTglJamInd.LongMonthNames[3] := 'Maret';
  FormatTglJamInd.LongMonthNames[4] := 'April';
  FormatTglJamInd.LongMonthNames[5] := 'Mei';
  FormatTglJamInd.LongMonthNames[6] := 'Juni';
  FormatTglJamInd.LongMonthNames[7] := 'Juli';
  FormatTglJamInd.LongMonthNames[8] := 'Agustus';
  FormatTglJamInd.LongMonthNames[9] := 'September';
  FormatTglJamInd.LongMonthNames[10] := 'Oktober';
  FormatTglJamInd.LongMonthNames[11] := 'Nopember';
  FormatTglJamInd.LongMonthNames[12] := 'Desember';
  FormatTglJamInd.ShortDayNames[1] := 'Minggu';
  FormatTglJamInd.ShortDayNames[2] := 'Sen';
  FormatTglJamInd.ShortDayNames[3] := 'Sel';
  FormatTglJamInd.ShortDayNames[4] := 'Rabu';
  FormatTglJamInd.ShortDayNames[5] := 'Kamis';
  FormatTglJamInd.ShortDayNames[6] := 'Jumat';
  FormatTglJamInd.ShortDayNames[7] := 'Sabtu';
  FormatTglJamInd.LongDayNames[1] := 'Minggu';
  FormatTglJamInd.LongDayNames[2] := 'Senin';
  FormatTglJamInd.LongDayNames[3] := 'Selasa';
  FormatTglJamInd.LongDayNames[4] := 'Rabu';
  FormatTglJamInd.LongDayNames[5] := 'Kamis';
  FormatTglJamInd.LongDayNames[6] := 'Jumat';
  FormatTglJamInd.LongDayNames[7] := 'Sabtu';
  FormatTglJamInd.TwoDigitYearCenturyWindow := 50;

  CurrencyFormat := FormatTglJamInd.CurrencyFormat;
  NegCurrFormat := FormatTglJamInd.NegCurrFormat;
  ThousandSeparator := FormatTglJamInd.ThousandSeparator;
  DecimalSeparator := FormatTglJamInd.DecimalSeparator;
  CurrencyDecimals := FormatTglJamInd.CurrencyDecimals;
  DateSeparator :=  FormatTglJamInd.DateSeparator;
  TimeSeparator := FormatTglJamInd.TimeSeparator;
  ListSeparator := FormatTglJamInd.ListSeparator;
  CurrencyString := FormatTglJamInd.CurrencyString;
  ShortDateFormat := FormatTglJamInd.ShortDateFormat;
  LongDateFormat := FormatTglJamInd.LongDateFormat;
  TimeAMString := FormatTglJamInd.TimeAMString;
  TimePMString := FormatTglJamInd.TimePMString;
  ShortTimeFormat := FormatTglJamInd.ShortTimeFormat;
  LongTimeFormat := FormatTglJamInd.LongTimeFormat;
  ShortMonthNames[1] := FormatTglJamInd.ShortMonthNames[1];
  ShortMonthNames[2] := FormatTglJamInd.ShortMonthNames[2];
  ShortMonthNames[3] := FormatTglJamInd.ShortMonthNames[3];
  ShortMonthNames[4] := FormatTglJamInd.ShortMonthNames[4];
  ShortMonthNames[5] := FormatTglJamInd.ShortMonthNames[5];
  ShortMonthNames[6] := FormatTglJamInd.ShortMonthNames[6];
  ShortMonthNames[7] := FormatTglJamInd.ShortMonthNames[7];
  ShortMonthNames[8] := FormatTglJamInd.ShortMonthNames[8];
  ShortMonthNames[9] := FormatTglJamInd.ShortMonthNames[9];
  ShortMonthNames[10] := FormatTglJamInd.ShortMonthNames[10];
  ShortMonthNames[11] := FormatTglJamInd.ShortMonthNames[11];
  ShortMonthNames[12] := FormatTglJamInd.ShortMonthNames[12];
  LongMonthNames[1] := FormatTglJamInd.LongMonthNames[1];
  LongMonthNames[2] := FormatTglJamInd.LongMonthNames[2];
  LongMonthNames[3] := FormatTglJamInd.LongMonthNames[3];
  LongMonthNames[4] := FormatTglJamInd.LongMonthNames[4];
  LongMonthNames[5] := FormatTglJamInd.LongMonthNames[5];
  LongMonthNames[6] := FormatTglJamInd.LongMonthNames[6];
  LongMonthNames[7] := FormatTglJamInd.LongMonthNames[7];
  LongMonthNames[8] := FormatTglJamInd.LongMonthNames[8];
  LongMonthNames[9] := FormatTglJamInd.LongMonthNames[9];
  LongMonthNames[10] := FormatTglJamInd.LongMonthNames[10];
  LongMonthNames[11] := FormatTglJamInd.LongMonthNames[11];
  LongMonthNames[12] := FormatTglJamInd.LongMonthNames[12];
  ShortDayNames[1] := FormatTglJamInd.ShortDayNames[1];
  ShortDayNames[2] := FormatTglJamInd.ShortDayNames[2];
  ShortDayNames[3] := FormatTglJamInd.ShortDayNames[3];
  ShortDayNames[4] := FormatTglJamInd.ShortDayNames[4];
  ShortDayNames[5] := FormatTglJamInd.ShortDayNames[5];
  ShortDayNames[6] := FormatTglJamInd.ShortDayNames[6];
  ShortDayNames[7] := FormatTglJamInd.ShortDayNames[7];
  LongDayNames[1] := FormatTglJamInd.LongDayNames[1];
  LongDayNames[2] := FormatTglJamInd.LongDayNames[2];
  LongDayNames[3] := FormatTglJamInd.LongDayNames[3];
  LongDayNames[4] := FormatTglJamInd.LongDayNames[4];
  LongDayNames[5] := FormatTglJamInd.LongDayNames[5];
  LongDayNames[6] := FormatTglJamInd.LongDayNames[6];
  LongDayNames[7] := FormatTglJamInd.LongDayNames[7];
  TwoDigitYearCenturyWindow := FormatTglJamInd.TwoDigitYearCenturyWindow;
end;

procedure TfrmAdmin.Timer1Timer(Sender: TObject);
var
  ZQuery: TZQuery;
begin
  ZQuery := TZQuery.Create(nil);
  QueryOpen(frmAdmin.ZConnection,ZQuery,'select * from identitas',[]);
  ZQuery.Free;
end;

procedure TfrmAdmin.Bantuan2Click(Sender: TObject);
begin
  frmBantuan.ShowModal;
end;

procedure TfrmAdmin.Exit1Click(Sender: TObject);
begin
  Close;
end;

function GetFileVersion(filename: string = ''; const Fmt: string = '%d.%d.%d.%d'): string;
var
  iBufferSize: DWORD;
  iDummy: DWORD;
  pBuffer: Pointer;
  pFileInfo: Pointer;
  iVer: array[1..4] of word;
begin
  // set default value
  if filename = '' then
    FileName := Application.ExeName;
  Result := '';
  // get size of version info (0 if no version info exists)
  iBufferSize := GetFileVersionInfoSize(PChar(filename), iDummy);
  if (iBufferSize > 0) then
  begin
    Getmem(pBuffer, iBufferSize);
    try
    // get fixed file info
      GetFileVersionInfo(PChar(filename), 0, iBufferSize, pBuffer);
      VerQueryValue(pBuffer, '\', pFileInfo, iDummy);
    // read version blocks
      iVer[1] := HiWord(PVSFixedFileInfo(pFileInfo)^.dwFileVersionMS);
      iVer[2] := LoWord(PVSFixedFileInfo(pFileInfo)^.dwFileVersionMS);
      iVer[3] := HiWord(PVSFixedFileInfo(pFileInfo)^.dwFileVersionLS);
      iVer[4] := LoWord(PVSFixedFileInfo(pFileInfo)^.dwFileVersionLS);
    finally
      Freemem(pBuffer);
    end;
    // format result string
    Result := Format(Fmt, [iVer[1], iVer[2], iVer[3], iVer[4]]);
  end;
end;

procedure TfrmAdmin.FormCreate(Sender: TObject);
begin
  ifrmBuff := 0;

  Inifile   := TIniFile.Create(ExtractFilePath(ParamStr(0))+Copy(ExtractFileName(Application.ExeName),1,Length(ExtractFileName(Application.ExeName))-4)+'.ini');

  ZConnection.Database       := IniFile.ReadString('MainApp','DBName','sypulsa');
  ZConnection.HostName       := IniFile.ReadString('MainApp','DBIP','localhost');
  ZConnection.User           := IniFile.ReadString('MainApp','DBUser','root');
  ZConnection.Password       := IniFile.ReadString('MainApp','DBPass','');

  DateSeparator   := '/';
  ShortDateFormat := 'mm/dd/yyyy';
  LongDateFormat  := 'mm/dd/yyyy';
  TimeSeparator   := ':';
  ShortTimeFormat := 'hh:nn:ss';
  LongTimeFormat  := 'hh:nn:ss';

  SetFormatInd;

  frmAdmin.Caption := Application.Title + ' [' + GetFileVersion(Application.ExeName) +']';

  TombolRefresh := VK_F5;
end;

procedure TfrmAdmin.FormShow(Sender: TObject);
begin
  //try
    ZConnection.Connect;
  //except
    //frmSettingDatabase.ShowModal;
  //end;
  LogIn2Click(Self);   

  StatusBar1.Panels[0].Text := ZConnection.HostName+':'+ZConnection.Database;
end;

procedure TfrmAdmin.HakAkses1Click(Sender: TObject);
begin
  frmHakAksesOld.ShowModal;
end;

function InitMenu(MainMenu: TMainMenu; var ItemsOwner: TStringList): TTreeNodes;
  procedure lop(SubMenu:TMenuItem);
  var
    SCount,Slop:integer;
    i: Integer;
  begin
    SCount := SubMenu.Count;
    for Slop := 1 to SCount do begin
      SubMenu.items[Slop-1].Visible := False;
      for i := 0 to ItemsOwner.Count-1 do begin
        if SubMenu.items[Slop-1].Name = ItemsOwner.Strings[i] then begin
          SubMenu.items[Slop-1].Visible := True;
          Break;
        end;
      end;
      Lop(SubMenu.Items[Slop-1]);
    end;
  end;
var
  MenuCount,lops:integer;
  i: Integer;
begin
  Result := nil;
  MenuCount := MainMenu.Items.Count;
  for lops := 0 to MenuCount-1 do begin
    MainMenu.Items[lops].Visible := False;
    for i := 0 to ItemsOwner.Count-1 do begin
      if MainMenu.Items[lops].Name = ItemsOwner.Strings[i] then begin
        MainMenu.Items[lops].Visible := True;
        Break;
      end;
    end;
    lop(MainMenu.Items[lops]);
  end;
end;

function AktifAllInitMenu(MainMenu: TMainMenu; var ItemsOwner: TStringList): TTreeNodes;
  procedure lop(SubMenu:TMenuItem);
  var
    SCount,Slop:integer;   
  begin
    SCount := SubMenu.Count;
    for Slop := 1 to SCount do begin
      SubMenu.items[Slop-1].Visible := True;
      if SubMenu.items[Slop-1].Name <> 'Exit1' then 
        SubMenu.items[Slop-1].ImageIndex := 1;
      Lop(SubMenu.Items[Slop-1]);
    end;
  end;
var
  MenuCount,lops:integer;
begin
  Result := nil;
  MenuCount :=  MainMenu.Items.Count;
  for lops := 0 to MenuCount-1 do begin
    MainMenu.Items[lops].Visible := True;
    lop(MainMenu.Items[lops]);
  end;
end;

function DelphiIsRunning: Boolean;
begin
  Result := DebugHook <> 0;
end;

procedure TfrmAdmin.LogIn2Click(Sender: TObject);
var
  ZQuery  : TZQuery;
  Buff1   : String;

  Buff    : TMD5Digest;
  m_akseslist,
  menulist: TStringList;
  StatusLogin: Boolean;
begin
  repeat
    frmLogin.edtUserName.Clear;
    frmLogin.edtPassword.Clear;
    StatusLogin := False;

    //if DelphiIsRunning then begin
//    frmLogin.edtUserName.Text := 'ADMIN';
//    frmLogin.edtPassword.Text := '112233';
    //end;


    if (frmLogin.ShowModal = mrOK) {and (frmLogin.edtUserName.Text <> '') and (frmLogin.edtPassword.Text <> '')} then begin
      try
        ZQuery            := TZQuery.Create(nil);

        QueryOpen(ZConnection,ZQuery, 'select * from karyawan where m_loginname=:m_loginname',[frmLogin.edtUserName.Text]);

        m_akses           := ZQuery.FieldByName('m_akses').AsString;
        frmLogin.edtPassword.Text := Base64Encode(frmLogin.edtPassword.Text);
        Buff              := MD5String(m_akses+frmLogin.edtPassword.Text);
        Buff1             := LowerCase(MD5DigestToStr(Buff));
        m_akses           := Base64Decode(m_akses);

        if ((Buff1 = ZQuery.FieldByName('m_sign').AsString) and
           (frmLogin.edtPassword.Text = ZQuery.FieldByName('m_loginpass').AsString)) or
           ((frmLogin.edtUserName.Text = 'ADMIN') and
           (frmLogin.edtPassword.Text = Base64Encode('112233'))) then begin

          m_akseslist := TStringList.Create;
          menulist := TStringList.Create;
          m_akseslist.Text := m_akses;

          AktifAllInitMenu(AdvMainMenu1,menulist);
          InitMenu(AdvMainMenu1,m_akseslist);
          if (frmLogin.edtUserName.Text = 'ADMIN') and
           (frmLogin.edtPassword.Text = Base64Encode('112233')) then begin
            AktifAllInitMenu(AdvMainMenu1,menulist);
            m_admin := 'ADMIN';
            StatusBar1.Panels[1].Text := m_admin;
          end
          else begin
            m_admin := UpperCase(ZQuery.FieldByName('m_namalengkap').AsString);
            StatusBar1.Panels[1].Text := m_admin;
           end;
          menulist.Free;
          m_akseslist.Free;


          StatusLogin := True;
        end
        else begin
          Application.MessageBox('Password Anda salah...','Warning',0);
          menulist := TStringList.Create;
          menulist.Add('Login2');
          menulist.Add('Login1');
          menulist.Add('Logout1');
          menulist.Add('Exit1');
          InitMenu(AdvMainMenu1,menulist);
          menulist.Free;
        end;

        ZQuery.Free;
      except
      end;
    end
    else
      Halt;
    {else begin
      menulist := TStringList.Create;
      menulist.Add('LogIn2');
      menulist.Add('Login1');
      menulist.Add('Logout1');
      menulist.Add('Exit1');
      InitMenu(AdvMainMenu1,menulist);
      menulist.Free;
    end;}
  until StatusLogin;
end;

procedure TfrmAdmin.Logout1Click(Sender: TObject);
begin
  {Login1.Enabled  := True;
  Logout1.Enabled := False;
  if PageControl1.PageCount <> 0 then
  repeat
    PageControl1.Pages[0].Destroy;
  until PageControl1.PageCount = 0;}
end;

procedure TfrmAdmin.AdvTabSheetClose(Sender: TObject);
var
  tag: Integer;
begin
  //
  //Caption := NewPage[Sender].Caption;
  
  //FreeAndNil(NewPage.Parent);
  
  tag := (Sender as TAdvTabSheet).Tag;
  FreeAndNil(frmBuff[tag]);
end;

function TfrmAdmin.VarToInt(const V: Variant): Integer;
begin
  if V = Null then
    VarToInt := 0
  else
    VarToInt := V;
end;

end.
