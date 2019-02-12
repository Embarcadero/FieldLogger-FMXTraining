unit ReportingDemoMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,

  System.Sensors, Generics.Collections, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, System.Rtti, System.Bindings.Outputs,
  Fmx.Bind.Editors, FMX.WebBrowser, FMX.TabControl, Data.Bind.Components,
  Data.Bind.DBScope, FMX.ListView, FMX.StdCtrls, FMX.Controls.Presentation,
  FMX.ScrollBox, FMX.Memo;

type
  TForm56 = class(TForm)
    ListView1: TListView;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkListControlToField1: TLinkListControlToField;
    TabControl1: TTabControl;
    tabList: TTabItem;
    tabReporting: TTabItem;
    WebBrowser1: TWebBrowser;
    TabItem1: TTabItem;
    Memo1: TMemo;
    AniIndicator1: TAniIndicator;
    ToolBar1: TToolBar;
    SpeedButton1: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TabControl1Change(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
    //FGeocoders: TObjectList<TGeocoder>;
    //procedure OnGeocodeReverseEvent(const Address: TCivicAddress);
    //procedure ReverseLocation(Lat, Long: double);
    procedure GenerateReport;

  public
    { Public declarations }
  end;

var
  Form56: TForm56;

implementation

{$R *.fmx}

uses
  IOUtils, FMX.Surfaces, FieldLogReportDM, System.NetEncoding, Data.DB, System.Threading, FMX.DialogService,
{$IFDEF ANDROID}
  Androidapi.JNI.Os, Androidapi.JNI.JavaTypes, Androidapi.JNI.GraphicsContentViewText, Androidapi.JNI.Net, Androidapi.JNI.Support,
  Androidapi.JNI.App, Androidapi.JNIBridge, Androidapi.Helpers, System.Permissions,

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

procedure TForm56.FormCreate(Sender: TObject);
begin
  TabControl1.ActiveTab := tabList;
end;

procedure TForm56.FormDestroy(Sender: TObject);
begin
end;

{$REGION}
{procedure TForm56.OnGeocodeReverseEvent(const Address: TCivicAddress);
begin
  ShowMessage('Geocoded');
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
end;
}

{procedure TForm56.ReverseLocation( Lat, Long: double );
var
  Geocoder: TGeocoder;
begin
  // Is it supported on this platform?
  if not TGeocoder.Current.Supported then
    exit;

  // Setup an instance of TGeocoder
  Geocoder := FGeocoders.Items[ FGeocoders.Add( TGeocoder.Current.Create )];

  if not Geocoder.Current.Supported then
    Exception.Create('Not supported.');

  Geocoder.OnGeocodeReverse := OnGeocodeReverseEvent;

  // Translate location to address
  Geocoder.GeocodeReverse(TLocationCoord2D.Create(Lat, Long));

  for Geocoder in FGeocoders do
  begin
    if Geocoder.Geocoding then
      ShowMessage('Geocoding!');
  end;
end;}
{$ENDREGION}

procedure TForm56.GenerateReport;
var
  jpegBytes: TByteDynArray;
  html: TStringList;
begin
  html := TStringList.Create;
  try
    html.BeginUpdate;
    try
      html.Add(format('<html><head><title>%s</title></head><body>',
        [TNetEncoding.HTML.Encode(dmFieldLogger.qProjectsPROJ_TITLE.Value)]));
      html.Add(format('<strong>Project:</strong><h1>%s</h1><p><strong>Description:</strong>%s</p>',
        [TNetEncoding.HTML.Encode(dmFieldLogger.qProjectsPROJ_TITLE.Value),
         TNetEncoding.HTML.Encode(dmFieldLogger.qProjectsPROJ_DESC.Value)]));
      html.Add('<hr><p><strong>Entries:</strong></p>');

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

    finally
      html.EndUpdate;
      TThread.Synchronize(nil,procedure begin
        WebBrowser1.LoadFromStrings(html.Text, 'about:blank');
        AniIndicator1.Visible := True;
        AniIndicator1.Enabled := True;
        WebBrowser1.Visible := True;

        Application.ProcessMessages;
        memo1.BeginUpdate;
        try
          memo1.Text := html.Text;
        finally
          Memo1.EndUpdate;
        end;
      end);
    end;
  finally
    html.DisposeOf;
  end;
end;

function LaunchActivity(const Intent: JIntent): Boolean; overload;
var
  ResolveInfo: JResolveInfo;
begin
  ResolveInfo := TAndroidHelper.Activity.getPackageManager.resolveActivity(Intent, 0);
  Result := ResolveInfo <> nil;
  if Result then
    TAndroidHelper.Activity.startActivity(Intent);
end;

procedure CreateEmail(const Subject, Content, Attachment: string); overload;
var
  Intent: JIntent;
  Uri: Jnet_Uri;
  AttachmentFile: JFile;
  LAuthority: JString;
begin
  Intent := TJIntent.JavaClass.init(TJIntent.JavaClass.ACTION_SEND);
  Intent.putExtra(TJIntent.JavaClass.EXTRA_SUBJECT, StringToJString(Subject));
  Intent.putExtra(TJIntent.JavaClass.EXTRA_TEXT, StringToJString(Content));
  Intent.setType(StringToJString('message/rfc822'));

  if Attachment <> '' then
  begin
    AttachmentFile :=  TJFile.JavaClass.init(TAndroidHelper.StringToJString(Attachment));

    Uri := TAndroidHelper.JFileToJURI(AttachmentFile);

{    LAuthority :=  TAndroidHelper.Context.getApplicationContext.getPackageName;
    if JStringToString(LAuthority).Length = 0 then
      LAuthority := StringToJString('com.embarcadero.ReportingDemo.fileprovider')
    else
      LAuthority := LAuthority.concat(StringToJString('.fileprovider'));
    Uri := TJFileProvider.JavaClass.getUriForFile(TAndroidHelper.Context, LAuthority, AttachmentFile);}

    Intent.putExtra(TJIntent.JavaClass.EXTRA_STREAM, TJParcelable.Wrap((Uri as ILocalObject).GetObjectID));
  end;

  LaunchActivity(TJIntent.JavaClass.createChooser(Intent, StrToJCharSequence('How to send your report?')));
end;

procedure TForm56.SpeedButton1Click(Sender: TObject);
var
  filename: string;
begin
  {$IFDEF ANDROID}
  PermissionsService.RequestPermissions([
      JStringToString(TJManifest_permission.JavaClass.WRITE_EXTERNAL_STORAGE)],
    procedure(const APermissions: TArray<string>; const AGrantResults: TArray<TPermissionStatus>)
    begin
      if (Length(AGrantResults) = 1) and (AGrantResults[0] = TPermissionStatus.Granted) then
      begin
        {$ENDIF}
        filename := TPath.Combine(TPath.GetCachePath, 'report.html');
        Memo1.Lines.SaveToFile(filename);
        CreateEmail('report','This is my report!',filename);
        {$IFDEF ANDROID}
      end
      else
        TDialogService.MessageDialog('Unable to save report for sharing.',TMsgDlgType.mtWarning,
          [TMsgDlgBtn.mbCancel], TMsgDlgBtn.mbCancel, 0, nil);
    end);
  {$ENDIF}
end;



procedure TForm56.TabControl1Change(Sender: TObject);
begin
  if TabControl1.ActiveTab = tabReporting then
  begin
    WebBrowser1.Visible := False;
    AniIndicator1.Visible := True;
    AniIndicator1.Enabled := True;
    Application.ProcessMessages;

    TTask.Create(procedure begin
      GenerateReport;
    end).Start;
  end;
end;

end.
