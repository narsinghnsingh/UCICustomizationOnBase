page 50050 "Packing List"
{
    // version Packing List Samadhan

    CardPageID = "Packing List Header";
    PageType = List;
    UsageCategory = Lists;
    RefreshOnActivate = true;
    SourceTable = "Packing List Header";
    SourceTableView = SORTING (Type, No)
                      ORDER(Ascending)
                      WHERE (Type = CONST (Production));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No; No)
                {
                }
                field("Sales Order No."; "Sales Order No.")
                {
                }
                field(Status; Status)
                {
                }
                field("Creation Date"; "Creation Date")
                {
                }
                field("Created  By"; "Created  By")
                {
                }
                field("Prod. Order No."; "Prod. Order No.")
                {
                }
                field("Prod. Order Line No."; "Prod. Order Line No.")
                {
                }
                field("Item No."; "Item No.")
                {
                }
                field("Order Quantity"; "Order Quantity")
                {
                }
                field("Existing Packing List Qty."; "Existing Packing List Qty.")
                {
                }
                field("Available Qty for Packing"; "Available Qty for Packing")
                {
                }
                field("Qty in each pallet"; "Qty in each pallet")
                {
                }
                field("No. of Pallets"; "No. of Pallets")
                {
                }
                field("Total Shipped Quantity"; "Total Shipped Quantity")
                {
                }
                field("Customer No."; "Customer No.")
                {
                }
                field("Customer's Name"; "Customer's Name")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Truncate Remaining Qty")
            {
                Visible = false;

                trigger OnAction()
                begin
                    FindFirst;
                    repeat
                        "Remaining Qty to Pack" := 0;
                        Modify(true);
                    until Next = 0;
                    Message('Complete');
                end;
            }
            action("Update Creation Date")
            {
                Visible = false;

                trigger OnAction()
                begin

                    ChangeLog.Reset;
                    ChangeLog.SetRange(ChangeLog."Table No.", 50029);
                    ChangeLog.SetRange(ChangeLog."Type of Change", ChangeLog."Type of Change"::Insertion);
                    ChangeLog.SetRange(ChangeLog."Primary Key Field 1 Value", No);
                    if ChangeLog.FindFirst then begin
                        repeat
                            "Creation Date" := DT2Date(ChangeLog."Date and Time");
                            "Created  By" := ChangeLog."User ID";
                            Modify(true);
                        until ChangeLog.Next = 0;
                    end;
                    Message('Update Complete');
                end;
            }
            action("Update Customer No & Name")
            {
                Visible = false;

                trigger OnAction()
                begin
                    PackingHeader.Reset;
                    PackingHeader.SetFilter(PackingHeader."Sales Order No.", '<>%1', '');
                    if PackingHeader.FindFirst then begin
                        repeat
                            SH.Reset;
                            SH.SetRange(SH."Document Type", SH."Document Type"::Order);
                            SH.SetRange(SH."No.", PackingHeader."Sales Order No.");
                            if SH.FindFirst then begin
                                PackingHeader."Customer No." := SH."Sell-to Customer No.";
                                PackingHeader."Customer's Name" := SH."Bill-to Name";
                                PackingHeader.Modify(true);
                            end;
                        until PackingHeader.Next = 0;
                    end;
                    Message('Update Complete');
                end;
            }
            action("Return Item Packing List")
            {
                Caption = 'Return Item Packing List';
                Image = ReturnReceipt;
                Promoted = true;
                RunObject = Page "Return Item Packing List";
            }
        }
    }

    var
        ChangeLog: Record "Change Log Entry";
        PackingHeader: Record "Packing List Header";
        SH: Record "Sales Header";
}

