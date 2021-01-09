unit ufrm;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  Generics.Collections,
  uCliente,
  uProduto,
  uPedido,
  uItemPedido,
  FMX.ListView.Types,
  FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base,
  FMX.ListView,
  uWKConnection,
  Data.Bind.EngExt,
  Fmx.Bind.DBEngExt,
  Data.Bind.Components,
  Data.Bind.ObjectScope,
  System.Rtti,
  System.Bindings.Outputs,
  Fmx.Bind.Editors,
  Data.Bind.Controls,
  FMX.Layouts,
  Fmx.Bind.Navigator,
  FMX.StdCtrls,
  FMX.Objects,
  FMX.Edit,
  FMX.DateTimeCtrls,
  FMX.EditBox,
  FMX.NumberBox,
  FMX.Controls.Presentation;

const
  sIDStrToCurrency = 'StrToCurrency';

type
  TItensPedidoBind = TListBindSourceAdapter<TItemPedido>;
  TPedidoBind = TObjectBindSourceAdapter<TPedido>;
  TItemPedidoBind = TObjectBindSourceAdapter<TItemPedido>;
  Tfrm = class(TForm)
    pnlDados: TPanel;
    lblNroPedido: TLabel;
    lblDataEmissao: TLabel;
    lblCodCliente: TLabel;
    edtNroPedido: TNumberBox;
    edtEmissao: TDateEdit;
    edtCodCliente: TNumberBox;
    edtNomeCliente: TEdit;
    linItens: TLine;
    pnlRodape: TPanel;
    linDados: TLine;
    lblDadosPedido: TLabel;
    lblItensPedido: TLabel;
    edtCodProduto: TNumberBox;
    edtDescrProduto: TEdit;
    lblCodProduto: TLabel;
    lstItensPedido: TListView;
    edtVlrUnitario: TNumberBox;
    lblQtde: TLabel;
    edtQtde: TNumberBox;
    lblVlrUnitario: TLabel;
    btnGravar: TButton;
    lblTotalPedido: TLabel;
    edtTotalPedido: TEdit;
    btnGravarPedido: TButton;
    lstBinding: TBindingsList;
    btnBuscarPedido: TButton;
    btnLimparTudo: TButton;
    Lang1: TLang;
    genItemPedido: TDataGeneratorAdapter;
    genItensPedido: TDataGeneratorAdapter;
    genPedido: TDataGeneratorAdapter;
    absPedido: TAdapterBindSource;
    absItensPedido: TAdapterBindSource;
    absItemPedido: TAdapterBindSource;
    LinkControlToField2: TLinkControlToField;
    LinkControlToField3: TLinkControlToField;
    LinkControlToField4: TLinkControlToField;
    LinkControlToField5: TLinkControlToField;
    LinkControlToField6: TLinkControlToField;
    LinkControlToField7: TLinkControlToField;
    LinkControlToField8: TLinkControlToField;
    LinkControlToField9: TLinkControlToField;
    LinkListControlToField1: TLinkListControlToField;
    LinkControlToField1: TLinkControlToField;
    lblCidadeUF: TLabel;
    edtCidade: TEdit;
    edtUF: TEdit;
    LinkControlToField10: TLinkControlToField;
    LinkControlToField11: TLinkControlToField;
    btnExcluirPedido: TButton;
    procedure absItensPedidoCreateAdapter(Sender: TObject;
      var ABindSourceAdapter: TBindSourceAdapter);
    procedure btnBuscarPedidoClick(Sender: TObject);
    procedure edtCodClienteChange(Sender: TObject);
    procedure absPedidoCreateAdapter(Sender: TObject;
      var ABindSourceAdapter: TBindSourceAdapter);
    procedure btnLimparTudoClick(Sender: TObject);
    procedure edtCodProdutoChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure absItemPedidoCreateAdapter(Sender: TObject;
      var ABindSourceAdapter: TBindSourceAdapter);
    procedure btnGravarClick(Sender: TObject);
    procedure lstItensPedidoKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure btnGravarPedidoClick(Sender: TObject);
    procedure edtNroPedidoEnter(Sender: TObject);
    procedure btnExcluirPedidoClick(Sender: TObject);
    procedure lstItensPedidoUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
  private
    FItensPedidoBind: TItensPedidoBind;
    FPedidoBind: TPedidoBind;
    FItemPedidoBind: TItemPedidoBind;
    FPedido: TPedido;
    FProduto: TProduto;
    FCliente: TCliente;
    FItemPedido: TItemPedido;
    FItemEmEdicao: Integer;
  end;

