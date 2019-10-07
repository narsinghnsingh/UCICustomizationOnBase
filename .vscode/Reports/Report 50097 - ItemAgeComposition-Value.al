report 50097 "ItemAgeComposition-Value"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/ItemAgeComposition-Value.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;


    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            DataItemTableView = SORTING ("Paper Type") ORDER(Ascending) WHERE ("Item Category Code" = FILTER ('PAPER' | 'DUPLEX_PAP'), Open = CONST (true));
            RequestFilterFields = "Posting Date";
            column(COMNAME; COMINFO.Name)
            {
            }
            column(COMPIC; COMINFO.Picture)
            {
            }
            column(PostingDate_ItemLedgerEntry; "Item Ledger Entry"."Posting Date")
            {
            }
            column(PaperType; "Item Ledger Entry"."Paper Type")
            {
            }
            column(Period1to3Amount; "Cost Amount (Expected)" + "Cost Amount (Actual)")
            {
            }
            column(Month2; Month1)
            {
            }
            column(Fromdate1to3_cap; Fromdate1to3)
            {
            }
            column(Todate1to3; Todate1to3)
            {
            }
            column(Fromdate3to6_cap; Fromdate3to6)
            {
            }
            column(Todate3to6_cap; Todate3to6)
            {
            }
            column(Fromdate6to9_cap; Fromdate6to9)
            {
            }
            column(Todate6to9_cap; Todate6to9)
            {
            }
            column(Fromdate9to12_cap; Fromdate9to12)
            {
            }
            column(Todate9to12_cap; Todate9to12)
            {
            }
            column(Fromdate12to18_cap; Fromdate12to18)
            {
            }
            column(Todate12to18_cap; Todate12to18)
            {
            }
            column(MonthDate_cap; MonthDate1)
            {
            }
            column(EntryNo; "Entry No.")
            {
            }
            column(MAXDATE; FORMAT('TO : ') + ' ' + FORMAT(MAXDATE))
            {
            }
            column(MINDATE; FORMAT('From  : ') + ' ' + FORMAT(MINDATE))
            {
            }

            trigger OnAfterGetRecord()
            begin

                COMINFO.GET;
                COMINFO.CALCFIELDS(COMINFO.Picture);
                CALCFIELDS("Cost Amount (Expected)", "Cost Amount (Actual)");

                IF ("Posting Date" > Todate1to3) AND ("Posting Date" <= Fromdate1to3) THEN BEGIN
                    Month1 := 'Previous 1 to 3 month';
                    MonthDate1 := FORMAT(Fromdate1to3) + ' to ' + FORMAT(Todate1to3);
                END;
                IF ("Posting Date" > Todate3to6) AND ("Posting Date" <= Fromdate3to6) THEN BEGIN
                    Month1 := 'Previous 4 to 6 month';
                    MonthDate1 := FORMAT(Fromdate3to6) + ' to ' + FORMAT(Todate3to6);
                END;
                IF ("Posting Date" > Todate6to9) AND ("Posting Date" <= Fromdate6to9) THEN BEGIN
                    Month1 := 'Previous 7 to 9 month';
                    MonthDate1 := FORMAT(Fromdate6to9) + ' to ' + FORMAT(Todate6to9);
                END;
                IF ("Posting Date" > Todate9to12) AND ("Posting Date" <= Fromdate9to12) THEN BEGIN
                    Month1 := 'Previous 10 to 12 month';
                    MonthDate1 := FORMAT(Fromdate9to12) + ' to ' + FORMAT(Todate9to12);
                END;
                IF ("Posting Date" > Todate12to18) AND ("Posting Date" <= Fromdate12to18) THEN BEGIN
                    Month1 := 'Previous 13 to 18 month';
                    MonthDate1 := FORMAT(Fromdate12to18) + ' to ' + FORMAT(Todate12to18);
                END;
                IF ("Posting Date" > Todate18to24) AND ("Posting Date" <= Fromdate18to24) THEN BEGIN
                    Month1 := 'Previous 19 to 24 month';
                    MonthDate1 := FORMAT(Fromdate18to24) + ' to ' + FORMAT(Todate18to24);
                END;
                IF ("Posting Date" > Todate18to24) AND ("Posting Date" <= Fromdate18to24) THEN BEGIN
                    Month1 := 'More than 24 month';
                    MonthDate1 := FORMAT(Todate18to24);
                END;






                //PaperType:="Paper Type";
            end;

            trigger OnPreDataItem()
            begin
                MAXDATE := "Item Ledger Entry".GETRANGEMAX("Item Ledger Entry"."Posting Date");
                MINDATE := "Item Ledger Entry".GETRANGEMIN("Item Ledger Entry"."Posting Date");
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

    trigger OnPreReport()
    begin
        Fromdate1to3 := "Item Ledger Entry".GETRANGEMAX("Posting Date");
        Fromdate1to3 := Fromdate1to3 - 1;
        Todate1to3 := CALCDATE('<-3M>', Fromdate1to3);
        Fromdate3to6 := CALCDATE('<-1D>', Todate1to3);
        Todate3to6 := CALCDATE('<-3M>', Fromdate3to6);
        Fromdate6to9 := CALCDATE('<-1D>', Todate3to6);
        Todate6to9 := CALCDATE('<-3M>', Fromdate6to9);
        Fromdate9to12 := CALCDATE('<-1D>', Todate6to9);
        Todate9to12 := CALCDATE('<-3M>', Fromdate9to12);
        Fromdate12to18 := CALCDATE('<-1D>', Todate9to12);
        Todate12to18 := CALCDATE('<-6M>', Fromdate12to18);
        Fromdate18to24 := CALCDATE('<-1D>', Todate12to18);
        Todate18to24 := CALCDATE('<-6M>', Fromdate18to24);
    end;

    var
        Previous12to18thfrom: Date;
        Previous12to18thto: Date;
        Previous18to24thfrom: Date;
        Previous18to24thto: Date;
        Previous24thfrom: Date;
        InvtQty1: Decimal;
        InvtQty3: Decimal;
        InvtQty4: Decimal;
        InvtQty5: Decimal;
        Previousfrom4: Date;
        Previousto4: Date;
        AmountDec: Decimal;
        InvtQty41: Decimal;
        Fromdate1to3: Date;
        Todate1to3: Date;
        InvtAmount1: Decimal;
        PaperType: Code[20];
        Month1: Code[40];
        Fromdate3to6: Date;
        Todate3to6: Date;
        Fromdate6to9: Date;
        Todate6to9: Date;
        Fromdate9to12: Date;
        Todate9to12: Date;
        Todate18to24: Date;
        Fromdate18to24: Date;
        Fromdate12to18: Date;
        Todate12to18: Date;
        MonthDate1: Text;
        COMINFO: Record "Company Information";
        MAXDATE: Date;
        MINDATE: Date;
}

