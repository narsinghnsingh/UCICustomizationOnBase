table 50039 "Bank LC Limit Details"
{
    // version LC Detail

    CaptionML = ENU = 'Bank LC Limit Details';

    fields
    {
        field(1;"Bank No.";Code[20])
        {
            CaptionML = ENU = 'Bank No.';
            TableRelation = "Bank Account"."No.";
        }
        field(2;"From Date";Date)
        {
            CaptionML = ENU = 'From Date';
        }
        field(3;Amount;Decimal)
        {
            CaptionML = ENU = 'Amount';

            trigger OnValidate()
            begin
                TestField("From Date");
                TestField("To Date");
                CalcFields("Amount Utilised","Amount Utilised Amended");
                if "Amount Utilised Amended" = 0 then
                  "Remaining Amount" := Amount - "Amount Utilised"
                else
                  "Remaining Amount" := Amount - "Amount Utilised Amended";
            end;
        }
        field(5;"Amount Utilised";Decimal)
        {
            CalcFormula = Sum("LC Detail"."LC Value LCY" WHERE ("Issuing Bank"=FIELD("Bank No."),
                                                                "Date of Issue"=FIELD("Date Filter")));
            CaptionML = ENU = 'Amount Utilised';
            FieldClass = FlowField;
        }
        field(6;"Remaining Amount";Decimal)
        {
            CaptionML = ENU = 'Remaining Amount';
        }
        field(7;"Amount Utilised Amended";Decimal)
        {
            CalcFormula = Sum("LC Detail"."Latest Amended Value" WHERE ("Issuing Bank"=FIELD("Bank No."),
                                                                        "Date of Issue"=FIELD("Date Filter")));
            CaptionML = ENU = 'Amount Utilised Amended';
            FieldClass = FlowField;
        }
        field(8;"Date Filter";Date)
        {
            CaptionML = ENU = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(9;"To Date";Date)
        {
            CaptionML = ENU = 'To Date';

            trigger OnValidate()
            begin
                if "From Date" > "To Date" then
                  Error('To Date cannot be less than From Date.');
            end;
        }
    }

    keys
    {
        key(Key1;"Bank No.","From Date")
        {
        }
    }

    fieldgroups
    {
    }
}

