report 50094 "Item Issued Report"
{
    // version Firoz

    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/Item Issued Report.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            DataItemTableView = SORTING ("Item No.", "Posting Date") ORDER(Ascending) WHERE ("Entry Type" = CONST ("Negative Adjmt."), Quantity = FILTER (<> 0));
            RequestFilterFields = "Posting Date";
            column(CompName; COMINFO.Name)
            {
            }
            column(Sys_Date; WorkDate)
            {
            }
            column(ItemNo; "Item Ledger Entry"."Item No.")
            {
            }
            column(PostingDate; "Item Ledger Entry"."Posting Date")
            {
            }
            column(DocumentNo; "Item Ledger Entry"."Document No.")
            {
            }
            column(ItemDescrition; ItemDesc)
            {
            }
            column(Location; "Item Ledger Entry"."Location Code")
            {
            }
            column(Quantity; "Item Ledger Entry".Quantity)
            {
            }
            column(RequisitionNo; "Item Ledger Entry"."Requisition No.")
            {
            }
            column(UserName; UserName)
            {
            }
            column(MaxDate; MaxDate)
            {
            }
            column(RequLineNo; "Item Ledger Entry"."Requisition Line No.")
            {
            }
            column(equestedQty; RequestedQty)
            {
            }
            column(UOM; "Item Ledger Entry"."Unit of Measure Code")
            {
            }

            trigger OnAfterGetRecord()
            begin
                COMINFO.Get;

                UserTab.Reset;
                UserTab.SetRange(UserTab."User Name", UserId);
                if UserTab.FindFirst then
                    UserName := UserTab."Full Name";
                //MESSAGE(MaxDate);


                MaxDate := "Item Ledger Entry".GetFilter("Item Ledger Entry"."Posting Date");

                ItemDesc := '';
                ItemCard.Reset;
                ItemCard.SetRange(ItemCard."No.", "Item No.");
                if ItemCard.FindFirst then
                    ItemDesc := ItemCard.Description;

                RequisitionLine.Reset;
                RequisitionLine.SetRange(RequisitionLine."Requisition No.", "Requisition No.");
                RequisitionLine.SetRange(RequisitionLine."Requisition Line No.", "Requisition Line No.");
                if RequisitionLine.FindFirst then
                    RequestedQty := RequisitionLine.Quantity;
                //MESSAGE(FORMAT(RequestedQty));
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
        COMINFO: Record "Company Information";
        MaxDate: Text[60];
        UserTab: Record User;
        UserName: Text[60];
        ItemCard: Record Item;
        ItemDesc: Text[250];
        RequisitionHeader: Record "Requisition Header";
        RequisitionCode: Code[20];
        RequisitionLine: Record "Requisition Line SAM";
        RequestedQty: Decimal;
}

