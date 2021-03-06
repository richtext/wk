unit uProduto;

interface

uses
  SysUtils,
  Classes,
  uWKObject;

type
  TProduto = class(TWKObject)
  private
    FCodProduto: Integer;
    FDescrProduto: string;
    FPrecoVenda: Currency;
  public
    function BuscarProduto(const ACodProduto: Integer): Boolean;
    property CodProduto: Integer read FCodProduto write FCodProduto;
    property DescrProduto: string read FDescrProduto write FDescrProduto;
    property PrecoVenda: Currency read FPrecoVenda write FPrecoVenda;
  end;

  TProdutos = TWKObjectList<TProduto>;

implementation

function TProduto.BuscarProduto(const ACodProduto: Integer): Boolean;
begin
  Query.SQL.Clear;
  Query.SQL.Add('select                         ');
  Query.SQL.Add('  cod_produto,                 ');
  Query.SQL.Add('  descr_produto,               ');
  Query.SQL.Add('  preco_venda                  ');
  Query.SQL.Add('from                           ');
  Query.SQL.Add('  produto                      ');
  Query.SQL.Add('where                          ');
  Query.SQL.Add('  cod_produto = :cod_produto   ');
  Query.ParamByName('cod_produto').AsInteger := ACodProduto;
  Query.Open;
  try
    Result := not Query.IsEmpty;
    if Result then
    begin
      CodProduto := Query.FieldByName('cod_produto').AsInteger;
      DescrProduto := Query.FieldByName('descr_produto').AsString;
      PrecoVenda := Query.FieldByName('preco_venda').AsCurrency;
    end;
  finally
    Query.Close;
  end;
end;

end.
