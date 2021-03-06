unit uWKObject;

interface

uses
  Sysutils,
  Classes,
  Generics.Collections,
  FireDAC.Comp.Client,
  uWKConnection;

type
  TWKObject = class(TComponent)
  private
    FDB: TWKConnection;
    FQuery: TFDQuery;
  protected
    property DB: TWKConnection read FDB;
    property Query: TFDQuery read FQuery;
  public
    constructor Create(const ADB: TWKConnection); reintroduce; virtual;
    destructor Destroy; override;
  end;

  TWKObjectList<T: TWKObject> = class(TObjectList<T>)
  private
    FDB: TWKConnection;
    FQuery: TFDQuery;
  protected
    property DB: TWKConnection read FDB;
    property Query: TFDQuery read FQuery;
  public
    constructor Create(const ADB: TWKConnection); reintroduce; virtual;
    destructor Destroy; override;
  end;

implementation

{ TWKObject }

constructor TWKObject.Create(const ADB: TWKConnection);
begin
  inherited Create(nil);
  FDB := ADB;
  FQuery := TFDQuery.Create(nil);
  FQuery.Connection := FDB;
end;

destructor TWKObject.Destroy;
begin
  FQuery.Free;
  inherited;
end;

{ TWKObjectList }

constructor TWKObjectList<T>.Create(const ADB: TWKConnection);
begin
  inherited Create(True);
  FDB := ADB;
  FQuery := TFDQuery.Create(nil);
  FQuery.Connection := FDB;
end;

destructor TWKObjectList<T>.Destroy;
begin
  FQuery.Free;
  inherited;
end;

end.
