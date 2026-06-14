codeunit 70249951 "GitHub Mgt TPE"
{
    procedure StartDeviceFlow()
    var
        Setup: Record "GitHub Setup TPE";
        J: JsonObject;
        Url: Text;
        Body: Text;
        Http: HttpClient;
        Content: HttpContent;
        Response: HttpResponseMessage;
        Headers: HttpHeaders;
    begin
        Setup.Get();

        Url := 'https://github.com/login/device/code';

        Http.DefaultRequestHeaders.Add('Accept', 'application/json');
        Http.DefaultRequestHeaders.Add('User-Agent', 'BC-GitHub-App');

        Body := 'client_id=' + Setup."Client ID" + '&scope=repo';

        Content.WriteFrom(Body);
        Content.GetHeaders(Headers);
        Headers.Clear();
        Headers.Add('Content-Type', 'application/x-www-form-urlencoded');

        Http.Post(Url, Content, Response);

        Response.Content.ReadAs(Body);
        J.ReadFrom(Body);

        if not Response.IsSuccessStatusCode() then
            Error('Error starting device flow: %1', Body);

        Setup."Device Code" := J.GetText('device_code');
        Setup."User Code" := J.GetText('user_code');
        Setup."Verification URI" := J.GetText('verification_uri');
        Setup."Interval" := J.GetInteger('interval');
        Setup."Expires In" := J.GetInteger('expires_in');

        Setup.Modify();

        Message(
            'Go to %1 and enter code %2',
            Setup."Verification URI",
            Setup."User Code"
        );

        // open browser automatically
        Hyperlink(Setup."Verification URI");
    end;

    procedure PollForToken(): Boolean
    var
        Setup: Record "GitHub Setup TPE";
        Url: Text;
        Body: Text;
        J: JsonObject;
        Attempts: Integer;
        Http: HttpClient;
        Content: HttpContent;
        Response: HttpResponseMessage;
        Headers: HttpHeaders;
    begin
        Setup.Get();

        Url := 'https://github.com/login/oauth/access_token';

        for Attempts := 1 to 60 do begin

            Body :=
              'client_id=' + Setup."Client ID" +
              '&device_code=' + Setup."Device Code" +
              '&grant_type=urn:ietf:params:oauth:grant-type:device_code';

            Content.WriteFrom(Body);
            Content.GetHeaders(Headers);
            Headers.Clear();
            Headers.Add('Content-Type', 'application/x-www-form-urlencoded');

            Http.DefaultRequestHeaders.Clear();
            Http.DefaultRequestHeaders.Add('Accept', 'application/json');
            Http.DefaultRequestHeaders.Add('User-Agent', 'BC-GitHub-App');

            Http.Post(Url, Content, Response);
            Response.Content.ReadAs(Body);

            if not Response.IsSuccessStatusCode() then
                Error('Error getting token: %1', Body);

            if Body.Contains('access_token') then begin
                J.ReadFrom(Body);
                Setup."Access Token" := J.GetText('access_token');
                Setup.Modify();
                exit(true);
            end;

            Sleep(3000);
        end;

        exit(false);
    end;

    procedure GetRepositories() Repos: Text
    var
        Setup: Record "GitHub Setup TPE";
        Url: Text;
        Http: HttpClient;

        Response: HttpResponseMessage;
    begin
        Setup.Get();

        Url := 'https://api.github.com/user/repos';

        Http.DefaultRequestHeaders.Clear();
        Http.DefaultRequestHeaders.Add('Authorization', 'Bearer ' + Setup."Access Token");
        Http.DefaultRequestHeaders.Add('User-Agent', 'BC-GitHub-App');
        Http.DefaultRequestHeaders.Add('Accept', 'application/vnd.github+json');

        Http.Get(Url, Response);
        Response.Content.ReadAs(Repos);

        if not Response.IsSuccessStatusCode() then
            Error('Error starting device flow: %1', Repos);

        exit(Repos);
    end;
}