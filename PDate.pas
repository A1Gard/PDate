unit PDate;
(**
 * @name : PDate
 * @programmer : A1Gard
 * @time :  6 Agu 2011
 * @vertion : 1.1
 *)

interface

uses
   SysUtils,ShlObj,ComObj,ActiveX,Windows ;

function PersiantoGer(PersianD: ShortString; ResultKind: Byte = 0): ShortString;
function GerToPersian(tt:tdatetime):String;
function UIntToDateTime (const Number : UInt64 ):TDateTime ;
function GerToWord (const Date : string  ) : LongWord;
function PersianToInt (const DateSTr : string ) :Int64 ;


implementation

(**
 * @todo: convert Persian date to Gregorian date
 * @param (shortstring) PersianD the string of persian date exp : 1391/12/07
 * @param (byte) what is format of result
 * @result (string) Gregorian date
 **)
function PersiantoGer(PersianD: ShortString; ResultKind: Byte = 0): ShortString;

  function TrueTo1(co: Boolean): Integer;
  begin
    if co then TrueTo1 := 1
    else
      TrueTo1 := 0;
  end;

const
  Conm_mons: array[0..11] of Byte = (31,28,31,30,31,30,31,31,30,31,30,31);
  monthes: array[0..11] of ShortString = ('Jan', 'Feb', 'Mar', 'Apr',
    'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec');
type
  date = record
    da_day, da_mon, da_year: Integer;
  end;
var
  m_mons: array[0..11] of BYTE;
  LeapYearSh: array[0..1000] of UInt16 ;
  LeapYearMi: array[0..1000] of UInt16 ;
  LastDayCountSh, LastDayCountMi: integer;
  a, b: date;
  sYY, sMM, sDD: ShortString;
  I: Integer;
begin
  for i := 0 to 999 do
	begin
    LeapYearSh[i] := (i * 4) + 1275 ;
    LeapYearMi[i] := (i * 4) + 1896 ;
	end;
  for I := Low(Conm_mons) to High(Conm_mons) do
    m_mons[I] := Conm_mons[I];
  a.da_day  := StrToInt(Copy(PersianD, 9, 2));
  a.da_mon  := StrToInt(Copy(PersianD, 6, 2));
  a.da_year := StrToInt(Copy(PersianD, 1, 4));
  b.da_year := a.da_year + 621;
  Inc(b.da_year, TrueTo1(((a.da_mon > 10) or ((a.da_mon = 10) and (a.da_day >= 12)))
    or ((LeapYearSh[(a.da_year - 1275) div 4] <> a.da_year) and
    ((a.da_mon = 10) and (a.da_day = 11)))));
  Inc(m_mons[1], TrueTo1(LeapYearMi[(b.da_year - 1896) div 4] = b.da_year));
  if (a.da_mon <= 7) then LastDayCountSh := ((a.da_mon - 1) * 31 + a.da_day)
  else
    LastDayCountSh := (186 + (a.da_mon - 7) * 30 + a.da_day);
  if (b.da_year = (a.da_year + 622)) then LastDayCountMi :=
      LastDayCountSh - 286 - TrueTo1(LeapYearSh[(a.da_year - 1275) div 4] = a.da_year)
  else
    LastDayCountMi := (LastDayCountSh + 79);

  b.da_day := LastDayCountMi;
  b.da_mon := 0;
  while (LastDayCountMi > m_mons[b.da_mon]) do
  begin
    Dec(LastDayCountMi, m_mons[b.da_mon]);
    Inc(b.da_mon);
    b.da_day := LastDayCountMi;
  end;
  Inc(b.da_mon);
  if b.da_year < 1000 then sYY := sYY + '0';
  if b.da_year < 100 then sYY := sYY + '0';
  if b.da_year < 10 then sYY := sYY + '0';
  sYY := sYY + IntToStr(b.da_year);

  if b.da_mon < 10 then sMM := sMM + '0';
  sMM := sMM + IntToStr(b.da_mon);

  if b.da_day < 10 then sDD := sDD + '0';
  sDD := sDD + IntToStr(b.da_day);

  case ResultKind of
    0: Result := sYY + '/' + sMM + '/' + sDD;
    1: Result := sYY + ' ' + monthes[b.da_mon - 1] + ' ' + sDD;
  end;
end;


(**
 * @todo: Gregorian to Persian Date
 * @param (TDateTime|float) standrad windows datetime format
 * @result (string) persian date by this format exp : 1367/04/19
 **)
function GerToPersian(tt:TDateTime):String;
var
  str,y,m,d:string;
  yi,mi,di,ytmp:integer;
