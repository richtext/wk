unit uEPedidoNaoEncontrado;

interface

uses
  Sysutils;

type
  EPedidoNaoEncontrado = class(Exception)
  public
    constructor Create(const ANroPedido: Integer); reintroduce;
  end;

implementation

resourcestring
  Msg = 'Pedido nro. %d não encontrado.';

constructor EPedidoNaoEncontrado.Create(const ANroPedido: Integer);
begin
  inherited Create(Format(Msg, [ANroPedido]));
end;

end.

