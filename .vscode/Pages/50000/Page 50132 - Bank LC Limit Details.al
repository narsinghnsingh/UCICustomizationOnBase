page 50132 "Bank LC Limit Details"
{
    // version LC Detail

    CaptionML = ENU = 'Bank LC Limit Details';
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Bank LC Limit Details";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Bank No."; "Bank No.")
                {
                    Visible = false;
                }
                field("From Date"; "From Date")
                {
                }
                field("To Date"; "To Date")
                {
                }
                field(Amount; Amount)
                {
                }
                field("Amount Utilised"; "Amount Utilised")
                {
                    DrillDown = false;
                    Editable = false;
                    Visible = false;
                }
                field("Amount Utilised Amended"; "Amount Utilised Amended")
                {
                    CaptionML = ENU = 'Amount Utilised ';
                    DrillDown = false;
                    Editable = false;
                }
                field("Remaining Amount"; "Remaining Amount")
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        SetFilter("Date Filter", '%1..%2', "From Date", "To Date");
        CalcFields("Amount Utilised", "Amount Utilised Amended");
        if "Amount Utilised Amended" = 0 then
            "Remaining Amount" := Amount - "Amount Utilised"
        else
            "Remaining Amount" := Amount - "Amount Utilised Amended";
    end;
}

