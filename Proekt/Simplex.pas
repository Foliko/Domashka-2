unit Simplex;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids;


type
  TForm1 = class(TForm)
    System_Neravenstv: TStringGrid;
    Button_Data_Input: TButton;
    Button_Creating_Table: TButton;
    Button_Exit: TButton;
    Simpleks_Table: TStringGrid;
    Label_Simpleks_Table: TLabel;
    Function_Label: TLabel;
    Edit_X1: TEdit;
    X1_Label: TLabel;
    Edit_X2: TEdit;
    X2_Label: TLabel;
    Edit_X3: TEdit;
    X3_Label: TLabel;
    MIN_MAX: TComboBox;
    Button_Converting: TButton;
    Ansver_Table: TStringGrid;
    Answer: TLabel;
    Otnashenie_Table: TStringGrid;
    Dual_table: TStringGrid;
    Dual: TButton;
    Label1: TLabel;
    procedure FormShow(Sender: TObject);
    procedure Button_Creating_TableClick(Sender: TObject);
    procedure System_NeravenstvDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure Simpleks_TableDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure Button_ExitClick(Sender: TObject);
    procedure Button_Data_InputClick(Sender: TObject);
    procedure Button_ConvertingClick(Sender: TObject);
    procedure Ansver_TableDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure Button5Click(Sender: TObject);
    procedure Dual_tableDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure DualClick(Sender: TObject);
//----------------Добавленные Процедуры и Функции-------------------------------
    procedure Creat_Sim_table();
    procedure Creat_Sim_table_Visible();
    procedure Primore();
    procedure Add_Test();
    procedure Dual_Zadacha();

//------------------------------------------------------------------------------

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  i_max,j_min,i_stol,j_str,e: integer;
  a1,a2,a3,c:array[1..4,1..4] of real;
  c2:array[1..3,1..2] of real;

implementation

uses Simpl;
{$R *.dfm}

procedure TForm1.FormShow(Sender: TObject);
begin
Add_Test();
end;

procedure TForm1.Button_Creating_TableClick(Sender: TObject);
var
i,j,r,g:integer;

min,t:real;
begin
  Label_Simpleks_Table.Visible:=true;
  Simpleks_Table.Visible:=true;
  Button_Converting.Enabled:=true;
  Dual_Table.Visible:=true;
  label1.Visible:=true;
  Dual.Enabled:=true;

  for i:=0 to 5 do
    Ansver_Table.Cells[1,i]:='0';

  Creat_Sim_table();
  Creat_Sim_table_Visible();

  //Poisk_Stolbca();

  Simpl.Metod.Poisk_Stolbca();
  Simpleks_Table.Refresh;

  Simpl.Metod.Opor_resh();


end;

procedure TForm1.System_NeravenstvDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  cr:TRect;
begin
  with System_Neravenstv.Canvas do
    begin
      cr:=System_Neravenstv.CellRect(acol,arow) ;
      FillRect(cr);
      TextOut(cr.left+((cr.Right-cr.Left) div 2)-(TextWidth(System_Neravenstv.Cells[acol,arow]) div 2),
      cr.Top,System_Neravenstv.Cells[acol,arow]);
    end;
end;

procedure TForm1.Simpleks_TableDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var cr:TRect;
max,t:real;
i,j:integer;
a,b:array [1..4,1..4] of real;
begin
  max:=-100;
  with Simpleks_Table.Canvas do
    begin
      cr:=Simpleks_Table.CellRect(acol,arow) ;
      FillRect(cr);
      TextOut(cr.left+((cr.Right-cr.Left) div 2)-(TextWidth(Simpleks_Table.Cells[acol,arow]) div 2),
      cr.Top,Simpleks_Table.Cells[acol,arow]);
    end;

  for i:=2 to 4 do
    if strtofloat(Simpleks_Table.Cells[i,4])>max then
      begin
        max:=strtofloat(Simpleks_Table.Cells[i,4]);
        i_max:=i;
      end;

  for i:=1 to 3 do
    for j:=1 to 4 do
      Otnashenie_Table.Cells[i,j]:=floattostr(c[j,i]);

  If (ACol=0) Or (ARow=0) Then Exit;
  if (i_max<>0)and(j_min<>0) then
    if (ACol=i_max)or(ARow=j_min) then
      begin
        with Simpleks_Table.Canvas do
          begin
            Simpleks_Table.Canvas.Font.Color:= clRed;
            cr:=Simpleks_Table.CellRect(acol,arow) ;
            FillRect(cr);
            TextOut(cr.left+((cr.Right-cr.Left) div 2)-(TextWidth(Simpleks_Table.Cells[acol,arow]) div 2),
            cr.Top,Simpleks_Table.Cells[acol,arow]);
          end;
      end;
end;

procedure TForm1.Button_ExitClick(Sender: TObject);
begin
form1.close;
end;

procedure TForm1.Button_Data_InputClick(Sender: TObject);
var
  i,j:integer;
  t:real;
