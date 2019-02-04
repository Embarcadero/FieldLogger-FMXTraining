unit FieldLogReportMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, System.Rtti,
  FMX.Grid.Style, Data.Bind.EngExt, Fmx.Bind.DBEngExt, Fmx.Bind.Grid,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.Controls, FMX.Layouts,
  Fmx.Bind.Navigator, Data.Bind.Components, Data.Bind.Grid, Data.Bind.DBScope,
  FMX.ScrollBox, FMX.Grid, FMX.Controls.Presentation, FMX.Edit, FMX.TabControl,
  FMX.StdCtrls, FMX.WebBrowser, FMX.Memo, FMX.Objects;

type
  TForm53 = class(TForm)
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    TabItem3: TTabItem;
    Edit1: TEdit;
    Grid1: TGrid;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkGridToDataSourceBindSourceDB1: TLinkGridToDataSource;
    Grid2: TGrid;
    BindSourceDB2: TBindSourceDB;
    LinkGridToDataSourceBindSourceDB2: TLinkGridToDataSource;
    NavigatorBindSourceDB1: TBindNavigator;
    NavigatorBindSourceDB2: TBindNavigator;
    Memo1: TMemo;
    WebBrowser1: TWebBrowser;
    Button2: TButton;
    Button3: TButton;
    Layout1: TLayout;
    Image1: TImage;
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form53: TForm53;

implementation

{$R *.fmx}

uses
  IOUtils, FMX.Surfaces, FieldLogReportDM, System.NetEncoding;

// Based on code by Dave Nottage, Embarcadero MVP - delphiworlds.com
function BitmapAsBase64(const ABitmap: TBitmap): string; overload;
var
  LInputStream: TBytesStream;
  LOutputStream: TStringStream;
begin
  Result := '';
  if not(assigned(ABitmap)) or ABitmap.IsEmpty then
    Exit;
  LInputStream := TBytesStream.Create;
  try
    ABitmap.SaveToStream(LInputStream);
    LInputStream.Position := 0;
    LOutputStream := TStringStream.Create('');
    try
      TNetEncoding.Base64.Encode(LInputStream, LOutputStream);
      Result := LOutputStream.DataString;
    finally
      LOutputStream.Free;
    end;
  finally
    LInputStream.Free;
  end;
end;

function GetAsBase64(const ABitmap: TBitmap): string; overload;
var
  LInputStream: TBytesStream;
  LOutputStream: TStringStream;
begin
  Result := '';
  if not(assigned(ABitmap)) or ABitmap.IsEmpty then Exit;
  LInputStream := TBytesStream.Create;
  try
    ABitmap.SaveToStream(LInputStream);
    LInputStream.Position := 0;
    LOutputStream := TStringStream.Create('');
    try
      TNetEncoding.Base64.Encode(LInputStream, LOutputStream);
      Result := LOutputStream.DataString;
    finally
      LOutputStream.Free;
    end;
  finally
    LInputStream.Free;
  end;
end;

procedure LoadJPEGSteam(bitmap: TBitmap; mem: TMemoryStream);
var
  surface: TBitmapSurface;
begin
  surface := TBitmapSurface.Create;
  try
    Surface.Assign(bitmap);
    TBitmapCodecManager.SaveToStream(mem, Surface, 'jpg');
  finally
    Surface.Free;
  end;
  mem.Position := 0;
end;

procedure DisplayJPEGStream(bitmap: TBitmap; mem: TMemoryStream);
var
  img: TBitmap;
begin
  img := TBitmap.Create;
  try
    mem.Position := 0;
    img.LoadFromStream(mem);
    Bitmap.SetSize(img.Width, img.Height);
    Bitmap.Canvas.BeginScene;
    try
      Bitmap.Canvas.DrawBitmap(img, img.BoundsF, bitmap.BoundsF, 1);
    finally
      Bitmap.Canvas.EndScene;
    end;
  finally
    img.Free;
  end;
  mem.Position := 0;
end;

procedure TForm53.Button2Click(Sender: TObject);
begin
  Memo1.Lines.SaveToFile('test.html');
  WebBrowser1.Navigate('file://' + GetCurrentDir + '/test.html');
end;

procedure TForm53.Button3Click(Sender: TObject);
var
  blob: TBlobStream;
begin
  Memo1.ClearContent;

  Memo1.BeginUpdate;
  try
    Memo1.Lines.Add(format('<html><head><title>%s</title></head><body>',
      [TNetEncoding.HTML.Encode(dmFieldLogger.qProjectsPROJ_TITLE.Value)]));
    Memo1.Lines.Add(format('<h1>%s</h1><p>%s</p>',
      [TNetEncoding.HTML.Encode(dmFieldLogger.qProjectsPROJ_TITLE.Value),
       TNetEncoding.HTML.Encode(dmFieldLogger.qProjectsPROJ_DESC.Value)]));

    dmFieldLogger.qLogEntries.First;

    while not dmFieldLogger.qLogEntries.Eof do
    begin
      blob := dmFieldLogger.qLogEntries.CreateBlobStream(
        dmFieldLogger.qLogEntriesPICTURE, TBlobStreamMode.bmRead)
      //mem := TMemoryStream.Create;
      //jpg := TBitmap.Create;
      try
        //mem.Write(dmFieldLogger.qLogEntriesPICTURE.Value, dmFieldLogger.qLogEntriesPICTURE.Size);
        Memo1.Lines.Add(format('<h2>%s</h2><p>%s</p>'+
          '<img src="data:image/jpg;base64,%s" alt="%s" />',
          [DateTimeToStr(dmFieldLogger.qLogEntriesTIMEDATESTAMP.AsDateTime),
           TNetEncoding.HTML.Encode(dmFieldLogger.qLogEntriesNOTE.Value),
           TNetEncoding.Base64.EncodeBytesToString(),
           DateTimeToStr(dmFieldLogger.qLogEntriesTIMEDATESTAMP.AsDateTime)]));


      finally
        //jpg.Free;
      end;
      dmFieldLogger.qLogEntries.Next;
    end;
  finally
    Memo1.EndUpdate;
  end;
end;



end.
