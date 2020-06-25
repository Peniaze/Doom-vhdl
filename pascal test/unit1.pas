unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, LCLType;

type


  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Edit1: TEdit;
    Image1: TImage;
    Image2: TImage;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Image1Click(Sender: TObject);
  private

  public

  end;

const mapsize = 19;

var

  Form1: TForm1;
  pangle: double;

  // Suradnice px,py .... od 0 do 500 (mapa 20x20),
  // pre zmenu riadok 128 --> max(testposx)/[x] = mapsize,
  // ovplyvnuje to aj detail pocitania vzdialenosti lucov (mozno bude treba zmensit)
  // suvisi aj riadok 134 --> vacsie suradnice = vacsia vzdialenost
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
  MyBitmap := TBitmap.Create();
  try
    // Load from disk
    MyBitmap.LoadFromFile('map2.bmp');

    // Here you can use MyBitmap.Canvas to read/write to/from the image

    for i:=0 to mapsize do
    begin
        for j:= 0 to mapsize do
        begin
            if (mybitmap.Canvas.Pixels[i,j] = $000000) then
               map[i,j]:= true;
        end;
    end;
    Form1.image2.Canvas.StretchDraw(form1.Image2.ClientRect,mybitmap);


  finally
    MyBitmap.Free;
  end;
end;



procedure TForm1.Image1Click(Sender: TObject);
var i: integer;

    testposx: double;
    testposy: double;

    distance: double;
    height_ceiling: integer;
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
          testangle := pangle + i*0.5236/320;     //FOV -> 60deg

          //vektor posuvu testovacieho lucu
          tvectx:= sin(testangle)/10;
          tvecty:= cos(testangle)/10;
	  vec_length:= sqrt(tvectx*tvectx+tvecty*tvecty);

          //pozicia testovacieho lucu
          testposx:= px;
          testposy:= py;

          hitwall := false;
          distance := 0;
	  height_ceiling:= 0;


          while (not hitwall) and (distance < 1000) do
            begin
                 testposx += tvectx;
                 testposy += tvecty;
                 distance += vec_length;
                 if map[round(testposx/25), round(testposy/25)] then
                    hitwall:= true;
            end;

	    height_ceiling:= round(240-10000/distance);
            if height_ceiling<0 then height_ceiling:=0;

          if hitwall then begin
            //tienovanie
            image1.canvas.Pen.Color:=$AF0000-$010000*height_ceiling+$00AF00-$000100*height_ceiling+$0000AF-$000001*height_ceiling;

            //kreslenie zvislej ciary pre kazdy pixel sirky
            image1.canvas.MoveTo(i+320,height_ceiling);
            image1.canvas.LineTo(i+320, 480-height_ceiling);
          end;






     end;

end;





procedure TForm1.FormCreate(Sender: TObject);
begin
  image1.canvas.fillrect(clientrect);

  //nastavenie globalnych premennych pri starte
   pangle := 0;
   px := 250;
   py := 250;
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

procedure TForm1.Edit1Change(Sender: TObject);
begin
     if edit1.Text = 'w' then
     begin
    px := round(px + sin(pangle)*5);
    py := round(py + cos(pangle)*5);
    image1.canvas.fillrect(clientrect);
    Image1Click(nil);
    end;
     if edit1.Text = 's' then
     begin
    px := round(px - sin(pangle));
    py := round(py - cos(pangle));
    image1.canvas.fillrect(clientrect);
    Image1Click(nil);
    end;
     if edit1.Text = 'a' then
    begin
    //posunutie pohladu dolava
    pangle := pangle - 0.1;
    image1.canvas.fillrect(clientrect);
    Image1Click(nil);
    end;
     if edit1.Text = 'd' then
     begin
    //posunutie pohladu doprava
    pangle := pangle + 0.1;
    image1.canvas.fillrect(clientrect);
    Image1Click(nil);
    end;
     edit1.Text:='';
     image2.canvas.Rectangle(round(px/5),round(py/5),round(px/5+2),round(py/5+2));
end;


end.

