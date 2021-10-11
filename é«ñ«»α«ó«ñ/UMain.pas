{
*************************
* Игра                  *
*         "Водопровод"  *
*************************
* Разработчик:          *
*      Карпов Максим    *
*************************
}

unit UMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Registry, ComCtrls;

type
  TMain = record
    Start : TPoint;
    Finish : TPoint;
  end;
  TForm1 = class(TForm)
    POLE: TImage;
    START: TButton;
    PIPES: TImage;
    NEXT: TImage;
    BEVEL: TBevel;
    MAINPIPES: TImage;
    LoadTimer: TTimer;
    Label1: TLabel;
    LEVEL: TLabel;
    Label3: TLabel;
    PROGRESS: TProgressBar;
    TimeLabel: TLabel;
    Timer1: TTimer;
    Label4: TLabel;
    procedure SetPipe(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure NewPipe;
    procedure FormCreate(Sender: TObject);
    function CheckOut : Boolean;
    procedure STARTClick(Sender: TObject);
    function LoadLevel(number : Integer) : Boolean;
    procedure DrawMP;
    procedure LoadTimerTimer(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
  Water : TColor = $00B000;

var
  Form1: TForm1;
  VPole: array [1..10, 1..10] of Boolean;
  MP : TMain;
  CurrentLevel : Integer = 1;
  Time    : Integer;
implementation

{$R *.dfm}

procedure TForm1.DrawMP;
begin
  //Очистка от труб
  POLE.Canvas.Brush.Color := clBlack;
  POLE.Canvas.Rectangle(0,0,320, 320);
  //Рисуем старт
  Pole.Canvas.CopyRect(Rect(MP.Start.X * 32, MP.Start.Y * 32, (MP.Start.X + 1) * 32, (MP.Start.Y + 1) * 32), MAINPIPES.Canvas, Rect(0, 0, 32, 32));
  //Рисуем финиш
  Pole.Canvas.CopyRect(Rect(MP.Finish.X * 32, MP.Finish.Y * 32, (MP.Finish.X + 1) * 32, (MP.Finish.Y + 1) * 32), MAINPIPES.Canvas, Rect(33, 0, 64, 32));
end;

function TForm1.LoadLevel(number : Integer) : Boolean;
var REG : TRegistry;
begin
  result := true;
  REG := TRegistry.Create;
  REG.RootKey := HKEY_LOCAL_MACHINE;
  REG.OpenKey('SOFTWARE\Vodoprovod', false);

  If REG.CurrentPath = '' then begin
    Application.Terminate;
    Abort;
  end;

  If REG.ReadInteger('Levels') < number then begin
    result := false;
    exit;
  end;

  Reg.OpenKey('Level' + IntToStr(number), false);

  If Reg.CurrentPath = 'Vodoprovod' then begin
    Application.Terminate;
    Abort;
  end;

  MP.Start.X := Reg.ReadInteger('StartX');
  MP.Start.Y := Reg.ReadInteger('StartY');

  MP.Finish.X := Reg.ReadInteger('FinishX');
  MP.Finish.Y := Reg.ReadInteger('FinishY');

  Time := Reg.ReadInteger('Time');
  PROGRESS.Max := Time;
  PROGRESS.Position := Time;

  DrawMP;
end;


function TForm1.CheckOut : Boolean;
var a, b : Integer;
    waterout, onfinish : Boolean;
begin
  onfinish := false;
  waterout := false;
  //Проверка, вылилась ли вода.
  for a := 1 to 10 do begin
    for b := 1  to 10 do begin
      If ((a = MP.Start.X + 1) and (b = MP.Start.Y + 1)) or
         ((a = MP.Finish.X + 1) and (b = MP.Finish.Y + 1)) then continue;
      If (VPole[a, b] = false) and (POLE.Canvas.Pixels[a*32-16, b*32-16] = Water)then
        waterout := true;
    end;
  end;

  //Проверка, досигла ли она финиша
  If POLE.Canvas.Pixels[MP.Finish.X*32-16, MP.Finish.Y*32-16] = Water
    then onfinish := true;

  result := (not waterout) and onfinish;
end;


procedure TForm1.SetPipe(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var XClick, YClick : Integer;
begin
  XClick := X div 32;
  YClick := Y div 32;

  //Проверка, не является ли точка стартом или финишом
  If ((XClick = MP.Start.X) and (YClick = MP.Start.Y)) or ((XClick = MP.Finish.X) and (YClick = MP.Finish.Y)) then exit;

  VPole[XClick + 1, YClick + 1] := true;
  Pole.Canvas.CopyRect(Rect(XClick * 32, YClick * 32, (XClick + 1) * 32, (YClick + 1) * 32), NEXT.Canvas, Rect(0, 0, 32, 32));

  NewPipe;
end;

procedure TForm1.NewPipe;
var num : integer;
begin
  num := Random(6);
  NEXT.Canvas.CopyRect(Rect(0, 0, 32, 32), PIPES.Canvas, Rect(num * 32, 0, (num + 1) * 32, 32));
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Randomize;
  NewPipe;
  LoadLevel(1);
end;

procedure TForm1.STARTClick(Sender: TObject);
begin
  POLE.Canvas.Brush.Color := Water;
  POLE.Canvas.FloodFill((MP.Start.X+1)*32-16, (MP.Start.Y+1)*32-16, clBlack, fsSurface);
  If not CheckOut then begin
    ShowMessage('Вы проиграли!');
    CurrentLevel := 0;
  end;
  LoadTimer.Enabled := true;
end;

procedure TForm1.LoadTimerTimer(Sender: TObject);
begin
  LoadTimer.Enabled := false;
    CurrentLevel := CurrentLevel+1;
  If not LoadLevel(CurrentLevel) then begin
    ShowMessage('Вы выиграли');
    START.Enabled := false;
    Timer1.Enabled := false;
  end;
  LEVEL.Caption := 'Уровень: ' + IntToStr(CurrentLevel);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Time := Time - 1;
  TimeLabel.Caption := IntToStr(Time div 60) + ':' + IntToStr(Time mod 60);
  If Time = 0 then START.Click;
  PROGRESS.Position := TIME;
end;

end.
