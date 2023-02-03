unit ufrmHakAksesOld;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, NxColumnClasses, 
  NxGrid, DB,
  ZAbstractRODataset, ZAbstractDataset, ZDataset, md5, ComCtrls, Menus,
  NxColumns, NxScrollControl, NxCustomGridControl, NxCustomGrid;

type
  TfrmHakAksesOld = class(TForm)
    NextGrid1: TNextGrid;
    namalogin: TNxTextColumn;
    password: TNxTextColumn;
    namalengkap: TNxTextColumn;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    Edit3: TEdit;
    akses: TNxTextColumn;
    btnHapus: TButton;
    btnEdit: TButton;
    btnTambah: TButton;
    btnRefresh: TButton;
    btnBatal: TButton;
    btnYa: TButton;
    NextGrid2: TNextGrid;
    NxTreeColumn1: TNxTreeColumn;
    NxTextColumn1: TNxTextColumn;
    NxCheckBoxColumn1: TNxCheckBoxColumn;
    TreeView1: TTreeView;
    procedure NextGrid1SelectCell(Sender: TObject; ACol, ARow: Integer);
    procedure btnTambahClick(Sender: TObject);
    procedure btnYaClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure btnBatalClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnHapusClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmHakAksesOld    : TfrmHakAksesOld;
  BStatus   : String;

implementation

uses Modul, FastStringFuncs, ufrmAdmin;

{$R *.dfm}

procedure TfrmHakAksesOld.NextGrid1SelectCell(Sender: TObject; ACol,
  ARow: Integer);
var
  akses   : TStringList;
  i,j : Integer;
begin
  Edit1.Text        := NextGrid1.CellByName['namalogin',Arow].AsString;
  Edit2.Text        := Base64Decode(NextGrid1.CellByName['password',Arow].AsString);
  Edit3.Text        := NextGrid1.CellByName['namalengkap',Arow].AsString;
  akses             := TStringList.Create;
  akses.Text             := NextGrid1.CellByName['akses',Arow].AsString;
  akses.Text             := Base64Decode(akses.Text);

  for i := 0 to NextGrid2.RowCount-1 do begin
    NextGrid2.Cell[2, i].AsString := 'False';
    for j := 0 to akses.Count-1 do begin
      if NextGrid2.Cell[1, i].AsString = akses.Strings[j] then begin
        NextGrid2.Cell[2, i].AsString := 'True';
      end;
    end;
  end;
  akses.Free;
  {CheckBox1.Checked := False;
  CheckBox2.Checked := False;
  CheckBox3.Checked := False;
  CheckBox4.Checked := False;
  CheckBox5.Checked := False;
  CheckBox6.Checked := False;
  CheckBox7.Checked := False;
  CheckBox8.Checked := False;
  CheckBox9.Checked := False;
  CheckBox10.Checked := False;
  CheckBox11.Checked := False;
  CheckBox12.Checked := False;
  CheckBox13.Checked := False;
  CheckBox14.Checked := False;
  CheckBox15.Checked := False;
  CheckBox16.Checked := False;
  CheckBox17.Checked := False;
  CheckBox18.Checked := False;
  CheckBox19.Checked := False;
  CheckBox20.Checked := False;
  CheckBox21.Checked := False;
  CheckBox22.Checked := False;
  CheckBox23.Checked := False;

  if akses[1] = '1' then
    CheckBox1.Checked := True;
  if akses[2] = '1' then
    CheckBox2.Checked := True;
  if akses[3] = '1' then
    CheckBox3.Checked := True;
  if akses[4] = '1' then
    CheckBox4.Checked := True;
  if akses[5] = '1' then
    CheckBox5.Checked := True;
  if akses[6] = '1' then
    CheckBox6.Checked := True;
  if akses[7] = '1' then
    CheckBox7.Checked := True;
  if akses[8] = '1' then
    CheckBox8.Checked := True;
  if akses[9] = '1' then
    CheckBox9.Checked := True;
  if akses[10] = '1' then
    CheckBox10.Checked := True;
  if akses[11] = '1' then
    CheckBox11.Checked := True;
  if akses[12] = '1' then
    CheckBox12.Checked := True;
  if akses[13] = '1' then
    CheckBox13.Checked := True;
  if akses[14] = '1' then
    CheckBox14.Checked := True;
  if akses[15] = '1' then
    CheckBox15.Checked := True;
  if akses[16] = '1' then
    CheckBox16.Checked := True;
  if akses[17] = '1' then
    CheckBox17.Checked := True;
  if akses[18] = '1' then
    CheckBox18.Checked := True;
  if akses[19] = '1' then
    CheckBox19.Checked := True;
  if akses[20] = '1' then
    CheckBox20.Checked := True;
  if akses[21] = '1' then
    CheckBox21.Checked := True;
  if akses[22] = '1' then
    CheckBox22.Checked := True;
  if akses[23] = '1' then
    CheckBox23.Checked := True;}
