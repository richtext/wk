unit uEProdutoNaoEncontrado;

interface

uses
  Sysutils;

type
  EProdutoNaoEncontrado = class(Exception)
  public
    constructor Create(const ACodProduto: Integer); reintroduce;
  end;

implementation

resourcestring
  Msg = 'Produto c�digo %d n�o encontrado.';

constructor EProdutoNaoEncontrado.Create(const ACodProduto: Integer);
begin
  inherited Create(Format(Msg, [ACodProduto]));
end;

end.

