pageextension 50063 Ext_654_RequesttoApprove extends "Requests to Approve"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addbefore(View)
        {
            group(Filters)
            {
                action(Item)
                {
                    CaptionML = ENU = 'Item';
                    ApplicationArea = All;
                    Image = "Filter";
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Ellipsis = true;
                    trigger OnAction()
                    begin
                        ShowTableTypeEntries(27);
                    end;
                }
                action(Vendor)
                {
                    CaptionML = ENU = 'Vendor';
                    ApplicationArea = All;
                    Image = "Filter";
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Ellipsis = true;
                    trigger OnAction()
                    begin
                        ShowTableTypeEntries(23);
                    end;
                }
                action(Customer)
                {
                    CaptionML = ENU = 'Customer';
                    ApplicationArea = All;
                    Image = "Filter";
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Ellipsis = true;
                    trigger OnAction()
                    begin
                        ShowTableTypeEntries(18);
                    end;
                }
                action(SalesOrder)
                {
                    CaptionML = ENU = 'Sales Order';
                    ApplicationArea = All;
                    Image = "Filter";
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Ellipsis = true;
                    trigger OnAction()
                    begin
                        ShowTableTypeEntries(36);
                    end;
                }
                action(PurchaseOrder)
                {
                    CaptionML = ENU = 'Purchase Order';
                    ApplicationArea = All;
                    Image = "Filter";
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Ellipsis = true;
                    trigger OnAction()
                    begin
                        ShowTableTypeEntries(38);
                    end;
                }
            }
        }
    }


    local procedure ShowTableTypeEntries(TableId: Integer)
    begin
        SETRANGE("Table ID", TableId);
        IF FINDSET THEN
            PAGE.RUN(PAGE::"Requests to Approve", Rec);
    end;
}