end;

procedure TfrmHakAksesOld.btnTambahClick(Sender: TObject);
begin
  BStatus           := 'Tambah';
  GroupBox1.Enabled := True;
  GroupBox2.Enabled := True;
  btnEdit.Enabled  := False;
  btnHapus.Enabled  := False;
  btnTambah.Enabled  := False;
  btnRefresh.Enabled  := False;
end;

procedure TfrmHakAksesOld.btnYaClick(Sender: TObject);
var
  TextSql : String;
  Password,
  sign    : String;
  akses1: string;
  akses   : TStringList;
  ZQuery  : TZQuery;
  i: Integer;

  Buff  : TMD5Digest;  
begin
  if BStatus = 'Tambah' then
  if (Application.MessageBox('Anda yakin data sudah benar..?','Warning',MB_YESNO) = IDYES) then begin
    ZQuery            := TZQuery.Create(nil);
    ZQuery.Connection := frmAdmin.ZConnection;

    password    := Base64Encode(Edit2.Text);


    akses := TStringList.Create;
    for i := 0 to NextGrid2.RowCount-1 do begin
      if UpperCase(NextGrid2.Cell[2, i].AsString) = 'TRUE' then begin
        akses.Add(NextGrid2.Cell[1, i].AsString);
      end;
    end;

    akses1       := Base64Encode(akses.Text);
    akses.Free;

    Buff        := MD5String(akses1+password);
    sign        := LowerCase(MD5DigestToStr(Buff));
    TextSql := 'insert into karyawan (m_loginname, m_loginpass, m_namalengkap, m_akses, m_isactive, m_sign) '+
               'values (:m_loginname, :m_loginpass, :m_namalengkap, :m_akses, :m_isactive, :m_sign)';

    ZQuery.Close;
    ZQuery.SQL.Clear;
    ZQuery.SQL.Add(TextSql);
    ZQuery.ParamByName('m_loginname').AsString          := Edit1.Text;
    ZQuery.ParamByName('m_loginpass').AsString          := password;
    ZQuery.ParamByName('m_namalengkap').AsString        := Edit3.Text;
    ZQuery.ParamByName('m_akses').AsString              := akses1;
    ZQuery.ParamByName('m_isactive').AsInteger          := 1;
    ZQuery.ParamByName('m_sign').AsString               := sign;
    ZQuery.ExecSQL;

    //TextSql := 'update karyawan set m_loginname=concat(''K'',m_id+1000) where m_loginname='''' or m_loginname = NULL';

    //ZQuery.Close;
    //ZQuery.SQL.Clear;
    //ZQuery.SQL.Add(TextSql);
    //ZQuery.ExecSQL;
    
    ZQuery.Free;
  end;

  if BStatus = 'Edit' then
  if (Application.MessageBox('Anda yakin data sudah benar..?','Warning',MB_YESNO) = IDYES) then begin
    ZQuery            := TZQuery.Create(nil);
    ZQuery.Connection := frmAdmin.ZConnection;

    password    := Base64Encode(Edit2.Text);

    akses := TStringList.Create;
    for i := 0 to NextGrid2.RowCount-1 do begin
      if UpperCase(NextGrid2.Cell[2, i].AsString) = 'TRUE' then begin
        akses.Add(NextGrid2.Cell[1, i].AsString);
      end;
    end;

    akses1       := Base64Encode(akses.Text);
    akses.Free;

    Buff        := MD5String(akses1+password);
    sign        := LowerCase(MD5DigestToStr(Buff));
    TextSql := 'update karyawan set m_loginpass=:m_loginpass, m_namalengkap=:m_namalengkap, m_akses=:m_akses, '+
               'm_isactive=:m_isactive, m_sign=:m_sign '+
               'where m_loginname=:m_loginname';

    ZQuery.Close;
    ZQuery.SQL.Clear;
    ZQuery.SQL.Add(TextSql);
    ZQuery.ParamByName('m_loginname').AsString          := Edit1.Text;
    ZQuery.ParamByName('m_loginpass').AsString          := password;
    ZQuery.ParamByName('m_namalengkap').AsString        := Edit3.Text;
    ZQuery.ParamByName('m_akses').AsString              := akses1;
    ZQuery.ParamByName('m_isactive').AsInteger          := 1;
    ZQuery.ParamByName('m_sign').AsString               := sign;
    ZQuery.ExecSQL;

    ZQuery.Free;
  end;

  GroupBox1.Enabled := False;
  GroupBox2.Enabled := False;
  btnTambah.Enabled  := True;
  btnEdit.Enabled  := True;
  btnHapus.Enabled  := True;
  btnRefresh.Enabled  := True;
