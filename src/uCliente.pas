unit uCliente;

interface

uses
  SysUtils,
  Classes,
  uWKObject;

type
  TCliente = class(TWKObject)
  private
    FCidade: string;
    FCodigo: Integer;
    FNome: string;
    FUF: string;
  public
    function BuscarCliente(const ACodCliente: Integer): Boolean;
    property Cidade: string read FCidade write FCidade;
    property Codigo: Integer read FCodigo write FCodigo;
    property Nome: string read FNome write FNome;
    property UF: string read FUF write FUF;
  end;

  TClientes = class(TWKObjectList<TCliente>)
  public
    procedure BuscarClientes;
  end;

implementation

function TCliente.BuscarCliente(const ACodCliente: Integer): Boolean;
begin
  Query.SQL.Clear;
  Query.SQL.Add('select                         ');
  Query.SQL.Add('  cod_cliente,                 ');
  Query.SQL.Add('  nome_cliente,                ');
  Query.SQL.Add('  cidade_cliente,              ');
  Query.SQL.Add('  uf_cliente                   ');
  Query.SQL.Add('from                           ');
  Query.SQL.Add('  cliente                      ');
  Query.SQL.Add('where                          ');
  Query.SQL.Add('  cod_cliente = :cod_cliente   ');
  Query.ParamByName('cod_cliente').AsInteger := ACodCliente;
  Query.Open;
  try
    Result := not Query.IsEmpty;
    if Result then
    begin
      Codigo := Query.FieldByName('cod_cliente').AsInteger;
      Nome := Query.FieldByName('nome_cliente').AsString;
      Cidade := Query.FieldByName('cidade_cliente').AsString;
      UF := Query.FieldByName('uf_cliente').AsString;
    end;
  finally
    Query.Close;
  end;
end;

procedure TClientes.BuscarClientes;
var
  oCliente: TCliente;
begin
  Clear;
  Query.SQL.Clear;
  Query.SQL.Add('select');
  Query.SQL.Add('  cod_cliente,');
  Query.SQL.Add('  nome_cliente,');
  Query.SQL.Add('  cidade_cliente,');
  Query.SQL.Add('  uf_cliente');
  Query.SQL.Add('from');
  Query.SQL.Add('  cliente');
  Query.SQL.Add('order by');
  Query.SQL.Add('  nome_cliente');
  Query.Open;
  try
    while not Query.Eof do
    begin
      oCliente := TCliente.Create(nil);
      oCliente.Codigo := Query.FieldByName('cod_cliente').AsInteger;
      oCliente.Nome := Query.FieldByName('nome_cliente').AsString;
      oCliente.Cidade := Query.FieldByName('cidade_cliente').AsString;
      oCliente.UF := Query.FieldByName('uf_cliente').AsString;
      Add(oCliente);
      Query.Next;
    end;
  finally
    Query.Close;
  end;
end;

end.
