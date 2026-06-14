table 70249951 "GitHub Setup TPE"
{
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            DataClassification = SystemMetadata;
        }
        field(2; "Client ID"; Text[100])
        {
            DataClassification = SystemMetadata;
        }
        field(3; "Device Code"; Text[250])
        {
            DataClassification = SystemMetadata;
        }
        field(4; "User Code"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Verification URI"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Access Token"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(7; Interval; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Expires In"; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}