report 50053 "Top Report"
{
    // version Sadaf

    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/Top Report.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            DataItemTableView = SORTING ("Posting Date") ORDER(Ascending);
            RequestFilterFields = "Posting Date";
            column(COMINFO_NAME; COM_INFO.Name)
            {
            }
            column(Month1; Format('Invoice For the month of ' + '  ' + MONTH))
            {
            }
            column(SelltoCustomerNo_SalesInvoiceHeader; "Sales Invoice Header"."Sell-to Customer No.")
            {
            }
            column(SelltoCustomerName_SalesInvoiceHeader; "Sales Invoice Header"."Sell-to Customer Name")
            {
            }
            column(PostingDate_SalesInvoiceHeader; "Sales Invoice Header"."Posting Date")
            {
            }
            column(Amount_SalesInvoiceHeader; "Sales Invoice Header".Amount)
            {
            }
            column(MonthYear; MonthYear)
            {
            }
            column(Month; MONTH)
            {
            }
            column(MINDATE; Format('FROM ') + ' ' + Format(MINDATE))
            {
            }
            column(MAXDATE; Format(' TO  ') + ' ' + Format(MAXDATE))
            {
            }
            column(AmounttoCustomer_SalesInvoiceHeader; "Sales Invoice Header"."Amount to Customer")
            {
            }
            column(Remainingamount; "Sales Invoice Header"."Remaining Amount")
            {
            }

            trigger OnAfterGetRecord()
            begin
                MINDATE := "Sales Invoice Header".GetRangeMin("Sales Invoice Header"."Posting Date");
                MAXDATE := "Sales Invoice Header".GetRangeMax("Sales Invoice Header"."Posting Date");


                MonthYear := Date2DMY("Sales Invoice Header"."Posting Date", 2);

                if MonthYear = 1 then
                    MONTH := 'January'
                else
                    if MonthYear = 2 then
                        MONTH := 'February'
                    else
                        if MonthYear = 3 then
                            MONTH := 'March'
                        else
                            if MonthYear = 4 then
                                MONTH := 'April'
                            else
                                if MonthYear = 5 then
                                    MONTH := 'May'
                                else
                                    if MonthYear = 6 then
                                        MONTH := 'June'
                                    else
                                        if MonthYear = 7 then
                                            MONTH := 'July'
                                        else
                                            if MonthYear = 8 then
                                                MONTH := 'August'
                                            else
                                                if MonthYear = 9 then
                                                    MONTH := 'September'
                                                else
                                                    if MonthYear = 10 then
                                                        MONTH := 'October'
                                                    else
                                                        if MonthYear = 11 then
                                                            MONTH := 'November'
                                                        else
                                                            if MonthYear = 12 then
                                                                MONTH := 'December';

                COM_INFO.Get;
                "Sales Invoice Header".CalcFields("Sales Invoice Header".Amount);
                "Sales Invoice Header".CalcFields("Sales Invoice Header"."Remaining Amount");
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
        MonthYear: Integer;
        CUST: Record Customer;
        CUST_NAME: Text[250];
        COM_INFO: Record "Company Information";
        MINDATE: Date;
        MAXDATE: Date;
        MONTH: Text;
}