var
  frm: Tfrm;

implementation

uses
  udtm,
  IOUtils,
  uEPedidoNaoInformado,
  uEPedidoNaoEncontrado,
  uEProdutoNaoEncontrado;

{$R *.fmx}

procedure Tfrm.absItensPedidoCreateAdapter(Sender: TObject;
  var ABindSourceAdapter: TBindSourceAdapter);
begin
  FItensPedidoBind := TItensPedidoBind.Create(Self, FPedido.ItensPedido, False);
  ABindSourceAdapter := FItensPedidoBind;
end;

procedure Tfrm.absItemPedidoCreateAdapter(Sender: TObject;
  var ABindSourceAdapter: TBindSourceAdapter);
begin
  FItemPedido := TItemPedido.Create(dtm.DB);
  FItemPedidoBind := TItemPedidoBind.Create(Self, FItemPedido, False);
  ABindSourceAdapter := FItemPedidoBind;
end;

procedure Tfrm.absPedidoCreateAdapter(Sender: TObject;
  var ABindSourceAdapter: TBindSourceAdapter);
begin
  FPedido := TPedido.Create(dtm.DB);
  FPedidoBind := TPedidoBind.Create(Self, FPedido, False);
  ABindSourceAdapter := FPedidoBind;
end;

procedure Tfrm.btnBuscarPedidoClick(Sender: TObject);
var
  iNroPedido: Integer;
begin
  iNroPedido := Trunc(edtNroPedido.Value);
  if iNroPedido > 0 then
  begin
    if FPedido.BuscarPedido(iNroPedido) then
    begin
      FPedidoBind.Refresh;
      FItensPedidoBind.Refresh;
      edtNroPedido.ReadOnly := True;
    end
    else
    begin
      edtNroPedido.SetFocus;
      raise EPedidoNaoEncontrado.Create(iNroPedido);
    end;
  end
  else
    raise EPedidoNaoInformado.Create;
end;

procedure Tfrm.btnExcluirPedidoClick(Sender: TObject);
var
  iNroPedido: Integer;
