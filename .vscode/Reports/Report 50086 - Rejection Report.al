report 50086 "Rejection Report"
{
    // version Firoz

    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/Rejection Report.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Return Receipt Header"; "Return Receipt Header")
        {
            RequestFilterFields = "Posting Date";
            column(COMPNAME; COMPNAME)
            {
            }
            column(Pic; CompanyInfo.Picture)
            {
            }
            column(ReturnOrder_No; "Return Receipt Header"."No.")
            {
            }
            column(CustomerNo; "Return Receipt Header"."Sell-to Customer No.")
            {
            }
            column(CustomerName; "Return Receipt Header"."Bill-to Name")
            {
            }
            column(ReturnOrderDate; "Return Receipt Header"."Order Date")
            {
            }
            column(PostingDate; "Return Receipt Header"."Posting Date")
            {
            }
            column(ExternalDocNo_LPONo; "Return Receipt Header"."External Document No.")
            {
            }
            column(OrderNo; OrderNo)
            {
            }
            column(JobNo; JobNo)
            {
            }
            dataitem("Return Receipt Line"; "Return Receipt Line")
            {
                DataItemLink = "Document No." = FIELD ("No.");
                DataItemTableView = WHERE (Quantity = FILTER (<> 0));
                column(ItemNo; "Return Receipt Line"."No.")
                {
                }
                column(ItemDescription; "Return Receipt Line".Description)
                {
                }
                column(ReturnQuantity; "Return Receipt Line".Quantity)
                {
                }
                column(Netweight; "Return Receipt Line"."Net Weight")
                {
                }
                column(SlNo; SlNo)
                {
                }
                column(ReturnReasonCode; ReasonDesc)
                {
                }
                column(AllFilters; AllFilters)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    SlNo += 1;



                    ReasonDesc := '';
                    ReturnReason.Reset;
                    ReturnReason.SetRange(ReturnReason.Code, "Return Reason Code");
                    if ReturnReason.FindFirst then
                        ReasonDesc := ReturnReason.Description;
                end;
            }

            trigger OnAfterGetRecord()
            begin

                OrderNo := '';
                SalesInvHeader.Reset;
                SalesInvHeader.SetRange(SalesInvHeader."External Document No.", "External Document No.");
                if SalesInvHeader.FindFirst then begin
                    OrderNo := SalesInvHeader."Order No.";
                    //MESSAGE(OrderNo);
                end;
                JobNo := '';
                SalesLine.Reset;
                SalesLine.SetRange(SalesLine."Document No.", OrderNo);
                if SalesLine.FindFirst then
                    JobNo := SalesLine."Prod. Order No.";




                CompanyInfo.Get;
                COMPNAME := CompanyInfo.Name;
                CompanyInfo.CalcFields(CompanyInfo.Picture);
            end;

            trigger OnPreDataItem()
            begin
                AllFilters := "Return Receipt Header".GetFilters;
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
        SalesInvHeader: Record "Sales Invoice Header";
        JobNo: Code[20];
        OrderNo: Code[20];
        SalesLine: Record "Sales Line";
        SlNo: Integer;
        AllFilters: Text;
        CompanyInfo: Record "Company Information";
        COMPNAME: Text[60];
        ReasonDesc: Text[100];
        ReturnReason: Record "Return Reason";
}

