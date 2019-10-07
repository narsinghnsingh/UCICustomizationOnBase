report 50035 "PDC Receipt/Payment"
{
    // version Account/Sadaf

    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/PDC ReceiptPayment.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
        dataitem("Post Dated Cheque PDC"; "Post Dated Cheque PDC")
        {
            DataItemTableView = SORTING ("PDC Number");
            RequestFilterFields = "PDC Number", "Posting Date";
            column(CompPics; COMINFO.Picture)
            {
            }
            column(NAME; COMINFO.Name)
            {
            }
            column(ADDRESS; COMINFO.Address)
            {
            }
            column(ADDRESS1; COMINFO."Address 2")
            {
            }
            column(AccountNo_PostDatedChequePDC; "Post Dated Cheque PDC"."Account No")
            {
            }
            column(Description_PostDatedChequePDC; "Post Dated Cheque PDC".Description)
            {
            }
            column(Amount_PostDatedChequePDC; Abs("Post Dated Cheque PDC".Amount))
            {
            }
            column(ChequeNo_PostDatedChequePDC; "Post Dated Cheque PDC"."Cheque No")
            {
            }
            column(ChequeDate_PostDatedChequePDC; "Post Dated Cheque PDC"."Cheque Date")
            {
            }
            column(ChequeBankName_PostDatedChequePDC; "Post Dated Cheque PDC"."Cheque Bank Name")
            {
            }
            column(PostingDate_PostDatedChequePDC; "Post Dated Cheque PDC"."Posting Date")
            {
            }
            column(MINDATE; Format(MINDATE) + '..  ' + Format(MAXDATE))
            {
            }
            column(AccountType; "Post Dated Cheque PDC"."Account Type")
            {
            }
            column(DateFilterMax; DateFilterMax)
            {
            }
            column(PdcNumber; "Post Dated Cheque PDC"."PDC Number")
            {
            }
            column(USER_NAME; USER_NAME)
            {
            }
            column(SysDate; WorkDate)
            {
            }
            column(PresentedBank; "Post Dated Cheque PDC"."Presented Bank Name")
            {
            }
            column(Custname; Custname)
            {
            }
            column(CustAddress; CustAddress)
            {
            }
            column(CustCity; CustCity + ' -' + CustPostCode)
            {
            }
            column(CustCountry; CustCountry)
            {
            }
            column(CustPostCode; CustPostCode)
            {
            }
            column(CountryName; CountryName)
            {
            }
            column(BankAccountNo; BankAccountNo)
            {
            }
            column(NarrationPDC; "Post Dated Cheque PDC".Narration)
            {
            }
            column(PaymentCaption; PaymentCaption)
            {
            }
            column(BankNAme; BankNAme)
            {
            }

            trigger OnAfterGetRecord()
            begin
                CountryName := '';
                Custname := '';
                CustAddress := '';
                CustCity := '';
                CustCountry := '';
                CustPostCode := '';


                COMINFO.Get;
                COMINFO.CalcFields(Picture);



                USERS.Reset;
                USERS.SetRange(USERS."User Name", "User ID");
                if USERS.FindFirst then begin
                    USER_NAME := USERS."Full Name";
                end;

                /*
                CountryName:='';
                countryRegion.RESET;
                countryRegion.SETRANGE(countryRegion.Code,CustCountry);
                IF countryRegion.FINDFIRST THEN
                   CountryName:=countryRegion.Name;
                  */
                if "Account Type" = "Account Type"::Customer then begin
                    BankNAme := "Cheque Bank Name";
                    PaymentCaption := 'Receipt Voucher';
                    CustomerCard.Reset;
                    CustomerCard.SetRange(CustomerCard."No.", "Account No");
                    if CustomerCard.FindFirst then begin
                        Custname := CustomerCard.Name;
                        CustAddress := CustomerCard.Address;
                        CustCity := CustomerCard.City;
                        CustCountry := CustomerCard."Country/Region Code";
                        CustPostCode := CustomerCard."Post Code";
                        //MESSAGE(Custname);
                        CountryName := '';
                        countryRegion.Reset;
                        countryRegion.SetRange(countryRegion.Code, CustCountry);
                        if countryRegion.FindFirst then
                            CountryName := countryRegion.Name;


                    end;
                end;




                if "Account Type" = "Account Type"::Vendor then begin
                    BankNAme := "Presented Bank Name";
                    PaymentCaption := 'Payment Voucher';
                    VendorCard.Reset;
                    VendorCard.SetRange(VendorCard."No.", "Account No");
                    if VendorCard.FindFirst then begin
                        Custname := VendorCard.Name;
                        CustAddress := VendorCard.Address;
                        CustCity := VendorCard.City;
                        CustCountry := VendorCard."Country/Region Code";
                        CustPostCode := VendorCard."Post Code";
                        //MESSAGE(Custname);
                        countryRegion.Reset;
                        countryRegion.SetRange(countryRegion.Code, CustCountry);
                        if countryRegion.FindFirst then
                            CountryName := countryRegion.Name;

                    end;
                end;

                BankAccountNo := '';
                BankCard.Reset;
                BankCard.SetRange(BankCard."No.", "Post Dated Cheque PDC"."Presented Bank");
                if BankCard.FindFirst then
                    BankAccountNo := BankCard."Bank Account No.";

            end;

            trigger OnPreDataItem()
            begin
                //MINDATE :="Post Dated Cheque PDC".GETRANGEMIN("Post Dated Cheque PDC"."Posting Date");
                //MAXDATE := "Post Dated Cheque PDC".GETRANGEMAX("Post Dated Cheque PDC"."Posting Date");
                DateFilterMax := "Post Dated Cheque PDC".GetFilters;
                //MESSAGE(DateFilterMax)
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
        MINDATE: Date;
        MAXDATE: Date;
        DateFilterMax: Text;
        USERS: Record User;
        USER_NAME: Text[100];
        CustomerCard: Record Customer;
        Custname: Text[100];
        CustAddress: Text[100];
        CustCity: Code[20];
        CustCountry: Code[20];
        CustPostCode: Code[20];
        VendorCard: Record Vendor;
        countryRegion: Record "Country/Region";
        CountryName: Text[100];
        BankCard: Record "Bank Account";
        BankAccountNo: Code[30];
        PaymentCaption: Text[60];
        ReceiptCaption: Text[60];
        BankNAme: Text[60];
}