begin
  iNroPedido := Trunc(edtNroPedido.Value);
  if iNroPedido > 0 then
  begin
    MessageDlg('Excluir este pedido?', TMsgDlgType.mtInformation,
      [System.UITypes.TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0,
      procedure(const AResult: System.UITypes.TModalResult)
      begin
        if AResult = mrYES then
        begin
          if FPedido.BuscarPedido(iNroPedido) then
            FPedido.Excluir
          else
          begin
            edtNroPedido.SetFocus;
            raise EPedidoNaoEncontrado.Create(iNroPedido);
          end;
        end;
      end);
  end
  else
    raise EPedidoNaoInformado.Create;
end;

procedure Tfrm.btnGravarClick(Sender: TObject);
var
  oItemPedido: TItemPedido;
begin
  FItemPedidoBind.Refresh;
  if FItemEmEdicao = 0 then // novo item
  begin
    oItemPedido := TItemPedido.Create(dtm.DB);
    oItemPedido.Assign(FItemPedido);
    FPedido.ItensPedido.Add(oItemPedido)
  end
  else
  begin // item alterado
    FPedido.ItensPedido[FItemEmEdicao - 1].Assign(FItemPedido);
    FItemEmEdicao := 0;
  end;
  FPedido.Totalizar;
  FPedidoBind.Refresh;
  FItensPedidoBind.Refresh;
  FItemPedido.Clear;
  FItemPedidoBind.Refresh;
  edtCodProduto.ReadOnly := False;
  edtCodProduto.SetFocus;
  btnGravar.Visible := False;
end;

procedure Tfrm.btnGravarPedidoClick(Sender: TObject);
begin
  FPedidoBind.Refresh;
  dtm.DB.StartTransaction;
  try
    FPedido.Gravar;
    dtm.DB.Commit;
  except
    on E: Exception do
    begin
      try
        dtm.DB.Rollback;
      except
      end;
      raise;
    end;
  end;
  btnLimparTudoClick(Sender);
end;

procedure Tfrm.edtCodProdutoChange(Sender: TObject);
var
  iCodProduto: Integer;
begin
  iCodProduto := Trunc(edtCodProduto.Value);
  if iCodProduto > 0 then
  begin
    if FProduto.BuscarProduto(iCodProduto) then
    begin
      FItemPedido.CodProduto := FProduto.CodProduto;
      FItemPedido.DescrProduto := FProduto.DescrProduto;
      if FItemPedido.VlrUnitario = 0 then
        FItemPedido.VlrUnitario := FProduto.PrecoVenda;
      if FItemPedido.QtdeItens = 0 then
        FItemPedido.QtdeItens := 1;
    end
    else
      raise EProdutoNaoEncontrado.Create(iCodProduto);
    FItemPedidoBind.Refresh;
    btnGravar.Visible := True;
  end;
end;

procedure Tfrm.edtNroPedidoEnter(Sender: TObject);
begin
  edtNroPedido.SelectAll;
end;

procedure Tfrm.edtCodClienteChange(Sender: TObject);
var
  iCodCliente: Integer;
begin
  iCodCliente := Trunc(edtCodCliente.Value);
  btnBuscarPedido.Visible := iCodCliente = 0;
  btnExcluirPedido.Visible := iCodCliente = 0;
  if iCodCliente > 0 then
  begin
    if FCliente.BuscarCliente(iCodCliente) then
    begin
      FPedido.CodCliente := FCliente.Codigo;
      FPedido.NomeCliente := FCliente.Nome;
      FPedido.CidadeCliente := FCliente.Cidade;
      FPedido.UFCliente := FCliente.UF;
      edtCodProduto.SetFocus;
    end
    else
      raise EProdutoNaoEncontrado.Create(iCodCliente);
    FPedidoBind.Refresh;
  end;
end;

procedure Tfrm.btnLimparTudoClick(Sender: TObject);
begin
  FPedido.Clear;
  FPedidoBind.Refresh;
  FItensPedidoBind.Refresh;
  edtNroPedido.ReadOnly := False;
  edtNroPedido.SetFocus;
end;

procedure Tfrm.FormCreate(Sender: TObject);
begin
  FProduto := TProduto.Create(dtm.DB);
  FCliente := TCliente.Create(dtm.DB);
  FItemEmEdicao := 0;
  FPedido.Clear;
  FPedidoBind.Refresh;
  LinkListControlToField1.Active := True;
  LinkControlToField9.Active := True;
end;

procedure Tfrm.FormDestroy(Sender: TObject);
begin
  FItemPedido.Free;
  FProduto.Free;
  FCliente.Free;
end;

procedure Tfrm.lstItensPedidoKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if Key = 13 then
  begin
    FItemPedido.Assign((FItensPedidoBind.Current as TItemPedido));
    FItemPedidoBind.Refresh;
    edtCodProduto.ReadOnly := True;
    FItemEmEdicao := lstItensPedido.Selected.Index + 1;
    edtQtde.SetFocus;
  end
  else
  if key = 46 then
  begin
    MessageDlg('Excluir este item?', TMsgDlgType.mtInformation,
      [System.UITypes.TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0,
      procedure(const AResult: System.UITypes.TModalResult)
      begin
        if AResult = mrYES then
        begin
          FItensPedidoBind.Delete;
          FPedido.Totalizar;
        end;
      end);
  end;
end;

procedure Tfrm.lstItensPedidoUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
var
  oText: TListItemText;
  s: string;
begin
  oText := AItem.Objects.FindDrawable('VlrUnitario')  as TListItemText;
  if Assigned(oText) then
    oText.Text := Format('%m', [StrToFloat(oText.Text)]);
  oText := AItem.Objects.FindDrawable('VlrTotal')  as TListItemText;
  if Assigned(oText) then
    oText.Text := Format('%m', [StrToFloat(oText.Text)]);
end;

end.
