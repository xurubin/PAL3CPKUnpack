unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, shlobj;

type
  TForm1 = class(TForm)
    Button1: TButton;
    OpenDialog1: TOpenDialog;
    Memo1: TMemo;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    ProgBar1: TProgressBar;
    Label3: TLabel;
    Edit2: TEdit;
    Button2: TButton;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

type a=function(Dest,Source:pointer;Size:integer):integer;stdcall;
Const Max=32768;
var
  Form1: TForm1;
  D:array[1..Max]of array[1..7]of dword;
  FileName,Dir:array[0..MAX]of string;
  Ord:array[1..Max]of word;
  B:array[1..Max]of boolean;
  DeCompress:a;
  h:THandle;
  CPK:TFileStream;
  CPKName:ShortString;
  Count:Integer;
  DirStack:array[1..20]of string;
implementation

{$R *.dfm}
  Function GetIndexFromCRC(CRC:DWord):integer;
    var h,r,p:integer;
      begin
         Result:=-1;
         h:=1;r:=Count;
            while h<r do
              begin
              p:=(h+r) div 2;
              if D[p][1]=CRC then
                 begin Result:=p;exit;end else
              if CRC<D[p][1] then
                 R:=P else
                 H:=p;
              end;
         if D[p][1]=CRC then begin Result:=p;exit;end else
         ShowMessage('Error From Binary Search!');
      end;

procedure TForm1.Button1Click(Sender: TObject);
var i,j:DWord;
DirCount:integer;
Source,Dest:Pointer;
F:TFileStream;
Name:String;
StrBuf:array[1..255]of char;
MinI:Integer;
begin
IF CPKName='' then exit;
if copy(edit1.text,length(edit1.text),1)<>'\' then edit1.text:=edit1.text+'\';
Button1.Enabled:=False;
try
CPK:=TFileStream.Create(CPKName,FMopenRead);
CPK.Seek($20,0);
CPK.Read(Count,4);
CPK.Seek($80,0);
Memo1.Lines.add('读取索引'+InttoStr(Count)+'个...');
For i:=1 to Count do
  begin
   CPK.Read(D[i],28);
   //Dec(D[i][4]);
  end;
Memo1.Lines.add('完成！');Application.ProcessMessages;

Memo1.Lines.add('建立索引...');
For i:=1 to Count do
   begin
      IF D[i][3]<>0 then
          D[i][3]:=GetIndexFromCRC(D[i][3]);
   end;
Fillchar(B,sizeof(b),TRUE);
ProgBar1.Max:=Count;
For i:=1 to Count do
   begin
      MinI:=-1;
      ProgBar1.Position:=i;Application.ProcessMessages;
      For j:=1 to COUNT DO
        IF B[j] then
           begin
              IF MinI=-1 then MinI:=j else
              IF D[j][4]<D[MinI][4] then MinI:=J;
           end;
      B[MinI]:=False;
      Ord[i]:=MinI;
   end;
Memo1.Lines.add('完成！');Application.ProcessMessages;

Memo1.Lines.add('读取文件名'+InttoStr(Count)+'个...');
ProgBar1.Max:=Count;
For i:=1 to Count do
   begin
       ProgBar1.Position:=i;Application.ProcessMessages;
       CPK.Seek(D[Ord[i]][4]+D[Ord[i]][5],0);
       CPK.Read(StrBuf,D[Ord[i]][7]);
       Name:='';
       j:=1;while StrBuf[j]<>#0 do
          begin
            Name:=Name+StrBuf[j];
            Inc(j);
          end;
       SetLength(Name,j-1);
       FileName[Ord[i]]:=Name;
   end;
Memo1.Lines.add('完成！');Application.ProcessMessages;

Memo1.Lines.add('建立目录结构...');
ProgBar1.Max:=Count;
Dir[0]:=Edit1.text;
For i:=1 to Count do
   begin
      ProgBar1.Position:=i;Application.ProcessMessages;
      IF D[i][2]<>3 then Continue;
      j:=D[i][3];
      DirCount:=1;DirStack[DirCount]:=FileName[i];
      while j<>0 do
         begin
             Inc(DirCount);
             DirStack[DirCount]:=FileName[j];
             J:=D[j][3];
         end;
      Name:=Edit1.text;
      For j:=DirCount downto 1 do
        begin
           Name:=Name+DirStack[j]+'\';
           CreateDirectory(PChar(Name),nil);
        end;
      Dir[i]:=Name;
   end;
Memo1.Lines.add('完成！');Application.ProcessMessages;

Memo1.Lines.add('开始解压...');
ProgBar1.Max:=Count;
For i:=1 to Count Do
   Begin
      Form1.Caption:=Inttostr(i);
      ProgBar1.Position:=i;Application.ProcessMessages;
      IF D[Ord[i]][2]=3 then Continue;
      IF (d[Ord[i]][5]=0)or(d[Ord[i]][6]=0)or(d[Ord[i]][7]=0) then
         begin
            Memo1.Lines.Add(Inttostr(Ord[i]));
            continue;
         end;
      F:=TFileStream.Create(DIr[D[Ord[i]][3]]+FileName[Ord[i]],FMCREATE or FMOPENWRITE);
      GetMem(Source,D[Ord[i]][5]);GetMem(Dest,D[Ord[i]][6]);
      CPK.Seek(D[Ord[i]][4],0);
      CPK.ReadBuffer(Source^,D[Ord[i]][5]);
      if d[Ord[i]][5]<D[Ord[i]][6] then
           begin
                j:=DeCompress(Dest,Source,D[Ord[i]][5]);
                if j<>D[Ord[i]][6] then
                        Memo1.Lines.Add('Error DeCompressing '+FileName[i])
                else F.Write(Dest^,D[Ord[i]][6]);
           end else
                F.Write(Source^,D[Ord[i]][5]);
      FreeMem(Source);FreeMem(Dest);
      F.Free;
   end;
Memo1.Lines.add('全部完成！');
FInally
Button1.Enabled:=TRUE;
CPK.Free;
end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
CPKName:='';
SetLastError(0);
h:=loadlibrary('gbengine.dll');
if h=0 then
   begin
      ShowMessage('Could not Load GBEngine.dll!'+#13#10+'GetLastError='+InttoStr(GetLastError));
      Halt;
   end;
DeCompress:=GetProcAddress(h,'?DeCompress@CPK@@QAEKPAX0K@Z');
if @DeCompress=Nil then
   begin
      ShowMessage('Could not Locate Function "?DeCompress@CPK@@QAEKPAX0K@Z" in Dll!'+#13#10+'GetLastError='+InttoStr(GetLastError));
      Halt;
   end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
FreeLibrary(h);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
If Not OpenDialog1.Execute then exit;
Edit1.Text:=ExtractFilePath(OpenDialog1.FileName);
CPKName:=OpenDialog1.FileName;
Edit2.text:=CPKName;
end;

procedure TForm1.Button3Click(Sender: TObject);
var bi:_browseinfoa;
pid:PItemIDList;
path:pchar;
begin
fillchar(bi,sizeof(bi),0);
bi.hwndOwner:=Self.handle;
bi.pszDisplayName:='青选择...';
bi.lpszTitle:='选择目录';
pid:=SHBrowseForFolder(bi);
if pid=nil then exit;
getmem(path,255);
SHGetPathFromIDList(pid,path);
edit1.text:=path;
if copy(edit1.text,length(edit1.text),1)<>'\' then edit1.text:=edit1.text+'\';
freemem(path);
end;

end.
