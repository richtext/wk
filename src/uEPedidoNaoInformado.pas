unit uEPedidoNaoInformado;

interface

uses
  Sysutils;

type
  EPedidoNaoInformado = class(Exception)
  public
    constructor Create; reintroduce;
  end;

implementation

resourcestring
  Msg = 'Informe o nro. do pedido.';

constructor EPedidoNaoInformado.Create;
begin
  inherited Create(Msg);
end;

end.
