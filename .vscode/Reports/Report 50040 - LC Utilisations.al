report 50040 "LC Utilisations"
{
    // version LC Detail

    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/LC Utilisations.rdl';
    Caption = 'LC Utilisations';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("LC Detail"; "LC Detail")
        {
            DataItemTableView = SORTING ("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.";
            RequestFilterHeading = 'LC Utilised';
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
            column(LC_Detail__Issued_To_Received_From_; "Issued To/Received From")
            {
            }
            column(LC_Detail__Issuing_Bank_; "Issuing Bank")
            {
            }
            column(LC_Detail__Date_of_Issue_; Format("Date of Issue"))
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
            column(LC_Detail__Expiry_Date_Caption; LC_Detail__Expiry_Date_CaptionLbl)
            {
            }
            column(LC_Detail__Date_of_Issue_Caption; LC_Detail__Date_of_Issue_CaptionLbl)
            {
            }
            column(LC_Detail__Issuing_Bank_Caption; FieldCaption("Issuing Bank"))
            {
            }
            column(LC_Detail__Issued_To_Received_From_Caption; FieldCaption("Issued To/Received From"))
            {
            }
            column(LC_Detail_DescriptionCaption; FieldCaption(Description))
            {
            }
            column(LC_Detail__LC_No__Caption; FieldCaption("LC No."))
            {
            }
            column(LC_Orders__Order_No__Caption; "LC Orders".FieldCaption("Order No."))
            {
            }
            column(LC_Orders__Shipment_Date_Caption; LC_Orders__Shipment_Date_CaptionLbl)
            {
            }
            column(LC_Orders__Order_Value_Caption; "LC Orders".FieldCaption("Order Value"))
            {
            }
            column(OrdersCaption; OrdersCaptionLbl)
            {
            }
            dataitem("LC Orders"; "LC Orders")
            {
                DataItemLink = "LC No." = FIELD ("No.");
                DataItemTableView = SORTING ("LC No.", "Order No.");
                column(LC_Orders__Order_No__; "Order No.")
                {
                }
                column(LC_Orders__Shipment_Date_; Format("Shipment Date"))
                {
                }
                column(LC_Orders__Order_Value_; "Order Value")
                {
                }
                column(LC_Orders_LC_No_; "LC No.")
                {
                }
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
        LC_Detail__Expiry_Date_CaptionLbl: Label 'Expiry Date';
        LC_Detail__Date_of_Issue_CaptionLbl: Label 'Date of Issue';
        LC_Orders__Shipment_Date_CaptionLbl: Label 'Shipment Date';
        OrdersCaptionLbl: Label 'Orders';
}

