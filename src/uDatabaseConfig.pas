unit uDatabaseConfig;

interface

uses
  SysUtils,
  IniFiles;

const
  cSection = 'Database';
  cDatabase = 'Database';
  cHost = 'Host';
  cPort = 'Port';
  cUser = 'User';
  cPassword = 'Password';
  cDefaultDatabase = 'wk';
  cDefaultHost = 'localhost';
  cDefaultPort = 3306;
  cDefaultUser = 'root';
  cDefaultPassword = 'temp';

type
  TDatabaseConfig = class(TIniFile)
  private
    function GetDatabase: string;
    function GetHost: string;
    function GetPassword: string;
    function GetPort: Integer;
    function GetUser: string;
    procedure SetDatabase(const Value: string);
    procedure SetHost(const Value: string);
    procedure SetPassword(const Value: string);
    procedure SetPort(Value: Integer);
    procedure SetUser(const Value: string);
  public
    property Database: string read GetDatabase write SetDatabase;
    property Host: string read GetHost write SetHost;
    property Password: string read GetPassword write SetPassword;
    property Port: Integer read GetPort write SetPort;
    property User: string read GetUser write SetUser;
  end;

implementation

uses
  System.IOUtils;


{
******************************* TDatabaseConfig ********************************
}
function TDatabaseConfig.GetDatabase: string;
begin
  Result := ReadString(cSection, cDatabase, cDefaultDatabase);
end;

function TDatabaseConfig.GetHost: string;
begin
  Result := ReadString(cSection, cHost, cDefaultHost);
end;

function TDatabaseConfig.GetPassword: string;
begin
  Result := ReadString(cSection, cPassword, cDefaultPassword);
end;

function TDatabaseConfig.GetPort: Integer;
begin
  Result := ReadInteger(cSection, cPort, cDefaultPort);
end;

function TDatabaseConfig.GetUser: string;
begin
  Result := ReadString(cSection, cUser, cDefaultUser);
end;

procedure TDatabaseConfig.SetDatabase(const Value: string);
begin
  WriteString(cSection, cDatabase, Value);
end;

procedure TDatabaseConfig.SetHost(const Value: string);
begin
  WriteString(cSection, cHost, Value);
end;

procedure TDatabaseConfig.SetPassword(const Value: string);
begin
  WriteString(cSection, cPassword, Value);
end;

procedure TDatabaseConfig.SetPort(Value: Integer);
begin
  WriteInteger(cSection, cPort, Value);
end;

procedure TDatabaseConfig.SetUser(const Value: string);
begin
  WriteString(cSection, cUser, Value);
end;



end.
