unit EditEx;
(**
 * @name : PDate Delphi componenet
 * @programmer : A1Gard
 * @time :  12 Aug 2015
 * update : 12 Aug 2015
 * @vertion : 1.0
 *)
interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.StdCtrls;

type
  TEditExPersianDate = class(TEdit)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
    function DatePicker():TDateTime; overload;
    function DatePicker(Datex:TDateTime):TDateTime;overload;
    constructor Create(AOwner: TComponent); override;
  published
    { Published declarations }
  end;

procedure Register;

implementation

uses uCldr, PDate;

// edit some date
constructor TEditExPersianDate.Create(AOwner: TComponent);
begin
  inherited;
  ReadOnly := True;
  Alignment := taCenter ;
end;

procedure Register;
begin
  RegisterComponents('Standard', [TEditExPersianDate]);
end;

// date picker without time show today
function TEditExPersianDate.DatePicker():TDateTime;
begin
  // creat clander foem
  frmCldr := TfrmCldr.Create(Self);
  // set today
  frmCldr.SelectedDate := Now;
  // show clander
  frmCldr.ShowModal;
  Result := frmCldr.SelectedDate;
  // update edit
  if Result = 0 then
  begin
    Clear;
  end
  else
  begin
    Text := GerToPersian(Result);
  end;
  frmCldr.Free
end;

function TEditExPersianDate.DatePicker(Datex:TDateTime):TDateTime;
begin
  // creat clander foem
  frmCldr := TfrmCldr.Create(Self);
  // set inserted date
  frmCldr.SelectedDate := Datex;
  // show clander
  frmCldr.ShowModal;
  Result := frmCldr.SelectedDate;
  // update edit
  if Result = 0 then
  begin
    Clear;
  end
  else
  begin
    Text := GerToPersian(Result);
  end;
  frmCldr.Free
end;

end.
