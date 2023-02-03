unit Modul;

interface

uses StdCtrls, ZDataset, ZConnection, SysUtils, Dialogs, DBModul, NxGrid,
     Graphics, NxCustomGridControl, Variants, Forms, Classes, ClassMisc,
     Windows, StrUtils;

procedure LoadToComboBox(ZConnection: TZConnection; Query : String; ComboBox : TComboBox);
procedure LoadToComboBox2(ZConnection: TZConnection; Query : String; ComboBox : TComboBox);
procedure Table2Grid(ZConnection: TZConnection; SQlQuery : String; Grid : TNextGrid; Color1,Color2 : TColor);
function CopyForSubStr(Str, SubStr : String) : String;
function StrToStrList(DataIn, ChrAwal, ChrAkhir: String): String;
function StrListToStr(DataIn, ChrAwal, ChrAkhir: String): String;
function CopyTeksCenterStr(StrParsing, Pesan, DimulaiDari : string) : string;
procedure Delay(MSecs: Integer) ;
procedure Sound(aFreq, aDelay: Integer) ;
procedure NoSound;
function RandomString(MaxStr: Integer) : string;

implementation

procedure LoadToComboBox2(ZConnection: TZConnection; Query : String; ComboBox : TComboBox);
var
  ZQuery  : TZQuery;
begin
  ZQuery            := TZQuery.Create(nil);
  ZQuery.Connection := ZConnection;

  try
    ZQuery.Close;
    //ZQuery.SQL.Clear;
    ZQuery.SQL.Text := Query;
    ZQuery.Open;

    ComboBox.Items.Clear;
    ComboBox.Clear;
    while not ZQuery.Eof do begin
      if ZQuery.FieldCount <> 1 then
        ComboBox.Items.Values[ZQuery.Fields[0].AsString] := ZQuery.Fields[1].AsString
      else
        ComboBox.Items.Add(ZQuery.Fields[0].AsString);
      //Sleep(1);
      //Application.ProcessMessages;
      ZQuery.Next;
    end;
    ComboBox.ItemIndex := -1;
  finally
    ZQuery.Free;
  end;
end;

procedure LoadToComboBox(ZConnection: TZConnection; Query : String; ComboBox : TComboBox);
var
  ZQuery  : TZQuery;
  TS: TStringList;
begin
  ZQuery            := TZQuery.Create(nil);
  ZQuery.Connection := ZConnection;
  TS                := TStringList.Create;

  try
    ZQuery.Close;
    ZQuery.SQL.Text := Query;
    ZQuery.Open;

    ComboBox.Items.Clear;
    ComboBox.Clear;
    while not ZQuery.Eof do begin
      if ZQuery.FieldCount <> 1 then
        //ComboBox.Items.Values[ZQuery.Fields[0].AsString] := ZQuery.Fields[1].AsString
        TS.Add(ZQuery.Fields[0].AsString+'='+ZQuery.Fields[1].AsString)
      else
        TS.Add(ZQuery.Fields[0].AsString);
        //ComboBox.Items.Add(ZQuery.Fields[0].AsString);
      ZQuery.Next;
    end;
    ComboBox.Items  := TS;
    ComboBox.ItemIndex := -1;
  finally
    ZQuery.Free;
    TS.Free;
  end;
end;

procedure Table2Grid(ZConnection: TZConnection; SQlQuery : String; Grid : TNextGrid; Color1,Color2 : TColor);
var
  ZQuery  : TZQuery;
  i,j,k   : Integer;
begin
  ZQuery              := TZQuery.Create(nil);
  try
    try
      Grid.AppearanceOptions := [aoIndicateSelectedCell];
      Grid.InactiveSelectionColor := clHighlight;

      QueryOpen(ZConnection,ZQuery,SQlQuery,[]);

      ZQuery.Last;
      k := ZQuery.RecordCount;

      Grid.ClearRows;
      if not ZQuery.IsEmpty then begin
        ZQuery.First;
        Grid.BeginUpdate;
        Grid.AddRow(k);
        for j := 0 to k-1 do begin
          for i := 0 to ZQuery.FieldCount-1 do begin
            if ZQuery.Fields[i].Value <> Null then
              Grid.Cell[i,j].AsString := StringReplace(ZQuery.Fields[i].AsString,'#13#10',Chr($0D)+Chr($0A),[rfReplaceAll, rfIgnoreCase])
            else
              Grid.Cell[i,j].AsString := '';
            if j mod 2 = 1 then
              Grid.Cell[i,j].Color := $00EFEFEF
            else
              Grid.Cell[i,j].Color := clWhite;
            Application.ProcessMessages;
          end;
          ZQuery.Next;
        end;
        Grid.EndUpdate;
        Grid.Refresh;
      end;
    except
      Raise;
    end;
  finally
    ZQuery.Free;
  end;
