unit uCldr;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Grids, Vcl.StdCtrls,
  Vcl.Samples.Spin, System.Math;

type
  TfrmCldr = class(TForm)
    pnlTop: TPanel;
    sgCldr: TStringGrid;
    btnNext: TButton;
    cbbMonth: TComboBox;
    btnPrv: TButton;
    seYear: TSpinEdit;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure sgCldrDblClick(Sender: TObject);
    procedure cbbMonthChange(Sender: TObject);
    procedure seYearChange(Sender: TObject);
    procedure btnPrvClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure sgCldrKeyPress(Sender: TObject; var Key: Char);
    procedure sgCldrDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
  private
    { Private declarations }
    function GetCurrentDate(): TDateTime;
    function ShowMonth(nn: TDateTime): boolean;
  const
    // small day name
     dayz : array[0..6] of WideChar = ('ش','ی','د','س','چ','پ','ج');
  public
    { public declarations }
    SelectedDate: TDateTime;

  end;

var
  frmCldr: TfrmCldr;
  // col and row for hilight today
  iToday,jToday : Integer;
implementation

{$R *.dfm}

uses PDate;


// show month by inputy date in calnader
function TfrmCldr.ShowMonth(nn: TDateTime): boolean;
var
  b, r: byte;
  f, l, dif, i: integer;
  isThisMonth : Boolean;
  sender: TObject;
begin
  // find today in this month
  if ( GetTheFirstDayOfThisMonth(now) < Now) and (GetTheLastDayOfThisMonth(Now) > Now ) then
  begin
    isThisMonth := True;
  end
  else
  begin
    isThisMonth := False;
  end;
  // reset
  for i := 0 to sgCldr.RowCount - 1 do
    sgCldr.Rows[i].Clear;
  // show date week name
  for I := 0 to 6 do
      sgCldr.Cells[i, 0] := dayz[i];
  // set correct month to combobox
  cbbMonth.ItemIndex := StrToInt(Copy(GerToPersian(nn), 6, 2)) - 1;
  // set correct year to spinedit
  seYear.Value := StrToInt(Copy(GerToPersian(nn), 1, 4));
  // for find diffrent berween first and last day of month
  f := floor(GetTheFirstDayOfThisMonth(nn));
  l := floor(GetTheLastDayOfThisMonth(nn));
  dif := l - f;
  r := 1;
  // reset today hilight
  iToday := 99;
  jToday := 99 ;
  // draw all month day in string grid
  for i := 0 to dif do
  begin
    // find the col for draw
    b := GetPersianDayWeek(i + f) - 1;
    // daw
    sgCldr.Cells[b, r] := IntToStr(i + 1);
    // if today is set hilight location
    if (isThisMonth and (i+f = Floor(now))) then
    begin
      iToday :=  r;
      jToday :=  b;
    end;
    // redraw
    sgCldr.Repaint;
    sgCldr.Refresh;
    // reset row
    if b = 6 then
      Inc(r);
  end;
end;



// find current date from clander's elements
function TfrmCldr.GetCurrentDate(): TDateTime;
var
  Fmt: TFormatSettings;
  b: integer;
  m: string;
begin
  // set format
  Fmt.ShortDateFormat := 'yyyy/mm/dd';
  Fmt.DateSeparator := '/';
  Fmt.LongTimeFormat := 'hh:nn:ss';
  Fmt.TimeSeparator := ':';
  b := cbbMonth.ItemIndex + 1;
  if b > 9 then
    m := IntToStr(b)
  else
    m := '0' + IntToStr(b);
  Result := (StrToDateTime(PersiantoGer(seYear.Text + '/' + m + '/1'), Fmt));
end;

procedure TfrmCldr.seYearChange(Sender: TObject);
begin
  ShowMonth(GetCurrentDate());
end;

// select date in clander
procedure TfrmCldr.sgCldrDblClick(Sender: TObject);
var
  Fmt: TFormatSettings;
  b: integer;
  m: string;
begin
  Fmt.ShortDateFormat := 'yyyy/mm/dd';
  Fmt.DateSeparator := '/';
  Fmt.LongTimeFormat := 'hh:nn:ss';
  Fmt.TimeSeparator := ':';
  b := cbbMonth.ItemIndex + 1;
  if b > 9 then
    m := IntToStr(b)
  else
    m := '0' + IntToStr(b);
  if sgCldr.Cells[sgCldr.Col, sgCldr.Row] <> '' then
  begin
    SelectedDate :=
      (StrToDateTime(PersiantoGer(seYear.Text + '/' + m + '/' + sgCldr.Cells
      [sgCldr.Col, sgCldr.Row]), Fmt));;
    Self.Close;
  end;

end;


// draw cell
procedure TfrmCldr.sgCldrDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  if ARow = 0 then
  Exit;
  // draw weekend red
  if (ACol = 6) then
    with TStringGrid(Sender) do
    begin
      //paint the background Green
      Canvas.Font.Color := clRed;
      Canvas.FillRect(Rect);
      Canvas.TextOut(Rect.Left + 16, Rect.Top + 10, Cells[ACol, ARow]);
    end;
  // if today hilight this
  if (ACol = jToday) and (ARow = iToday) then
    with TStringGrid(Sender) do
    begin
      //paint the background Green
      Canvas.Brush.Color := $00ddffdd;
    end;
  TStringGrid(Sender).Canvas.FillRect(Rect);
  TStringGrid(Sender).Canvas.TextOut(Rect.Left + 16, Rect.Top + 10, TStringGrid(Sender).Cells[ACol, ARow]);
end;

// close on escape
procedure TfrmCldr.sgCldrKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
  begin
    SelectedDate := 0;
    Close;
  end;
  //ShowMessage(IntToStr(Ord(Key)));
end;

// go next month
procedure TfrmCldr.btnNextClick(Sender: TObject);
begin
  if cbbMonth.ItemIndex = -1 then
  begin
    Exit;
  end;
  if cbbMonth.ItemIndex = cbbMonth.Items.Count - 1 then
  begin
    cbbMonth.ItemIndex := 0;
    seYear.Value := seYear.Value + 1;
  end
  else
    cbbMonth.ItemIndex := cbbMonth.ItemIndex + 1;
  ShowMonth(GetCurrentDate());
end;

// go prev month
procedure TfrmCldr.btnPrvClick(Sender: TObject);
begin
  if cbbMonth.ItemIndex = -1 then
  begin
    Exit;
  end;
  if cbbMonth.ItemIndex = 0 then
  begin
    cbbMonth.ItemIndex := cbbMonth.Items.Count - 1;
    seYear.Value := seYear.Value - 1;
  end
  else
    cbbMonth.ItemIndex := cbbMonth.ItemIndex - 1;
  ShowMonth(GetCurrentDate());
end;

procedure TfrmCldr.cbbMonthChange(Sender: TObject);
begin
  ShowMonth(GetCurrentDate());
end;

procedure TfrmCldr.FormCreate(Sender: TObject);
begin
  //
end;

// close on escape
procedure TfrmCldr.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
  begin
    SelectedDate := 0;
    Close;
  end;
  //ShowMessage(IntToStr(Ord(Key)));
end;

procedure TfrmCldr.FormShow(Sender: TObject);
begin
  if SelectedDate = 0 then SelectedDate := Now;
  ShowMonth(SelectedDate);
end;

end.
