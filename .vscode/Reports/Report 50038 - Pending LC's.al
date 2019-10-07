report 50038 "Pending LC's"
{
    // version LC Detail

    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/Pending LC''s.rdl';
    Caption = 'Pending LC''s';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;


    dataset
    {
        dataitem("LC Detail"; "LC Detail")
        {
            DataItemTableView = SORTING ("No.") WHERE (Closed = CONST (false), Released = CONST (true));
            RequestFilterFields = "No.";
            RequestFilterHeading = 'LC Amendments';
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            column(CurrReport_PAGENO; 0)
            {
            }
            column(USERID; UserId)
            {
            }
            column(LC_Detail__LC_No__; "LC No.")
            {
            }
            column(LC_Detail_Description; Description)
            {
            }
            column(LC_Detail__Transaction_Type_; "Transaction Type")
            {
            }
            column(LC_Detail__Issued_To_Received_From_; "Issued To/Received From")
            {
            }
            column(LC_Detail__LC_Value_; "LC Value")
            {
            }
            column(LC_Detail__Value_Utilised_; "Value Utilised")
            {
            }
            column(LC_Detail__Remaining_Amount_; "Remaining Amount")
            {
            }
            column(LC_Detail__Currency_Code_; "Currency Code")
            {
            }
            column(LC_Detail__Latest_Amended_Value_; "Latest Amended Value")
            {
            }
            column(LC_Detail__Expiry_Date_; Format("Expiry Date"))
            {
            }
            column(LC_Detail_No_; "No.")
            {
            }
            column(LC_DetailCaption; LC_DetailCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(LC_No_Caption; LC_No_CaptionLbl)
            {
            }
            column(LC_Detail_DescriptionCaption; FieldCaption(Description))
            {
            }
            column(LC_Detail__Transaction_Type_Caption; FieldCaption("Transaction Type"))
            {
            }
            column(LC_Detail__Issued_To_Received_From_Caption; FieldCaption("Issued To/Received From"))
            {
            }
            column(LC_Detail__LC_Value_Caption; FieldCaption("LC Value"))
            {
            }
            column(LC_Detail__Remaining_Amount_Caption; FieldCaption("Remaining Amount"))
            {
            }
            column(LC_Detail__Currency_Code_Caption; FieldCaption("Currency Code"))
            {
            }
            column(Value_UtilisedCaption; Value_UtilisedCaptionLbl)
            {
            }
            column(LC_Value_LCYCaption; LC_Value_LCYCaptionLbl)
            {
            }
            column(LC_Detail__Expiry_Date_Caption; LC_Detail__Expiry_Date_CaptionLbl)
            {
            }

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("No.");
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
        LastFieldNo: Integer;
        LC_DetailCaptionLbl: Label 'LC Detail';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        LC_No_CaptionLbl: Label 'LC No.';
        Value_UtilisedCaptionLbl: Label 'Value Utilised';
        LC_Value_LCYCaptionLbl: Label 'LC Value LCY';
        LC_Detail__Expiry_Date_CaptionLbl: Label 'Expiry Date';
}

