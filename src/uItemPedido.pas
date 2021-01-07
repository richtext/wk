unit uItemPedido;

interface

uses
  SysUtils,
  Classes,
  uWKConnection,
  uWKObject;

type
  TItemPedido = class(TWKObject)
  private
    FCodProduto: Integer;
    FCodSequencia: Integer;
    FDescrProduto: string;
    FNroPedido: Integer;
    FQtdeItens: Integer;
    FVlrTotal: Double;
    FVlrUnitario: Double;
    procedure SetQtdeItens(const Value: Integer);
    procedure SetVlrUnitario(const Value: Double);
    procedure AtualizarItem;
    procedure InserirItem;
  public
    procedure Clear;
    procedure Assign(const AItemPedido: TItemPedido);
    procedure Gravar;
    property CodProduto: Integer read FCodProduto write FCodProduto;
    property CodSequencia: Integer read FCodSequencia write FCodSequencia;
    property DescrProduto: string read FDescrProduto write FDescrProduto;
    property NroPedido: Integer read FNroPedido write FNroPedido;
    property QtdeItens: Integer read FQtdeItens write SetQtdeItens;
    property VlrTotal: Double read FVlrTotal write FVlrTotal;
    property VlrUnitario: Double read FVlrUnitario write SetVlrUnitario;

  end;

  TItensPedido = class(TWKObjectList<TItemPedido>)
  private
    procedure ExcluirInexistentes(const ANroPedido: Integer);
  public
    function Totalizar: Double;
    procedure Gravar(const ANroPedido: Integer);
    procedure SetarNroPedido(const ANroPedido: Integer);
    procedure BuscarItensPedido(const ANroPedido: Integer);
    procedure BuscarItemPorSequencia(const ACodSequencia: Integer;
      var AItemPedido: TItemPedido);
  end;

implementation

{ TItensPedido }

procedure TItensPedido.BuscarItemPorSequencia(const ACodSequencia: Integer;
  var AItemPedido: TItemPedido);
var
  i: Integer;
begin
  AItemPedido := nil;
  for i := 0 to Count - 1 do
  begin
    if Items[i].CodSequencia = ACodSequencia then
    begin
      AItemPedido := Items[i];
      Break;
    end;
  end;
end;

procedure TItensPedido.BuscarItensPedido(const ANroPedido: Integer);
var
  oItemPedido: TItemPedido;
begin
  Clear;
  Query.SQL.Clear;
  Query.SQL.Add('select                                        ');
  Query.SQL.Add('  i.cod_sequencia,                            ');
  Query.SQL.Add('  i.nro_pedido,                               ');
  Query.SQL.Add('  i.cod_produto,                              ');
  Query.SQL.Add('  i.qtd,                                      ');
  Query.SQL.Add('  i.vlr_unitario,                             ');
  Query.SQL.Add('  i.vlr_total,                                ');
  Query.SQL.Add('  p.descr_produto                            ');
  Query.SQL.Add('from                                          ');
  Query.SQL.Add('  pedido_item i                               ');
  Query.SQL.Add('inner join                                    ');
  Query.SQL.Add('  produto p on p.cod_produto = i.cod_produto  ');
  Query.SQL.Add('where                                         ');
  Query.SQL.Add('  i.nro_pedido = :nro_pedido                  ');
  Query.ParamByName('nro_pedido').AsInteger := ANroPedido;
  Query.Open;
  try
    while not Query.Eof do
    begin
      oItemPedido := TItemPedido.Create(DB);
      oItemPedido.CodSequencia := Query.FieldByName('cod_sequencia').AsInteger;
      oItemPedido.NroPedido := Query.FieldByName('nro_pedido').AsInteger;
      oItemPedido.CodProduto := Query.FieldByName('cod_produto').AsInteger;
      oItemPedido.QtdeItens := Query.FieldByName('qtd').AsInteger;
      oItemPedido.VlrUnitario := Query.FieldByName('vlr_unitario').AsCurrency;
      oItemPedido.VlrTotal := Query.FieldByName('vlr_total').AsCurrency;
      oItemPedido.DescrProduto := Query.FieldByName('descr_produto').AsString;
      Add(oItemPedido);
      Query.Next;
    end;
  finally
    Query.Close;
  end;
end;

procedure TItensPedido.Gravar(const ANroPedido: Integer);
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    Items[I].Gravar;
  ExcluirInexistentes(ANroPedido);
end;

procedure TItensPedido.ExcluirInexistentes(const ANroPedido: Integer);
var
  lstIn: TStringList;
  i: Integer;