end;

function CopyForSubStr(Str, SubStr : String) : String;
begin
  if Pos(SubStr,Str) <> 0 then
    CopyForSubStr := Copy(Str,1,Pos(SubStr,Str)-1)
  else
    CopyForSubStr := Str;
end;

function StrToStrList(DataIn, ChrAwal, ChrAkhir: String): String;
var
  i         : Integer;
  CNilai,
  BuffHasil : String;
begin
  i         := 1;
  BuffHasil := '';
  if DataIn <> '' then begin
  repeat
    if DataIn[i] = ChrAwal then begin
      CNilai := '';
      repeat
        CNilai := CNilai + DataIn[i];
        inc(i);
      until (DataIn[i] = ChrAkhir) or (DataIn[i] = ChrAwal);
      CNilai := CNilai + DataIn[i];

      if DataIn[i] = ChrAwal then begin
        dec(i);
      end
      else begin
        BuffHasil := BuffHasil + Copy(CNilai,2,Length(CNilai)-2) + Chr($0D) + Chr($0A);
      end;
    end;
    inc(i);
  until i = Length(DataIn)+1;
  end;
  StrToStrList := BuffHasil;
end;

function StrListToStr(DataIn, ChrAwal, ChrAkhir: String): String;
var
  ST: TStringList;
  i: Integer;
  BuffHasil: String;
begin
  ST := TStringList.Create;
  ST.Text := DataIn;
  BuffHasil := '';
  for i := 0 to ST.Count-1 do begin
    BuffHasil := BuffHasil + ChrAwal + ST.Strings[i] + ChrAkhir;
  end;
  ST.Free;
  StrListToStr := BuffHasil;
end;

function PosStr(SubStr, Str: string): Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 1 to Length(Str) do begin
    if Copy(Str,1,Length(SubStr)) = SubStr then begin
      Result := i;
      Break;
    end;
  end;
end;

function CopyTeksCenterStr(StrParsing, Pesan, DimulaiDari : string) : string;
function JmlHuruf(SubStr,Str : String) : Integer;
var
  i,j : Integer;
begin
  j := 0;
  for i := 1 to Length(Str) do
    if Str[i] = SubStr then
      inc(j);
  JmlHuruf  := j;
end;

var
  Buff, Hasil : String;
  Parsing: array of string;
  i,k, PosStr, JmlRbh : Integer;
  PosisiCari: Integer;
