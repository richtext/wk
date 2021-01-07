unit udtm;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Phys.MySQLDef, FireDAC.UI.Intf,
  FireDAC.ConsoleUI.Wait, FireDAC.Comp.UI, FireDAC.Stan.Intf, FireDAC.Phys,
  FireDAC.Phys.MySQL;

type
  Tdtm = class(TDataModule)
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dtm: Tdtm;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

end.
