unit uWKConnection;

interface

uses
  SysUtils,
  Classes,
  FireDAC.Comp.Client,
  FireDAC.Stan.Def,
  FireDAC.Phys.Intf,
  FireDAC.DApt,
  FireDAC.Stan.Async,
  uDatabaseConfig,
  Generics.Collections;

type
  TWKConnection = class(TFDConnection)
  private
    FTables: TStringList;
    FConfig: TDatabaseConfig;
    FQuery: TFDQuery;
    procedure SetParams;
    procedure CheckTables;
    procedure CheckTableClientes;
    procedure CheckTableProdutos;
    procedure CheckTablePedidos;
    procedure CheckTableItens;
  protected
    procedure DoConnect; override;
  public
    constructor Create(const AConfigFile: TFilename); reintroduce;
    destructor Destroy; override;
  end;

implementation

{ TWKConnection }

procedure TWKConnection.CheckTableClientes;
begin
  GetTableNames(EmptyStr, EmptyStr, 'cliente', FTables, [osMy], [tkTable]);;
  if FTables.Count = 0 then
  begin
    FQuery.SQL.Clear;
    FQuery.SQL.Add('create table cliente (');
    FQuery.SQL.Add('  cod_cliente integer not null,');
    FQuery.SQL.Add('  nome_cliente varchar(128) not null,');
    FQuery.SQL.Add('  cidade_cliente varchar(64),');
    FQuery.SQL.Add('  uf_cliente varchar(64),');
    FQuery.SQL.Add('  primary key (cod_cliente)');
    FQuery.SQL.Add(')');
    FQuery.ExecSql;
    FQuery.SQL.Clear;
    FQuery.SQL.Add('insert into cliente (');
    FQuery.SQL.Add('  cod_cliente,');
    FQuery.SQL.Add('  nome_cliente,');
    FQuery.SQL.Add('  cidade_cliente,');
    FQuery.SQL.Add('  uf_cliente');
    FQuery.SQL.Add(') values');
    FQuery.SQL.Add('(1,''Carlos Drummond de Andrade'',''São Paulo'',''SP''),');
    FQuery.SQL.Add('(2,''Cecília Meireles'',''Rio de Janeiro'',''RJ''),');
    FQuery.SQL.Add('(3,''Graciliano Ramos'',''Fortaleza'',''CE''),');
    FQuery.SQL.Add('(4,''Euclides da Cunha'',''Belo Horizonte'',''MG''),');
    FQuery.SQL.Add('(5,''Monteiro Lobato'',''Araçatuba'',''SP''),');
    FQuery.SQL.Add('(6,''José de Alencar'',''Salvador'',''BA''),');
    FQuery.SQL.Add('(7,''Machado de Assis'',''Curitiba'',''PR''),');
    FQuery.SQL.Add('(8,''Clarice Lispector'',''Porto Alegre'',''RS''),');
    FQuery.SQL.Add('(9,''João Cabral de Melo Neto'',''Florianópolis'',''SC''),');
    FQuery.SQL.Add('(10,''Mario Quintana'',''Manaus'',''AM''),');
    FQuery.SQL.Add('(11,''Guimarães Rosa'',''Palmas'',''TO''),');
    FQuery.SQL.Add('(12,''Ruth Rocha'',''Goiânia'',''GO''),');
    FQuery.SQL.Add('(13,''Luis Fernando Veríssimo'',''Brasília'',''DF''),');
    FQuery.SQL.Add('(14,''Ana Maria Machado'',''Vitória'',''Espírito Santo''),');
    FQuery.SQL.Add('(15,''Chico Buarque de Holanda'',''Macapá'',''AP''),');
    FQuery.SQL.Add('(16,''Adélia Prado'',''Blumenau'',''SC''),');
    FQuery.SQL.Add('(17,''Eva Furnari'',''Santo André'',''SP''),');
    FQuery.SQL.Add('(18,''Martha Medeiros'',''Porto Alegre'',''RS''),');
    FQuery.SQL.Add('(19,''Conceição Evaristo'',''São Paulo'',''SP''),');
    FQuery.SQL.Add('(20,''André Dahmer'',''São Paulo'',''SP'')');
    FQuery.ExecSql;
    FQuery.SQL.Clear;
    FQuery.SQL.Add('create index idx_cliente_nome_cliente on');
    FQuery.SQL.Add('  cliente');
    FQuery.SQL.Add('(');
    FQuery.SQL.Add('  nome_cliente');
    FQuery.SQL.Add(')');
    FQuery.ExecSql;
  end;
end;

procedure TWKConnection.CheckTableItens;
begin
  GetTableNames(EmptyStr, EmptyStr, 'pedido_item', FTables, [osMy], [tkTable]);;
  if FTables.Count = 0 then
  begin
    FQuery.SQL.Clear;
    FQuery.SQL.Add('create table pedido_item (');
    FQuery.SQL.Add('  cod_sequencia integer not null auto_increment,');
    FQuery.SQL.Add('  nro_pedido integer not null,');
    FQuery.SQL.Add('  cod_produto integer not null,');
    FQuery.SQL.Add('  qtd integer not null,');
    FQuery.SQL.Add('  vlr_unitario decimal(15,2) not null,');
    FQuery.SQL.Add('  vlr_total decimal(15,2) not null,');
    FQuery.SQL.Add('  primary key (cod_sequencia),');
    FQuery.SQL.Add('  foreign key (cod_produto) references produto(cod_produto),');
    FQuery.SQL.Add('  foreign key (nro_pedido) references pedido(nro_pedido) on delete cascade');
    FQuery.SQL.Add(')');
    FQuery.ExecSql;
  end;
