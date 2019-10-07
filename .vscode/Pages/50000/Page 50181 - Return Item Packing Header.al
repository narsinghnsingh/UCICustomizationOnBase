page 50181 "Return Item Packing Header"
{
    // version Packing List Samadhan

    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "Packing List Header";
    SourceTableView = SORTING (No)
                      ORDER(Ascending)
                      WHERE (Type = CONST ("Sales Return"), "Packing List Status" = filter (open | Approved | Rejected));

    layout
    {
        area(content)
        {
            group(Header)
            {
                field(No; No)
                {
                }
                field("Creation Date"; "Creation Date")
                {
                    Editable = true;
                }
                field("Created  By"; "Created  By")
                {
                }
                field("Return Recipt No."; "Return Recipt No.")
                {
                    Editable = RemarkEditable;
                }
                field("Return Recipt Line No."; "Return Recipt Line No.")
                {
                    Editable = RemarkEditable;
                }
                field("Prod. Order No."; "Prod. Order No.")
                {
                    Editable = false;
                }
                field("Sales Order No."; "Sales Order No.")
                {
                    Editable = RemarkEditable;
                }
                field("Customer No."; "Customer No.")
                {
                }
                field("Customer's Name"; "Customer's Name")
                {
                }
                field("Item No."; "Item No.")
                {
                }
                field("Item Description"; "Item Description")
                {
                }
                field(Status; Status)
                {
                }
                field("Order Quantity"; "Order Quantity")
                {
                }
                field("Total Finished Quantity"; "Total Finished Quantity")
                {
                }
                field("Total Shipped Quantity"; "Total Shipped Quantity")
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
                    Editable = RemarkEditable;
                }
                field("Total Pallet Quantity"; "Total Pallet Quantity")
                {
                }
                field("No. of Pallets"; "No. of Pallets")
                {
                }
                field("Packing List Status"; "Packing List Status")
                {

                }
                field("Approved By"; "Approved By")
                {

                }
                field(Remarks; Remarks)
                {
                    Editable = RemarkEditable;
                }
            }
            part(Control13; "Return Item Packing Line")
            {
                SubPageLink = "Packing List No." = FIELD (FILTER (No)),
                              "Prod. Order No." = FIELD (FILTER ("Prod. Order No.")),
                              "Sales Order No." = FIELD (FILTER ("Sales Order No."));
                SubPageView = SORTING ("Packing List No.", "Pallet No.")
                              ORDER(Ascending);
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Generate Pallets")
            {
                Image = ResourcePrice;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortCutKey = 'Ctrl+P';

                trigger OnAction()
                begin

                    TestField(Status, Status::Open);
                    TestField("Qty in each pallet");
                    TestField("Packing List Status", "Packing List Status"::Open);
                    if "Available Qty for Packing" < "Qty in each pallet" then
                        Error('Available Qty for Packing must not be less then "Qty in each pallet"');

                    NoofPallet := Round("Available Qty for Packing" / "Qty in each pallet", 1, '<');
                    //MESSAGE(FORMAT(NoofPallet));
                    I := 1;
                    PackingLine.Reset;
                    for I := 1 to NoofPallet do begin
                        PackingLine.Reset;
                        PackingLine."Packing List No." := No;
                        PackingLine."Pallet No." := I;
                        //MESSAGE(FORMAT(I));
                        PackingLine.Quantity := "Qty in each pallet";
                        PackingLine."Prod. Order No." := "Prod. Order No.";
                        PackingLine."Sales Order No." := "Sales Order No.";
                        PackingLine."Sales Order Line No." := "Sales Order Line No.";
                        PackingLine."Item No." := "Item No.";
                        PackingLine."Document Type" := PackingLine."Document Type"::Order;
                        PackingLine."Return Recipt No" := "Return Recipt No.";
                        PackingLine."Return Recipt Line No." := "Return Recipt Line No.";
                        PackingLine.Insert(true);
                    end;
                    CalcFields("Total Pallet Quantity");
                    "Available Qty for Packing" := "Available Qty for Packing" - "Total Pallet Quantity";
                    if "Available Qty for Packing" <> 0 then begin
                        PackingLine.Reset;
                        PackingLine."Packing List No." := No;
                        PackingLine."Pallet No." := I + 1;
                        //MESSAGE(FORMAT(I));
                        PackingLine.Quantity := "Available Qty for Packing";
                        PackingLine."Prod. Order No." := "Prod. Order No.";
                        PackingLine."Sales Order No." := "Sales Order No.";
                        PackingLine."Sales Order Line No." := "Sales Order Line No.";
                        PackingLine."Item No." := "Item No.";
                        PackingLine."Document Type" := PackingLine."Document Type"::Order;
                        PackingLine."Return Recipt No" := "Return Recipt No.";
                        PackingLine."Return Recipt Line No." := "Return Recipt Line No.";

                        PackingLine.Insert(true);
                    end;
                    CalcFields("Total Pallet Quantity");
                    "Available Qty for Packing" := "Total Finished Quantity" - "Total Pallet Quantity";


                    Modify(true);
                end;
            }
            action("Item Card")
            {
                Image = Item;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Item Card";
                RunPageLink = "No." = FIELD ("Item No.");
                RunPageView = SORTING ("No.");
            }
            action("Print Pallet Tag")
            {
                Caption = 'Print Pallet Tag';
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    // Lines added bY deepak kumar
                    IF "Packing List Status" = "Packing List Status"::Approved then begin
                        PackingLine.Reset;
                        PackingLine.SetRange(PackingLine."Packing List No.", No);
                        PackingListReport.SetTableView(PackingLine);
                        PackingListReport.Run;
                    end else
                        Error('Return Packing List must be approved');
                end;
            }
            action("Send for Approval")
            {
                Caption = 'Send for Approval';
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    // Lines added by Deepak Kumar
                    IF "Packing List Status" IN ["Packing List Status"::Open] then begin
                        CalcFields("No. of Pallets");
                        IF "No. of Pallets" = 0 then
                            ERROR('Kindly generate pallet first');
                        "Packing List Status" := "Packing List Status"::"Pending for Approval";
                        Modify();
                        Message('Packing List %1 has been successfully Sent for Approval', No);
                    END else
                        Error('Return Packing List should be Open, Kindly Reopen it and Send it for Approval');
                end;
            }
            action(Release)
            {
                Caption = 'Release';
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    // Lines added by Deepak Kumar
                    IF "Packing List Status" = "Packing List Status"::Approved then
                        ReleasePackingList
                    else
                        Error('Return Packing List should be approved, Kindly Send it for Approval');
                end;
            }
            action("Re-Open")
            {
                Caption = 'Re-Open';
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    // Lines added by Deepak Kumar
                    IF ("Packing List Status" in ["Packing List Status"::Approved, "Packing List Status"::Rejected])
                        AND (Status = Status::Released) then begin
                        "Packing List Status" := "Packing List Status"::Open;
                        Modify();
                        ReOpenPackingList;
                    end else begin
                        IF ("Packing List Status" in ["Packing List Status"::Approved, "Packing List Status"::Rejected]) then begin
                            "Packing List Status" := "Packing List Status"::Open;
                            Modify();
                        END;
                    ENd;
                end;
            }
            action("Refresh Packing")
            {
                Image = Recalculate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    IF "Packing List Status" = "Packing List Status"::Open then begin
                        Validate("Return Recipt Line No.", "Return Recipt Line No.");
                        Modify(true);
                    end;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        CalcFields("Total Pallet Quantity");
        Validate("Remaining Qty to Pack", ("Available Qty for Packing" - "Total Pallet Quantity"));
    end;

    trigger OnAfterGetCurrRecord()
    begin
        If "Packing List Status" IN ["Packing List Status"::Approved, "Packing List Status"::Rejected] THEN
            RemarkEditable := false
        else
            RemarkEditable := true;

    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Type := Type::"Sales Return";
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    begin
        CalcFields("Total Pallet Quantity");
        Validate("Remaining Qty to Pack", ("Available Qty for Packing" - "Total Pallet Quantity"));
    end;

    trigger OnOpenPage()
    begin
        /*
        CALCFIELDS("Total Pallet Quantity");
        VALIDATE("Remaining Qty to Pack",("Available Qty for Packing" - "Total Pallet Quantity"));
         */

    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        CalcFields("Total Pallet Quantity");
        Validate("Remaining Qty to Pack", ("Available Qty for Packing" - "Total Pallet Quantity"));
    end;

    var
        NoofPallet: Integer;
        I: Integer;
        PackingLine: Record "Packing List Line";
        PackingListReport: Report "Pallet Tag";
        PackingListReport2: Report "JobWise Costing";
        RemarkEditable: Boolean;
}