begin
  str:=formatdatetime('yyyy,mm,dd',tt);
  y:=copy(str,1,4);
  m:=copy(str,6,2);
  d:=copy(str,9,2);
  yi:=strtoint(y);
  mi:=strtoint(m);
  di:=strtoint(d);
  if (yi mod 4=0) then
  if mi>2 then
  begin
    tt:=tt+1;
    str:=formatdatetime('yyyy,mm,dd',tt);
    y:=copy(str,1,4);
    m:=copy(str,6,2);
    d:=copy(str,9,2);
    yi:=strtoint(y);
    mi:=strtoint(m);
    di:=strtoint(d);
  end;
  if ((mi<3) or ((mi=3) and (di<21))) then
  begin
   yi:=yi-622;
  end
  else
  begin
    yi:=yi-621;
  end;
  case mi of
    1:

    if di<21 then
    begin
      mi:=10;
      di:=di+10;
    end
    else
    begin
      mi:=11;
      di:=di-20;
    end;

    2:
    if di<20 then
    begin
      mi:=11;
      di:=di+11;
    end
    else
    begin
      mi:=12;
      di:=di-19;
    end;
    3:
    if di<21 then
    begin
      mi:=12;
      di:=di+9;
    end
    else
    begin
      mi:=1;
      di:=di-20;
    end;
    4:
    if di<21 then
    begin
      mi:=1;
      di:=di+11;
    end
    else
    begin
      mi:=2;
      di:=di-20;
    end;
    5:
    if di<22 then
    begin
      mi:=mi-3;
      di:=di+10;
    end
    else
    begin
      mi:=mi-2;
      di:=di-21;
    end;
    6:
    if di<22 then
    begin
      mi:=mi-3;
      di:=di+10;
    end
    else
    begin
      mi:=mi-2;
      di:=di-21;
    end;
    7:
    if di<23 then
    begin
      mi:=mi-3;
      di:=di+9;
    end
    else
    begin
      mi:=mi-2;
      di:=di-22;
    end;
    8:
    if di<23 then
    begin
      mi:=mi-3;
      di:=di+9;
    end
    else
    begin
      mi:=mi-2;
      di:=di-22;
    end;
    9:
    if di<23 then
    begin
      mi:=mi-3;
      di:=di+9;
    end
    else
    begin
      mi:=mi-2;
      di:=di-22;
    end;
    10:
    if di<23 then
    begin
      mi:=7;
      di:=di+8;
    end
    else
    begin
      mi:=8;
      di:=di-22;
    end;
    11:
    if di<22 then
    begin
      mi:=mi-3;
      di:=di+9;
    end
    else
    begin
      mi:=mi-2;
      di:=di-21;
    end;
    12:
    if di<22 then
    begin
      mi:=mi-3;
      di:=di+9;
    end
    else
    begin
      mi:=mi-2;
      di:=di-21;
    end;
  end;
  ytmp := yi - 1279 ;
  ytmp := ytmp mod 4 ;
  if (mi = 12) and (ytmp=0 )then
  begin
    Inc(di);
  end;
  y:=inttostr(yi);
  m:=inttostr(mi);
  if (length(m)=1) then
    m:='0'+m;
  d:=inttostr(di);
  if length(d)=1 then
    d:='0'+d;
  Result :=y+'/'+m+'/'+d ;
end;

 (**
  * @todo: timpsamp to windows standard DateTime
  * @param (unsigned int64) timestamp for convert
  * @result (TDateTime|float)
  **)
function UIntToDateTime (const Number : UInt64 ):TDateTime ;
begin
  Result := (Number / 100000);
end;


 (**
  * @todo: Gregorian date to timestamp
  * @param (string) input for convert
  * @result (LongWord)
  **)
function GerToWord (const Date : string  ) : LongWord;
var   dy : Word;
      dm,dd : Byte;
begin
  dy := StrToIntDef(Copy(Date,1,4),2000);
  dm := StrToIntDef(Copy(Date,6,2),0);
  if (dm = 0) or (dm > 12) then
  begin
    Result := 0 ;
    Exit;
  end;
  dd := StrToIntDef(Copy(Date,9,2),0);
  if (dd = 0) or (dd > 31) then
  begin
    Result := 0 ;
    Exit;
  end;
  Result := Round(EncodeDate(dy,dm,dd));
end;

 (**
  * @todo: Persian date to timestamp
  * @param (string) input for convert
  * @result (Int64)
  **)
function PersianToInt (const DateSTr:string): Int64 ;
var diy,dim,did: Integer ;
i1,i2,i3,itotal : Int64;
begin
  diy := StrToIntDef(Copy(DateSTr,1,4),0);
  dim := StrToIntDef(Copy(DateSTr,6,2),0);
  did := StrToIntDef(Copy(DateSTr,9,2),0);

  i1 := diy - 1279 ;

  Inc(i1);



  itotal := i1 * 365 ;

  i2 := i1 div 4 ; // + days ;


  case dim of
    1:  i1 := 0  ;
    2:  i1 := 31  ;
    3:  i1 := 62  ;
    4:  i1 := 93  ;
    5:  i1 := 124  ;
    6:  i1 := 155 ;
    7:  i1 := 186 ;
    8:  i1 := 216 ;
    9:  i1 := 246 ;
    10: i1 := 276 ;
    11: i1 := 306 ;
    12: i1 := 336 ;
  end;

  //Dec(did);

  i3 := (i1 + did + i2)-285;

  if itotal > 0 then
  begin
    itotal := itotal + i3 ;
  end
  else
  begin
    itotal := itotal - i3 ;
  end;
  Result := itotal ;
end;



end.