begin
  Ansver_Table.Visible:=false;
  Answer.Visible:=false;
  Simpleks_Table.Visible:=false;
  Label_Simpleks_Table.Visible:=false;
  Button_Creating_Table.Enabled:=true;

  for j:=1 to 3 do
    a1[1,j]:=strtofloat(System_Neravenstv.Cells[1,j]);
  for j:=1 to 3 do
    a1[2,j]:=strtofloat(System_Neravenstv.Cells[i_max,j]);
  for j:=1 to 3 do
    if (a1[1,j]=0) or (a1[2,j]=0) then  a1[3,j]:=0
    else a1[3,j]:=a1[1,j]/a1[2,j];

  t:=abs(c[3,1]);
  j_min:=1;
  for i:=1 to 3 do
    begin
      if (a1[3,i]<>0) then
        if (t>abs(a1[3,i]))and(a1[4,i]<>0) then
          begin
            t:=abs(a1[3,i]);
            j_min:=i;
          end;
    end;
  a1[4,j_min]:=0;

  for i:=1 to 3 do
    for j:=1 to 3 do
      if i=j then
        System_Neravenstv.Cells[i+2,j]:='1';
  for i:=1 to 3 do
    System_Neravenstv.cells[6,i]:='=';
  for j:=1 to 3 do
    c[4,j]:=1;
  for i:=1 to 3 do
    a1[4,i]:=1;

  Button_Data_Input.Enabled:=false;
end;



procedure TForm1.Button_ConvertingClick(Sender: TObject);
begin
  Primore();
end;

procedure TForm1.Ansver_TableDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  cr:TRect;
  i,j:integer;
begin
  with Ansver_Table.Canvas do
    begin
      cr:=Ansver_Table.CellRect(acol,arow) ;
      FillRect(cr);
      TextOut(cr.left+((cr.Right-cr.Left) div 2)-(TextWidth(Ansver_Table.Cells[acol,arow]) div 2),
      cr.Top,Ansver_Table.Cells[acol,arow]);
    end;


end;

procedure TForm1.Button5Click(Sender: TObject);
var
i,j:integer;
begin

end;

//-------------- Функции -------------------------------------------------------
procedure TForm1.Creat_Sim_table();//заполнение симплекс таблицы
var
i,j:integer;
begin
  a2[4,2]:=strtofloat(Edit_X1.Text);
  a2[4,3]:=strtofloat(Edit_X2.Text);
  a2[4,4]:=strtofloat(Edit_X3.Text);
  for i:=1 to 3 do
    a2[i,1]:=strtofloat(System_Neravenstv.Cells[7,i]);
  for i:=1 to 3 do
    for j:=1 to 3 do
      a2[j,i+1]:=strtofloat(System_Neravenstv.Cells[i-1,j]);
  a2[4,1]:=0;
  for i:=1 to 3 do
    for j:=1 to 3 do
      a3[i,j+1]:=0-a2[j,i+1];
  for i:=1 to 3 do
      a3[4,i+1]:=0-a2[i,1];
  for i:=1 to 3 do
      a3[i,1]:=0-a2[4,i+1];
end;

procedure TForm1.Creat_Sim_table_Visible();//заполнение видимой симплекс таблицы
var
i,j:integer;
begin
  Simpleks_Table.Cells[1,0]:='Si0';
  Simpleks_Table.Cells[0,4]:='F';
  for i:=2 to 4 do
    Simpleks_Table.Cells[i,0]:='X'+inttostr(i-1);
  for i:=1 to 3 do
    Simpleks_Table.Cells[0,i]:='X'+inttostr(i+3);
  for i:=1 to 4 do
    for j:=1 to 4 do
      Simpleks_Table.Cells[i,j]:=floattostr(a2[j,i]);

  Dual_table.Cells[1,0]:='Si0';
  Dual_table.Cells[0,4]:='F';
  for i:=2 to 4 do
    Dual_table.Cells[i,0]:='Y'+inttostr(i-1);
  for i:=1 to 3 do
    Dual_table.Cells[0,i]:='Y'+inttostr(i+3);
  for i:=1 to 4 do
    for j:=1 to 4 do
      Dual_table.Cells[i,j]:=floattostr(a3[j,i]);
  Button_Creating_Table.Enabled:=false;
end;

procedure TForm1.Dual_Zadacha();//Двойственная задача
var
i,j:integer;

begin

Metod.Pereschot();

for i:=1 to 3 do
    if a3[i,1]<0 then
                    begin
                      Metod.Opor_resh();
                      break;
                    end
    else if i=3 then Metod.Optim_resh();
end;

procedure TForm1.Primore();//Прямая задача
var
  i,j,k,l,p:integer;
  a,b:array[1..4,1..4] of real;
  t:real;
  s:string;
