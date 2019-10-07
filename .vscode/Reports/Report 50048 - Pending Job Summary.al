report 50048 "Pending Job Summary"
{
    // version Sadaf

    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/Pending Job Summary.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
        dataitem("Sales Line"; "Sales Line")
        {
            DataItemTableView = SORTING ("Document Type", "Document No.", "Line No.") ORDER(Ascending) WHERE ("Document Type" = FILTER (Order));
            RequestFilterFields = "Documnet Date";
            column(COM_NAME; COMINFO.Name)
            {
            }
            column(COM_PIC; COMINFO.Picture)
            {
            }
            column(ORDERDATE; MAXDATE)
            {
            }
            column(QTYORDERED; QTYORDERED)
            {
            }
            column(QTYSHIPPED; QTYSHIPPED)
            {
            }
            column(QTY_OUTSTANDING; QTY_OUTSTANDING)
            {
            }
            column(OUSTANDING_AMT; OUSTANDING_AMT)
            {
            }
            column(MAXDATE; MAXDATE)
            {
            }
            column(RUNDATE; WORKDATE)
            {
            }
            column(allfilters; allfilters)
            {
            }

            trigger OnAfterGetRecord()
            begin
                COMINFO.GET;
                COMINFO.CALCFIELDS(COMINFO.Picture);

                QTYORDERED := 0;
                QTYSHIPPED := 0;
                QTY_OUTSTANDING := 0;
                OUSTANDING_AMT := 0;


                QTYORDERED := QTYORDERED + "Sales Line".Quantity;
                QTYSHIPPED := QTYSHIPPED + "Sales Line"."Quantity Shipped";
                QTY_OUTSTANDING := QTY_OUTSTANDING + "Sales Line"."Outstanding Quantity";
                OUSTANDING_AMT := OUSTANDING_AMT + "Sales Line"."Outstanding Amount";
            end;

            trigger OnPreDataItem()
            begin
                MAXDATE := GETRANGEMAX("Documnet Date");
                allfilters := "Sales Line".GETFILTERS;
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
        MAXDATE: Date;
        SALES_LINES: Record "Sales Line";
        QTYORDERED: Decimal;
        QTYSHIPPED: Decimal;
        QTY_OUTSTANDING: Decimal;
        OUSTANDING_AMT: Decimal;
        allfilters: Text;
}

