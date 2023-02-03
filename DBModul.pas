unit DBModul;

interface

uses StdCtrls, ZDataset, ZConnection, SysUtils, Dialogs;

procedure QueryOpen(ZConnection: TZConnection; ZQuery : TZQuery; Query: String; const Params : array of Variant);
procedure QueryExecute(ZConnection: TZConnection; Query: String; const Params : array of Variant; NamaFunction: string = '');
procedure QueryExecuteLastID(ZConnection: TZConnection; Query: String; const Params : array of Variant; var SMSOutID: Double; NamaFunction: string = '');
function TableRowCount(ZConnection: TZConnection; SQlQuery : String) : Int64;
function TableRowCountOpenFirst(ZConnection: TZConnection; SQlQuery : String) : Int64;
function TableRowSum(ZConnection: TZConnection; SQlQuery : String) : Int64;
function StrToStrSql(TeksIn : String): String;
procedure SaveLogError(aNamaFile,StrQuery,aStr: String);
procedure SaveLogCom(aNamaFile,aStr: String);

implementation

procedure QueryOpen(ZConnection: TZConnection; ZQuery : TZQuery; Query : String; const Params : array of Variant);
var
  i : Integer;
begin
  {if not ZConnection.Connected then
    try
      ZConnection.Connect;
    except
      Exit;
    end;}

  try
    ZQuery.Connection := ZConnection;
    ZQuery.Close;
    ZQuery.SQL.Clear;
    ZQuery.SQL.Add(Query);
    for i := Low(Params) to High(Params) do
      ZQuery.Params[i].Value  := Params[i];
    ZQuery.Open;
  except
    on E : Exception do begin
       SaveLogError('',Query,E.Message);
    end;
      
    //ZConnection.Disconnect;
  end;
end;

procedure QueryExecute(ZConnection: TZConnection; Query: String; const Params : array of Variant; NamaFunction: string = '');
var
  i : Integer;
  SQLQuery: String;
  ZQuery: TZQuery;
begin
  if not ZConnection.Connected then
    try
      ZConnection.Connect;
    except
      Exit;
    end;
    
  SQLQuery := Query;

  ZQuery := TZQuery.Create(nil);
  try
    ZQuery.Connection := ZConnection;
    try
      ZQuery.Close;
      ZQuery.SQL.Clear;
      ZQuery.SQL.Add(SQLQuery);
      for i := Low(Params) to High(Params) do
        ZQuery.Params[i].Value  := Params[i];
      ZQuery.ExecSQL;
    except
      //Raise;
      on E : Exception do begin
       //ShowMessage('Exception message = '+E.Message);
       SaveLogError('',SQLQuery,NamaFunction+'-->'+E.Message);
       //ZConnection.Disconnect;
      end;
    end;
  finally
    ZQuery.Free;
  end;
end;

procedure QueryExecuteLastID(ZConnection: TZConnection; Query: String; const Params : array of Variant; var SMSOutID: Double; NamaFunction: string = '');
var
  i : Integer;
  SQLQuery: String;
  ZQuery: TZQuery;
begin
  if not ZConnection.Connected then
    try
      ZConnection.Connect;
    except
      Exit;
    end;
    
  SQLQuery := Query;

  ZQuery := TZQuery.Create(nil);
  try
    ZQuery.Connection := ZConnection;
    try
      ZQuery.Close;
      ZQuery.SQL.Clear;
      ZQuery.SQL.Add(SQLQuery);
      for i := Low(Params) to High(Params) do
        ZQuery.Params[i].Value  := Params[i];
      ZQuery.ExecSQL;

      ZQuery.SQL.Clear;
      //ZQuery.SQL.Add('SELECT MAX(m_id) as lastid FROM smsout');
      ZQuery.SQL.Add('select last_insert_id() as `lastid`');
      ZQuery.Open;
      SMSOutID := ZQuery.FieldByName('lastid').AsFloat;
    except
      //Raise;
      on E : Exception do begin
       //ShowMessage('Exception message = '+E.Message);
       SaveLogError('',SQLQuery,NamaFunction+'-->'+E.Message);
       //ZConnection.Disconnect;
      end;
    end;
  finally
    ZQuery.Free;
  end;
end;

procedure SaveLogError(aNamaFile,StrQuery,aStr: String);
var
  myFile: TextFile;
begin
  if aNamaFile = '' then
    aNamaFile := ExtractFilePath(ParamStr(0))+'LogError.txt';

  AssignFile(myFile, aNamaFile);

  if FileExists(aNamaFile) then begin
    Append(myFile);
  end
  else begin
    ReWrite(myFile);  
  end;

  WriteLn(myFile, FormatDateTime('hh:nn:ss dd:mm:yyyy',Now)+#9+StrQuery+#10#13+#9#9#9+aStr);
  
  CloseFile(myFile);
end;

procedure SaveLogCom(aNamaFile,aStr: String);
var
  myFile: TextFile;
begin
  if aNamaFile = '' then
    aNamaFile := ExtractFilePath(ParamStr(0))+'Log.txt';

  AssignFile(myFile, aNamaFile);

  if FileExists(aNamaFile) then begin
    Append(myFile);
  end
  else begin
    ReWrite(myFile);  
  end;

  WriteLn(myFile, FormatDateTime('hh:nn:ss dd:mm:yyyy',Now)+#9#9#9+aStr);
  //WriteLn(myFile, aStr);
  
  CloseFile(myFile);
end;

function TableRowCount(ZConnection: TZConnection; SQlQuery : String) : Int64;
var
  ZQuery  : TZQuery;                                      
begin
  Result := 0;
  ZQuery              := TZQuery.Create(nil);
  try
    try
      QueryOpen(ZConnection,ZQuery,SQlQuery,[]);
      Result := ZQuery.Fields[0].AsInteger;
    except
      Raise;
    end;
  finally
    ZQuery.Free;
  end;
end;

function TableRowCountOpenFirst(ZConnection: TZConnection; SQlQuery : String) : Int64;
var
  ZQuery  : TZQuery;
begin
  Result := 0;
  ZQuery              := TZQuery.Create(nil);
  try
    try
      QueryOpen(ZConnection,ZQuery,SQlQuery,[]);
      Result := ZQuery.RecordCount;
    except
      Raise;
    end;
  finally
    ZQuery.Free;
  end;
end;

function TableRowSum(ZConnection: TZConnection; SQlQuery : String) : Int64;
var
  ZQuery  : TZQuery;                                      
  i       : Int64;
  Buff    : String;
begin
  ZQuery              := TZQuery.Create(nil);
  ZQuery.Connection   := ZConnection;

  ZQuery.SQL.Clear;
  ZQuery.SQL.Add(SqlQuery);
  ZQuery.Open;

  Buff := ZQuery.FieldByName('total').AsString;
  if Buff = '' then
    Buff := '0';
  i    := StrToInt64(Buff);
  Result := i;  
  
  ZQuery.Free;
end;

function StrToStrSql(TeksIn : String): String;
begin
  StrToStrSql := StringReplace(TeksIn,'''','\''',[rfReplaceAll,rfIgnoreCase]);
end;

end.
