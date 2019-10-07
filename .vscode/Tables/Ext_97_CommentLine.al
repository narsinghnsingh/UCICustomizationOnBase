tableextension 50018 Ext_CommentLine extends "Comment Line"
{
    fields
    {
        field(50001; Type; Option)
        {
            Description = '//Deepak';
            OptionCaption = ',Document';
            OptionMembers = ,Document;
        }
        field(50002; "Document Code"; Code[50])
        {
            Description = '//Deepak';
            TableRelation = "Standard Text".Code WHERE (Type = CONST ("Sale Check list"));

            trigger OnValidate()
            begin
                //Lines added BY deepak Kumar
                StandardText.RESET;
                StandardText.SETRANGE(StandardText.Code, "Document Code");
                IF StandardText.FINDFIRST THEN BEGIN
                    Description := StandardText.Description;
                END ELSE BEGIN
                    Description := '';
                END;
            end;
        }
        field(50003; Description; Text[150])
        {
            Description = '//Deepak';
        }
        field(50004; Mandatory; Boolean)
        {
            Description = '//Deepak';
        }
    }

    var
        StandardText: Record "Standard Text";
}