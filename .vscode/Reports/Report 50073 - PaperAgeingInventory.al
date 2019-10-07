report 50073 PaperAgeingInventory
{
    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/PaperAgeingInventory.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = SORTING ("No.") ORDER(Ascending) WHERE ("Item Category Code" = CONST ('PAPER'));
            RequestFilterFields = "Date Filter";
            dataitem("Item Ledger Entry"; "Item Ledger Entry")
            {
                DataItemLink = "Item No." = FIELD ("No.");
                DataItemTableView = SORTING ("Item No.", Positive, "Location Code", "Variant Code") ORDER(Ascending) WHERE ("Item Category Code" = FILTER ('PAPER'), Positive = CONST (true));
                RequestFilterFields = "Posting Date";
                column(EntryType_ItemLedgerEntry; "Item Ledger Entry"."Entry Type")
                {
                }
                column(ALLFILTER; ALLFILTER)
                {
                }
                column(Cominfo_Name; CompanyInformation.Name)
                {
                }
                column(Rundate; WorkDate)
                {
                }
                column(PaperType_ItemLedgerEntry; "Item Ledger Entry"."Paper Type")
                {
                }
                column(PaperGSM_ItemLedgerEntry; "Item Ledger Entry"."Paper GSM")
                {
                }
                column(DeckleSizemm_ItemLedgerEntry; "Item Ledger Entry"."Deckle Size (mm)")
                {
                }
                column(DocumentNo_ItemLedgerEntry; "Item Ledger Entry"."Document No.")
                {
                }
                column(PostingDate_ItemLedgerEntry; "Item Ledger Entry"."Posting Date")
                {
                }
                column(VariantCode_ItemLedgerEntry; "Item Ledger Entry"."Variant Code")
                {
                }
                column(RemainingQuantity_ItemLedgerEntry; "Item Ledger Entry"."Remaining Quantity")
                {
                }
                column(Quantity_ItemLedgerEntry; "Item Ledger Entry".Quantity)
                {
                }
                column(Qty; Qty)
                {
                }
                column(Vendor_Nmae; Vendor_Nmae)
                {
                }
                column(NOOFDYS; NOOFDYS)
                {
                }
                column(MILLNO; MILLNO)
                {
                }
                column(GRNNo; GRNNo)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    CompanyInformation.Get;
                    ALLFILTER := "Item Ledger Entry".GetFilters;

                    NOOFDYS := WorkDate - "Item Ledger Entry"."Posting Date";
                    Qty := 0;

                    //"Item Ledger Entry".CALCSUMS("Item Ledger Entry".Quantity);
                    //Mpower

                    if (VarCode <> "Item Ledger Entry"."Variant Code") then begin
                        ItemLedgerEntry.Reset;
                        ItemLedgerEntry.SetFilter("Posting Date", "Item Ledger Entry".GetFilter("Item Ledger Entry"."Posting Date"));
                        ItemLedgerEntry.SetRange(ItemLedgerEntry."Item No.", "Item No.");
                        ItemLedgerEntry.SetRange(ItemLedgerEntry."Variant Code", "Variant Code");
                        if ItemLedgerEntry.FindSet then begin
                            ItemLedgerEntry.CalcSums(ItemLedgerEntry.Quantity);
                            Qty := ItemLedgerEntry.Quantity;
                        end;
                        //Mpower

                        if Qty = 0 then begin
                            VarCode := "Item Ledger Entry"."Variant Code";
                            CurrReport.Skip;
                        end;

                        MILLNO := '';
                        GRNNo := '';
                        Vendor_Nmae := '';
                        ITEMVARINT.Reset;
                        ITEMVARINT.SetRange(ITEMVARINT."Purchase Receipt No.", "Document No.");
                        ITEMVARINT.SetRange(ITEMVARINT.Code, "Variant Code");
                        if ITEMVARINT.FindFirst then begin
                            MILLNO := ITEMVARINT."MILL Reel No.";
                            GRNNo := ITEMVARINT."Purchase Receipt No.";
                            PurchRcptHeader.Reset;
                            PurchRcptHeader.SetRange(PurchRcptHeader."No.", ITEMVARINT."Purchase Receipt No.");
                            if PurchRcptHeader.FindFirst then
                                Vendor_Nmae := PurchRcptHeader."Buy-from Vendor Name"
                            else
                                Vendor_Nmae := '';
                        end;
                        VarCode := "Item Ledger Entry"."Variant Code";
                    end else
                        CurrReport.Skip
                end;

                trigger OnPreDataItem()
                begin
                    VarCode := '';
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Item.CalcFields(Item."Net Change");
                if Item."Net Change" = 0 then
                    CurrReport.Skip;
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
        CompanyInformation: Record "Company Information";
        Vendor_Nmae: Text;
        ALLFILTER: Text;
        NOOFDYS: Integer;
        ITEMVARINT: Record "Item Variant";
        MILLNO: Code[30];
        GRNNo: Code[30];
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        ItemLedgerEntry: Record "Item Ledger Entry";
        Qty: Decimal;
        Item_Num: Code[20];
        VarCode: Code[20];
}

