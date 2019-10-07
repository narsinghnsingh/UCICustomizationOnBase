report 50072 "Expected Collection Cust/Sales"
{
    // version Sales /Sadaf

    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/Expected Collection CustSales.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem(Customer; Customer)
        {
            RequestFilterFields = "Date Filter";
            column(RUNDATE; WorkDate)
            {
            }
            column(COMINFO_NAME; CompanyInformation.Name)
            {
            }
            column(COMINFO_ADD; CompanyInformation.Address)
            {
            }
            column(COMINFO_ADD1; CompanyInformation."Address 2")
            {
            }
            column(COMINFO_CITY; CompanyInformation.City)
            {
            }
            column(No_Customer; Customer."No.")
            {
            }
            column(SalespersonCode_Customer; Customer."Salesperson Code")
            {
            }
            column(Name_Customer; Customer.Name)
            {
            }
            column(EXPECTED_AMOUNT; EXPECTED_AMOUNTN)
            {
            }
            column(RECEIVED_AMOUNT; Abs(RECEIVED_AMOUNT))
            {
            }
            column(AVAILABLE_AMOUNT; Abs(AVAILABLE_AMOUNT))
            {
            }
            column(ALLFILTER; ALLFILTER)
            {
            }

            trigger OnAfterGetRecord()
            begin
                CompanyInformation.Get;

                ALLFILTER := Customer.GetFilter(Customer."Date Filter");
                EXPECTED_AMOUNTN := 0;
                CustLedgerEntryN.Reset;
                CustLedgerEntryN.SetRange(CustLedgerEntryN."Document Type", CustLedgerEntryN."Document Type"::Invoice);
                CustLedgerEntryN.SetRange(CustLedgerEntryN."Customer No.", Customer."No.");
                CustLedgerEntryN.SetRange(CustLedgerEntryN."Due Date", STARTDATE, ENDDATE);
                //CustLedgerEntryN.SETRANGE(CustLedgerEntryN."Due Date",0D,(WORKDATE-1));
                if CustLedgerEntryN.FindFirst then begin
                    repeat
                        CustLedgerEntryN.CalcFields(CustLedgerEntryN."Remaining Amount");
                        EXPECTED_AMOUNTN += CustLedgerEntryN."Remaining Amount";
                    until CustLedgerEntryN.Next = 0;
                end;



                RECEIVED_AMOUNT := 0;
                CustLedgerEntryN.Reset;
                CustLedgerEntryN.SetRange(CustLedgerEntryN."Document Type", CustLedgerEntryN."Document Type"::Payment);
                CustLedgerEntryN.SetRange(CustLedgerEntryN."Customer No.", Customer."No.");
                CustLedgerEntryN.SetFilter(CustLedgerEntryN."Posting Date", DateFilterN);
                if CustLedgerEntryN.FindFirst then begin
                    repeat
                        CustLedgerEntryN.CalcFields(CustLedgerEntryN.Amount);
                        RECEIVED_AMOUNT += CustLedgerEntryN.Amount;
                    until CustLedgerEntryN.Next = 0;
                end;



                /*RECEIVED_AMOUNT :=0;
                RECEIVED_AMOUNT1 :=0;
                PostDatedChequePDC.RESET;
                PostDatedChequePDC.SETRANGE(PostDatedChequePDC."Account No",Customer."No.");
                PostDatedChequePDC.SETFILTER(PostDatedChequePDC.Presented,'True');
                PostDatedChequePDC.SETFILTER(PostDatedChequePDC."Void Cheque",'FALSE');
                PostDatedChequePDC.SETFILTER(PostDatedChequePDC."Posting Date",GETFILTER(Customer."Date Filter"));
                IF PostDatedChequePDC.FINDFIRST THEN BEGIN
                  REPEAT
                  RECEIVED_AMOUNT += PostDatedChequePDC.Amount;
                 UNTIL PostDatedChequePDC.NEXT=0;
                END;*/


                AVAILABLE_AMOUNT := 0;
                PostDatedChequePDC.Reset;
                PostDatedChequePDC.SetRange(PostDatedChequePDC."Account No", Customer."No.");
                PostDatedChequePDC.SetFilter(PostDatedChequePDC.Received, 'TRUE');
                PostDatedChequePDC.SetFilter(PostDatedChequePDC.Presented, 'FALSE');
                PostDatedChequePDC.SetFilter(PostDatedChequePDC."Void Cheque", 'FALSE');
                PostDatedChequePDC.SetFilter(PostDatedChequePDC."Cheque Date", GetFilter(Customer."Date Filter"));
                if PostDatedChequePDC.FindFirst then begin
                    repeat
                        AVAILABLE_AMOUNT += PostDatedChequePDC.Amount;
                    until PostDatedChequePDC.Next = 0;
                end;

            end;

            trigger OnPreDataItem()
            begin
                DateFilterN := GetFilter(Customer."Date Filter");
                //MESSAGE(DateFilterN);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Start Date"; STARTDATE)
                {
                }
                field("End Date"; ENDDATE)
                {
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if (STARTDATE = 0D) and (ENDDATE = 0D) then
                ENDDATE := WorkDate;
        end;
    }

    labels
    {
    }

    var
        CompanyInformation: Record "Company Information";
        Report_Caption: Label 'EXPECTED COLLECTION REPORT';
        PostDatedChequePDC: Record "Post Dated Cheque PDC";
        RECEIVED_AMOUNT: Decimal;
        AVAILABLE_AMOUNT: Decimal;
        ALLFILTER: Text;
        CustLedgerEntryN: Record "Cust. Ledger Entry";
        EXPECTED_AMOUNTN: Decimal;
        DateFilterN: Text;
        DUEDATE: Date;
        STARTDATE: Date;
        ENDDATE: Date;
}

