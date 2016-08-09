unit EditExPersianDate;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, StdCtrls;

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

uses uClr, PDate;

procedure Register;
begin
  {$I editexpersiandate_icon.lrs}
  RegisterComponents('Additional',[TEditExPersianDate]);
end;



// edit some date
constructor TEditExPersianDate.Create(AOwner: TComponent);
begin
  inherited;
  ReadOnly := True;
  Alignment := taCenter ;
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
