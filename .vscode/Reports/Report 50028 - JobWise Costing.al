report 50028 "JobWise Costing"
{
    // version Production/Sadaf

    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/JobWise Costing.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
        dataitem("Value Entry"; "Value Entry")
        {
            DataItemTableView = SORTING ("Order Type", "Order No.", "Order Line No.") ORDER(Ascending);
            RequestFilterFields = "Order No.";
            column(Cominfo_Name; CompanyInformation.Name)
            {
            }
            column(RunDate; WorkDate)
            {
            }
            column(ItemNo_ValueEntry; "Value Entry"."Item No.")
            {
            }
            column(OrderNo_ValueEntry; "Value Entry"."Order No.")
            {
            }
            column(OrderLineNo_ValueEntry; "Value Entry"."Order Line No.")
            {
            }
            column(ItemLedgerEntryType_ValueEntry; "Value Entry"."Item Ledger Entry Type")
            {
            }
            column(ItemLedgerEntryQuantity_ValueEntry; "Value Entry"."Item Ledger Entry Quantity")
            {
            }
            column(SourceNo_ValueEntry; "Value Entry"."Source No.")
            {
            }
            column(CostAmountActual_ValueEntry; "Value Entry"."Cost Amount (Actual)")
            {
            }
            column(Description_ValueEntry; "Value Entry".Description)
            {
            }
            column(ItemDescription; ItemDescription)
            {
            }
            column(ItemDescription1; ItemDescription1)
            {
            }
            column(TYPE; CapacityLedgerEntryType)
            {
            }
            column(MacNo; MacNo)
            {
            }
            column(Macdes; Macdes)
            {
            }
            column(OutputQty; OutputQty)
            {
            }
            column(ScrapQty; ScrapQty)
            {
            }
            column(No_ValueEntry; "Value Entry"."No.")
            {
            }

            trigger OnAfterGetRecord()
            begin
                CompanyInformation.Get;
                ItemDescription := '';
                ProdOrderLine.Reset;
                ProdOrderLine.SetRange(ProdOrderLine."Prod. Order No.", "Order No.");
                ProdOrderLine.SetRange(ProdOrderLine."Line No.", "Order Line No.");
                if ProdOrderLine.FindFirst then begin
                    ItemDescription := ProdOrderLine.Description;
                end;

                ItemDescription1 := '';
                Item.Reset;
                Item.SetRange(Item."No.", "Item No.");
                if Item.FindFirst then begin
                    ItemDescription1 := Item.Description;
                end;


                /*MacNo :='';
                Macdes :='';
                OutputQty :=0;
                ScrapQty :=0;
                CapacityLedgerEntryType:='';
                IF "Value Entry"."Item Ledger Entry No." = 0 THEN BEGIN
                  CapacityLedgerEntry.RESET;
                  CapacityLedgerEntry.SETRANGE(CapacityLedgerEntry."Entry No.","Capacity Ledger Entry No.");
                  IF CapacityLedgerEntry.FINDFIRST THEN BEGIN
                    CapacityLedgerEntryType := FORMAT(CapacityLedgerEntry.Type);
                    MacNo := CapacityLedgerEntry."No.";
                    Macdes := CapacityLedgerEntry.Description;
                    OutputQty += CapacityLedgerEntry."Output Quantity";
                    ScrapQty += CapacityLedgerEntry."Scrap Quantity";
                   END;
                END;*/


                Macdes := '';
                MachineCenter.Reset;
                MachineCenter.SetRange(MachineCenter."No.", "Value Entry"."No.");
                if MachineCenter.FindFirst then begin
                    Macdes := MachineCenter.Name;
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
        ProdOrderLine: Record "Prod. Order Line";
        ItemDescription: Text;
        CompanyInformation: Record "Company Information";
        Item: Record Item;
        ItemDescription1: Text;
        CapacityLedgerEntry: Record "Capacity Ledger Entry";
        CapacityLedgerEntryType: Text;
        MacNo: Code[10];
        Macdes: Text;
        OutputQty: Decimal;
        ScrapQty: Decimal;
        MachineCenter: Record "Machine Center";
}

