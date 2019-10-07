tableextension 50065 Ext_SalesCommentLine extends "Sales Comment Line"
{
    fields
    {
        field(50000; "Document Code"; Code[20])
        {
            TableRelation = IF (Type = CONST (Comment)) "Standard Text".Code WHERE (Type = FILTER (Sale))
            ELSE
            IF (Type = CONST ("Sales CheckList")) "Standard Text".Code WHERE (Type = CONST ("Sale Check list"))
            ELSE
            IF (Type = CONST (Terms)) "Standard Text".Code WHERE (Type = FILTER (Terms),
            "Sub- Type" = FIELD ("Sub- Type"));

            trigger OnValidate()
            begin
                // Lines added BY deepak kumar
                StandardText.RESET;
                StandardText.SETRANGE(StandardText.Type, 2);
                StandardText.SETRANGE(StandardText.Code, "Document Code");
                IF StandardText.FINDFIRST THEN BEGIN
                    Description := StandardText.Description;
                END ELSE BEGIN
                    StandardText.Description := '';
                END;
                StandardText.RESET;
                StandardText.SETRANGE(StandardText.Type, 3);
                StandardText.SETRANGE(StandardText.Code, "Document Code");
                IF StandardText.FINDFIRST THEN BEGIN
                    Description := StandardText.Description;
                END ELSE BEGIN
                    StandardText.Description := '';
                END;
            end;
        }
        field(50001; Description; Text[150])
        {
        }
        field(50002; Attached; Boolean)
        {

            trigger OnValidate()
            begin
                // Lines added BY Deepak Kumar
                "Marked By" := USERID + FORMAT(WORKDATE) + FORMAT(TIME);
            end;
        }
        field(50003; "Marked By"; Code[150])
        {
            Editable = false;
        }
        field(50004; Mandatory; Boolean)
        {
        }
        field(50005; Type; Option)
        {
            OptionCaption = 'Comment,Sales CheckList,Terms';
            OptionMembers = Comment,"Sales CheckList",Terms;
        }
        field(50006; "Sub- Type"; Option)
        {
            OptionCaption = 'Shipment,Delivery,Variation Quantity vs Actual,Payment,Validity';
            OptionMembers = Shipment,Delivery,"Variation Quantity vs Actual",Payment,Validity;
        }
    }
   keys
   {
       key(Key12; Type,"Sub- Type")
       {
           
       }
   }

    var
        StandardText: Record "Standard Text";
}