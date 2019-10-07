report 50023 "Die/Plate Status"
{
    // version Production/Sadaf

    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/DiePlate Status.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = SORTING ("No.") ORDER(Ascending) WHERE ("Plate Item" = FILTER (true), "Inventory Value Zero" = FILTER (true));
            RequestFilterFields = "Item Category Code";
            column(COM_NAME; COMINFO.Name)
            {
            }
            column(No_Item; Item."No.")
            {
            }
            column(Description_Item; Item.Description)
            {
            }
            column(NoofImpression; Item."Output Qty")
            {
            }
            column(PrintingThresholdLimit_Item; Item."Printing Threshold Limit")
            {
            }
            column(SYSDATE; WorkDate)
            {
            }

            trigger OnAfterGetRecord()
            begin
                COMINFO.Get
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
}

