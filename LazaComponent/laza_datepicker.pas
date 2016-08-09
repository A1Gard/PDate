{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit laza_datepicker;

interface

uses
  EditExPersianDate, PDate, uClr, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('EditExPersianDate', @EditExPersianDate.Register);
end;

initialization
  RegisterPackage('laza_datepicker', @Register);
end.
