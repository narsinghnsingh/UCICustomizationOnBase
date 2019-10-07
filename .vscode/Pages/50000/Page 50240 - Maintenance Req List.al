page 50240 "Maintenance Requisition List"
{
    // version Deepak

    CardPageID = "Maintenance Requisition Header";
    DeleteAllowed = false;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Requisition Header";
    SourceTableView = SORTING ("Requisition No.")
                      ORDER(Ascending)
                      WHERE ("Requisition Type" = FILTER (Maintenance));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Requisition No."; "Requisition No.")
                {
                }
                field("Requisition Type"; "Requisition Type")
                {
                }
                field("Requisition Date"; "Requisition Date")
                {
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                }
                field("User ID"; "User ID")
                {
                }
                field(Status; Status)
                { }
                field("Requisition Remarks"; "Requisition Remarks")
                { }
                field("Rejection Remarks"; "Rejection Remarks")
                { }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    var
        UserSetup: Record "User Setup";
    begin
        // Lines added By Deepak Kumar
        UserSetup.Reset;
        UserSetup.SetRange(UserSetup."User ID", UserId);
        UserSetup.SetRange(UserSetup."Auth. Store User", true);
        if not UserSetup.FindFirst then begin
            SetFilter("User ID", UserId);
        end;
    end;
}

