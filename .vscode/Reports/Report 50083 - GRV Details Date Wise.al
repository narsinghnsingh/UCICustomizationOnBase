report 50083 "GRV Details Date Wise"
{
    // version Purchase/Sadaf/Frz

    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/GRV Details Date Wise.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Purch. Rcpt. Line"; "Purch. Rcpt. Line")
        {
            DataItemTableView = SORTING ("Document No.", "Line No.") ORDER(Ascending) WHERE ("Posting Group" = FILTER ('PAPER'), Quantity = FILTER (<> 0));
            RequestFilterFields = "Buy-from Vendor No.", "Posting Date", "No.", "Document No.";
            column(CompName; COMINFO.Name)
            {
            }
            column(GRVNo; "Purch. Rcpt. Line"."Document No.")
            {
            }
            column(GRV_Date; "Purch. Rcpt. Line"."Posting Date")
            {
            }
            column(sys_date; WorkDate)
            {
            }
            column(ItemNo; "Purch. Rcpt. Line"."No.")
            {
            }
            column(Amount; Amount)
            {
            }
            column(Description; "Purch. Rcpt. Line".Description)
            {
            }
            column(Direct_unit_cost; "Purch. Rcpt. Line"."Direct Unit Cost")
            {
            }
            column(Quantity; "Purch. Rcpt. Line".Quantity)
            {
            }
            column(RemarkS; RemarkS)
            {
            }
            column(ReelNo; "Purch. Rcpt. Line"."Variant Code")
            {
            }
            column(PostingGroup_PurchRcptLine; "Purch. Rcpt. Line"."Posting Group")
            {
            }
            column(VendorName; VendorName)
            {
            }
            column(PaperGSM_PurchRcptLine; "Purch. Rcpt. Line"."Paper GSM")
            {
            }
            dataitem(Item; Item)
            {
                DataItemLink = "No." = FIELD ("No.");
                column(Deckle_size; Item."Deckle Size (mm)")
                {
                }
                column(Mill; "Purch. Rcpt. Line".MILL)
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                COMINFO.Get;

                Amount := "Purch. Rcpt. Line".Quantity * "Purch. Rcpt. Line"."Direct Unit Cost";

                RollMaster.Reset;
                RollMaster.SetRange(RollMaster."Purchase Receipt No.", "Document No.");
                RollMaster.SetRange(RollMaster."Item No.", "Purch. Rcpt. Line"."No.");
                RollMaster.SetRange(RollMaster."Document No.", "Purch. Rcpt. Line"."Order No.");
                if RollMaster.FindFirst then
                    ReelNo := RollMaster."MILL Reel No.";
                RemarkS := RollMaster.Remarks;

                //MESSAGE(ReelNo);
                VendorName := '';
                VendorCard.Reset;
                VendorCard.SetRange(VendorCard."No.", "Buy-from Vendor No.");
                if VendorCard.FindFirst then
                    VendorName := VendorCard.Name;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        Amount: Decimal;
        RollMaster: Record "Item Variant";
        ReelNo: Code[30];
        RemarkS: Text[50];
        COMINFO: Record "Company Information";
        VendorCard: Record Vendor;
        VendorName: Text[60];
}

