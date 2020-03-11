unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Clipbrd, StdCtrls,
  ExtCtrls, ComCtrls, Menus, DOM, XMLWrite, XMLRead;

type

  { TForm1 }

  TForm1 = class(TForm)
    Bevel1: TBevel;
    Edit1: TEdit;
    ImageList1: TImageList;
    ListBox1: TListBox;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    OpenDialog1: TOpenDialog;
    PopupMenu1: TPopupMenu;
    SaveDialog1: TSaveDialog;
    ScrollBox1: TScrollBox;
    StatusBar1: TStatusBar;
    Timer1: TTimer;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    TrayIcon1: TTrayIcon;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormWindowStateChange(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure ListBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Memo1Change(Sender: TObject);
    procedure Memo1Click(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure StatusBar1DrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel;
      const Rect: TRect);
    procedure Timer1Timer(Sender: TObject);
    procedure ToolBar1Click(Sender: TObject);
    procedure ToolButton11Click(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);
    procedure ToolButton4Click(Sender: TObject);
    procedure ToolButton5Click(Sender: TObject);
    procedure ToolButton7Click(Sender: TObject);
    procedure ToolButton9Click(Sender: TObject);
    procedure TrayIcon1Click(Sender: TObject);
  private
    procedure prcdCheckClipboard();
    procedure prcdCheckClipboard2();
    function createMemo(Memo : TMemo; strText : String) : TMemo;
    procedure refreshMemoList(arrMemoList : array of TMemo);
    procedure memoClickEvent(Sender: TObject);
    procedure writeXML(strFile : String);
    procedure readXML(strFile : String);
    procedure FreeArrayOfObject(anObjArray: array of TMemo);
    procedure memoChangeEvent(Sender: TObject);
    procedure deleteItemFromArray(intItemPos : integer);
  public

  end;


var
  Form1: TForm1;

  strLastClipBoardStr : String;
  blParseClipBoard : boolean;
  strArrClipList : array of String;
  TMemoArrClipList : array of TMemo;
  intSelectedItem : integer;
implementation

{$R *.lfm}

{ TForm1 }



procedure TForm1.FormCreate(Sender: TObject);
begin
  strLastClipBoardStr := '';
  blParseClipBoard := true;
  //setLength(strArrClipList, 1);
  form1.StatusBar1.Panels[1].Width := form1.Width - 30 - 100;
  intSelectedItem := -1;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
   form1.StatusBar1.Panels[1].Width := form1.Width - 30 - 100;
   form1.ScrollBox1.Width:=form1.Width;
   form1.ScrollBox1.Height:=form1.Height - 116;
end;

procedure TForm1.FormWindowStateChange(Sender: TObject);
begin
     if Form1.WindowState = wsMinimized then
     begin
          //form1.WindowState := wsNormal;
          Form1.Hide;
          Form1.ShowInTaskBar := stNever;
     end;
     if Form1.WindowState = wsNormal then
     begin
          //form1.WindowState := wsNormal;
          Form1.Show;
          Form1.ShowInTaskBar := stDefault;
     end;
end;

procedure TForm1.ListBox1Click(Sender: TObject);
begin
     //ShowMessage(form1.ListBox1.GetSelectedText);
     if (form1.ListBox1.GetSelectedText <> '') then begin
       strLastClipBoardStr := form1.ListBox1.GetSelectedText;
       form1.Edit1.Text := strLastClipBoardStr;
       Clipboard.AsText := strLastClipBoardStr;
     end;
end;

procedure TForm1.ListBox1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
     //if (Button = mbRight) then
     //begin
     //     ShowMessage(form1.ListBox1.GetSelectedText);
     //end;
end;

procedure TForm1.Memo1Change(Sender: TObject);
begin

end;

procedure TForm1.Memo1Click(Sender: TObject);
begin

end;

procedure TForm1.MenuItem1Click(Sender: TObject);
begin
     Form1.WindowState := wsNormal;
     Form1.Show;
     Form1.ShowInTaskBar := stDefault;
end;

procedure TForm1.MenuItem2Click(Sender: TObject);
begin
  Form1.close;
end;

procedure TForm1.StatusBar1DrawPanel(StatusBar: TStatusBar;
  Panel: TStatusPanel; const Rect: TRect);
var
   bmp: TBitmap;
begin
  bmp := TBitmap.Create;
  if (Panel = form1.StatusBar1.Panels[0]) then begin
     if (blParseClipBoard = true) then begin
        form1.ImageList1.GetBitmap(8, bmp);
     end;
     if (blParseClipBoard = false) then begin
        form1.ImageList1.GetBitmap(9, bmp);
     end; ;
     form1.StatusBar1.Canvas.Draw(Rect.Left + 5, Rect.Top + 5, bmp);
  end;
  bmp.free;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
     if (blParseClipBoard = true) then begin
          prcdCheckClipboard2();
     end;
     form1.Edit1.Text := Clipboard.AsText;
end;

procedure TForm1.ToolBar1Click(Sender: TObject);
begin

end;

procedure TForm1.ToolButton11Click(Sender: TObject);
begin
  //form1.Label1.Caption:=inttostr(intSelectedItem);
  if intSelectedItem >= 0 then begin
     //ShowMessage('Delete');
     deleteItemFromArray(intSelectedItem);
     refreshMemoList(TMemoArrClipList);
  end;
end;

procedure TForm1.ToolButton1Click(Sender: TObject);
begin
    form1.OpenDialog1.InitialDir := GetCurrentDir;
    if OpenDialog1.Execute then
    begin
     //   form1.ListBox1.Items.LoadFromFile(OpenDialog1.Filename);
          readXML(OpenDialog1.Filename);
          intSelectedItem := -1;
    end;
end;

procedure TForm1.ToolButton3Click(Sender: TObject);
begin
     if length(strArrClipList) > 0 then begin
        form1.SaveDialog1.InitialDir := GetCurrentDir;
        if SaveDialog1.Execute then
        begin
          //form1.ListBox1.Items.SaveToFile(SaveDialog1.Filename);
           writeXML(SaveDialog1.Filename);
        end;
     end
     else begin
         MessageDlg('Info', 'Clipboard List is empty.', mtInformation, [mbOk], '');
     end;
end;

procedure TForm1.ToolButton4Click(Sender: TObject);
begin
  form1.close;
end;

procedure TForm1.ToolButton5Click(Sender: TObject);
begin
  strLastClipBoardStr := '';
  Clipboard.AsText := '';
  form1.Edit1.Text := '';
  setLength(strArrClipList, 0);
  FreeArrayOfObject(TMemoArrClipList);
  setLength(TMemoArrClipList, 0);
  //form1.ListBox1.Items.Clear;
  refreshMemoList(TMemoArrClipList);
  intSelectedItem := -1;
end;

procedure TForm1.ToolButton7Click(Sender: TObject);
begin
     if (blParseClipBoard = true) then
     begin
          blParseClipBoard := false;
          form1.ToolButton7.ImageIndex := 9;
          form1.ToolButton7.Hint := 'Clipboard will not be parsed into List';
          form1.StatusBar1.Panels[1].Text := 'Parsing Clipboard: Deactivated';
     end
     else
     begin
          blParseClipBoard := true;
          form1.ToolButton7.ImageIndex := 8;
          form1.ToolButton7.Hint := 'Parsing the Clipboard into List';
          form1.StatusBar1.Panels[1].Text := 'Parsing Clipboard: Activated';
          prcdCheckClipboard();
     end;
     form1.StatusBar1.Refresh;
end;

procedure TForm1.ToolButton9Click(Sender: TObject);
begin
     MessageDlg('Info', 'MultiClipboard v0.3 by Alexander Wegner.' + sLineBreak + 'This project is open source under CC BY-NC-SA 4.0.' + sLineBreak + 'Get source files at: www.tiny-labs.com or github.com\stish', mtInformation, [mbOk], '');
end;

procedure TForm1.TrayIcon1Click(Sender: TObject);
begin

end;

procedure TForm1.prcdCheckClipboard();
var
     intMaxWidth : integer;
     intWidth : integer;
     i : integer;
     blItemFound : boolean;
begin
     if (Clipboard.AsText <> strLastClipBoardStr) then
     begin
          blItemFound := false;
          form1.ListBox1.ItemIndex := -1;
          //ShowMessage(Clipboard.AsText);
          strLastClipBoardStr := Clipboard.AsText;
          form1.Edit1.Text := strLastClipBoardStr;
          //form1.ListBox1.Items.Add(strLastClipBoardStr);
          intMaxWidth := 0;
          form1.ListBox1.Canvas.Font := form1.ListBox1.Font;
          for i := 0 to form1.ListBox1.Items.Count-1 do
          begin
               if (form1.ListBox1.Items.Strings[i] = strLastClipBoardStr) then
               begin
                    blItemFound := true;
               end;
               intWidth := form1.ListBox1.Canvas.TextWidth(form1.ListBox1.Items.Strings[i] + 'x');
               if intMaxWidth < intWidth then
               begin
                  intMaxWidth := intWidth;
               end;
          end;
          if blItemFound = false then
          begin
               form1.ListBox1.Items.Add(strLastClipBoardStr);
               intWidth := form1.ListBox1.Canvas.TextWidth(form1.ListBox1.Items.Strings[form1.ListBox1.Items.Count-1] + 'x');
               if intMaxWidth < intWidth then
               begin
                  intMaxWidth := intWidth;
               end;
          end;
          form1.ListBox1.ScrollWidth := intMaxWidth;
          //SendMessage(form1.ListBox1.Handle, LB_SETHORIZONTALEXTENT, intMaxWidth, 0);
     end;
end;

procedure TForm1.prcdCheckClipboard2();
var
     intMaxWidth : integer;
     intWidth : integer;
     i : integer;
     blItemFound : boolean;
begin
     if (Clipboard.AsText <> strLastClipBoardStr) and (Clipboard.AsText <> '') then
     begin
          blItemFound := false;
          intSelectedItem := -1;
          strLastClipBoardStr := Clipboard.AsText;
          form1.Edit1.Text := strLastClipBoardStr;
          intMaxWidth := 0;
          //ShowMessage(inttostr(length(strArrClipList)));
          if length(strArrClipList) = 0 then begin
             setLength(strArrClipList, 1);
             setLength(TMemoArrClipList, 1);
             TMemoArrClipList[0] := createMemo(TMemoArrClipList[0], strLastClipBoardStr);
             strArrClipList[length(strArrClipList) - 1] := strLastClipBoardStr;
             form1.ListBox1.Items.Add(strLastClipBoardStr);
             //TMemoArrClipList[0].OnClick := @memoClickEvent;
          end;
          if length(strArrClipList) > 0 then begin
            for i := 0 to (length(strArrClipList) - 1) do
            begin
                 if (strArrClipList[i] = strLastClipBoardStr) then
                 begin
                      blItemFound := true;
                 end;
            end;
            if blItemFound = false then
            begin
                 setLength(strArrClipList, length(strArrClipList) + 1);
                 strArrClipList[length(strArrClipList) - 1] := strLastClipBoardStr;
                 setLength(TMemoArrClipList, length(TMemoArrClipList) + 1);
                 TMemoArrClipList[length(TMemoArrClipList) - 1] := createMemo(TMemoArrClipList[length(TMemoArrClipList) - 1], strLastClipBoardStr);
                 form1.ListBox1.Items.Add(strLastClipBoardStr);
            end;
          end;
          for i := 0 to form1.ListBox1.Items.Count-1 do
          begin
               intWidth := form1.ListBox1.Canvas.TextWidth(form1.ListBox1.Items.Strings[i] + 'x');
               if intMaxWidth < intWidth then
               begin
                  intMaxWidth := intWidth;
               end;
          end;
          form1.ListBox1.ScrollWidth := intMaxWidth;
          //form1.Repaint;
          TMemoArrClipList[0].Width := Form1.Edit1.Width;
          //TMemoArrClipList[0].Repaint;
          refreshMemoList(TMemoArrClipList);
          form1.StatusBar1.BringToFront;
          form1.Edit1.SetFocus;
     end;
end;

procedure TForm1.memoClickEvent(Sender: TObject);
var
     i : integer;
     strTemp : String;
begin
  //ShowMessage((Sender as TMemo).name + ' clicked.');
  for i := 0 to length(TMemoArrClipList)-1 do begin
      TMemoArrClipList[i].Color := clDefault;
  end;
  strLastClipBoardStr := (Sender as TMemo).Text;
  form1.Edit1.Text := strLastClipBoardStr;
  Clipboard.AsText := strLastClipBoardStr;
  (Sender as TMemo).Color := $00FFDDBB;
  strTemp := (Sender as TMemo).name;
  //Clipnode_
  strTemp := Copy(strTemp, 10, length(strTemp));
  intSelectedItem := strtoint(strTemp);
  //ShowMessage(strTemp);
  //form1.Label1.Caption:=strTemp;
end;

procedure TForm1.memoChangeEvent(Sender: TObject);
var
     strTemp : String;
begin
  strTemp := (Sender as TMemo).name;
  //Clipnode_
  strTemp := Copy(strTemp, 10, length(strTemp));
  strLastClipBoardStr := (Sender as TMemo).Text;
  strArrClipList[strtoint(strTemp)] := strLastClipBoardStr;
  form1.Edit1.Text := strLastClipBoardStr;
  Clipboard.AsText := strLastClipBoardStr;
end;

function TForm1.createMemo(Memo : TMemo; strText : String) : TMemo;
var
     intWidth : integer;
begin
     intWidth := Form1.edit1.width;
     if form1.ScrollBox1.VertScrollBar.IsScrollBarVisible = true then begin
        intWidth := Form1.Width - 35;
     end;
     Memo := TMemo.Create(Form1);
     Memo.Parent := ScrollBox1;
     Memo.Top := 0;
     Memo.Left := 8;
     Memo.Visible := true;
     Memo.Width := intWidth;
     Memo.WordWrap := false;
     Memo.Font := form1.Edit1.Font;
     //Memo.Height := 200;
     Memo.Text := strText;
     Memo.Anchors := [akLeft, akRight, akTop];
     Memo.VertScrollBar.Visible := false;
     Memo.HorzScrollBar.Visible := false;
     Memo.ScrollBars := ssNone;
     //ShowMessage(inttostr(Memo.Lines.Count));
     //Memo.AutoSize := true;
     Memo.Height := (Memo.Lines.Count*17) + 10;
     if (Memo.Height > 210) then begin
        Memo.Height := 210;
        Memo.VertScrollBar.Visible := true;
        Memo.ScrollBars := ssAutoVertical;
     end;
     Memo.OnClick := @memoClickEvent;
     Memo.OnChange := @memoChangeEvent;
     Memo.Color := clDefault;
     //Memo.Repaint;
     result := Memo;
end;

procedure TForm1.refreshMemoList(arrMemoList : array of TMemo);
var
     i : integer;
     intDistToTop, intWidth : integer;
begin
   intDistToTop := 0;
   intWidth := Form1.edit1.width;
   if form1.ScrollBox1.VertScrollBar.IsScrollBarVisible = true then begin
      intWidth := Form1.Width - 35;
   end;
   for i := 0 to length(arrMemoList)-1 do
   begin
       //ShowMessage(inttostr(i));
        arrMemoList[i].Top := intDistToTop;
        arrMemoList[i].name := 'Clipnode_' + inttostr(i);
        intDistToTop := intDistToTop + arrMemoList[i].Height + 2;
        arrMemoList[i].Width := intWidth;
        arrMemoList[i].Color := clDefault;
        arrMemoList[i].Text := strArrClipList[i];
        //form1.StatusBar1.BringToFront;
   end;
   if form1.ScrollBox1.VertScrollBar.IsScrollBarVisible = true then begin
      intWidth := Form1.Width - 35;
      intDistToTop := 0;
      for i := 0 to length(arrMemoList)-1 do
      begin
          arrMemoList[i].Width := intWidth;
      end;
   end;
   form1.StatusBar1.Panels[2].Text := 'Items: ' + inttostr(length(arrMemoList));
   //ShowMessage(inttostr(length(arrMemoList)));
end;

procedure TForm1.writeXML(strFile : String);
var
  Doc : TXMLDocument;
  RootNode, nofilho, ItemNode: TDOMNode;
  i : integer;
begin
  if (length(strArrClipList) > 0) then begin
    // Create a document
    Doc := TXMLDocument.Create;
    RootNode := Doc.CreateElement('clipBoardItems');
    Doc.Appendchild(RootNode);
    RootNode := Doc.DocumentElement;
    for i := 0 to length(strArrClipList)-1 do
    begin
       ItemNode :=Doc.CreateElement('Item');
       nofilho := Doc.CreateTextNode(strArrClipList[i]);
       ItemNode.AppendChild(nofilho);
       RootNode.AppendChild(ItemNode);
    end;
    writeXMLFile(Doc, strFile);
    Doc.Free;
  end;
end;

procedure TForm1.readXML(strFile : String);
var
  ItemNode: TDOMNode;
  Doc: TXMLDocument;
  i : integer;
begin
  try
    form1.ListBox1.Clear;
    // Read in xml file from disk
    ReadXMLFile(Doc, strFile);
    // Retrieve the "password" node
    ItemNode := Doc.DocumentElement.FindNode('Item');
    i := 0;
    FreeArrayOfObject(TMemoArrClipList);
    while Assigned(ItemNode) do begin
          //form1.ListBox1.Items.Add(ItemNode.FirstChild.NodeValue);
          setLength(strArrClipList, i + 1);
          setLength(TMemoArrClipList, i + 1);
          TMemoArrClipList[i] := createMemo(TMemoArrClipList[i], ItemNode.FirstChild.NodeValue);
          strArrClipList[i] := ItemNode.FirstChild.NodeValue;
          i := i + 1;
          ItemNode := ItemNode.NextSibling;
    end;
  finally
    // finally, free the document
    Doc.Free;
    refreshMemoList(TMemoArrClipList);
  end;
end;

procedure TForm1.FreeArrayOfObject(anObjArray: array of TMemo);
var
  obj: TObject;
begin
  for obj in anObjArray do
    obj.Free;
  Finalize(anObjArray);
end;

procedure Tform1.deleteItemFromArray(intItemPos : integer);
var
  i, intLength : integer;
  TMemoTemp : TMemo;
begin
  if intItemPos >= 0 then begin
    //ShowMessage(inttostr(intItemPos) + ' ' + inttostr(length(strArrClipList)-1));
    if intItemPos = length(strArrClipList)-1 then begin
       //ShowMessage('Last item');
       setLength(strArrClipList, intItemPos);
       TMemoArrClipList[intItemPos].Free;
       setLength(TMemoArrClipList, intItemPos);
       strLastClipBoardStr := '';
       Clipboard.AsText := '';
       form1.Edit1.Text := '';
    end
    else begin
      intLength := length(TMemoArrClipList);
      for i := intItemPos to length(strArrClipList)-2 do begin
        //ShowMessage(inttostr(i));
        strArrClipList[i] := strArrClipList[i + 1];
        TMemoArrClipList[i].Free;
        TMemoArrClipList[i] := createMemo(TMemoArrClipList[i], strArrClipList[i]);
      end;
      //ShowMessage('For end');
      TMemoArrClipList[intLength-1].free;
      setLength(strArrClipList, length(strArrClipList)-1);
      setLength(TMemoArrClipList, intLength-1);
      //ShowMessage('Delete Array end');
      //TMemoTemp.Free;
    end;
  end;
end;

end.

