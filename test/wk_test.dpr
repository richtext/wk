program wk_test;
{

  Delphi DUnit Test Project
  -------------------------
  This project contains the DUnit test framework and the GUI/Console test runners.
  Add "CONSOLE_TESTRUNNER" to the conditional defines entry in the project options
  to use the console test runner.  Otherwise the GUI test runner will be used by
  default.

}

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  DUnitTestRunner,
  uTestDatabaseConfig in 'uTestDatabaseConfig.pas',
  uTestWKConnection in 'uTestWKConnection.pas',
  udtm in 'udtm.pas' {dtm: TDataModule},
  uWKConnection in '..\src\uWKConnection.pas',
  uPedido in '..\src\uPedido.pas',
  uItemPedido in '..\src\uItemPedido.pas',
  uCliente in '..\src\uCliente.pas',
  uProduto in '..\src\uProduto.pas',
  uEProdutoNaoEncontrado in '..\src\uEProdutoNaoEncontrado.pas',
  uWKObject in '..\src\uWKObject.pas',
  uEPedidoNaoEncontrado in '..\src\uEPedidoNaoEncontrado.pas',
  uEPedidoNaoInformado in '..\src\uEPedidoNaoInformado.pas',
  uDatabaseConfig in '..\src\uDatabaseConfig.pas';

{$R *.RES}

begin
  dtm := Tdtm.Create(nil);
  DUnitTestRunner.RunRegisteredTests;
end.

