codeunit 70249951 "GitHub OAuth TPE"
{
    procedure GetRepositories()
    var
        OAuth2: Codeunit OAuth2;
        Client: HttpClient;
        Response: HttpResponseMessage;
        Headers: HttpHeaders;
        AccessToken: SecretText;
        IdToken: Text;
        ErrorText: Text;
        Scopes: List of [Text];
        JsonResponse: Text;
        ClientId: Text;
        ClientSecret: SecretText;
        AuthorityUrl: Text;
        RedirectUrl: Text;
    begin
        // GitHub OAuth App values
        ClientId := 'YOUR_CLIENT_ID';
        ClientSecret := 'YOUR_CLIENT_SECRET';

        AuthorityUrl :=
          'https://github.com/login/oauth';

        RedirectUrl :=
          'https://businesscentral.dynamics.com/OAuthLanding.htm';

        Scopes.Add('repo');
        Scopes.Add('read:user');

        Oauth2.AcquireAuthorizationCode()

        if not OAuth2.AcquireTokensByAuthorizationCode(
            ClientId,
            ClientSecret,
            AuthorityUrl,
            RedirectUrl,
            Scopes,
            Enum::"Prompt Interaction"::Login,
            AccessToken,
            IdToken,
            ErrorText)
        then
            Error(ErrorText);

        Client.DefaultRequestHeaders().Clear();

        Client.DefaultRequestHeaders().Add(
            'Authorization',
            'Bearer ' + Format(AccessToken));

        Client.DefaultRequestHeaders().Add(
            'Accept',
            'application/vnd.github+json');

        Client.DefaultRequestHeaders().Add(
            'X-GitHub-Api-Version',
            '2022-11-28');

        Client.DefaultRequestHeaders().Add(
            'User-Agent',
            'BusinessCentral');

        Client.Get(
            'https://api.github.com/user/repos',
            Response);

        if not Response.IsSuccessStatusCode() then
            Error('GitHub API Error: %1', Response.HttpStatusCode());

        Response.Content().ReadAs(JsonResponse);

        Message(JsonResponse);
    end;
}