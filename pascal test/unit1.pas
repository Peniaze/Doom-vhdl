unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, math;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Image1: TImage;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Image1Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  pangle: double;
  px,py: integer;

implementation


{$R *.lfm}


{ TForm1 }

procedure TForm1.Image1Click(Sender: TObject);
var i, j: integer;

    testposx: double;
    testposy: double;

    distance: integer;
    testangle: double;
    tvectx: double;
    tvecty: double;
    hitwall: boolean;

    map:array [0..49] of array [0..49] of boolean;

begin


     // vytvorenie mapy (50x50) steny na krajoch
     for i:= 0 to 49 do begin
         for j:= 0 to 49 do begin
             if (i<>0) and (i<>49) and (j<>0) and (j<>49) then
               map[i, j]:= false
             else
               map[i, j]:= true;
         end;
     end;

     //raycasting pre kazdy pixel sirky (640)
     for i:= -320 to 320 do
     begin
          testangle := pangle + i*0.5236/320;     //FOV -> 60deg

          //vektor posuvu testovacieho lucu
          tvectx:= sin(testangle);
          tvecty:= cos(testangle);

          //pozicia testovacieho lucu
          testposx:= px;
          testposy:= py;

          hitwall := false;
          distance := 0;


          while (not hitwall) and (distance < 100) do
            begin
                 testposx += tvectx;
                 testposy += tvecty;
                 distance += 1;
                 if map[round(testposx), round(testposy)] then
                    hitwall:= true;
            end;


          if hitwall then begin
            //tienovanie
            image1.canvas.Pen.Color:=$010000*2*distance+$000100*2*distance+$000001*2*distance;

            //kreslenie zvislej ciary pre kazdy pixel sirky
            image1.canvas.MoveTo(i+320,distance*3);
            image1.canvas.LineTo(i+320, 480-distance*3);
          end;






     end;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  image1.canvas.fillrect(clientrect);

  //nastavenie globalnych premennych pri starte
   pangle := 0;
   px := 25;
   py := 25;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
     //posunutie pohladu doprava
     pangle := pangle + 0.2;
     image1.canvas.fillrect(clientrect);
     Image1Click(nil);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
     //posunutie pohladu dolava
     pangle := pangle - 0.2;
     image1.canvas.fillrect(clientrect);
     Image1Click(nil);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
     //pohyb dopredu
      px := round(px + 2*sin(pangle));
      py := round(py + 2*cos(pangle));
      image1.canvas.fillrect(clientrect);
     Image1Click(nil);
end;

end.

