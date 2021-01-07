unit udtm;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Phys.MySQLDef, FireDAC.UI.Intf,
  FireDAC.ConsoleUI.Wait, FireDAC.Comp.UI, FireDAC.Stan.Intf, FireDAC.Phys,
  FireDAC.Phys.MySQL,
  uWKConnection, Data.Bind.Components, Data.Bind.ObjectScope;

const
  cConfigFile = 'wk.ini';

type
  Tdtm = class(TDataModule)
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    FDB: TWKConnection;
  public
    property DB: TWKConnection read FDB;
  end;

var
  dtm: Tdtm;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

uses
  IOUtils;

{$R *.dfm}

procedure Tdtm.DataModuleCreate(Sender: TObject);
begin
  FDB := TWKConnection.Create(
    TPath.Combine(
      TPath.GetHomePath, cConfigFile
    )
  );

end;

procedure Tdtm.DataModuleDestroy(Sender: TObject);
begin
  FDB.Free;
end;

end.