unit FieldLogReportMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, System.Rtti,
  FMX.Grid.Style, Data.Bind.EngExt, Fmx.Bind.DBEngExt, Fmx.Bind.Grid,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.Controls, FMX.Layouts,
  Fmx.Bind.Navigator, Data.Bind.Components, Data.Bind.Grid, Data.Bind.DBScope,
  FMX.ScrollBox, FMX.Grid, FMX.Controls.Presentation, FMX.Edit, FMX.TabControl,
  FMX.StdCtrls, FMX.WebBrowser, FMX.Memo, FMX.Objects,

  System.Sensors, Generics.Collections;

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
    Button3: TButton;
    Layout1: TLayout;
    Image1: TImage;
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FGeocoders: TObjectList<TGeocoder>;
    html: TStringList;
    procedure OnGeocodeReverseEvent(const Address: TCivicAddress);
    procedure ReverseLocation(Lat, Long: double);
  public
    { Public declarations }
  end;

var
  Form53: TForm53;

implementation

{$R *.fmx}

uses
  IOUtils, FMX.Surfaces, FieldLogReportDM, System.NetEncoding, Data.DB,
{$IFDEF ANDROID}
  Androidapi.JNI.Os, Androidapi.JNI.JavaTypes, Androidapi.Helpers,
  System.Android.Sensors;
{$ENDIF ANDROID}
{$IFDEF IOS}
  System.iOS.Sensors;
{$ENDIF IOS}
{$IFDEF MACOS}
  System.Mac.Sensors;
{$ENDIF MACOS}
{$IFDEF MSWINDOWS}
  System.Win.Sensors;
{$ENDIF}

{$REGION 'stale code'}
  {
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
        LOutputStream.DisposeOf;
      end;
    finally
      LInputStream.DisposeOf;
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
      Surface.DisposeOf;
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
      img.DisposeOf;
    end;
    mem.Position := 0;
  end;
  }

{$ENDREGION}

procedure TForm53.OnGeocodeReverseEvent(const Address: TCivicAddress);
begin
  ShowMessage('test');
{
  lblSubThoroughfare.Text := Address.SubThoroughfare;
  lblThoroughfare.Text := Address.Thoroughfare;
  lblSubLocality.Text := Address.SubLocality;
  lblSubAdminArea.Text := Address.SubAdminArea;
  lblZipCode.Text := Address.PostalCode;
  lblLocality.Text := Address.Locality;
  lblFeature.Text := Address.FeatureName;
  lblCountry.Text := Address.CountryName;
  lblCountryCode.Text := Address.CountryCode;
  lblAdminArea.Text := Address.AdminArea;
}
end;

procedure TForm53.ReverseLocation( Lat, Long: double );
var
  Geocoder: TGeocoder;
begin
  // Setup an instance of TGeocoder
  Geocoder := FGeocoders.Items[ FGeocoders.Add( TGeocoder.Current.Create )];

  if not Geocoder.Supported then
    Exception.Create('Not supported.');

  Geocoder.OnGeocodeReverse := OnGeocodeReverseEvent;

  // Translate location to address
  Geocoder.GeocodeReverse(TLocationCoord2D.Create(Lat, Long));
  
  for Geocoder in FGeocoders do
  begin
    if Geocoder.Geocoding then
      ShowMessage('Geocoding!');
  end;
end;


procedure TForm53.Button3Click(Sender: TObject);
var
  jpegBytes: TByteDynArray;

begin
  html := TStringList.Create;
  try
    html.BeginUpdate;
    try
      html.Add(format('<html><head><title>%s</title></head><body>',
        [TNetEncoding.HTML.Encode(dmFieldLogger.qProjectsPROJ_TITLE.Value)]));
      html.Add(format('<strong>Project</strong><h1>%s</h1><p><strong>Description:</strong>%s</p>',
        [TNetEncoding.HTML.Encode(dmFieldLogger.qProjectsPROJ_TITLE.Value),
         TNetEncoding.HTML.Encode(dmFieldLogger.qProjectsPROJ_DESC.Value)]));
      html.Add('<p><strong>Log Entries:</strong></p>');

      {
      dmFieldLogger.qLogEntries.First;

      while not dmFieldLogger.qLogEntries.Eof do
      begin
        ReverseLocation(
          dmFieldLogger.qLogEntriesLATITUDE.Value,
          dmFieldLogger.qLogEntriesLONGITUDE.Value);

        dmFieldLogger.qLogEntries.Next;
      end;
      }

      dmFieldLogger.qLogEntries.First;

      while not dmFieldLogger.qLogEntries.Eof do
      begin
        jpegBytes := ResizeJpegField(dmFieldLogger.qLogEntriesPICTURE, 512);

        html.Add(format('<h2>%s</h2><p>%s</p>'+
          '<img src="data:image/jpg;base64,%s" alt="%s" />',
          [DateTimeToStr(dmFieldLogger.qLogEntriesTIMEDATESTAMP.AsDateTime),
           TNetEncoding.HTML.Encode(dmFieldLogger.qLogEntriesNOTE.Value),
           TNetEncoding.Base64.EncodeBytesToString(jpegBytes),
           DateTimeToStr(dmFieldLogger.qLogEntriesTIMEDATESTAMP.AsDateTime)]));

        html.Add('<table>');
        html.Add(format('<tr><td>Lat, Long:</td><td>%f, %f</td></tr>',
          [dmFieldLogger.qLogEntriesLATITUDE.Value,dmFieldLogger.qLogEntriesLONGITUDE.Value]));
        html.Add(format('<tr><td>Orentation:</td><td>%f, %f, %f</td></tr>',
          [dmFieldLogger.qLogEntriesOR_X.Value,dmFieldLogger.qLogEntriesOR_Y.Value,dmFieldLogger.qLogEntriesOR_Z.Value]));
        html.Add(format('<tr><td>Heading:</td><td>%f, %f, %f</td></tr>',
          [dmFieldLogger.qLogEntriesHEADING_X.Value, dmFieldLogger.qLogEntriesHEADING_Y.Value, dmFieldLogger.qLogEntriesHEADING_Z.Value]));
        html.Add(format('<tr><td>Velocity:</td><td>%f, %f, %f</td></tr>',
          [dmFieldLogger.qLogEntriesV_X.Value, dmFieldLogger.qLogEntriesV_Y.Value, dmFieldLogger.qLogEntriesV_Z.Value]));
        html.Add(format('<tr><td>Angle:</td><td>%f, %f, %f</td></tr>',
          [dmFieldLogger.qLogEntriesANGLE_X.Value, dmFieldLogger.qLogEntriesANGLE_Y.Value, dmFieldLogger.qLogEntriesANGLE_Z.Value]));
        html.Add(format('<tr><td>Motion:</td><td>%f</td></tr>',[dmFieldLogger.qLogEntriesMOTION.Value]));
        html.Add(format('<tr><td>Speed:</td><td>%f</td></tr>',[dmFieldLogger.qLogEntriesSPEED.Value]));
        html.Add('</table><hr>');
        dmFieldLogger.qLogEntries.Next;
      end;

      html.Add('</body></html>');
      WebBrowser1.LoadFromStrings(html.Text, 'about:blank');
      memo1.Text := html.Text;
    finally
      Memo1.EndUpdate;
    end;
  finally
    html.free;
  end;
end;

procedure TForm53.FormCreate(Sender: TObject);
begin
  FGeocoders := TObjectList<TGeocoder>.Create;
end;

procedure TForm53.FormDestroy(Sender: TObject);
begin
  FGeocoders.Free;
end;

end.
