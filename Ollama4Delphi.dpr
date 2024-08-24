program Ollama4Delphi;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Horse,
  RESTRequest4D;

const
  PORT_DEFAULT = 9004;
  BASE_URL_OLLAMA = 'http://localhost:11434/api/chat';

var
  FPort: Integer;
  FPortStr: string;

begin
  Write(Format('Enter the port number (default %d): ', [PORT_DEFAULT]));
  Readln(FPortStr);
  FPort := StrToIntDef(FPortStr, PORT_DEFAULT);

  THorse.Get('/ping',
    procedure(Req: THorseRequest; Res: THorseResponse)
    begin
      Res.Send('pong');
    end);

  THorse.Post('/api/chat',
    procedure(Req: THorseRequest; Res: THorseResponse)
    var
      LResponse: IResponse;
    begin
      Writeln(Format('Request started %s', [FormatDateTime('yyyy/mm/dd HH:nn:ss', Now)]));

      LResponse := TRequest.New
        .BaseURL(BASE_URL_OLLAMA)
        .ContentType('application/json')
        //.Accept('application/json')
        //.Token('Bearer ' + FSettings.ApiKeyOllama)
        .AddBody(Req.Body)
        .Post;

      Res.Send(LResponse.Content);
    end);

  THorse.Listen(FPort,
    procedure
    begin
      Writeln(Format('Ollama4Delphi running on the port %d ', [FPort]));
    end);

end.
