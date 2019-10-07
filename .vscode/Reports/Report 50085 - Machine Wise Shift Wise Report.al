report 50085 "Machine Wise Shift Wise Report"
{
    // version Firoz

    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/Machine Wise Shift Wise Report.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Company Information"; "Company Information")
        {
            DataItemTableView = SORTING ("Primary Key");
            column(SysDate; WorkDate)
            {
            }
            column(CompName; "Company Information".Name)
            {
            }
        }
        dataitem("Capacity Ledger Entry"; "Capacity Ledger Entry")
        {
            DataItemTableView = SORTING ("Document No.", "Posting Date") WHERE ("Work Shift Code" = FILTER (<> ''));
            RequestFilterFields = "Posting Date";
            column(Job_No; "Capacity Ledger Entry"."Order No.")
            {
            }
            column(Opreation_desc; "Capacity Ledger Entry".Description)
            {
            }
            column(OutPutQty; "Capacity Ledger Entry"."Output Quantity")
            {
            }
            column(Scrap_qty; "Capacity Ledger Entry"."Scrap Quantity")
            {
            }
            column(Scrab_reason_code; "Capacity Ledger Entry"."Scrap Code")
            {
            }
            column(work_shift_code; "Capacity Ledger Entry"."Work Shift Code")
            {
            }
            column(PostingDate; "Capacity Ledger Entry"."Posting Date")
            {
            }
            column(Machine_Id; "Capacity Ledger Entry"."Machine Id")
            {
            }
            column(No; "Capacity Ledger Entry"."No.")
            {
            }
            column(MaxDate; MaxDate)
            {
            }
            column(OutputWeight; OutputWeight)
            {
            }
            column(ScrapWeight; ScrapWeight)
            {
            }
            column(Ending_Time; "Capacity Ledger Entry"."Ending Time")
            {
            }
            column(Setting_Time; "Capacity Ledger Entry"."Setup Time")
            {
            }
            column(Break_Down; "Capacity Ledger Entry"."Stop Time")
            {
            }
            column(Starting_Time; "Capacity Ledger Entry"."Starting Time")
            {
            }
            column(run_Time; "Capacity Ledger Entry"."Run Time")
            {
            }
            column(Total_ScrapWt; Total_ScrapWt)
            {
            }
            column(TSUM; TSUM)
            {
            }
            column(SUM_TOTALTIME; SUM_TOTALTIME)
            {
            }
            column(TOTAL_HOURS; TOTALHOUR)
            {
            }
            column(Total_Time_InHours; "Capacity Ledger Entry"."Starting Time")
            {
            }
            column(OUTPUTPERHOUR; OUTPUTPERHOUR)
            {
            }
            column(T_RUNTIME; "Capacity Ledger Entry"."Run Time")
            {
            }
            column(ST; "Capacity Ledger Entry"."Setup Time")
            {
            }
            column(BD; "Capacity Ledger Entry"."Stop Time")
            {
            }

            trigger OnAfterGetRecord()
            begin
                MaxDate := "Capacity Ledger Entry".GetFilter("Capacity Ledger Entry"."Posting Date");

                OutputWeight := "Output Weight (Kg)" / 1000;
                //ScrapWeight:="Scrap Weight(gms)"/1000;
                ScrapWeight := 0;
                Total_ScrapWt := 0;
                TOTALHOUR := 0;

                CLE.Reset;
                CLE.SetRange(CLE.Type, Type);
                CLE.SetRange(CLE."No.", "No.");
                CLE.SetRange(CLE."Work Shift Code", "Work Shift Code");
                CLE.SetFilter(CLE."Posting Date", MaxDate);
                if CLE.FindFirst then begin
                    repeat
                        ScrapWeight := "Scrap Weight (Kg)" / 1000;
                        Total_ScrapWt := Total_ScrapWt + ScrapWeight;
                        TOTALHOUR += CLE."Run Time" / 60;
                    until CLE.Next = 0;
                end;

                TSUM := 0;
                T_OUTPUTQTY := 0;
                T_RUNTIME := 0;
                OUTPUTPERHOUR := 0;
                ST := 0;
                BD := 0;

                CLE.Reset;
                CLE.SetRange(CLE."Work Shift Code", "Work Shift Code");
                CLE.SetFilter(CLE."Posting Date", MaxDate);
                CLE.SetRange(CLE.Type, Type);
                CLE.SetRange(CLE."No.", "No.");
                if CLE.FindFirst then begin
                    repeat
                        T_OUTPUTQTY += CLE."Output Quantity";
                        T_RUNTIME += CLE."Run Time" / 60;
                        ST += ST;
                        BD += BD;
                        // SUM_TOTALTIME := T_RUNTIME + ST +BD;
                    until CLE.Next = 0;
                end;

                if T_RUNTIME <> 0 then
                    TSUM := T_OUTPUTQTY / (T_RUNTIME + ST + BD)
                else
                    TSUM := T_OUTPUTQTY;

                CLE.Reset;
                SUM_TOTALTIME := 0;
                CLE.SetFilter(CLE."Work Shift Code", "Work Shift Code");
                CLE.SetFilter(CLE."Posting Date", MaxDate);
                CLE.SetFilter(CLE."No.", "No.");
                //   CLE.SETFILTER(CLE.Type,Type);
                if CLE.FindFirst then begin
                    repeat
                        T_OUTPUTQTY += CLE."Output Quantity";
                        T_RUNTIME += CLE."Run Time" / 60;
                        ST += ST;
                        BD += BD;
                        // SUM_TOTALTIME := T_RUNTIME + ST +BD;
                    until CLE.Next = 0;
                end;

                if T_RUNTIME <> 0 then
                    SUM_TOTALTIME := T_OUTPUTQTY / (T_RUNTIME + ST + BD)
                else
                    SUM_TOTALTIME := T_OUTPUTQTY;
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
        OutputWeight: Decimal;
        ScrapWeight: Decimal;
        MaxDate: Text[100];
        CLE: Record "Capacity Ledger Entry";
        Total_ScrapWt: Decimal;
        TSUM: Decimal;
        T_OUTPUTQTY: Decimal;
        T_RUNTIME: Decimal;
        SUM_TOTALTIME: Decimal;
        RT: Decimal;
        ST: Decimal;
        BD: Decimal;
        TOTALHOUR: Decimal;
        OUTPUTPERHOUR: Decimal;
}

