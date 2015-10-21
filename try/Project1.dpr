program Project1;

uses
  SysUtils;

{$APPTYPE CONSOLE}
var x: TDateTime;
begin
  {ShortDateFormat:='dd/mm/yyyy';}

  try x:=StrToDateTime('23/2');
  except
    writeln('loi');
  end;
  writeln(DateTimeToStr(x));
  readln;
end.
