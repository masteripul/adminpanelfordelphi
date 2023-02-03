unit ClassMisc;

interface

function GetLocalIP: string;
function CopyWord(AText: string; WordIndex: integer; ADelimiter: char = ' '): string;
function RemoveTextPart(AText: string; IndexOffset: integer = 1; ADelimiter: char = ' '; NewText: string = ''): string;
function GetTextValue(AText: string; IndexOffset: Integer = 1; ADelimiter: Char = ':'; EndDelimiter: string = #13#10): string;
function GetTextBetween(AText: string; const StartDelimiter, EndDelimiter: string; const TrimResult: Boolean = True; const IndexOffset: Integer = 1): string;
function GetNumericValue(AText: string): Integer;
procedure Delay(const Interval: Cardinal);
function IfThen(AValue: Boolean; const ATrue, AFalse: Variant): Variant; overload;
function GetValueLevel(const MinVal, MaxVal, Level: Integer; const FillWithChar: Char = '|'): string;
function DuplicateString(const AText: string; ACount: Integer; const ADelimiter: string = ''): string;
function MakePrintableText(const AText: string): string;
procedure SleepDelay(const Miliseconds: Cardinal; const IsThreadedProcess: Boolean = False);

implementation

uses Windows, Forms, WinSock, SysUtils, StrUtils;

function GetLocalIP: string;
type
  TPInAddr = array[0..10] of PInAddr;
  PPInAddr = ^TPInAddr;
var
  i: integer;
  HostName: PHostEnt;
  HostAddr: PPInAddr;
  InitData: TWSAData;
  Buffer: array[0..63] of char;
begin
  WSAStartup($101, InitData);
  Result := '';
  GetHostName(Buffer, SizeOf(Buffer));
  HostName := GetHostByName(buffer);
  if HostName = nil then Exit;
  HostAddr := PPInAddr(Hostname^.h_addr_list);
  i := 0;
  while HostAddr^[i] <> nil do
  begin
    Result := inet_ntoa(HostAddr^[i]^);
    Inc(i);
  end;
  WSACleanup;
end;

function CopyWord(AText: string; WordIndex: integer; ADelimiter: char = ' '): string;
var
  c, len, pStart, pEnd: integer;
begin
  Result := '';
  
  // remove trailing delimiter
  AText := Trim(AText);
  len := Length(AText);
  if AText[len] = ADelimiter then
    AText := Copy(AText, 1, len-1);

  // reject wrong parameter
  if AText = '' then Exit;
  if WordIndex < 1 then Exit;

  // count delimiters
  c := 1;
  pStart := 1;
  //len := Length(AText);
  pEnd := PosEx(ADelimiter, AText, pStart);
  if pEnd = 0 then pEnd := len;

  // iterate words
  while pEnd > 0 do begin
    // word index reached
    if c = WordIndex then begin
      if pEnd = len then  Result := Copy(AText, pStart, pEnd-pStart+1)
      else Result := Copy(AText, pStart, pEnd-pStart);
      Exit;
    end;

    // next word
    c := c + 1;
    pStart := pEnd+1;
    pEnd := PosEx(ADelimiter, AText, pEnd+1);

    // next delimiter is not found, then end limit is end of text
    if pEnd = 0 then pEnd := len;
  end;
end;

function RemoveTextPart(AText: string; IndexOffset: integer = 1; ADelimiter: char = ' '; NewText: string = ''): string;
var
  pStart, pEnd: integer;
begin
  pStart := PosEx(ADelimiter, AText, IndexOffset);
  pEnd := PosEx(ADelimiter, AText, pStart+1);
  Delete(AText, pStart, pEnd-pStart+1);

  if NewText <> '' then
    Insert(NewText, AText, pStart);

  Result := AText;
end;

//+DATA:123123,
function GetTextValue(AText: string; IndexOffset: Integer = 1; ADelimiter: Char = ':'; EndDelimiter: string = #13#10): string;
var CPos: Integer;
begin
  Result:= '';
  if IndexOffset < 1 then Exit;

  // delete text after <cr><lf>
  Delete(AText, PosEx(EndDelimiter, AText, IndexOffset), MaxInt);

  CPos:= PosEx(ADelimiter, AText, IndexOffset) + 1;
  if CPos = 0 then Exit;

  Result:= TrimLeft(Copy(AText, CPos, MaxInt));
end;

//+DATA:#13#10TEXT_DATA#13#10
// revision of GetTextValue
function GetTextBetween(AText: string; const StartDelimiter, EndDelimiter: string; const TrimResult: Boolean = True; const IndexOffset: Integer = 1): string;
var DelPos1, DelPos2: Integer;
begin
  Result:= '';
  if StartDelimiter <> '' then
    DelPos1:= PosEx(StartDelimiter, AText, IndexOffset) + Length(StartDelimiter)
  else DelPos1:= 1;

  if DelPos1 = 0 then Exit;
  DelPos2:= PosEx(EndDelimiter, AText, DelPos1 + 1);

  if DelPos2 = 0 then DelPos2:= MaxInt
  else DelPos2:= DelPos2 - DelPos1;

  Result:= Copy(AText, DelPos1, DelPos2);
  if TrimResult then Result:= Trim(Result);
end;

procedure Delay(const Interval: Cardinal);
var Ref: DWord;
begin
  Ref:= GetTickCount + Interval;
  while GetTickCount < Ref do Application.ProcessMessages;
end;

function GetNumericValue(AText: string): Integer;
var S: string;
    L: Integer;
    C: Char;
begin
  S:= '';
  L:= Length(AText);
  for Result:= 1 to L do begin
    C:= AText[Result];
    if C in ['0'..'9'] then S:= S + C;
  end;
  Result:= StrToIntDef(S, 0);   
end;

function IfThen(AValue: Boolean; const ATrue, AFalse: Variant): Variant;
begin
  if AValue then Result:= ATrue
  else Result:= AFalse;
end;

function GetValueLevel(const MinVal, MaxVal, Level: Integer; const FillWithChar: Char = '|'): string;
begin
  //Result:= StringOfChar(FillWithChar, Level);
  Result:= StringOfChar('', Level);
  Result:= Result + StringOfChar('-', (MaxVal - MinVal) - Level);
end;

function DuplicateString(const AText: string; ACount: Integer; const ADelimiter: string = ''): string;
var P: PChar;
    C, L: Integer;
begin
  C:= Length(AText);

  L:= C * ACount;                                             // dont include last delimiter
  if ADelimiter <> '' then L:= L + (Length(ADelimiter) * (ACount - 1));

  SetLength(Result, L);

  L:= Length(ADelimiter);

  P := Pointer(Result);
  if P = nil then Exit;
  while ACount > 0 do begin
    // copy AText
    Move(Pointer(AText)^, P^, C);
    Inc(P, C);

    Dec(ACount);

    if (L > 0) and (ACount > 0) then begin
      // add delimiter
      Move(Pointer(ADelimiter)^, P^, L);
      Inc(P, L);
    end;
  end;
end;

function MakePrintableText(const AText: string): string;
var P, S: PChar;
    L, C: Integer;
begin
  L:= Length(AText);
  SetLength(Result, L);

  P:= Pointer(Result);
  if (L = 0) or (P = nil) then begin
    Result:= AText;
    Exit;
  end;

  S:= Pointer(AText);

  C:= 0;
  while L >= 0 do begin
    // copy AText
    if S^ in [#32..#127] then begin
      Move(S^, P^, 1);
      Inc(P, 1);
      Inc(C);
    end;

    Inc(S);
    Dec(L);
  end;

  SetLength(Result, C);
  Result:= TrimRight(Result);
end;

procedure SleepDelay(const Miliseconds: Cardinal; const IsThreadedProcess: Boolean = False);

  function PercentValue(const Value: Cardinal; const Percent: Byte): Cardinal;
  begin
    Result:= Trunc(Value * (Percent / 100));
  end;

begin
  Sleep(Miliseconds);

{  if Miliseconds > 1 then begin
    Delay(PercentValue(Miliseconds, 35));   // 35 percent for delay
    Sleep(PercentValue(Miliseconds, 65));   // 65 percent for sleep
  end else begin
    Application.ProcessMessages;
    Sleep(Miliseconds);
  end;}
end;

end.
