report 50055 "Additional Cost ChargeAssignmt"
{
    // version Purchase/Sadaf

    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/Additional Cost ChargeAssignmt.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Purch. Rcpt. Line"; "Purch. Rcpt. Line")
        {
            DataItemTableView = SORTING ("Document No.", "Line No.") ORDER(Ascending) WHERE ("Item Category Code" = FILTER ('PAPER'), Quantity = FILTER (<> 0));
            RequestFilterFields = "Posting Date";
            column(COMINFO_Name; CompanyInformation.Name)
            {
            }
            column(RUNDATE; WorkDate)
            {
            }
            column(REP_CAP; REP_CAP)
            {
            }
            column(ALLFILTER; ALLFILTER)
            {
            }
            column(DocumentNo_PurchRcptLine; "Purch. Rcpt. Line"."Document No.")
            {
            }
            column(No_PurchRcptLine; "Purch. Rcpt. Line"."No.")
            {
            }
            column(ITEM_DESC; ITEM_DESC)
            {
            }
            column(Description_PurchRcptLine; "Purch. Rcpt. Line".Description)
            {
            }
            column(Quantity_PurchRcptLine; "Purch. Rcpt. Line".Quantity)
            {
            }
            column(VariantCode_PurchRcptLine; "Purch. Rcpt. Line"."Variant Code")
            {
            }
            column(UnitofMeasureCode_PurchRcptLine; "Purch. Rcpt. Line"."Unit of Measure Code")
            {
            }
            column(PaperType_PurchRcptLine; "Purch. Rcpt. Line"."Paper Type")
            {
            }
            column(ENTRYNO; ENTRYNO)
            {
            }
            column(UnitCost_PurchRcptLine; "Purch. Rcpt. Line"."Unit Cost")
            {
            }
            column(UnitCostLCY_PurchRcptLine; "Purch. Rcpt. Line"."Unit Cost (LCY)")
            {
            }
            column(CHARGES_CAP1; CHARGES_CAP[1])
            {
            }
            column(CHARGES_CAP2; CHARGES_CAP[15])
            {
            }
            column(CHARGES_CAP3; CHARGES_CAP[3])
            {
            }
            column(CHARGES_CAP4; CHARGES_CAP[4])
            {
            }
            column(CHARGES_CAP5; CHARGES_CAP[5])
            {
            }
            column(CHARGES_CAP6; CHARGES_CAP[6])
            {
            }
            column(CHARGES_CAP7; CHARGES_CAP[7])
            {
            }
            column(CHARGES_CAP8; CHARGES_CAP[8])
            {
            }
            column(CHARGES_CAP9; CHARGES_CAP[9])
            {
            }
            column(CHARGES_CAP10; CHARGES_CAP[10])
            {
            }
            column(CHARGES_CAP11; CHARGES_CAP[11])
            {
            }
            column(CHARGES_CAP12; CHARGES_CAP[12])
            {
            }
            column(CHARGES_AMT1; CHARGES_AMT[1])
            {
            }
            column(CHARGES_AMT2; CHARGES_AMT[15])
            {
            }
            column(CHARGES_AMT3; CHARGES_AMT[3])
            {
            }
            column(CHARGES_AMT4; CHARGES_AMT[4])
            {
            }
            column(CHARGES_AMT5; CHARGES_AMT[5])
            {
            }
            column(CHARGES_AMT6; CHARGES_AMT[6])
            {
            }
            column(CHARGES_AMT7; CHARGES_AMT[7])
            {
            }
            column(CHARGES_AMT8; CHARGES_AMT[8])
            {
            }
            column(CHARGES_AMT9; CHARGES_AMT[9])
            {
            }
            column(CHARGES_AMT10; CHARGES_AMT[10])
            {
            }
            column(CHARGES_AMT11; CHARGES_AMT[11])
            {
            }
            column(CHARGES_AMT12; CHARGES_AMT[12])
            {
            }

            trigger OnAfterGetRecord()
            begin
                CompanyInformation.Get;
                ALLFILTER := "Purch. Rcpt. Line".GetFilters;

                ROWNO := 1;
                ItemCharge.Reset;
                if ItemCharge.FindFirst then begin
                    repeat
                        CHARGES_CAP[ROWNO] := ItemCharge."No.";
                        ROWNO := ROWNO + 1;
                    until ItemCharge.Next = 0;
                end;

                ROWNO1 := 1;
                CHARGES_AMT[1] := 0;
                CHARGES_AMT[2] := 0;
                CHARGES_AMT[3] := 0;
                CHARGES_AMT[4] := 0;
                CHARGES_AMT[5] := 0;
                CHARGES_AMT[6] := 0;
                CHARGES_AMT[7] := 0;
                CHARGES_AMT[8] := 0;
                CHARGES_AMT[9] := 0;
                CHARGES_AMT[10] := 0;
                CHARGES_AMT[11] := 0;
                CHARGES_AMT[12] := 0;
                CHARGES_AMT[13] := 0;
                CHARGES_AMT[14] := 0;
                CHARGES_AMT[15] := 0;
                CHARGES_AMT[16] := 0;



                ENTRYNO := 0;
                ItemLedgerEntry.Reset;
                ItemLedgerEntry.SetRange(ItemLedgerEntry."Document No.", "Document No.");
                ItemLedgerEntry.SetRange(ItemLedgerEntry."Variant Code", "Variant Code");
                if ItemLedgerEntry.FindFirst then begin
                    ENTRYNO := ItemLedgerEntry."Entry No.";
                    ValueEntry.Reset;
                    ValueEntry.SetRange(ValueEntry."Item Ledger Entry No.", ItemLedgerEntry."Entry No.");
                    if ValueEntry.FindFirst then begin
                        repeat
                            if ValueEntry."Item Charge No." = CHARGES_CAP[1] then
                                CHARGES_AMT[1] += ValueEntry."Cost Amount (Actual)";
                            if ValueEntry."Item Charge No." = CHARGES_CAP[2] then
                                CHARGES_AMT[2] += ValueEntry."Cost Amount (Actual)";
                            if ValueEntry."Item Charge No." = CHARGES_CAP[3] then
                                CHARGES_AMT[3] += ValueEntry."Cost Amount (Actual)";
                            if ValueEntry."Item Charge No." = CHARGES_CAP[4] then
                                CHARGES_AMT[4] += ValueEntry."Cost Amount (Actual)";
                            if ValueEntry."Item Charge No." = CHARGES_CAP[5] then
                                CHARGES_AMT[5] += ValueEntry."Cost Amount (Actual)";
                            if ValueEntry."Item Charge No." = CHARGES_CAP[6] then
                                CHARGES_AMT[6] += ValueEntry."Cost Amount (Actual)";
                            if ValueEntry."Item Charge No." = CHARGES_CAP[7] then
                                CHARGES_AMT[7] += ValueEntry."Cost Amount (Actual)";
                            if ValueEntry."Item Charge No." = CHARGES_CAP[8] then
                                CHARGES_AMT[8] += ValueEntry."Cost Amount (Actual)";
                            if ValueEntry."Item Charge No." = CHARGES_CAP[9] then
                                CHARGES_AMT[9] += ValueEntry."Cost Amount (Actual)";
                            if ValueEntry."Item Charge No." = CHARGES_CAP[10] then
                                CHARGES_AMT[10] += ValueEntry."Cost Amount (Actual)";
                            if ValueEntry."Item Charge No." = CHARGES_CAP[11] then
                                CHARGES_AMT[11] += ValueEntry."Cost Amount (Actual)";
                            if ValueEntry."Item Charge No." = CHARGES_CAP[12] then
                                CHARGES_AMT[12] += ValueEntry."Cost Amount (Actual)";
                            if ValueEntry."Item Charge No." = CHARGES_CAP[13] then
                                CHARGES_AMT[13] += ValueEntry."Cost Amount (Actual)";
                            if ValueEntry."Item Charge No." = CHARGES_CAP[14] then
                                CHARGES_AMT[14] += ValueEntry."Cost Amount (Actual)";
                            if ValueEntry."Item Charge No." = CHARGES_CAP[15] then
                                CHARGES_AMT[15] += ValueEntry."Cost Amount (Actual)";
                            if ValueEntry."Item Charge No." = CHARGES_CAP[16] then
                                CHARGES_AMT[16] += ValueEntry."Cost Amount (Actual)";
                        until ValueEntry.Next = 0;
                    end;
                end;
                ITEM_DESC := '';
                Item.Reset;
                Item.SetRange(Item."No.", "No.");
                if Item.FindFirst then begin
                    ITEM_DESC := Item.Description;
                end;
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
        REP_CAP: Label 'ADDITIONAL COST CHARGE ASSIGNMENT';
        ALLFILTER: Text;
        ItemLedgerEntry: Record "Item Ledger Entry";
        ENTRYNO: Integer;
        DOCNO: Code[30];
        ValueEntry: Record "Value Entry";
        ROWNO: Integer;
        CHARGES_CAP: array[16] of Code[30];
        CHARGES_AMT: array[1000000] of Decimal;
        ItemCharge: Record "Item Charge";
        ROWNO1: Integer;
        TOTAL_AMT: Decimal;
        Item: Record Item;
        ITEM_DESC: Text;
}

