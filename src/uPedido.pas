unit uPedido;

interface

uses
  SysUtils,
  Classes,
  Generics.Collections,
  uWKConnection,
  uWKObject,
  uItemPedido;

type
  TPedido = class(TWKObject)
  private
    FCodCliente: Integer;
    FDataEmissao: TDateTime;
    FNomeCliente: string;
    FNroPedido: Integer;
    FVlrTotal: Currency;
    FItensPedido: TItensPedido;
    FCidadeCliente: string;
    FUFCliente: string;
    procedure InserirPedido;
    procedure AtualizarPedido;
  public
    constructor Create(const AConnection: TWKConnection); override;
    destructor Destroy; override;
    procedure Clear;
    procedure Totalizar;
    procedure Gravar;
    procedure Excluir;
    function BuscarPedido(const ANroPedido: Integer): Boolean;
    property CodCliente: Integer read FCodCliente write FCodCliente;
    property DataEmissao: TDateTime read FDataEmissao write FDataEmissao;
    property NomeCliente: string read FNomeCliente write FNomeCliente;
    property CidadeCliente: string read FCidadeCliente write FCidadeCliente;
    property UFCliente: string read FUFCliente write FUFCliente;
    property NroPedido: Integer read FNroPedido write FNroPedido;
    property VlrTotal: Currency read FVlrTotal write FVlrTotal;
    property ItensPedido: TItensPedido read FItensPedido write FItensPedido;
  end;

  TPedidos = TWKObjectList<TPedido>;

implementation

{ TPedido }

constructor TPedido.Create(const AConnection: TWKConnection);
begin
  inherited Create(AConnection);
  FItensPedido := TItensPedido.Create(AConnection);
end;

destructor TPedido.Destroy;
begin
  FItensPedido.Free;
  inherited;
end;

procedure TPedido.Excluir;
begin
  Query.SQL.Clear;
  Query.SQL.Add('delete from                  ');
  Query.SQL.Add('  pedido                     ');
  Query.SQL.Add('where                        ');
  Query.SQL.Add('  nro_pedido = :nro_pedido   ');
  Query.ParamByName('nro_pedido').AsInteger := NroPedido;
  Query.ExecSQL;
  Clear;
end;

procedure TPedido.Gravar;
begin
  if NroPedido = 0 then
    InserirPedido
  else
    AtualizarPedido;
  ItensPedido.SetarNroPedido(NroPedido);
  ItensPedido.Gravar(NroPedido);
end;

procedure TPedido.InserirPedido;
begin
  Query.SQL.Clear;
  Query.SQL.Add('insert into pedido (     ');
  Query.SQL.Add('  data_emissao,          ');
  Query.SQL.Add('  cod_cliente,           ');
  Query.SQL.Add('  vlr_total              ');
  Query.SQL.Add(') values (');
  Query.SQL.Add('  :data_emissao,          ');
  Query.SQL.Add('  :cod_cliente,           ');
  Query.SQL.Add('  :vlr_total              ');
  Query.SQL.Add(')');
  Query.ParamByName('data_emissao').AsDateTime := DataEmissao;
  Query.ParamByName('cod_cliente').AsInteger := CodCliente;
  Query.ParamByName('vlr_total').AsCurrency := VlrTotal;
  Query.ExecSQL;
  Query.SQL.Clear;
  Query.SQL.Add('select last_insert_id()');
  Query.Open;
  try
    NroPedido := Query.Fields[0].AsInteger;
  finally
    Query.Close;
  end;
end;

procedure TPedido.AtualizarPedido;
begin
  Query.SQL.Clear;
  Query.SQL.Add('update pedido set                  ');
  Query.SQL.Add('  data_emissao = :data_emissao,    ');
  Query.SQL.Add('  cod_cliente = :cod_cliente,      ');
  Query.SQL.Add('  vlr_total = :vlr_total           ');
  Query.SQL.Add('where                              ');
  Query.SQL.Add('  nro_pedido = :nro_pedido         ');
  Query.ParamByName('data_emissao').AsDateTime := DataEmissao;
  Query.ParamByName('cod_cliente').AsInteger := CodCliente;
  Query.ParamByName('vlr_total').AsCurrency := VlrTotal;
  Query.ParamByName('nro_pedido').AsInteger := NroPedido;
  Query.ExecSQL;
end;

procedure TPedido.Totalizar;
begin
  FVlrTotal := ItensPedido.Totalizar;
end;

procedure TPedido.Clear;
begin
  FCodCliente := 0;
  FDataEmissao := Trunc(Now);
  FNomeCliente := EmptyStr;
  FCidadeCliente := EmptyStr;
  FUFCliente := EmptyStr;
  FNroPedido := 0;
  FVlrTotal := 0;
  FItensPedido.Clear;
end;

function TPedido.BuscarPedido(const ANroPedido: Integer): Boolean;
begin
  Query.SQL.Clear;
  Query.SQL.Add('select                                         ');
  Query.SQL.Add('  p.cod_cliente,                               ');
  Query.SQL.Add('  p.data_emissao,                              ');
  Query.SQL.Add('  p.nro_pedido,                                ');
  Query.SQL.Add('  p.vlr_total,                                 ');
  Query.SQL.Add('  c.nome_cliente,                              ');
  Query.SQL.Add('  c.cidade_cliente,                            ');
  Query.SQL.Add('  c.uf_cliente                                 ');
  Query.SQL.Add('from                                           ');
  Query.SQL.Add('  pedido p                                     ');
  Query.SQL.Add('inner join                                     ');
  Query.SQL.Add(' cliente c on c.cod_cliente = p.cod_cliente    ');
  Query.SQL.Add('where                                          ');
  Query.SQL.Add('  p.nro_pedido = :nro_pedido                   ');
  Query.ParamByName('nro_pedido').AsInteger := ANroPedido;
  Query.Open;
  try
    Result := not Query.IsEmpty;
    if Result then
    begin
      Clear;
      CodCliente := Query.FieldByName('cod_cliente').AsInteger;
      DataEmissao := Query.FieldByName('data_emissao').AsDateTime;
      NroPedido := Query.FieldByName('nro_pedido').AsInteger;
      VlrTotal := Query.FieldByName('vlr_total').AsCurrency;
      NomeCliente := Query.FieldByName('nome_cliente').AsString;
      CidadeCliente := Query.FieldByName('cidade_cliente').AsString;
      UFCliente := Query.FieldByName('uf_cliente').AsString;
    end;
  finally
    Query.Close;
  end;
  if Result then
    ItensPedido.BuscarItensPedido(ANroPedido);
end;

end.