begin
  try
    Hasil := '';
    try
      //Buff := '#Rp.#EOF#,#.';
      //Buff := '#+22#Rp.#EOF#,#.';
      Buff := StrParsing;
      //
      SetLength(Parsing,JmlHuruf('#',Buff));
      for i := 0 to JmlHuruf('#',Buff)-1 do begin
        Parsing[i] := CopyWord(Buff,i+2,'#');
        if DimulaiDari = '1' then
          Parsing[i] := ReverseString(Parsing[i]);
      end;

      if Copy(Parsing[0],1,2) = '+2' then begin
        //Hilangkan Kode Pertama
        Hasil := UpperCase(Pesan);
        Hasil := StringReplace(Hasil,'[','{',[rfReplaceAll,rfIgnoreCase]);
        Hasil := StringReplace(Hasil,']','}',[rfReplaceAll,rfIgnoreCase]);
        Hasil := StringReplace(Hasil,'#','{',[rfReplaceAll,rfIgnoreCase]);
        PosStr := Pos(Parsing[1],UpperCase(Hasil));
        if PosStr <> 0 then begin
          // Rubah Karakter Pertama dst
          try
            JmlRbh := StrToInt(Copy(Parsing[0],3,MaxInt));
          except
            JmlRbh := 1;
          end;
          for k := 1 to JmlRbh-1 do begin
            Hasil := StringReplace(Hasil,UpperCase(Parsing[1]),#13,[]);
          end;

          // Parsing
          if Pos(UpperCase(Parsing[1]),Hasil) <> 0 then begin
            Hasil := Copy(Hasil,Pos(UpperCase(Parsing[1]),Hasil)+Length(Parsing[1]),Length(Hasil));
            if UpperCase(Parsing[2]) = 'EOF' then
              Hasil := Copy(Hasil,1,Length(Hasil))
            else begin
              if UpperCase(Parsing[1]) = '+D' then begin
                PosisiCari := Pos('0',Hasil);
                if PosisiCari > Pos('1',Hasil) then PosisiCari := Pos('1',Hasil);
                if PosisiCari > Pos('2',Hasil) then PosisiCari := Pos('2',Hasil);
                if PosisiCari > Pos('3',Hasil) then PosisiCari := Pos('3',Hasil);
                if PosisiCari > Pos('4',Hasil) then PosisiCari := Pos('4',Hasil);
                if PosisiCari > Pos('5',Hasil) then PosisiCari := Pos('5',Hasil);
                if PosisiCari > Pos('6',Hasil) then PosisiCari := Pos('6',Hasil);
                if PosisiCari > Pos('7',Hasil) then PosisiCari := Pos('7',Hasil);
                if PosisiCari > Pos('8',Hasil) then PosisiCari := Pos('8',Hasil);
                if PosisiCari > Pos('9',Hasil) then PosisiCari := Pos('9',Hasil);
                if PosisiCari = 0 then
                  Hasil := ''
                else
                  Hasil := Copy(Hasil,1,PosisiCari-1);
              end
              else begin
                if Pos(UpperCase(Parsing[2]),Hasil) <> 0 then
                  Hasil := Copy(Hasil,1,Pos(UpperCase(Parsing[2]),Hasil)-Length(Parsing[2]))
                else
                  Hasil := '';
              end;
            end;
            for i := 3 to JmlHuruf('#',Buff)-1 do begin
              Hasil := StringReplace(Hasil,Parsing[i],'',[rfReplaceAll,rfIgnoreCase]);
            end;

            Hasil := StringReplace(Hasil,#10,'',[rfReplaceAll,rfIgnoreCase]);
            Hasil := StringReplace(Hasil,#13,'',[rfReplaceAll,rfIgnoreCase]);
            Result := Hasil;

            {try
              StrToInt(Hasil);
            except
              Result := '';
              Hasil := '';
            end;}
          end
          else begin
            Result := '';
            Hasil := '';
          end;
        end
        else begin
          Result := '';
          Hasil := '';
        end;
      end
      else begin
        Hasil := UpperCase(Pesan);
        if DimulaiDari = '1' then
          Hasil := ReverseString(Hasil);
        Hasil := StringReplace(Hasil,'[','{',[rfReplaceAll,rfIgnoreCase]);
        Hasil := StringReplace(Hasil,']','}',[rfReplaceAll,rfIgnoreCase]);
        Hasil := StringReplace(Hasil,'#','{',[rfReplaceAll,rfIgnoreCase]);
        PosisiCari := Pos(UpperCase(Parsing[0]),Hasil);
        //Buff := IntToStr(PosisiCari); 
        if PosisiCari <> 0 then begin
          Hasil := Copy(Hasil,PosisiCari+Length(Parsing[0]),Length(Hasil));
          if UpperCase(Parsing[1]) = 'EOF' then
            Hasil := Copy(Hasil,1,Length(Hasil))
          else begin
            if UpperCase(Parsing[1]) = '+D' then begin
              PosisiCari := Pos('0',Hasil);
              if PosisiCari > Pos('1',Hasil) then PosisiCari := Pos('1',Hasil);
              if PosisiCari > Pos('2',Hasil) then PosisiCari := Pos('2',Hasil);
              if PosisiCari > Pos('3',Hasil) then PosisiCari := Pos('3',Hasil);
              if PosisiCari > Pos('4',Hasil) then PosisiCari := Pos('4',Hasil);
              if PosisiCari > Pos('5',Hasil) then PosisiCari := Pos('5',Hasil);
              if PosisiCari > Pos('6',Hasil) then PosisiCari := Pos('6',Hasil);
              if PosisiCari > Pos('7',Hasil) then PosisiCari := Pos('7',Hasil);
              if PosisiCari > Pos('8',Hasil) then PosisiCari := Pos('8',Hasil);
              if PosisiCari > Pos('9',Hasil) then PosisiCari := Pos('9',Hasil);
              if PosisiCari = 0 then
                Hasil := ''
              else
                Hasil := Copy(Hasil,1,PosisiCari-1);   
            end
            else begin
              PosisiCari := Pos(UpperCase(Parsing[1]),Hasil);
              if PosisiCari <> 0 then
                //Hasil := Copy(Hasil,1,PosisiCari-Length(Parsing[1]))
                Hasil := Copy(Hasil,1,PosisiCari-1)
              else
                Hasil := '';
            end;
          end;
          for i := 2 to JmlHuruf('#',Buff)-1 do begin
            Hasil := StringReplace(Hasil,Parsing[i],'',[rfReplaceAll,rfIgnoreCase]);
          end;

          Hasil := StringReplace(Hasil,#10,'',[rfReplaceAll,rfIgnoreCase]);
          Hasil := StringReplace(Hasil,#13,'',[rfReplaceAll,rfIgnoreCase]);
          if DimulaiDari = '1' then
            Hasil := ReverseString(Hasil);
          Result := Hasil;

          {try
            StrToInt(Hasil);
          except
            Result := '';
            Hasil := '';
          end;}
        end
        else begin
          Result := '';
          Hasil := '';
        end;
      end;
    except
      Result := '';
      Hasil := '';
    end;
  finally
  end;

  Result := Trim(Result);
end;

procedure Delay(MSecs: Integer) ;
var
  FirstTickCount: DWORD;
begin
  FirstTickCount := GetTickCount;
  repeat
    Sleep(1) ;
    Application.ProcessMessages;
  until ((GetTickCount - FirstTickCount) >= dword(MSecs)) ;
end;

procedure SetPort(address, Value: Word) ;
var
   bValue: Byte;
begin
   bValue := trunc(Value and 255) ;
   asm
     mov dx, address
     mov al, bValue
     out dx, al
   end;
end;

function GetPort(address: Word): Word;
var
   bValue: Byte;
begin
   asm
     mov dx, address
     in al, dx
     mov bValue, al
   end;
   GetPort := bValue;
end;

procedure Sound(aFreq, aDelay: Integer) ;

   procedure DoSound(Freq: Word) ;
   var
     B: Byte;
   begin
     if Freq > 18 then
     begin
       Freq := Word(1193181 div Longint(Freq)) ;
       B := Byte(GetPort($61)) ;

       if (B and 3) = 0 then
       begin
         SetPort($61, Word(B or 3)) ;
         SetPort($43, $B6) ;
       end;

       SetPort($42, Freq) ;
       SetPort($42, Freq shr 8) ;
     end;
   end;

   procedure Delay(MSecs: Integer) ;
   var
     FirstTickCount: Dword;
   begin
     FirstTickCount := GetTickCount;
     repeat
       //Sleep(1) ;
       //or use
       Application.ProcessMessages;// instead;// of Sleep
     until ((GetTickCount - FirstTickCount) >= DWord(MSecs)) ;
   end;

begin
   if Win32Platform = VER_PLATFORM_WIN32_NT then
   begin
     Windows.Beep(aFreq, aDelay) ;
   end
   else
   begin
     DoSound(aFreq) ;
     //Delay(aDelay) ;
   end;
end;

procedure NoSound;
var
   Value: Word;
begin
   if not (Win32Platform = VER_PLATFORM_WIN32_NT) then
   begin
     Value := GetPort($61) and $FC;
     SetPort($61, Value) ;
   end;
end;

function RandomString(MaxStr: Integer) : string;
const
  Chars = '1234567890ABCDEFGHJKLMNPQRSTUVWXYZ';
var
  S: string;
  i, N: integer;
begin
  Randomize;
  S := '';
  for i := 1 to MaxStr do begin   {... menampilkan 6 digit character...}
    N := Random(Length(Chars)) + 1;
    S := S + Chars[N];
  end;
  Result := S;
end;

end.
