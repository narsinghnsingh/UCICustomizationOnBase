page 50178 "Sales Line Prod. Order Update"
{
    PageType = Worksheet;
    UsageCategory = Tasks;
    SourceTable = "Sales Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Type"; "Document Type")
                {
                    Editable = false;
                }
                field("Sell-to Customer No."; "Sell-to Customer No.")
                {
                }
                field("Document No."; "Document No.")
                {
                    Editable = false;
                }
                field("Line No."; "Line No.")
                {
                    Editable = false;
                }
                field(Type; Type)
                {
                    Editable = false;
                }
                field("No."; "No.")
                {
                    Editable = false;
                }
                field(Description; Description)
                {
                    Editable = false;
                }
                field("Description 2"; "Description 2")
                {
                    Editable = false;
                }
                field("Unit of Measure"; "Unit of Measure")
                {
                    Editable = false;
                }
                field(Quantity; Quantity)
                {
                    Editable = false;
                }
                field("Prod. Order No."; "Prod. Order No.")
                {

                    trigger OnValidate()
                    begin
                        // Lines added By Deepak Kumar
                        UserSetup.SetRange(UserSetup."User ID", UserId);
                        UserSetup.SetRange(UserSetup."Delete Sales Header", true);
                        if not UserSetup.FindFirst then
                            Error('You are not authorized user ');
                    end;
                }
                field("Prod. Order Line No."; "Prod. Order Line No.")
                {

                    trigger OnValidate()
                    begin
                        // Lines added By Deepak Kumar
                        UserSetup.SetRange(UserSetup."User ID", UserId);
                        UserSetup.SetRange(UserSetup."Delete Sales Header", true);
                        if not UserSetup.FindFirst then
                            Error('You are not authorized user ');
                    end;
                }
            }
        }
    }

    actions
    {
    }

    var
        UserSetup: Record "User Setup";
}