end;

procedure TWKConnection.CheckTablePedidos;
begin
  GetTableNames(EmptyStr, EmptyStr, 'pedido', FTables, [osMy], [tkTable]);;
  if FTables.Count = 0 then
  begin
    FQuery.SQL.Clear;
    FQuery.SQL.Add('create table pedido (');
    FQuery.SQL.Add('  nro_pedido integer not null auto_increment,');
    FQuery.SQL.Add('  data_emissao date not null,');
    FQuery.SQL.Add('  cod_cliente integer not null,');
    FQuery.SQL.Add('  vlr_total decimal(15,2) not null,');
    FQuery.SQL.Add('  primary key (nro_pedido),');
    FQuery.SQL.Add('  foreign key (cod_cliente) references cliente(cod_cliente)');
    FQuery.SQL.Add(')');
    FQuery.ExecSql;
  end;
end;

procedure TWKConnection.CheckTableProdutos;
begin
  GetTableNames(EmptyStr, EmptyStr, 'produto', FTables, [osMy], [tkTable]);;
  if FTables.Count = 0 then
  begin
    FQuery.SQL.Clear;
    FQuery.SQL.Add('create table produto (');
    FQuery.SQL.Add('  cod_produto integer not null,');
    FQuery.SQL.Add('  descr_produto varchar(128) not null,');
    FQuery.SQL.Add('  preco_venda decimal(15,2),');
    FQuery.SQL.Add('  primary key (cod_produto)');
    FQuery.SQL.Add(')');
    FQuery.ExecSql;
    FQuery.SQL.Clear;
    FQuery.SQL.Add('insert into produto (');
    FQuery.SQL.Add('  cod_produto,');
    FQuery.SQL.Add('  descr_produto,');
    FQuery.SQL.Add('  preco_venda');
    FQuery.SQL.Add(') values');
    FQuery.SQL.Add('(1,''Quadrinhos dos Anos 10'',10.34),');
    FQuery.SQL.Add('(2,''Antologia Poética'',34.45),');
    FQuery.SQL.Add('(3,''Felicidade Crônica'',18.35),');
    FQuery.SQL.Add('(4,''Marcelo, Marmelo, Martelo'',32.00),');
    FQuery.SQL.Add('(5,''Grande Sertão Veredas'',75.21),');
    FQuery.SQL.Add('(6,''Vidas Secas'',23.56),');
    FQuery.SQL.Add('(7,''Morte e Vida Severina '',35.21),');
    FQuery.SQL.Add('(8,''Dom Casmurro'',56.43),');
    FQuery.SQL.Add('(9,''A Rosa do Povo'',8.34),');
    FQuery.SQL.Add('(10,''Espectros'',24.31),');
    FQuery.SQL.Add('(11,''O Guarani'',45.89),');
    FQuery.SQL.Add('(12,''Sítio do Pica-Pau Amarelo'',56.34),');
    FQuery.SQL.Add('(13,''O Choque das Raças'',89.00),');
    FQuery.SQL.Add('(14,''Contos Negreiros'',17.49),');
    FQuery.SQL.Add('(15,''Opisanie swiata'',8.45),');
    FQuery.SQL.Add('(16,''Contos de Mentira'',34.09),');
    FQuery.SQL.Add('(17,''Dias Perfeitos'',29.05),');
    FQuery.SQL.Add('(18,''Memórias Póstumas de Brás Cubas'',45.23),');
    FQuery.SQL.Add('(19,''Capitães da Areia'',98.34),');
    FQuery.SQL.Add('(20,''Macunaíma'',51.98)');
    FQuery.ExecSql;
  end;
end;

procedure TWKConnection.CheckTables;
begin
  FTables := TStringList.Create;
  try
    CheckTableClientes;
    CheckTableProdutos;
    CheckTablePedidos;
    CheckTableItens;
  finally
    FTables.Free;
  end;
end;

constructor TWKConnection.Create(const AConfigFile: TFilename);
begin
  inherited Create(nil);
  FConfig := TDatabaseConfig.Create(AConfigFile);
  FQuery := TFDQuery.Create(Self);
  FQuery.Connection := Self;
end;

destructor TWKConnection.Destroy;
begin
  FQuery.Free;
  FConfig.Free;
  inherited;
end;

procedure TWKConnection.DoConnect;
begin
  SetParams;
  inherited;
  CheckTables;
end;

procedure TWKConnection.SetParams;
begin
  Params.Clear;
  Params.Add('DriverID=MySQL');
  Params.Add(Format('Server=%s', [FConfig.Host]));
  Params.Add(Format('Port=%d', [FConfig.Port]));
  Params.Add(Format('Database=%s', [FConfig.Database]));
  Params.Add(Format('User_name=%s', [FConfig.User]));
  Params.Add(Format('Password=%s', [FConfig.Password]));
end;

end.
