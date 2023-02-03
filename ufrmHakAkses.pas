unit ufrmHakAkses;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, AdvPageControl, StdCtrls, NxColumnClasses,
  NxGrid, NxColumns, NxScrollControl, NxCustomGridControl, NxCustomGrid;

type
  TfrmHakAkses = class(TForm)
    PageControl1: TAdvPageControl;
    AdvTabSheet1: TAdvTabSheet;
    AdvTabSheet2: TAdvTabSheet;
    Akses: TAdvTabSheet;
    NextGrid1: TNextGrid;
    namalogin: TNxTextColumn;
    password: TNxTextColumn;
    namalengkap: TNxTextColumn;
    NxTextColumn1: TNxTextColumn;
    btnTambah: TButton;
    btnEdit: TButton;
    btnSimpan: TButton;
    btnBatal: TButton;
    btnHapus: TButton;
    btnTutup: TButton;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Edit3: TEdit;
    Label3: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmHakAkses: TfrmHakAkses;

implementation

{$R *.dfm}

end.
