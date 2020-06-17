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

const mapsize = 99;

var

  Form1: TForm1;
  pangle: double;
  px,py: integer;
  map:array [0..mapsize] of array [0..mapsize] of boolean;

implementation



{$R *.lfm}


{ TForm1 }
procedure loadmap;
var
  MyBitmap: TBitmap;
   i, j: integer;
begin
  MyBitmap := TBitmap.Create;
  try
    // Load from disk
    MyBitmap.LoadFromFile('map.bmp');

    // Here you can use MyBitmap.Canvas to read/write to/from the image

    for i:=0 to mapsize do
    begin
        for j:= 0 to mapsize do
        begin
            if (mybitmap.Canvas.Pixels[i,j] = $000000) then
               map[i,j]:= true;
        end;
    end;


  finally
    MyBitmap.Free;
  end;
end;



procedure TForm1.Image1Click(Sender: TObject);
var i, j: integer;

    testposx: double;
    testposy: double;

    distance: double;
    int_distance: integer;
    testangle: double;
    tvectx: double;
    tvecty: double;
    vec_length: double;
    hitwall: boolean;

begin

     loadmap;

     //raycasting pre kazdy pixel sirky (640)
     for i:= -320 to 320 do
     begin
          testangle := pangle + i*0.2618/320;     //FOV -> 30deg

          //vektor posuvu testovacieho lucu
          tvectx:= sin(testangle);
          tvecty:= cos(testangle);
	  vec_length:= sqrt(tvectx*tvectx+tvecty*tvecty);

          //pozicia testovacieho lucu
          testposx:= px;
          testposy:= py;

          hitwall := false;
          distance := 0;
	  int_distance:= 0;


          while (not hitwall) and (distance < 1000) do
            begin
                 testposx += tvectx;
                 testposy += tvecty;
                 distance += vec_length;
                 if map[round(testposx), round(testposy)] then
                    hitwall:= true;
            end;

	    int_distance:= round(distance);

          if hitwall then begin
            //tienovanie
            image1.canvas.Pen.Color:=$8F0000-$010000*int_distance+$008F00-$000100*int_distance+$00008F-$000001*int_distance;

            //kreslenie zvislej ciary pre kazdy pixel sirky
            image1.canvas.MoveTo(i+320,int_distance);
            image1.canvas.LineTo(i+320, 480-int_distance);
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

