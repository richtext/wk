program wk_firemonkey;

uses
  System.StartUpCopy,
  FMX.Forms,
  ufrm in 'ufrm.pas' {frm},
  uCliente in 'uCliente.pas',
  uDatabaseConfig in 'uDatabaseConfig.pas',
  uWKConnection in 'uWKConnection.pas',
  udtm in 'udtm.pas' {dtm: TDataModule},
  uItemPedido in 'uItemPedido.pas',
  uPedido in 'uPedido.pas',
  uProduto in 'uProduto.pas',
  uEPedidoNaoInformado in 'uEPedidoNaoInformado.pas',
  uEPedidoNaoEncontrado in 'uEPedidoNaoEncontrado.pas',
  uWKObject in 'uWKObject.pas',
  uEProdutoNaoEncontrado in 'uEProdutoNaoEncontrado.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tdtm, dtm);
  Application.CreateForm(Tfrm, frm);
  Application.Run;
end.
