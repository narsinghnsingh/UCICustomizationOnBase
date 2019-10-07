table 50201 "Temp Production Order"
{

    fields
    {
        field(1;"Entry No";Integer)
        {
        }
        field(3;"Order No.";Code[50])
        {
        }
        field(50024;Status;Option)
        {
            CalcFormula = Lookup("Production Order".Status WHERE ("No."=FIELD("Order No.")));
            CaptionML = ENU = 'Status';
            FieldClass = FlowField;
            OptionCaption = 'Simulated,Planned,Firm Planned,Released,Finished';
            OptionMembers = Simulated,Planned,"Firm Planned",Released,Finished;
        }
    }

    keys
    {
        key(Key1;"Entry No")
        {
        }
    }

    fieldgroups
    {
    }
}

