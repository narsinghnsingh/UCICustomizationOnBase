pageextension 50047 Ext_ReleasedProductionOrder extends "Released Production Order"
{
    layout
    {
        addafter("Last Date Modified")

        {

            field("Creation Date"; "Creation Date")
            {
            }

            field("Sales Order No."; "Sales Order No.")
            {
            }
            field("Sales Order Line No."; "Sales Order Line No.")
            {
            }
            field("Salesperson Code"; "Salesperson Code")
            {
                Editable = false;
            }
            field("Estimate Code"; "Estimate Code")
            {
            }
            field("Customer Name"; "Customer Name")
            {
            }
            field("Repeat Job"; "Repeat Job")
            {
            }
            field(Modified; Modified)
            {
            }
            field("Production Approval Status"; "Production Approval Status")
            {
                Importance = Additional;
            }
            field("Sales Requested Delivery Date"; "Sales Requested Delivery Date")
            {
            }
            field("Eliminate in Prod. Schedule"; "Eliminate in Prod. Schedule")
            {
            }
            field("Allowed Extra Consumption"; "Allowed Extra Consumption")
            {
                Importance = Additional;
            }
            field("Allowed Extra Consumption By"; "Allowed Extra Consumption By")
            {
                Importance = Additional;
            }

            // field("Inventory Posting Group";"Inventory Posting Group")
            // {
            //     Importance = Promoted;
            // }
            // field("Gen. Prod. Posting Group";"Gen. Prod. Posting Group")
            // {
            // }
            // field("Gen. Bus. Posting Group";"Gen. Bus. Posting Group")
            // {
            // }

        }
        addafter(Control1905767507)
        {
            part(Control29; "Prod. Order ListPart")
            {
                SubPageLink = "Prod. Order No." = FIELD ("No.");
                Visible = true;
            }
        }

    }


    actions
    {
        addafter(OrderTracking)
        {
            separator(Separator23)
            {
                Caption = '';
            }
            action("<Special Instruction>")
            {
                Caption = 'Special Instruction';
                Promoted = true;
                RunObject = Page "Estimate Special Description";
                RunPageLink = "No." = FIELD ("Estimate Code");
                RunPageView = SORTING ("No.", "Line No.");
            }
            action("Update Components")
            {
                Caption = 'Update Components';
                Image = Components;
                Promoted = true;
                RunPageMode = Edit;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Update Prod Component";
                RunPageLink = Status = FIELD (Status),
                                  "No." = FIELD ("No.");

                trigger OnAction()
                var
                    UpdateCompPage: Page "Posted Inspection Line";
                begin
                end;
            }
            separator(Separator87)
            {
            }
            action("Consumption Journal")
            {
                Image = ConsumptionJournal;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Consumption Journal";
                RunPageView = SORTING ("Journal Template Name", "Journal Batch Name", "Line No.");
            }
            action("Allow Extra Consumption ")
            {
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    // Lines Added by deepak Kumar
                    UserSetup.Reset;
                    UserSetup.SetRange(UserSetup."User ID", UserId);
                    UserSetup.SetRange(UserSetup."Approval Authority Extra Cons", true);
                    if UserSetup.FindFirst then begin
                        "Allowed Extra Consumption" := true;
                        "Allowed Extra Consumption By" := UserId + ' ' + Format(CurrentDateTime);
                        Modify(true);

                        Message('Production Order %1 Allowed for extra consumption0', "No.");

                    end else begin
                        Error('You are not authorised user, Please contact your system Administrator');
                    end;
                end;
            }
            action(Hello)
            {
                Caption = 'Hello';
                Enabled = false;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ItemLedgerEntry: Record "Item Ledger Entry";
                begin
                    ItemLedgerEntry.Reset;
                    ItemLedgerEntry.SetRange("Order Type", ItemLedgerEntry."Order Type"::Production);
                    ItemLedgerEntry.SetRange("Order No.", "No.");
                    if ItemLedgerEntry.FindSet then begin
                        PAGE.Run(38, ItemLedgerEntry);
                    end;
                end;
            }
        }
        addafter("Subcontractor - Dispatch List")
        {
            action("DIE REQUISITION")
            {
                Promoted = true;
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction()
                begin
                    ProdOrderRec.Reset;
                    ProdOrderRec.SetRange(ProdOrderRec."No.", "No.");
                    if ProdOrderRec.FindFirst then
                        REPORT.RunModal(REPORT::"DIE Requistion", true, true, ProdOrderRec);
                end;
            }
            action("Plate Requisition")
            {
                Caption = 'Plate Requisition';
                Promoted = true;
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction()
                begin
                    ProdOrderRec.Reset;
                    ProdOrderRec.SetRange(ProdOrderRec."No.", "No.");
                    if ProdOrderRec.FindFirst then
                        REPORT.RunModal(REPORT::"Plate Requistion", true, true, ProdOrderRec);
                end;
            }
            action("Variation Details")
            {
                Caption = 'Variation Details';
                Image = Versions;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Paper Variation";
                RunPageLink = "Production Order" = FIELD ("No.");
                RunPageView = SORTING ("Production Order", "Prod. Order Line", "Paper Position")
                              ORDER(Ascending);
            }
        }
    }

    var
        PROD_ORDER: Record "Production Order";
        ProdOrderRec: Record "Production Order";
        UserSetup: Record "User Setup";

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        "Creation Date" := Today;
    end;
}