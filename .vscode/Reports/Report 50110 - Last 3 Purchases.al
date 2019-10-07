report 50110 "Last 3 Purchases"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/Last 3 Purchases.rdlc';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            DataItemTableView = SORTING ("Item No.", "Posting Date") ORDER(Descending) WHERE ("Entry Type" = FILTER (Purchase | "Positive Adjmt."));
            RequestFilterFields = "Item No.", "Posting Date";
            column(ItemNum; Item_Num)
            {
            }
            column(PostingDate; PostingDate)
            {
            }
            column(UnitCost; UnitCost)
            {
            }
            column(VendorNum; VendorNum)
            {
            }
            column(VendName; VendorName)
            {
            }
            column(DocumentNo_ItemLedgerEntry; "Item Ledger Entry"."Document No.")
            {
            }
            column(ItemDesc; "Item Ledger Entry".Description)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if DocNum <> "Item Ledger Entry"."Document No." then begin
                    if (RecCont <= 3) then begin
                        Item_Num := "Item Ledger Entry"."Item No.";
                        PostingDate := "Item Ledger Entry"."Posting Date";
                        //    PostingDate := DT2DATE(PostingDate);
                        "Item Ledger Entry".CalcFields("Item Ledger Entry"."Cost per Unit");
                        UnitCost := "Item Ledger Entry"."Cost per Unit";
                        VendorNum := "Item Ledger Entry"."Source No.";
                        Vendor.Reset;
                        if Vendor.Get("Item Ledger Entry"."Source No.") then
                            VendorName := Vendor.Name
                        else
                            VendorName := '';
                        RecCont += 1;
                    end else
                        CurrReport.Skip;
                end else begin
                    CurrReport.Skip;
                end;
                DocNum := "Item Ledger Entry"."Document No."


            end;

            trigger OnPreDataItem()
            begin
                RecCont := 1;
                DocNum := '';
                VendorNum := '';
                VendorName := '';
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
        Item_Num: Code[20];
        PostingDate: Date;
        UnitCost: Decimal;
        RecCont: Integer;
        DocNum: Code[20];
        VendorNum: Code[20];
        VendorName: Text[100];
        Vendor: Record Vendor;
}