begin
  lstIn := TStringList.Create;
  try
    for i := 0 to Count - 1 do
      lstIn.Add(IntToStr(Items[i].CodSequencia));
    Query.SQL.Clear;
    Query.SQL.Add('delete from                                        ');
    Query.SQL.Add('  pedido_item                                      ');
    Query.SQL.Add('where                                              ');
    Query.SQL.Add('  nro_pedido = :nro_pedido                         ');
    if Count > 0 then
    begin
      Query.SQL.Add('and                                                ');
      Query.SQL.Add('  cod_sequencia not in (' + lstIn.CommaText + ')   ');
    end;
    Query.ParamByName('nro_pedido').AsInteger := ANroPedido;
    Query.ExecSQL;
  finally
    lstIn.Free;
  end;
end;

procedure TItensPedido.SetarNroPedido(const ANroPedido: Integer);
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    Items[i].NroPedido := ANroPedido;
end;

function TItensPedido.Totalizar: Double;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to Count - 1 do
    Result := Result + Items[i].VlrTotal;
end;

{ TItemPedido }

procedure TItemPedido.Assign(const AItemPedido: TItemPedido);
begin
  CodProduto := AItemPedido.CodProduto;
  CodSequencia := AItemPedido.CodSequencia;
  DescrProduto := AItemPedido.DescrProduto;
  NroPedido := AItemPedido.NroPedido;
  QtdeItens := AItemPedido.QtdeItens;
  VlrTotal := AItemPedido.VlrTotal;
  VlrUnitario := AItemPedido.VlrUnitario;
end;

procedure TItemPedido.Clear;
begin
  CodProduto := 0;
  CodSequencia := 0;
  DescrProduto := EmptyStr;
  NroPedido := 0;
  QtdeItens := 0;
  VlrTotal := 0;
  VlrUnitario := 0;
end;

procedure TItemPedido.InserirItem;
begin
  Query.SQL.Clear;
  Query.SQL.Add('insert into pedido_item (      ');
  Query.SQL.Add('  nro_pedido,                  ');
  Query.SQL.Add('  cod_produto,                 ');
  Query.SQL.Add('  qtd,                         ');
  Query.SQL.Add('  vlr_unitario,                ');
  Query.SQL.Add('  vlr_total                    ');
  Query.SQL.Add(') values (                     ');
  Query.SQL.Add('  :nro_pedido,                 ');
  Query.SQL.Add('  :cod_produto,                ');
  Query.SQL.Add('  :qtd,                        ');
  Query.SQL.Add('  :vlr_unitario,               ');
  Query.SQL.Add('  :vlr_total                   ');
  Query.SQL.Add(')');
  Query.ParamByName('nro_pedido').AsInteger := NroPedido;
  Query.ParamByName('cod_produto').AsInteger := CodProduto;
  Query.ParamByName('qtd').AsFloat := QtdeItens;
  Query.ParamByName('vlr_unitario').AsCurrency := VlrUnitario;
  Query.ParamByName('vlr_total').AsCurrency := VlrTotal;
  Query.ExecSQL;
  Query.SQL.Clear;
  Query.SQL.Add('select last_insert_id()');
  Query.Open;
  try
    CodSequencia := Query.Fields[0].AsInteger;
  finally
    Query.Close;
  end;
end;

procedure TItemPedido.AtualizarItem;
begin
  Query.SQL.Clear;
  Query.SQL.Add('update pedido_item set           ');
  Query.SQL.Add('  nro_pedido = :nro_pedido,      ');
  Query.SQL.Add('  cod_produto = :cod_produto,    ');
  Query.SQL.Add('  qtd = :qtd,                    ');
  Query.SQL.Add('  vlr_unitario = :vlr_unitario,  ');
  Query.SQL.Add('  vlr_total = :vlr_total         ');
  Query.SQL.Add('where                            ');
  Query.SQL.Add('  cod_sequencia = :cod_sequencia ');
  Query.ParamByName('nro_pedido').AsInteger := NroPedido;
  Query.ParamByName('cod_produto').AsInteger := CodProduto;
  Query.ParamByName('qtd').AsFloat := QtdeItens;
  Query.ParamByName('vlr_unitario').AsCurrency := VlrUnitario;
  Query.ParamByName('vlr_total').AsCurrency := VlrTotal;
  Query.ParamByName('cod_sequencia').AsInteger := CodSequencia;
  Query.ExecSQL;
end;

procedure TItemPedido.Gravar;
begin
  if CodSequencia = 0 then
    InserirItem
  else
    AtualizarItem;
end;

procedure TItemPedido.SetQtdeItens(const Value: Integer);
begin
  FQtdeItens := Value;
  FVlrTotal := FQtdeItens * FVlrUnitario;
end;

procedure TItemPedido.SetVlrUnitario(const Value: Double);
begin
  FVlrUnitario := Value;
  FVlrTotal := FQtdeItens * FVlrUnitario;
end;

end.
