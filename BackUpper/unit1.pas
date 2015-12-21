unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Buttons, ComCtrls, Spin, Menus;

type

  { TForm1 }

  TForm1 = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    bb_run: TBitBtn;
    bb_backup: TBitBtn;
    bb_stop: TBitBtn;
    e_dest: TEdit;
    e_source: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    OpenDialog1: TOpenDialog;
    pb_time: TProgressBar;
    PopupMenu1: TPopupMenu;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    se_time: TSpinEdit;
    Timer1: TTimer;
    TrayIcon1: TTrayIcon;
    procedure bb_runClick(Sender: TObject);
    procedure bb_stopClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure bb_backupClick(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormWindowStateChange(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure se_timeChange(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure TrayIcon1Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;
  str_source : string;
  str_dest : string;
  str_sourceFile : string;
  int_interval : integer;
  int_minCnt : integer;

implementation

function MyCopyFile(const SrcFilename, DestFilename: String;
                  Flags: TCopyFileFlags=[cffOverwriteFile]): Boolean;
var
  SrcHandle: THandle;
  DestHandle: THandle;
  Buffer: array[1..4096] of byte;
  ReadCount, WriteCount, TryCount: LongInt;
begin
  Result := False;
  // check overwrite
  if (not (cffOverwriteFile in Flags)) and FileExistsUTF8(DestFileName) then
    exit;
  // check directory
  if (cffCreateDestDirectory in Flags)
  and (not DirectoryExistsUTF8(ExtractFilePath(DestFileName)))
  and (not ForceDirectoriesUTF8(ExtractFilePath(DestFileName))) then
    exit;
  TryCount := 0;
  While TryCount <> 3 Do Begin
    SrcHandle := FileOpenUTF8(SrcFilename, fmOpenRead or fmShareDenyNone);
    if (THandle(SrcHandle)=feInvalidHandle) then Begin
      Inc(TryCount);
      Sleep(10);
    End
    Else Begin
      TryCount := 0;
      Break;
    End;
  End;
  If TryCount > 0 Then
    raise EFOpenError.Createfmt({SFOpenError}'Unable to open file "%s"', [SrcFilename]);
  try
    DestHandle := FileCreateUTF8(DestFileName);
    if (THandle(DestHandle)=feInvalidHandle) then
      raise EFCreateError.createfmt({SFCreateError}'Unable to create file "%s"',[DestFileName]);
    try
      repeat
        ReadCount:=FileRead(SrcHandle,Buffer[1],High(Buffer));
        if ReadCount<=0 then break;
        WriteCount:=FileWrite(DestHandle,Buffer[1],ReadCount);
        if WriteCount<ReadCount then
          raise EWriteError.createfmt({SFCreateError}'Unable to write to file "%s"',[DestFileName])
      until false;
    finally
      FileClose(DestHandle);
    end;
    if (cffPreserveTime in Flags) then
      FileSetDateUTF8(DestFilename, FileGetDate(SrcHandle));
    Result := True;
  finally
    FileClose(SrcHandle);
  end;
end;

{$R *.lfm}

{ TForm1 }

procedure TForm1.BitBtn1Click(Sender: TObject);
     var filename : string;
begin
     if OpenDialog1.Execute then
     begin
          filename := OpenDialog1.Filename;
          //ShowMessage(filename);
          str_sourceFile := ExtractFileName(filename);
          //ShowMessage(str_sourceFile);
          form1.caption := 'BackUpper - ' + str_sourceFile;
     end;
     form1.e_source.Text := filename;
     str_source := filename;
end;

procedure TForm1.bb_stopClick(Sender: TObject);
begin
  form1.Timer1.Enabled:=false;
  form1.pb_time.position := 0;
  form1.se_time.Enabled:=true;
end;

procedure TForm1.bb_runClick(Sender: TObject);
begin
     if (str_dest <> '') and (str_source <> '') then
     begin
            int_interval := form1.se_time.Value;
            int_minCnt := 0;
            form1.Timer1.Enabled := true;
            form1.pb_time.position := 0;
            form1.pb_time.Max := int_interval;
            form1.se_time.Enabled:=false;
     end
     else
     begin
          ShowMessage('Bitte eine Datei und ein Zielordner auswählen.');
     end
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
          var filename : string;
begin
     if SelectDirectoryDialog1.Execute then
     begin
          filename := SelectDirectoryDialog1.Filename;
          //ShowMessage(filename);
     end;
     form1.e_dest.Text := filename;
     str_dest := filename;
end;

procedure TForm1.bb_backupClick(Sender: TObject);
var
  str_time : string;
  td_time : TDateTime;
begin
  if (str_dest <> '') and (str_source <> '') then
  begin
       td_time := Now;
       str_time := FormatDateTime('yyy-mm-dd-hhnn', td_time);
       MyCopyFile(str_source, (str_dest + '\' + StringReplace(str_sourceFile, '.', ('_' + str_time + '.'), [rfReplaceAll])));
  end
  else
  begin
       ShowMessage('Bitte eine Datei und ein Zielordner auswählen.');
  end
end;

procedure TForm1.BitBtn3Click(Sender: TObject);
begin

end;

procedure TForm1.Button1Click(Sender: TObject);
begin

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
    form1.TrayIcon1.Show;
    int_interval := 30;
    int_minCnt := 0;
end;

procedure TForm1.FormWindowStateChange(Sender: TObject);
begin
  if Form1.WindowState = wsMinimized then begin
      form1.WindowState := wsNormal;
      form1.Hide;
      Form1.ShowInTaskBar := stNever;
  end;
end;

procedure TForm1.MenuItem1Click(Sender: TObject);
begin
  form1.bb_run.Click;
end;

procedure TForm1.MenuItem2Click(Sender: TObject);
begin
  form1.bb_stop.Click;
end;

procedure TForm1.MenuItem3Click(Sender: TObject);
begin
  form1.bb_backup.Click;
end;

procedure TForm1.MenuItem4Click(Sender: TObject);
begin
  form1.Show;
  form1.WindowState:=wsNormal;
  Form1.ShowInTaskBar := stAlways;
end;

procedure TForm1.MenuItem5Click(Sender: TObject);
begin
  form1.Close;
end;

procedure TForm1.MenuItem6Click(Sender: TObject);
begin
    ShowMessage('For help, mail to: alex@tiny-labs.com');
end;

procedure TForm1.se_timeChange(Sender: TObject);
begin
  form1.pb_time.Max:=form1.se_time.Value;
  int_interval := form1.se_time.Value;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin

end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  int_minCnt := int_minCnt + 1;
  form1.pb_time.position := form1.pb_time.position + 1;
  //ShowMessage('1 Min vorbei');
  if int_minCnt >= int_interval then
  begin
      form1.bb_backup.Click;
      int_minCnt := 0;
      form1.pb_time.position := 0;
  end;
end;

procedure TForm1.TrayIcon1Click(Sender: TObject);
begin

end;

end.

