page 50237 "Pending Return Item Pack Head"
{
    // version Packing List Samadhan
    Caption = 'Pending Return Item Packing Header';
    PageType = Card;
    InsertAllowed = false;
    RefreshOnActivate = true;
    SourceTable = "Packing List Header";
    SourceTableView = SORTING (No)
                      ORDER(Ascending)
                      WHERE (Type = CONST ("Sales Return"), "Packing List Status" = const ("Pending for Approval"));

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
                    Editable = false;
                }
                field("Created  By"; "Created  By")
                {
                    Editable = false;
                }
                field("Return Recipt No."; "Return Recipt No.")
                {
                    Editable = false;
                }
                field("Return Recipt Line No."; "Return Recipt Line No.")
                {
                    Editable = false;
                }
                field("Prod. Order No."; "Prod. Order No.")
                {
                    Editable = false;
                }
                field("Sales Order No."; "Sales Order No.")
                {
                    Editable = false;
                }
                field("Customer No."; "Customer No.")
                {
                    Editable = false;
                }
                field("Customer's Name"; "Customer's Name")
                {
                    Editable = false;
                }
                field("Item No."; "Item No.")
                {
                    Editable = false;
                }
                field("Item Description"; "Item Description")
                {
                    Editable = false;
                }
                field(Status; Status)
                {
                    Editable = false;
                }
                field("Order Quantity"; "Order Quantity")
                {
                    Editable = false;
                }
                field("Total Finished Quantity"; "Total Finished Quantity")
                {
                    Editable = false;
                }
                field("Total Shipped Quantity"; "Total Shipped Quantity")
                {
                    Editable = false;
                }
                field("Existing Packing List Qty."; "Existing Packing List Qty.")
                {
                    Editable = false;
                }
                field("Available Qty for Packing"; "Available Qty for Packing")
                {
                    Editable = false;
                }
                field("Qty in each pallet"; "Qty in each pallet")
                {
                    Editable = false;
                }
                field("Total Pallet Quantity"; "Total Pallet Quantity")
                {
                    Editable = false;
                }
                field("No. of Pallets"; "No. of Pallets")
                {
                    Editable = false;
                }
                field("Packing List Status"; "Packing List Status")
                {

                }
                field("Approved By"; "Approved By")
                {

                }
                field(Remarks; Remarks)
                {

                }
            }
            part(Control13; "Pending Return Item Pack Line")
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
                    PackingLine.Reset;
                    PackingLine.SetRange(PackingLine."Packing List No.", No);
                    PackingListReport.SetTableView(PackingLine);
                    PackingListReport.Run;
                end;
            }
            action("Approve")
            {
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    UserSetup: Record "User Setup";
                begin
                    IF UserSetup.Get(UserId) then begin
                        if UserSetup."Return Packing list Approver" then begin
                            "Packing List Status" := "Packing List Status"::Approved;
                            "Approved By" := UserId();
                            Message('Packing List %1 has been successfully Approved', No);
                            Modify();
                        end else
                            Error('You do not have permission to approve the packing list Kindly check with Administrator');
                    end;
                end;
            }
            action("Reject")
            {
                Image = Reject;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    UserSetup: Record "User Setup";
                begin
                    IF UserSetup.Get(UserId) then begin
                        if UserSetup."Return Packing list Approver" then begin
                            TestField(Remarks);
                            "Packing List Status" := "Packing List Status"::Rejected;
                            "Approved By" := UserId();
                            Modify();
                        end else
                            Error('You do not have permission to approve the packing list Kindly check with Administrator');
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

