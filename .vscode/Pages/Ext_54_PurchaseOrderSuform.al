pageextension 50018 Ext_54_PurchaseOrderSubform extends "Purchase Order Subform"
{
    layout
    {
        // Add changes to page layout here
        addafter("Location Code")
        {
            field("Receiving Location"; "Receiving Location")
            {

            }
            field("Currency Code"; "Currency Code")
            {

            }
        }
        addafter("Unit of Measure")
        {
            field("Amount Including VAT"; "Amount Including VAT")
            {

            }
        }
        addafter("Qty. to Receive")
        {
            field("Depreciation Book Code"; "Depreciation Book Code")
            {

            }
            field(Paper; Paper)
            {

            }
            field("Paper Type"; "Paper Type")
            {

            }
            field("Paper GSM"; "Paper GSM")
            {

            }
            field("Outstanding Quantity"; "Outstanding Quantity")
            {

            }
            field("Roll Quantity to Receive"; "Roll Quantity to Receive")
            {

            }
            field("No of Roll to Recive"; "No of Roll to Recive")
            {

            }



        }

        addafter("Quantity Invoiced")
        {
            field(ORIGIN; ORIGIN)
            {

            }
            field(MILL; MILL)
            {

            }
        }
        addafter("Shortcut Dimension 2 Code")
        {
            field("Short Closed Document"; "Short Closed Document")
            {

            }

            field("Short Closed Quantity"; "Short Closed Quantity")
            {

            }
        }
        addafter("VAT Prod. Posting Group")
        {
            field("VAT %"; "VAT %")
            {

            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter("&Line")
        {
            action("Paper Roll Entry")
            {
                ApplicationArea = All;
                ShortCutKey = 'Ctrl+r';
                Promoted = true;
                PromotedIsBig = true;
                Image = Bins;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    Item: Record Item;
                    RollMaster: Record "Item Variant";
                    RollDetails: Page "Roll Details";
                begin
                    // Lines added bY Deepak Kumar
                    TESTFIELD(Type, Type::Item);
                    Item.GET("No.");
                    Item.TESTFIELD(Item."Roll ID Applicable", TRUE);
                    TESTFIELD("Receiving Location");
                    TESTFIELD("Location Code");
                    TESTFIELD("Direct Unit Cost");
                    TESTFIELD(Quantity);
                    Clear(RollDetails);
                    RollMaster.RESET;
                    RollMaster.SETRANGE(RollMaster."Document No.", "Document No.");
                    RollMaster.SETRANGE(RollMaster."Document Line No.", "Line No.");
                    RollMaster.SETRANGE(RollMaster."Item No.", "No.");
                    RollDetails.SETTABLEVIEW(RollMaster);
                    RollDetails.Run();
                end;
            }
            action(Label)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = Print;
                PromotedCategory = Report;
                trigger OnAction()
                begin
                    ITEM_VARAINT.RESET;
                    ITEM_VARAINT.SETCURRENTKEY(ITEM_VARAINT."Document No.");
                    IF ITEM_VARAINT.FINDFIRST THEN
                        ITEM_VARAINT.SETRANGE(ITEM_VARAINT."Document No.", "Document No.");
                    REPORT.RUNMODAL(REPORT::"Label", TRUE, TRUE, ITEM_VARAINT);
                end;
            }
        }
    }

    var
        ITEM_VARAINT: Record "Item Variant";

    trigger OnOpenPage()
    begin
        FilterGroup(2);
        SetRange("For Location Roll Entry", Rec."For Location Roll Entry"::Mother);
        FilterGroup(0);
    end;
}