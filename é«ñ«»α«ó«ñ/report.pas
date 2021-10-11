unit report;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, Grids;

type
  TForm2 = class(TForm)
    StringGrid1: TStringGrid;
    PopupMenu1: TPopupMenu;
    Refresh1: TMenuItem;
    procedure Refresh1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

uses UMain;

{$R *.dfm}

procedure TForm2.Refresh1Click(Sender: TObject);
var
  a, b : Integer;
begin
  for a := 0 to 10 do begin
    for b := 0 to 10 do begin
      if UMain.Pole[a, b] then
        stringgrid1.Cells[a, b] := 's';
    end;
  end;
end;

end.
