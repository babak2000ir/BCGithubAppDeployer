page 70249951 "GitHub Setup Card TPE"
{
    PageType = Card;
    SourceTable = "GitHub Setup TPE";
    ApplicationArea = All;
    UsageCategory = Administration;
    Editable = true;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Primary Key"; Rec."Primary Key")
                {
                    ApplicationArea = All;
                }
                field("Client ID"; Rec."Client ID")
                {
                    ApplicationArea = All;
                }
                field("User Code"; Rec."User Code")
                {
                    ApplicationArea = All;
                }
                field("Verification URI"; Rec."Verification URI")
                {
                    ApplicationArea = All;
                }
                field("Access Token"; Rec."Access Token")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Connect GitHub")
            {
                ApplicationArea = All;
                trigger OnAction()
                var
                    Mgt: Codeunit "GitHub Mgt TPE";
                begin
                    Mgt.StartDeviceFlow();
                end;
            }

            action("Poll Token")
            {
                ApplicationArea = All;
                trigger OnAction()
                var
                    Mgt: Codeunit "GitHub Mgt TPE";
                begin
                    if Mgt.PollForToken() then
                        Message('Connected to GitHub successfully!');
                end;
            }

            action("List Repos")
            {
                ApplicationArea = All;
                trigger OnAction()
                var
                    Mgt: Codeunit "GitHub Mgt TPE";
                    Repos: Text;
                begin
                    Repos := Mgt.GetRepositories();
                    Message(Repos);
                end;
            }
        }
    }
}