begin
  l:=0;
  for i:=2 to 4 do
    if strtofloat(Simpleks_Table.Cells[i,4])>0 then   l:=1;
  if l=1 then
    begin
      Metod.Poisk_Stroki();

      for i:=1 to 4 do
        for j:=1 to 4 do
          a[j,i]:=strtofloat(Simpleks_Table.Cells[i,j]);

      s:=Simpleks_Table.Cells[0,j_min];
      Simpleks_Table.Cells[0,j_min]:=Simpleks_Table.Cells[i_max,0];
      Simpleks_Table.Cells[i_max,0]:=s;

     if a[j_min,i_max]<>0 then
        for i:=1 to 4 do
          for j:=1 to 4 do
            begin
              if (j_min<>i)and(i_max<>j) then  b[i,j]:=a[i,j]-((a[j_min,j]*a[i,i_max])/a[j_min,i_max])
              else
              if (j_min=i)and(i_max<>j)then b[i,j]:=a[i,j]/a[j_min,i_max]
              else if (j_min<>i)and(i_max=j)then b[i,j]:=a[i,j]/(-1*a[j_min,i_max])
              else if (j_min=i)and(i_max=j)then  b[i,j]:=1/(-1*a[j_min,i_max]);
            end
      else b[i,j]:=a[i,j];

      for i:=1 to 4 do
        for j:=1 to 4 do
          Simpleks_Table.Cells[i,j]:=floattostr(b[j,i]);

      Metod.Poisk_Stroki();

  end
  else
    begin
      Answer.Visible:=true;
      Ansver_Table.Visible:=true;
      j:=1;
      for i:=1 to 3 do
        begin
          for j:=0 to 5 do
            if Simpleks_Table.Cells[0,i]=Ansver_Table.Cells[0,j] then Ansver_Table.Cells[1,j]:=Simpleks_Table.Cells[1,i];
        end;
      Answer.Caption:='Оптимальное решениефункции F='+Simpleks_Table.Cells[1,4];
      Button_Converting.Enabled:=false;
      Button_Data_Input.Enabled:=true;
    end;
end;

procedure TForm1.Add_Test();  //Добавление тестового варианта
var
  i,j:integer;
begin
  i_max:=0;
  e:=1;
//----------Заполнение таблицы системы неравенств------------------------------
//-------------Атрибуты--------------------------------------------------------
  for i:=0 to System_Neravenstv.ColCount-3 do
    System_Neravenstv.Cells[i,0]:='X'+inttostr(i+1);
  for i:=1 to 3 do
    System_Neravenstv.Cells[6,i]:='<=';
  for i:=3 to System_Neravenstv.ColCount-3 do
    for j:=1 to 3 do
      System_Neravenstv.Cells[i,j]:='0';
  System_Neravenstv.Cells[6,0]:='Знак';
//-------------Значения--------------------------------------------------------
  System_Neravenstv.Cells[0,1]:='2';
  System_Neravenstv.Cells[1,1]:='1';
  System_Neravenstv.Cells[2,1]:='1';
  System_Neravenstv.Cells[0,2]:='1';
  System_Neravenstv.Cells[1,2]:='2';
  System_Neravenstv.Cells[2,2]:='0';
  System_Neravenstv.Cells[0,3]:='0';
  System_Neravenstv.Cells[1,3]:='0,5';
  System_Neravenstv.Cells[2,3]:='1';

  System_Neravenstv.Cells[7,1]:='4';
  System_Neravenstv.Cells[7,2]:='6';
  System_Neravenstv.Cells[7,3]:='2';
//--------------Атрибуты таблицы решения---------------------------------------
  for i:=0 to 5 do
    Ansver_Table.Cells[0,i]:='X'+inttostr(i+1);
   for i:=1 to 3 do
    c2[i,2]:=1;
end;
//------------------------------------------------------------------------------
procedure TForm1.Dual_tableDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  cr:TRect;
  i,j:integer;
begin

  with Dual_table.Canvas do
    begin
      cr:=Dual_table.CellRect(acol,arow) ;
      FillRect(cr);
      TextOut(cr.left+((cr.Right-cr.Left) div 2)-(TextWidth(Dual_table.Cells[acol,arow]) div 2),
      cr.Top,Dual_table.Cells[acol,arow]);
    end;

 // Poisk_Stolbca();


  If (ACol=0) Or (ARow=0) Then Exit;
  if (i_stol<>0)and(j_min<>0) then
    if (ACol=i_stol)or(ARow=j_str) then
    //if (ACol=j_str)or(ARow=i_stol) then
      begin
        with Dual_table.Canvas do
          begin
            Dual_table.Canvas.Font.Color:= clRed;
            cr:=Dual_table.CellRect(acol,arow) ;
            FillRect(cr);
            TextOut(cr.left+((cr.Right-cr.Left) div 2)-(TextWidth(Dual_table.Cells[acol,arow]) div 2),
            cr.Top,Dual_table.Cells[acol,arow]);
          end;
      end;
end;

procedure TForm1.DualClick(Sender: TObject);
var
i,j:integer;

begin
Metod.Pereschot();

for i:=1 to 3 do
    if a3[i,1]<0 then
                    begin
                      Metod.Opor_resh();
                      break;
                    end
    else if i=3 then Metod.Optim_resh();

end;
end.
