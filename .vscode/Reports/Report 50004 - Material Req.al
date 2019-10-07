report 50004 "Material Req"
{
    // version Production/Sadaf

    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/Material Req.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
        dataitem("Requisition Header"; "Requisition Header")
        {
            DataItemTableView = SORTING ("Requisition No.");
            RequestFilterFields = "Requisition No.";
            column(Name_Comp; CompanyInfo.Name)
            {
            }
            column(Add_Comp; CompanyInfo.Address)
            {
            }
            column(Add2_Comp; CompanyInfo."Address 2")
            {
            }
            column(City_Comp; CompanyInfo.City)
            {
            }
            column(Department; "Requisition Header"."Shortcut Dimension 2 Code")
            {
            }
            column(Phone_Comp; CompanyInfo."Phone No.")
            {
            }
            column(Fax_Comp; CompanyInfo."Fax No.")
            {
            }
            column(Picture_Comp; CompanyInfo.Picture)
            {
            }
            column(Loc_Cpmp; CompanyInfo."Location Code")
            {
            }
            column(Postcode_Comp; CompanyInfo."Post Code")
            {
            }
            column(Country_Comp; CompanyInfo.County)
            {
            }
            column(Emai_Comp; CompanyInfo."E-Mail")
            {
            }
            column(Home_Comp; CompanyInfo."Home Page")
            {
            }
            column(CoutryCode_Comp; CompanyInfo."Country/Region Code")
            {
            }
            column(UserID_RequisitionHeader; "Requisition Header"."User ID")
            {
            }
            column(Description_RequisitionHeader; "Requisition Header".Description)
            {
            }
            column(RefDocumentNumber_RequisitionHeader; "Requisition Header"."Ref. Document Number")
            {
            }
            column(ProdOrderNo_RequisitionHeader; "Requisition Header"."Prod. Order No")
            {
            }
            column(ProdOrderLineNo_RequisitionHeader; "Requisition Header"."Prod. Order Line No.")
            {
            }
            column(RequisitionNo_RequisitionHeader; "Requisition Header"."Requisition No.")
            {
            }
            column(RequisitionDate_RequisitionHeader; ': ' + Format("Requisition Header"."Requisition Date"))
            {
            }
            column(RequisitionType_RequisitionHeader; "Requisition Header"."Requisition Type")
            {
            }
            column(RequisitionQuantity_RequisitionHeader; "Requisition Header"."Requisition Quantity")
            {
            }
            column(ProductionOrderQuantity_RequisitionHeader; "Requisition Header"."Production Order Quantity")
            {
            }
            column(ProdOrderLineQuantity_RequisitionHeader; "Requisition Header"."Prod. Order Line Quantity")
            {
            }
            column(PREV_JOBNO; PREV_JOBNO)
            {
            }
            column(CUST_NAME; CUST_NAME)
            {
            }
            column(DIE_UP; DIE_UP)
            {
            }
            column(ScheduleDocumentNo_RequisitionHeader; "Requisition Header"."Schedule Document No.")
            {
            }
            column(SHIFT_CODE; SHIFT_CODE)
            {
            }
            dataitem("Requisition Line SAM"; "Requisition Line SAM")
            {
                DataItemLink = "Requisition No." = FIELD ("Requisition No.");
                DataItemTableView = SORTING ("Requisition No.", "Requisition Line No.");
                column(SlNo_PurchaseLine; SLNo)
                {
                }
                column(PaperPosition_RequisitionLineSAM; "Requisition Line SAM"."Paper Position")
                {
                }
                column(RequisitionNo_RequisitionLineSAM; "Requisition Line SAM"."Requisition No.")
                {
                }
                column(RequisitionLineNo_RequisitionLineSAM; "Requisition Line SAM"."Requisition Line No.")
                {
                }
                column(ProdOrderNo_RequisitionLineSAM; "Requisition Line SAM"."Prod. Order No")
                {
                }
                column(ProdOrderLineNo_RequisitionLineSAM; "Requisition Line SAM"."Prod. Order Line No.")
                {
                }
                column(ProdOrderCompLineNo_RequisitionLineSAM; "Requisition Line SAM"."Prod. Order Comp. Line No")
                {
                }
                column(ItemNo_RequisitionLineSAM; "Requisition Line SAM"."Item No.")
                {
                }
                column(Description_RequisitionLineSAM; "Requisition Line SAM".Description)
                {
                }
                column(Quantity_RequisitionLineSAM; "Requisition Line SAM".Quantity)
                {
                }
                column(UnitOfMeasure_RequisitionLineSAM; "Requisition Line SAM"."Unit Of Measure")
                {
                }
                column(RequestedDate_RequisitionLineSAM; "Requisition Line SAM"."Requested Date")
                {
                }
                column(RemainingQuantity_RequisitionLineSAM; "Requisition Line SAM"."Remaining Quantity")
                {
                }
                column(AvailableQuantity; "Requisition Line SAM"."Available Inventory")
                {
                }
                column(RequestedDate; "Requisition Line SAM"."Requested Date")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    SLNo := SLNo + 1;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                //CurrReport.LANGUAGE := Language.GetLanguageID("Language Code");
                CompanyInfo.Get;
                CompanyInfo.CalcFields(CompanyInfo.Picture);

                PROD_ORDER.Reset;
                PROD_ORDER.SetRange(PROD_ORDER."No.", "Prod. Order No");
                if PROD_ORDER.FindFirst then begin
                    EST_NO := PROD_ORDER."Estimate Code";
                    ESTMATION_HEADER.Reset;
                    ESTMATION_HEADER.SetRange(ESTMATION_HEADER."Product Design No.", EST_NO);
                    if ESTMATION_HEADER.FindFirst then begin
                        BOARD_LENGTH := ESTMATION_HEADER."Board Length (mm)- L";
                        BOARD_WIDTH := ESTMATION_HEADER."Board Width (mm)- W";
                        BOARD_UP := ESTMATION_HEADER."Board Ups";
                    end else begin
                        BOARD_LENGTH := 0;
                        BOARD_WIDTH := 0;
                        BOARD_UP := 0;
                    end;

                end;

                DIE_UP := Format(BOARD_WIDTH) + ' ' + 'X' + ' ' + Format(BOARD_LENGTH) + ' (' + Format(1) + ' ' + 'X' + Format(BOARD_UP) + ')';

                PROD_ORDER.Reset;
                PROD_ORDER.SetRange(PROD_ORDER."No.", "Prod. Order No");
                if PROD_ORDER.FindFirst then begin
                    CUST_NAME := PROD_ORDER."Customer Name";
                end;

                SHIFT_CODE := '';
                ProductionSchedule.Reset;
                ProductionSchedule.SetRange(ProductionSchedule."Schedule No.", "Schedule Document No.");
                if ProductionSchedule.FindFirst then begin
                    SHIFT_CODE := ProductionSchedule."Shift Code";
                end;
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
        Language: Record Language;
        Location: Record Location;
        CompanyInfo: Record "Company Information";
        SLNo: Integer;
        PROD_ORDER: Record "Production Order";
        PREV_JOBNO: Code[10];
        CUST: Record Customer;
        CUST_NAME: Text[100];
        CUST_NO: Code[20];
        ESTMATION_HEADER: Record "Product Design Header";
        BOARD_LENGTH: Decimal;
        BOARD_WIDTH: Decimal;
        BOARD_UP: Decimal;
        DIE_UP: Text;
        EST_NO: Code[20];
        ProductionSchedule: Record "Production Schedule";
        SHIFT_CODE: Code[20];
}