end;

procedure TfrmHakAksesOld.btnRefreshClick(Sender: TObject);
var
  TextSql : String;
begin
  TextSql     := 'select m_loginname, m_loginpass, m_namalengkap, m_akses from karyawan';
  Table2Grid(frmAdmin.ZConnection,TextSql,NextGrid1,$00F8E8DC,clWhite);
end;

procedure TfrmHakAksesOld.btnBatalClick(Sender: TObject);
begin
  GroupBox1.Enabled := False;
  GroupBox2.Enabled := False;
  btnTambah.Enabled  := True;
  btnEdit.Enabled  := True;
  btnHapus.Enabled  := True;
  btnRefresh.Enabled  := True;
end;

procedure TfrmHakAksesOld.btnEditClick(Sender: TObject);
begin
  BStatus           := 'Edit';
  GroupBox1.Enabled := True;
  GroupBox2.Enabled := True;
  btnTambah.Enabled  := False;
  btnEdit.Enabled  := False;
  btnHapus.Enabled  := False;
  btnRefresh.Enabled  := False;  
end;

procedure TfrmHakAksesOld.btnHapusClick(Sender: TObject);
var
  TextSql : String;
  ZQuery  : TZQuery;
begin
  if (Application.MessageBox('Anda yakin data mau dihapus..?','Warning',MB_YESNO) = IDYES) then begin
    ZQuery            := TZQuery.Create(nil);
    ZQuery.Connection := frmAdmin.ZConnection;

    TextSql := 'delete from karyawan where m_loginname=:m_loginname';

    ZQuery.Close;
    ZQuery.SQL.Clear;
    ZQuery.SQL.Add(TextSql);
    ZQuery.ParamByName('m_loginname').AsString          := Edit1.Text;
    ZQuery.ExecSQL;
    
    ZQuery.Free;
  end;

  GroupBox1.Enabled := False;
  GroupBox2.Enabled := False;
  btnTambah.Enabled  := True;
  btnEdit.Enabled  := True;
  btnHapus.Enabled  := True;
  btnRefresh.Enabled  := True;
end;

function   InitMenu(MainMenu:   TMainMenu;   ItemsOwner:   TTreeView; Grid: TNextGrid):   TTreeNodes;
      procedure   lop(SubMenu:TMenuItem;var   TreeItem:TTreeNodes;SubNode:TTreeNode);   
      var   
          SCount,Slop:integer;   
          SSubNode:TTreeNode;
          i: Integer;   
      begin   
          SCount   :=   SubMenu.Count;
          i := Grid.LastAddedRow;   
          For   Slop   :=   1   to   SCount   do
          begin
              SSubNode   :=   TreeItem.AddChild(subNode,SubMenu.items[Slop-1].Caption);
              if SubMenu.items[Slop-1].Caption <> '-' then begin
              Grid.AddChildRow(i, crLast);
              Grid.Cell[0, Grid.LastAddedRow].AsString := StringReplace(SubMenu.items[Slop-1].Caption,'&','',[rfReplaceAll,rfIgnoreCase]);
              Grid.Cell[1, Grid.LastAddedRow].AsString := SubMenu.items[Slop-1].Name;
              end;
              SSubNode.StateIndex   :=   1;   
              Lop(SubMenu.Items[Slop-1],TreeItem,SSubNode);   
          end;   
      end;   
  var   
      RetuMenu:TTreeNodes;   
      SubItem,ParentItem:TTreeNode;   
      MenuCount,lops:integer;   
  begin   
      Result   :=   nil;   
      RetuMenu   :=   TTreeNodes.Create(ItemsOwner);
      ParentItem   :=   RetuMenu.AddFirst(nil,'MENU');   
          MenuCount   :=   MainMenu.Items.Count;   
          for   lops   :=   0   to   MenuCount-1   do   
          begin   
              SubItem   :=   RetuMenu.Add(ParentItem,MainMenu.Items[lops].Caption);

                Grid.AddRow();
                Grid.Cell[0, Grid.LastAddedRow].AsString := StringReplace(MainMenu.Items[lops].Caption,'&','',[rfReplaceAll,rfIgnoreCase]);
                Grid.Cell[1, Grid.LastAddedRow].AsString := MainMenu.Items[lops].Name;
              SubItem.StateIndex   :=   1;
              lop(MainMenu.Items[lops],RetuMenu,SubItem);   
          end;   
          Result   :=   RetuMenu;   
  end;


procedure TfrmHakAksesOld.FormCreate(Sender: TObject);
begin
  InitMenu(frmAdmin.AdvMainMenu1,TreeView1,NextGrid2)
end;

end.
