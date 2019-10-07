report 50011 "Sales VAT Invoice"
{
    // version Sales /Sadaf

    // <changelog>
    //     <change releaseversion="IN6.00"/>
    //     <change id="IN0090" dev="AUGMENTUM" date="2008-06-16" area="Sales"
    //            baseversion="IN6.00" releaseversion="IN6.00" feature="NAVCORS20358">
    //            Report transformation.
    //     </change>
    // </changelog>
    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/Sales VAT Invoice.rdl';

    Caption = 'Invoice';
    Permissions = TableData "Sales Shipment Buffer" = rimd;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            DataItemTableView = SORTING ("No.");
            RequestFilterFields = "No.", "Sell-to Customer No.", "No. Printed";
            RequestFilterHeading = 'Posted Sales Invoice';
            column(ComInfo_Pic; CompanyInfo.Picture)
            {
            }
            column(Cominfo; CompanyInfo.Cominfo)
            {
            }
            column(Comadd; CompanyInfo.ComAdd)
            {
            }
            column(Comadd1; CompanyInfo.ComAdd1)
            {
            }
            column(Comadd2; CompanyInfo.ComAdd2)
            {
            }
            column(Comadd3; CompanyInfo.ComAdd3)
            {
            }
            column(Comadd4; CompanyInfo.ComAdd4)
            {
            }
            column(ComTel; CompanyInfo.ComTel)
            {
            }
            column(ComFAX; CompanyInfo.ComFax)
            {
            }
            column(TaxINVOICE; CompanyInfo."Tax Invoice")
            {
            }
            column(VATReg; CompanyInfo."Vat Registration No.1")
            {
            }
            column(CustName; CompanyInfo."Customer Name")
            {
            }
            column(CustRegNo; CompanyInfo."Cust VAT REG")
            {
            }
            column(PaymnetTerms; CompanyInfo."Payment Terms")
            {
            }
            column(Date; CompanyInfo.Date)
            {
            }
            column(InvoiceNumber; CompanyInfo."Invoice Number")
            {
            }
            column(DONumber; CompanyInfo."D.O. Number")
            {
            }
            column(LPONo; CompanyInfo."LPO No")
            {
            }
            column(SNO; CompanyInfo."S.No")
            {
            }
            column(ITEMCODE; CompanyInfo."UCIL Item Code")
            {
            }
            column(Descofgoods; CompanyInfo."Description of Goods")
            {
            }
            column(UOM; CompanyInfo.UOM)
            {
            }
            column(QTY; CompanyInfo.Qty)
            {
            }
            column(RATE; CompanyInfo.Rate)
            {
            }
            column(AMOUNT; CompanyInfo.Amount)
            {
            }
            column(TRUCKNO; CompanyInfo."Truck No.")
            {
            }
            column(DRIVERNAME1; CompanyInfo."Driver Name")
            {
            }
            column(RECEIVEDBY1; CompanyInfo."Received By")
            {
            }
            column(PREPAREDBY1; CompanyInfo."Prepared By")
            {
            }
            column(FORUCIL1; CompanyInfo."For Universal Carton Industrie")
            {
            }
            column(AmtInWord; CompanyInfo.AmountInWords)
            {
            }
            column(TOTAL_TAX_AMT; TOTAL_TAX_AMT)
            {
            }
            column(Ccode; Ccode)
            {
            }
            column(CurrencyCode_SalesInvoiceHeader; "Sales Invoice Header"."Currency Code")
            {
            }
            column(AmountIncludingVAT_SalesInvoiceHeader; "Sales Invoice Header"."Amount Including VAT")
            {
            }
            column(CompanynyName; CompanyInfo.Name)
            {
            }
            column(NAME; NAME)
            {
            }
            column(Com_name; 'For' + ' ' + NAME)
            {
            }
            column(ADD; ADDRESS)
            {
            }
            column(ADD1; ADDRESS1)
            {
            }
            column(CITY; CITY)
            {
            }
            column(COMPFAX; COMPFAX)
            {
            }
            column(TMOBNO; MOBNO + ', ')
            {
            }
            column(TMAIL; MAIL + '  ' + '  Website: ' + WEB)
            {
            }
            column(CompVatReg_No; CompanyInfo."VAT Registration No.")
            {
            }
            column(CustVATNO; CustVATNO)
            {
            }
            column(Rep_Cap; CaptionNew)
            {
                OptionCaption = '  ,ORIGINAL FOR BUYER , DUPLICATE FOR TANSPORTER,EXTRA_COPY';
                OptionMembers = "  ","ORIGINAL FOR BUYER "," DUPLICATE FOR TANSPORTER",EXTRA_COPY;
            }
            column(DeliveryTime; "Sales Invoice Header"."Delivery Time")
            {
            }
            column(Pic; CompanyInfo.Picture)
            {
            }
            column(ShipmentNo; ShipmentNo)
            {
            }
            column(No_SalesInvoiceHeader; "No.")
            {
            }
            column(PostingDate_SalesInvoiceHeader; "Sales Invoice Header"."Posting Date")
            {
            }
            column(DODATE; "Sales Invoice Header"."Order Date")
            {
            }
            column(InvDiscountAmountCaption; InvDiscountAmountCaptionLbl)
            {
            }
            column(VATPercentageCaption; VATPercentageCaptionLbl)
            {
            }
            column(VATAmountCaption; VATAmountCaptionLbl)
            {
            }
            column(VATIdentifierCaption; VATIdentifierCaptionLbl)
            {
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }
            column(VATBaseCaption; VATBaseCaptionLbl)
            {
            }
            column(PaymentTermsCaption; PaymentTermsCaptionLbl)
            {
            }
            column(ShipmentMethodCaption; ShipmentMethodCaptionLbl)
            {
            }
            column(EMailCaption; EMailCaptionLbl)
            {
            }
            column(DocumentDateCaption; DocumentDateCaptionLbl)
            {
            }
            column(PaymentTerms; "Sales Invoice Header"."Payment Terms Code")
            {
            }
            column(DueDate; "Sales Invoice Header"."Due Date")
            {
            }
            column(OrderNo_SalesInvoiceHeader; "Sales Invoice Header"."Order No.")
            {
            }
            column(OrderDate_SalesInvoiceHeader; "Sales Invoice Header"."Order Date")
            {
            }
            column(ExternalDocumentNo_SalesInvoiceHeader; "Sales Invoice Header"."External Document No.")
            {
            }
            column(CHALLAN; CHALLAN)
            {
            }
            column(DriverName; "Sales Invoice Header"."Driver Name")
            {
            }
            column(VehicleName; "Sales Invoice Header"."Vehicle No.")
            {
            }
            column(BilltoName_SalesInvoiceHeader; "Sales Invoice Header"."Bill-to Name")
            {
            }
            column(BilltoAddress_SalesInvoiceHeader; "Sales Invoice Header"."Bill-to Address" + ',' + "Sales Invoice Header"."Bill-to Address 2")
            {
            }
            column(BilltoAddress2_SalesInvoiceHeader; "Sales Invoice Header"."Bill-to Address 2")
            {
            }
            column(BilltoCity_SalesInvoiceHeader; "Sales Invoice Header"."Bill-to City" + '-' + "Sales Invoice Header"."Bill-to Post Code")
            {
            }
            column(BilltoPostCode_SalesInvoiceHeader; "Sales Invoice Header"."Bill-to Post Code")
            {
            }
            column(SelltoCustomerName_SalesInvoiceHeader; "Sales Invoice Header"."Sell-to Customer Name")
            {
            }
            column(SelltoAddress_SalesInvoiceHeader; "Sales Invoice Header"."Sell-to Address" + ',' + "Sales Invoice Header"."Sell-to Address 2")
            {
            }
            column(ShiptoName; "Sales Invoice Header"."Ship-to Name")
            {
            }
            column(ShipToCode; "Sales Invoice Header"."Ship-to Code")
            {
            }
            column(ShiptoAdd1_Add2; "Sales Invoice Header"."Ship-to Address" + ', ' + "Sales Invoice Header"."Ship-to Address 2" + ',' + "Sales Invoice Header"."Ship-to City" + ' - ' + "Sales Invoice Header"."Ship-to Post Code")
            {
            }
            column(Removed; POSTCODE + ' ( ' + SCD + ' ) ')
            {
            }
            column(ShiptpAdd2; "Sales Invoice Header"."Ship-to Address 2")
            {
            }
            column(ShipToCity_PostCode; "Sales Invoice Header"."Ship-to City" + ' - ' + "Sales Invoice Header"."Ship-to Post Code" + ' ( ' + SCD + ' ) ')
            {
            }
            column(ShipToPostcode; "Sales Invoice Header"."Ship-to Post Code")
            {
            }
            column(SelltoAddress2_SalesInvoiceHeader; "Sales Invoice Header"."Sell-to Address 2")
            {
            }
            column(SelltoPostCode_SalesInvoiceHeader; "Sales Invoice Header"."Sell-to Post Code")
            {
            }
            column(ConsigneeCode; "Sales Invoice Header"."Ship-to Post Code")
            {
            }
            column(Origin; "Sales Invoice Header"."Sell-to Country/Region Code")
            {
            }
            column(TotalAmount; TotalAmount)
            {
                AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                AutoFormatType = 1;
            }
            column(UserName; UserName)
            {
            }
            column(SelltoCity_SalesInvoiceHeader; "Sales Invoice Header"."Sell-to City" + '-' + "Sales Invoice Header"."Sell-to Post Code" + ' ( ' + SCD + ' ) ')
            {
            }
            column(Payment_Desc; PAYMENTDES)
            {
            }
            column(Method_desc; METHODDESC)
            {
            }
            column(CHRG_DESC; CHRG_DESC)
            {
            }
            column(AmounttoCustomer_SalesInvoiceHeader; "Sales Invoice Header".Amount)
            {
            }
            column(RsNumberText1NumberText2; NumberText[1] + ' ' + NumberText[2])
            {
            }
            column(Remarks; Remarks)
            {
            }
            column(CustAdd; CustAdd)
            {

            }
            column(CustCity; CustCity)
            {

            }
            column(PayDescription; PayDescription)
            {
            }
            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = SORTING (Number);
                dataitem(PageLoop; "Integer")
                {
                    DataItemTableView = SORTING (Number) WHERE (Number = CONST (1));
                    column(CompanyInfo2Picture; CompanyInfo2.Picture)
                    {
                    }
                    column(CompanyInfo1Picture; CompanyInfo1.Picture)
                    {
                    }
                    column(CompanyInfo3Picture; CompanyInfo3.Picture)
                    {
                    }
                    column(DocumentCaptionCopyText; StrSubstNo(DocumentCaption, CopyText))
                    {
                    }
                    column(CustAddr1; CustAddr[1])
                    {
                    }
                    column(CompanyAddr1; CompanyAddr[1])
                    {
                    }
                    column(CustAddr2; CustAddr[2])
                    {
                    }
                    column(CompanyAddr2; CompanyAddr[2])
                    {
                    }
                    column(CustAddr3; CustAddr[3])
                    {
                    }
                    column(CompanyAddr3; CompanyAddr[3])
                    {
                    }
                    column(CustAddr4; CustAddr[4])
                    {
                    }
                    column(CompanyAddr4; CompanyAddr[4])
                    {
                    }
                    column(CustAddr5; CustAddr[5])
                    {
                    }
                    column(CompanyInfoPhoneNo; CompanyInfo."Phone No.")
                    {
                    }
                    column(CustAddr6; CustAddr[6])
                    {
                    }
                    column(PaymentTermsDescription; PaymentTerms.Description)
                    {
                    }
                    column(ShipmentMethodDescription; ShipmentMethod.Description)
                    {
                    }
                    column(CompanyInfoHomePage; CompanyInfo."Home Page")
                    {
                    }
                    column(CompanyInfoEMail; CompanyInfo."E-Mail")
                    {
                    }
                    column(CompanyInfoVATRegNo; CompanyInfo."VAT Registration No.")
                    {
                    }
                    column(CompanyInfoGiroNo; CompanyInfo."Giro No.")
                    {
                    }
                    column(CompanyInfoBankName; CompanyInfo."Bank Name")
                    {
                    }
                    column(CompanyInfoBankAccountNo; CompanyInfo."Bank Account No.")
                    {
                    }
                    column(BillToCustNo_SalesInvHdr; "Sales Invoice Header"."Bill-to Customer No.")
                    {
                    }
                    column(PostingDate_SalesInvHdr; Format("Sales Invoice Header"."Posting Date"))
                    {
                    }
                    column(VATNoText; VATNoText)
                    {
                    }
                    column(VATRegNo_SalesInvHdr; "Sales Invoice Header"."VAT Registration No.")
                    {
                    }
                    column(DueDate_SalesInvoiceHdr; Format("Sales Invoice Header"."Due Date"))
                    {
                    }
                    column(SalesPersonText; SalesPersonText)
                    {
                    }
                    column(SalesPurchPersonName; SalesPurchPerson.Name)
                    {
                    }
                    column(ReferenceText; ReferenceText)
                    {
                    }
                    column(YourReference_SalesInvHdr; "Sales Invoice Header"."Your Reference")
                    {
                    }
                    column(OrderNoText; OrderNoText)
                    {
                    }
                    column(OrderNo_SalesInvoiceHdr; "Sales Invoice Header"."Order No.")
                    {
                    }
                    column(CustAddr7; CustAddr[7])
                    {
                    }
                    column(CustAddr8; CustAddr[8])
                    {
                    }
                    column(CompanyAddr5; CompanyAddr[5])
                    {
                    }
                    column(CompanyAddr6; CompanyAddr[6])
                    {
                    }
                    column(DocDate_SalesInvHeader; Format("Sales Invoice Header"."Document Date", 0, 4))
                    {
                    }
                    column(PricesInclVAT_SalesInvHdr; "Sales Invoice Header"."Prices Including VAT")
                    {
                    }
                    column(OutputNo; OutputNo)
                    {
                    }
                    column(PricesInclVATYesNo; Format("Sales Invoice Header"."Prices Including VAT"))
                    {
                    }
                    column(PageCaption; StrSubstNo(Text005, ''))
                    {
                    }
                    column(SupplementaryText; SupplementaryText)
                    {
                    }
                    column(PhoneNoCaption; PhoneNoCaptionLbl)
                    {
                    }
                    column(HomePageCaption; HomePageCaptionLbl)
                    {
                    }
                    column(VATRegNoCaption; VATRegNoCaptionLbl)
                    {
                    }
                    column(GiroNoCaption; GiroNoCaptionLbl)
                    {
                    }
                    column(BankNameCaption; BankNameCaptionLbl)
                    {
                    }
                    column(BankAccNoCaption; BankAccNoCaptionLbl)
                    {
                    }
                    column(DueDateCaption; DueDateCaptionLbl)
                    {
                    }
                    column(InvoiceNoCaption; InvoiceNoCaptionLbl)
                    {
                    }
                    column(PostingDateCaption; PostingDateCaptionLbl)
                    {
                    }
                    column(ServiceTaxRegistrationNoCaption; ServiceTaxRegistrationNoLbl)
                    {
                    }
                    column(ServiceTaxRegistrationNo; ServiceTaxRegistrationNo)
                    {
                    }
                    column(BillToCustNo_SalesInvHdrCaption; "Sales Invoice Header".FieldCaption("Bill-to Customer No."))
                    {
                    }
                    column(PricesInclVAT_SalesInvHdrCaption; "Sales Invoice Header".FieldCaption("Prices Including VAT"))
                    {
                    }
                    dataitem(DimensionLoop1; "Integer")
                    {
                        DataItemLinkReference = "Sales Invoice Header";
                        DataItemTableView = SORTING (Number) WHERE (Number = FILTER (1 ..));
                        column(DimText_DimensionLoop1; DimText)
                        {
                        }
                        column(Number_Integer; DimensionLoop1.Number)
                        {
                        }
                        column(HeaderDimensionsCaption; HeaderDimensionsCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if Number = 1 then begin
                                if not DimSetEntry1.FindSet then
                                    CurrReport.Break;
                            end else
                                if not Continue then
                                    CurrReport.Break;

                            Clear(DimText);
                            Continue := false;
                            repeat
                                OldDimText := DimText;
                                if DimText = '' then
                                    DimText := StrSubstNo('%1 %2', DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code")
                                else
                                    DimText :=
                                      StrSubstNo(
                                        '%1, %2 %3', DimText,
                                        DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code");
                                if StrLen(DimText) > MaxStrLen(OldDimText) then begin
                                    DimText := OldDimText;
                                    Continue := true;
                                    exit;
                                end;
                            until DimSetEntry1.Next = 0;
                        end;

                        trigger OnPreDataItem()
                        begin
                            if not ShowInternalInfo then
                                CurrReport.Break;
                        end;
                    }
                    dataitem("Sales Invoice Line"; "Sales Invoice Line")
                    {
                        DataItemLink = "Document No." = FIELD ("No.");
                        DataItemLinkReference = "Sales Invoice Header";
                        DataItemTableView = SORTING ("Document No.", "Line No.") WHERE ("No." = FILTER (<> '9140'), Quantity = FILTER (<> 0));
                        column(VAT_SalesInvoiceLine; "Sales Invoice Line"."VAT %")
                        {
                        }
                        column(AmountIncludingVAT_SalesInvoiceLine; "Sales Invoice Line"."Amount Including VAT")
                        {
                        }
                        column(ExternalDocNo_SalesInvoiceLine; "Sales Invoice Line"."External Doc. No.")
                        {
                        }
                        column(ProdOrderNo_SalesInvoiceLine; "Sales Invoice Line"."Prod. Order No.")
                        {
                        }
                        column(ShipmentNo_SalesInvoiceLine; "Sales Invoice Line"."Shipment No.")
                        {
                        }
                        column(LOPDATE; "Sales Invoice Line"."LPO(Order) Date")
                        {
                        }
                        column(TAXDESC; TAXDES)
                        {
                        }
                        column(LineAmount_SalesInvLine; "Line Amount")
                        {
                            AutoFormatExpression = "Sales Invoice Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(Description_SalesInvLine; AdditionalDesc + Description + ' ' + '(' + PailotDescription + ')')
                        {
                        }
                        column(TerrifCode; TerrifCode)
                        {
                        }
                        column(NetWight; "Sales Invoice Line"."Net Weight")
                        {
                        }
                        column(EmptyCartonDesc; AdditionalDesc)
                        {
                        }
                        column(No_SalesInvoiceLine; "No.")
                        {
                        }
                        column(Quantity_SalesInvoiceLine; Quantity)
                        {
                        }
                        column(SLNO; SLNO)
                        {
                        }
                        column(UOM_SalesInvoiceLine; "Unit of Measure")
                        {
                        }
                        column(UnitPrice_SalesInvLine; "Unit Price")
                        {
                            AutoFormatExpression = "Sales Invoice Line".GetCurrencyCode;
                            AutoFormatType = 2;
                        }
                        column(LineDiscount_SalesInvLine; "Line Discount %")
                        {
                        }
                        column(LineDiscount_SalesInvLineAmount; "Line Discount Amount")
                        {
                        }
                        column(PostedShipmentDate; Format(PostedShipmentDate))
                        {
                        }
                        column(SalesLineType; Format("Sales Invoice Line".Type))
                        {
                        }
                        column(InvDiscountAmount; -"Inv. Discount Amount")
                        {
                            AutoFormatExpression = "Sales Invoice Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(TotalSubTotal; TotalSubTotal)
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalInvoiceDiscAmount; TotalInvoiceDiscountAmount)
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalText; TotalText)
                        {
                        }
                        column(SalesInvoiceLineAmount; Amount)
                        {
                            AutoFormatExpression = "Sales Invoice Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(AmtInclVAT_SalesInvLine; Amount)
                        {
                            AutoFormatExpression = "Sales Invoice Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(TotalInclVATText; TotalInclVATText)
                        {
                        }
                        column(TotalAmountInclVAT; TotalAmountInclVAT)
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(ServiceTaxAmt; ServiceTaxAmt)
                        {
                            AutoFormatExpression = "Sales Invoice Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(ChargesAmount; ChargesAmount)
                        {
                            AutoFormatExpression = "Sales Invoice Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(OtherTaxesAmount; OtherTaxesAmount)
                        {
                            AutoFormatExpression = "Sales Invoice Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(ServiceTaxECessAmt; ServiceTaxECessAmt)
                        {
                            AutoFormatExpression = "Sales Invoice Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(SalesInvLineTotalTDSTCSInclSHECESS; TotalTCSAmount)
                        {
                        }
                        column(AppliedServiceTaxAmt; AppliedServiceTaxAmt)
                        {
                            AutoFormatExpression = "Sales Invoice Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(AppliedServiceTaxECessAmt; AppliedServiceTaxECessAmt)
                        {
                            AutoFormatExpression = "Sales Invoice Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(ServiceTaxSHECessAmt; ServiceTaxSHECessAmt)
                        {
                            AutoFormatExpression = "Sales Invoice Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(AppliedServTaxSHECessAmt; AppliedServiceTaxSHECessAmt)
                        {
                            AutoFormatExpression = "Sales Invoice Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(TotalTaxAmt; TotalTaxAmt)
                        {
                        }
                        column(TotalExciseAmt; TotalExciseAmt)
                        {
                        }
                        column(VATBaseDisc_SalesInvHdr; "Sales Invoice Header"."VAT Base Discount %")
                        {
                            AutoFormatType = 1;
                        }
                        column(TotalPaymentDiscountOnVAT; TotalPaymentDiscountOnVAT)
                        {
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVATAmtText; VATAmountLine.VATAmountText)
                        {
                        }
                        column(TotalExclVATText; TotalExclVATText)
                        {
                        }
                        column(TotalAmountVAT; TotalAmountVAT)
                        {
                        }
                        column(SalesInvoiceLineLineNo; "Line No.")
                        {
                        }
                        column(UnitPriceCaption; UnitPriceCaptionLbl)
                        {
                        }
                        column(DiscountCaption; DiscountCaptionLbl)
                        {
                        }
                        column(AmountCaption; AmountCaptionLbl)
                        {
                        }
                        column(LineDiscountCaption; LineDiscountCaptionLbl)
                        {
                        }
                        column(PostedShipmentDateCaption; PostedShipmentDateCaptionLbl)
                        {
                        }
                        column(SubtotalCaption; SubtotalCaptionLbl)
                        {
                        }
                        column(ExciseAmountCaption; ExciseAmountCaptionLbl)
                        {
                        }
                        column(TaxAmountCaption; TaxAmountCaptionLbl)
                        {
                        }
                        column(ServiceTaxAmountCaption; ServiceTaxAmountCaptionLbl)
                        {
                        }
                        column(ChargesAmountCaption; ChargesAmountCaptionLbl)
                        {
                        }
                        column(OtherTaxesAmountCaption; OtherTaxesAmountCaptionLbl)
                        {
                        }
                        column(ServTaxeCessAmtCaption; ServTaxeCessAmtCaptionLbl)
                        {
                        }
                        column(TCSAmountCaption; TCSAmountCaptionLbl)
                        {
                        }
                        column(SvcTaxAmtAppliedCaption; SvcTaxAmtAppliedCaptionLbl)
                        {
                        }
                        column(SvcTaxeCessAmtAppliedCaption; SvcTaxeCessAmtAppliedCaptionLbl)
                        {
                        }
                        column(ServTaxSHECessAmtCaption; ServTaxSHECessAmtCaptionLbl)
                        {
                        }
                        column(SvcTaxSHECessAmtAppliedCaption; SvcTaxSHECessAmtAppliedCaptionLbl)
                        {
                        }
                        column(PaymentDiscVATCaption; PaymentDiscVATCaptionLbl)
                        {
                        }
                        column(Description_SalesInvLineCaption; FieldCaption(Description))
                        {
                        }
                        column(No_SalesInvoiceLineCaption; FieldCaption("No."))
                        {
                        }
                        column(Quantity_SalesInvoiceLineCaption; FieldCaption(Quantity))
                        {
                        }
                        column(UOM_SalesInvoiceLineCaption; FieldCaption("Unit of Measure"))
                        {
                        }
                        dataitem("Sales Shipment Buffer"; "Integer")
                        {
                            DataItemTableView = SORTING (Number);
                            column(SalesShpBufferPostingDate; Format(SalesShipmentBuffer."Posting Date"))
                            {
                            }
                            column(SalesShipmentBufferQty; SalesShipmentBuffer.Quantity)
                            {
                                DecimalPlaces = 0 : 5;
                            }
                            column(ShipmentCaption; ShipmentCaptionLbl)
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                if Number = 1 then
                                    SalesShipmentBuffer.Find('-')
                                else
                                    SalesShipmentBuffer.Next;
                            end;

                            trigger OnPreDataItem()
                            begin
                                SalesShipmentBuffer.SetRange("Document No.", "Sales Invoice Line"."Document No.");
                                SalesShipmentBuffer.SetRange("Line No.", "Sales Invoice Line"."Line No.");

                                SetRange(Number, 1, SalesShipmentBuffer.Count);
                            end;
                        }
                        dataitem(DimensionLoop2; "Integer")
                        {
                            DataItemTableView = SORTING (Number) WHERE (Number = FILTER (1 ..));
                            column(DimText_DimensionLoop2; DimText)
                            {
                            }
                            column(LineDimensionsCaption; LineDimensionsCaptionLbl)
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                if Number = 1 then begin
                                    if not DimSetEntry2.FindSet then
                                        CurrReport.Break;
                                end else
                                    if not Continue then
                                        CurrReport.Break;

                                Clear(DimText);
                                Continue := false;
                                repeat
                                    OldDimText := DimText;
                                    if DimText = '' then
                                        DimText := StrSubstNo('%1 %2', DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code")
                                    else
                                        DimText :=
                                          StrSubstNo(
                                            '%1, %2 %3', DimText,
                                            DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code");
                                    if StrLen(DimText) > MaxStrLen(OldDimText) then begin
                                        DimText := OldDimText;
                                        Continue := true;
                                        exit;
                                    end;
                                until DimSetEntry2.Next = 0;
                            end;

                            trigger OnPreDataItem()
                            begin
                                if not ShowInternalInfo then
                                    CurrReport.Break;

                                DimSetEntry2.SetRange("Dimension Set ID", "Sales Invoice Line"."Dimension Set ID");
                            end;
                        }
                        dataitem(AsmLoop; "Integer")
                        {
                            DataItemTableView = SORTING (Number);
                            column(TempPostedAsmLineNo; BlanksForIndent + TempPostedAsmLine."No.")
                            {
                            }
                            column(TempPostedAsmLineDescription; BlanksForIndent + TempPostedAsmLine.Description)
                            {
                            }
                            column(TempPostedAsmLineVariantCode; BlanksForIndent + TempPostedAsmLine."Variant Code")
                            {

                            }
                            column(TempPostedAsmLineQuantity; TempPostedAsmLine.Quantity)
                            {

                            }
                            column(TempPostedAsmLineUOMCode; GetUOMText(TempPostedAsmLine."Unit of Measure Code"))
                            {

                            }

                            trigger OnAfterGetRecord()
                            begin
                                if Number = 1 then
                                    TempPostedAsmLine.FindSet
                                else
                                    TempPostedAsmLine.Next;
                            end;

                            trigger OnPreDataItem()
                            begin
                                Clear(TempPostedAsmLine);
                                if not DisplayAssemblyInformation then
                                    CurrReport.Break;
                                CollectAsmInformation;
                                Clear(TempPostedAsmLine);
                                SetRange(Number, 1, TempPostedAsmLine.Count);
                            end;
                        }

                        trigger OnAfterGetRecord()
                        begin
                            //SLNO := SLNO+1;
                            /*
                            SALES_SHPHEADER.RESET;
                            SALES_SHPHEADER.SETRANGE(SALES_SHPHEADER."No.","Shipment No.");
                            IF SALES_SHPHEADER.FINDFIRST THEN BEGIN
                              DODATE := SALES_SHPHEADER."Posting Date";
                            END ELSE BEGIN
                              DODATE := 0D;
                            END;
                            */
                            if "Sales Invoice Line".Type = "Sales Invoice Line".Type::Item then begin
                                SLI := SLI + 1;
                                SLNO := Format(SLI);
                            end else begin
                                SLNO := '';
                            end;




                            /*SALES_LINE.RESET;
                            SALES_LINE.SETRANGE(SALES_LINE."Document No.","Ref. Sales Order No.");
                            SALES_LINE.SETRANGE(SALES_LINE."No.","No.");
                            IF SALES_LINE.FINDFIRST THEN BEGIN
                              SALES_LINE.CALCFIELDS(SALES_LINE."Order Date");
                              LOPDATE := SALES_LINE."Order Date";
                            END ELSE BEGIN
                              LOPDATE := 0D;
                            END;
                            */
                            /*
                          SALES_SHPHEADER.RESET;
                          SALES_SHPHEADER.SETRANGE(SALES_SHPHEADER."No.","Shipment No.");
                          IF SALES_SHPHEADER.FINDFIRST THEN BEGIN
                            LOPDATE := SALES_SHPHEADER."Order Date";
                          END ELSE BEGIN
                            LOPDATE := 0D;
                          END;

                           */



                            TG.Reset;
                            TG.SetRange(TG.Code, "Tax Group Code");
                            if TG.FindFirst then begin
                                TAXDES := TG.Description;
                            end else begin
                                TAXDES := '';
                            end;


                            PostedShipmentDate := 0D;
                            if Quantity <> 0 then
                                PostedShipmentDate := FindPostedShipmentDate;

                            if (Type = Type::"G/L Account") and (not ShowInternalInfo) then
                                "No." := '';

                            VATAmountLine.Init;
                            VATAmountLine."VAT Identifier" := "VAT Identifier";
                            VATAmountLine."VAT Calculation Type" := "VAT Calculation Type";
                            VATAmountLine."Tax Group Code" := "Tax Group Code";
                            VATAmountLine."VAT %" := "VAT %";
                            VATAmountLine."VAT Base" := Amount;
                            VATAmountLine."Amount Including VAT" := "Amount Including VAT";
                            VATAmountLine."Line Amount" := "Line Amount";
                            if "Allow Invoice Disc." then
                                VATAmountLine."Inv. Disc. Base Amount" := "Line Amount";
                            VATAmountLine."Invoice Discount Amount" := "Inv. Discount Amount";
                            VATAmountLine.InsertLine;

                            //TotalTCSAmount += "Total TDS/TCS Incl. SHE CESS";

                            TotalSubTotal += "Line Amount";
                            TotalInvoiceDiscountAmount -= "Inv. Discount Amount";
                            TotalAmount += Amount;
                            TotalAmountVAT += "Amount Including VAT" - Amount;
                            // TotalAmountInclVAT += "Amount Including VAT";
                            TotalPaymentDiscountOnVAT += -("Line Amount" - "Inv. Discount Amount" - "Amount Including VAT");
                            //IN0090.begin
                            TotalAmountInclVAT += Amount;
                            //TotalExciseAmt +=  "Excise Amount";
                            //TotalTaxAmt +=  "Tax Amount";
                            //ServiceTaxAmount += "Service Tax Amount";
                            //ServiceTaxeCessAmount += "Service Tax eCess Amount";
                            //ServiceTaxSHECessAmount += "Service Tax SHE Cess Amount";
                            //IN0090.end

                            /*StructureLineDetails.RESET;
                            StructureLineDetails.SETRANGE(Type,StructureLineDetails.Type::"2");
                            StructureLineDetails.SETRANGE("Document Type",StructureLineDetails."Document Type"::"2");
                            StructureLineDetails.SETRANGE("Invoice No.","Document No.");
                            StructureLineDetails.SETRANGE("Item No.","No.");
                            StructureLineDetails.SETRANGE("Line No.","Line No.");
                            IF StructureLineDetails.FIND('-') THEN
                              REPEAT
                                IF NOT StructureLineDetails."Payable to Third Party" THEN BEGIN
                                  IF StructureLineDetails."Tax/Charge Type" = StructureLineDetails."Tax/Charge Type"::"0" THEN
                                    ChargesAmount := ChargesAmount + ABS(StructureLineDetails.Amount);
                                  IF StructureLineDetails."Tax/Charge Type" = StructureLineDetails."Tax/Charge Type"::"3" THEN
                                    OtherTaxesAmount := OtherTaxesAmount + ABS(StructureLineDetails.Amount);
                                END;
                              UNTIL StructureLineDetails.NEXT = 0;     */
                            //IN0090.begin
                            /*IF "Sales Invoice Header"."Transaction No. Serv. Tax" <> 0 THEN BEGIN
                              ServiceTaxEntry.RESET;
                              ServiceTaxEntry.SETRANGE(Type,ServiceTaxEntry.Type::"0");
                              ServiceTaxEntry.SETRANGE("Document Type",ServiceTaxEntry."Document Type"::"2");
                              ServiceTaxEntry.SETRANGE("Document No.","Document No.");
                              IF ServiceTaxEntry.FINDFIRST THEN BEGIN
                            
                                IF "Sales Invoice Header"."Currency Code" <> '' THEN BEGIN
                                  ServiceTaxEntry."Service Tax Amount" :=
                                    ROUND(CurrExchRate.ExchangeAmtLCYToFCY(
                                    "Sales Invoice Header"."Posting Date","Sales Invoice Header"."Currency Code",
                                    ServiceTaxEntry."Service Tax Amount","Sales Invoice Header"."Currency Factor"));
                                  ServiceTaxEntry."eCess Amount" :=
                                    ROUND(CurrExchRate.ExchangeAmtLCYToFCY(
                                    "Sales Invoice Header"."Posting Date","Sales Invoice Header"."Currency Code",
                                    ServiceTaxEntry."eCess Amount","Sales Invoice Header"."Currency Factor"));
                                  ServiceTaxEntry."SHE Cess Amount" :=
                                    ROUND(CurrExchRate.ExchangeAmtLCYToFCY(
                                    "Sales Invoice Header"."Posting Date","Sales Invoice Header"."Currency Code",
                                    ServiceTaxEntry."SHE Cess Amount","Sales Invoice Header"."Currency Factor"));
                                END;
                            
                                ServiceTaxAmt := ABS(ServiceTaxEntry."Service Tax Amount");
                                ServiceTaxECessAmt := ABS(ServiceTaxEntry."eCess Amount");
                                ServiceTaxSHECessAmt := ABS(ServiceTaxEntry."SHE Cess Amount");
                                AppliedServiceTaxAmt := ServiceTaxAmount - ABS(ServiceTaxEntry."Service Tax Amount");
                                AppliedServiceTaxECessAmt := ServiceTaxeCessAmount - ABS(ServiceTaxEntry."eCess Amount");
                                AppliedServiceTaxSHECessAmt := ServiceTaxSHECessAmount - ABS(ServiceTaxEntry."SHE Cess Amount");
                              END ELSE BEGIN
                                AppliedServiceTaxAmt := ServiceTaxAmount;
                                AppliedServiceTaxECessAmt := ServiceTaxeCessAmount;
                                AppliedServiceTaxSHECessAmt := ServiceTaxSHECessAmount;
                              END;
                            END ELSE BEGIN
                              ServiceTaxAmt := ServiceTaxAmount;
                              ServiceTaxECessAmt := ServiceTaxeCessAmount;
                              ServiceTaxSHECessAmt := ServiceTaxSHECessAmount;
                            END; */
                            //IN0090.end


                            //For Pallet



                            if ("Sales Invoice Line".Type = "Sales Invoice Line".Type::Item) then
                                PACKING_LINE.Reset;
                            PACKING_LINE.SetCurrentKey(PACKING_LINE.Quantity);
                            PACKING_LINE.SetRange(PACKING_LINE."Sales Shipment No.", "Shipment No.");
                            PACKING_LINE.SetRange(PACKING_LINE."Item No.", "No.");
                            PACKING_LINE.SetRange(PACKING_LINE."Type Of Packing", 0);
                            PACKING_LINE.SetFilter(PACKING_LINE.Posted, 'True');
                            if PACKING_LINE.FindFirst then begin
                                TempQty := '';
                                LineCounter := 0;
                                PailotDescription := '';
                                repeat
                                    if TempQty <> Format(PACKING_LINE.Quantity) then begin
                                        if LineCounter <> 0 then
                                            PailotDescription := PailotDescription + ' ' + TempQty + ' X ' + Format(LineCounter) + ' ' + 'Pallet' + ' ';

                                        TempQty := Format(PACKING_LINE.Quantity);
                                        LineCounter := 1;
                                    end else begin
                                        LineCounter := LineCounter + 1;
                                    end;
                                until PACKING_LINE.Next = 0;
                                if LineCounter <> 0 then
                                    PailotDescription := PailotDescription + ' ' + TempQty + ' X ' + Format(LineCounter) + ' ' + 'Pallet' + ' ';
                            end else begin
                                PailotDescription := '';
                            end;

                        end;

                        trigger OnPreDataItem()
                        begin
                            VATAmountLine.DeleteAll;
                            SalesShipmentBuffer.Reset;
                            SalesShipmentBuffer.DeleteAll;
                            FirstValueEntryNo := 0;
                            MoreLines := Find('+');
                            while MoreLines and (Description = '') and ("No." = '') and (Quantity = 0) and (Amount = 0) do
                                MoreLines := Next(-1) <> 0;
                            if not MoreLines then
                                CurrReport.Break;
                            SetRange("Line No.", 0, "Line No.");

                            //CurrReport.CREATETOTALS("Service Tax SHE Cess Amount");
                            NetWeight := NetWeight + "Net Weight"; //frz
                            //MESSAGE(FORMAT(NetWeight));
                            /*IF "Item Category Code"= 'FG' THEN BEGIN
                            AdditionalDesc:='EMPTY CARTONS ';
                            END ELSE
                            AdditionalDesc:='';
                            */
                            if Quantity <> 0 then
                                TerrifCode := '';
                            Item.Reset;
                            Item.SetRange(Item."No.", "No.");
                            if Item.Find('-') then
                                TerrifCode := Item."Tariff No.";
                            //MESSAGE(TerrifCode);//frz

                        end;
                    }
                    dataitem(VATCounter; "Integer")
                    {
                        DataItemTableView = SORTING (Number);
                        column(VATAmountLineVATBase; VATAmountLine."VAT Base")
                        {
                            AutoFormatExpression = "Sales Invoice Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(VATAmountLineVATAmount; VATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLineLineAmount; VATAmountLine."Line Amount")
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineInvDiscBaseAmt; VATAmountLine."Inv. Disc. Base Amount")
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineInvDiscAmt; VATAmountLine."Invoice Discount Amount")
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVAT_VATCounter; VATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(VATAmtLineVATIdentifier_VATCounter; VATAmountLine."VAT Identifier")
                        {
                        }
                        column(VATAmountSpecificationCaption; VATAmountSpecificationCaptionLbl)
                        {
                        }
                        column(InvDiscBaseAmtCaption; InvDiscBaseAmtCaptionLbl)
                        {
                        }
                        column(LineAmountCaption; LineAmountCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            VATAmountLine.GetLine(Number);
                        end;

                        trigger OnPreDataItem()
                        begin
                            SetRange(Number, 1, VATAmountLine.Count);

                        end;
                    }
                    dataitem(VatCounterLCY; "Integer")
                    {
                        DataItemTableView = SORTING (Number);
                        column(VALSpecLCYHeader; VALSpecLCYHeader)
                        {
                        }
                        column(VALExchRate; VALExchRate)
                        {
                        }
                        column(VALVATBaseLCY; VALVATBaseLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VALVATAmountLCY; VALVATAmountLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVAT_VatCounterLCY; VATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(VATAmtLineVATIdentifier_VatCounterLCY; VATAmountLine."VAT Identifier")
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            VATAmountLine.GetLine(Number);

                            VALVATBaseLCY := Round(VATAmountLine."VAT Base" / "Sales Invoice Header"."Currency Factor");
                            VALVATAmountLCY := Round(VATAmountLine."VAT Amount" / "Sales Invoice Header"."Currency Factor");
                        end;

                        trigger OnPreDataItem()
                        begin
                            if (not GLSetup."Print VAT specification in LCY") or
                               ("Sales Invoice Header"."Currency Code" = '')
                            then
                                CurrReport.Break;

                            SetRange(Number, 1, VATAmountLine.Count);


                            if GLSetup."LCY Code" = '' then
                                VALSpecLCYHeader := Text007 + Text008
                            else
                                VALSpecLCYHeader := Text007 + Format(GLSetup."LCY Code");

                            CurrExchRate.FindCurrency("Sales Invoice Header"."Posting Date", "Sales Invoice Header"."Currency Code", 1);
                            CalculatedExchRate := Round(1 / "Sales Invoice Header"."Currency Factor" * CurrExchRate."Exchange Rate Amount", 0.000001);
                            VALExchRate := StrSubstNo(Text009, CalculatedExchRate, CurrExchRate."Exchange Rate Amount");
                        end;
                    }
                    dataitem(Total; "Integer")
                    {
                        DataItemTableView = SORTING (Number) WHERE (Number = CONST (1));
                    }
                    dataitem(Total2; "Integer")
                    {
                        DataItemTableView = SORTING (Number) WHERE (Number = CONST (1));
                        column(SellToCustNo_SalesInvHdr; "Sales Invoice Header"."Sell-to Customer No.")
                        {
                        }
                        column(ShipToAddr1; ShipToAddr[1])
                        {
                        }
                        column(ShipToAddr2; ShipToAddr[2])
                        {
                        }
                        column(ShipToAddr3; ShipToAddr[3])
                        {
                        }
                        column(ShipToAddr4; ShipToAddr[4])
                        {
                        }
                        column(ShipToAddr5; ShipToAddr[5])
                        {
                        }
                        column(ShipToAddr6; ShipToAddr[6])
                        {
                        }
                        column(ShipToAddr7; ShipToAddr[7])
                        {
                        }
                        column(ShipToAddr8; ShipToAddr[8])
                        {
                        }
                        column(ShipToAddressCaption; ShipToAddressCaptionLbl)
                        {
                        }
                        column(SellToCustNo_SalesInvHdrCaption; "Sales Invoice Header".FieldCaption("Sell-to Customer No."))
                        {
                        }

                        trigger OnPreDataItem()
                        begin
                            if not ShowShippingAddr then
                                CurrReport.Break;
                        end;
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    if Number > 1 then begin
                        CopyText := Text003;
                        OutputNo += 1;
                    end;


                    TotalSubTotal := 0;
                    TotalInvoiceDiscountAmount := 0;
                    TotalAmount := 0;
                    TotalAmountVAT := 0;
                    TotalAmountInclVAT := 0;
                    TotalPaymentDiscountOnVAT := 0;
                    TotalExciseAmt := 0;
                    TotalTaxAmt := 0;
                    ServiceTaxAmount := 0;
                    ServiceTaxeCessAmount := 0;
                    ServiceTaxSHECessAmount := 0;

                    OtherTaxesAmount := 0;
                    ChargesAmount := 0;
                    AppliedServiceTaxSHECessAmt := 0;
                    AppliedServiceTaxECessAmt := 0;
                    AppliedServiceTaxAmt := 0;
                    ServiceTaxSHECessAmt := 0;
                    ServiceTaxECessAmt := 0;
                    ServiceTaxAmt := 0;
                    TotalTCSAmount := 0;
                end;

                trigger OnPostDataItem()
                begin
                    if not CurrReport.Preview then
                        SalesInvCountPrinted.Run("Sales Invoice Header");
                end;

                trigger OnPreDataItem()
                begin
                    NoOfLoops := Abs(NoOfCopies) + Cust."Invoice Copies" + 1;
                    if NoOfLoops <= 0 then
                        NoOfLoops := 1;
                    CopyText := '';
                    SetRange(Number, 1, NoOfLoops);
                    OutputNo := 1;
                end;
            }

            trigger OnAfterGetRecord()
            var
                SalesInvLine: Record "Sales Invoice Line";
                Location: Record Location;
            begin
                CurrReport.Language := Language.GetLanguageID("Language Code");

                if RespCenter.Get("Responsibility Center") then begin
                    FormatAddr.RespCenter(CompanyAddr, RespCenter);
                    CompanyInfo."Phone No." := RespCenter."Phone No.";
                    CompanyInfo."Fax No." := RespCenter."Fax No.";
                end else begin
                    FormatAddr.Company(CompanyAddr, CompanyInfo);
                end;

                DimSetEntry1.SetRange("Dimension Set ID", "Dimension Set ID");

                if "Order No." = '' then
                    OrderNoText := ''
                else
                    OrderNoText := FieldCaption("Order No.");
                if "Salesperson Code" = '' then begin
                    SalesPurchPerson.Init;
                    SalesPersonText := '';
                end else begin
                    SalesPurchPerson.Get("Salesperson Code");
                    SalesPersonText := Text000;
                end;
                if "Your Reference" = '' then
                    ReferenceText := ''
                else
                    ReferenceText := FieldCaption("Your Reference");
                if "VAT Registration No." = '' then
                    VATNoText := ''
                else
                    VATNoText := FieldCaption("VAT Registration No.");
                if "Currency Code" = '' then begin
                    GLSetup.TestField("LCY Code");
                    TotalText := StrSubstNo(Text001, GLSetup."LCY Code");
                    TotalInclVATText := StrSubstNo(Text13700, GLSetup."LCY Code");
                    TotalExclVATText := StrSubstNo(Text13701, GLSetup."LCY Code");
                end else begin
                    TotalText := StrSubstNo(Text001, "Currency Code");
                    TotalInclVATText := StrSubstNo(Text13700, "Currency Code");
                    TotalExclVATText := StrSubstNo(Text13701, "Currency Code");
                end;
                FormatAddr.SalesInvBillTo(CustAddr, "Sales Invoice Header");
                if not Cust.Get("Bill-to Customer No.") then
                    Clear(Cust);

                if "Payment Terms Code" = '' then
                    PaymentTerms.Init
                else begin
                    PaymentTerms.Get("Payment Terms Code");
                    PaymentTerms.TranslateDescription(PaymentTerms, "Language Code");
                end;

                if "Shipment Method Code" = '' then
                    ShipmentMethod.Init
                else begin
                    ShipmentMethod.Get("Shipment Method Code");
                    ShipmentMethod.TranslateDescription(ShipmentMethod, "Language Code");
                end;
                FormatAddr.SalesInvShipTo(ShipToAddr, CustAddr, "Sales Invoice Header");
                ShowShippingAddr := "Sell-to Customer No." <> "Bill-to Customer No.";
                for i := 1 to ArrayLen(ShipToAddr) do
                    if ShipToAddr[i] <> CustAddr[i] then
                        ShowShippingAddr := true;

                if LogInteraction then
                    if not CurrReport.Preview then begin
                        if "Bill-to Contact No." <> '' then
                            SegManagement.LogDocument(
                              4, "No.", 0, 0, DATABASE::Contact, "Bill-to Contact No.", "Salesperson Code",
                              "Campaign No.", "Posting Description", '')
                        else
                            SegManagement.LogDocument(
                              4, "No.", 0, 0, DATABASE::Customer, "Bill-to Customer No.", "Salesperson Code",
                              "Campaign No.", "Posting Description", '');
                    end;

                SupplementaryText := '';
                SalesInvLine.SetRange("Document No.", "No.");
                if SalesInvLine.Find('-') then
                    SupplementaryText := Text16500;

                /*IF Location.GET("Location Code") THEN
                 // ServiceTaxRegistrationNo := Location."Service Tax Registration No."
                //ELSE
                  ServiceTaxRegistrationNo := CompanyInfo."Service Tax Registration No.";*/

                CompanyInfo.Get;
                CompanyInfo.CalcFields(CompanyInfo.Picture);
                NAME := CompanyInfo.Name;
                ADDRESS := CompanyInfo.Address;
                ADDRESS1 := CompanyInfo."Address 2";
                CITY := CompanyInfo.City;
                //State := CompanyInfo.State;
                /*ST.RESET;
                ST.SETRANGE(ST.Code,State);
                IF ST.FINDFIRST THEN BEGIN
                  STATDESC := ST.Description;
                END; */

                POSTCODE := CompanyInfo."Post Code";
                //CSTNO := CompanyInfo."C.S.T No.";
                //TINNO := CompanyInfo."T.I.N. No.";
                MOBNO := CompanyInfo."Phone No.";
                MAIL := CompanyInfo."E-Mail";
                WEB := CompanyInfo."Home Page";
                COMPFAX := CompanyInfo."Fax No.";


                Cust.Reset;
                Cust.SetRange(Cust."No.", "Sell-to Customer No.");
                if Cust.FindFirst then begin
                    CustVATNO := Cust."VAT Registration No.";
                end;

                /*ST.RESET;
                ST.SETRANGE(ST.Code,State);
                IF ST.FINDFIRST THEN BEGIN
                  CUSTSTATE := ST.Description;
                END ELSE BEGIN
                  CUSTSTATE := '';
                END; */

                VE.Reset;
                VE.SetRange(VE."Document No.", "No.");
                if VE.FindFirst then
                    ILE.Reset;
                ILE.SetRange(ILE."Entry No.", VE."Item Ledger Entry No.");
                if ILE.FindFirst then
                    CHALLAN := ILE."Document No."
                else
                    CHALLAN := '';

                /*ST.RESET;
                ST.SETRANGE(ST.Code,Cust."State Code");
                IF ST.FINDFIRST THEN BEGIN
                  SCD := ST.Description;
                END;  */

                /*ST.RESET;
                ST.SETRANGE(ST.Code,State);
                IF ST.FINDFIRST THEN BEGIN
                  STATDESC := ST.Description;
                END;*/

                PT.Reset;
                PT.SetRange(PT.Code, "Payment Terms Code");
                if PT.FindFirst then begin
                    PAYMENTDES := PT.Description;
                end;

                PM.Reset;
                PM.SetRange(PM.Code, "Payment Method Code");
                if PM.FindFirst then begin
                    METHODDESC := PM.Description;
                end;

                /*PSTRUCT.RESET;
                PSTRUCT.SETRANGE("Invoice No.","No.");
                PSTRUCT.SETFILTER(PSTRUCT."Tax/Charge Type",'Charges');
                IF PSTRUCT.FINDFIRST THEN
                  BEGIN
                    TaxChrgG.RESET;
                    TaxChrgG.SETRANGE(TaxChrgG.Code,PSTRUCT."Tax/Charge Group");
                    IF TaxChrgG.FINDFIRST THEN
                      CHRG_DESC := TaxChrgG.Description + '' +'@ Rs.'+ FORMAT(PSTRUCT."Calculation Value")
                      ELSE
                      CHRG_DESC := '';
                  END;*/


                ENTRY_VAT.Reset;
                ENTRY_VAT.SetRange(ENTRY_VAT."Document No.", "Sales Invoice Header"."No.");
                if ENTRY_VAT.FindFirst then begin
                    repeat
                        PRODUCT_POSTING_VAT := ENTRY_VAT."VAT Prod. Posting Group";
                        BUSINESS_POSTING_VAT := ENTRY_VAT."VAT Bus. Posting Group";
                        TOTAL_TAX_AMT += ENTRY_VAT.Amount;
                    until ENTRY_VAT.Next = 0;

                end;

                /*IF "Sales Invoice Header"."Currency Code" <>'' THEN BEGIN
                  Ccode := "Sales Invoice Header"."Currency Code"
                 END ELSE BEGIN
                 Ccode := 'AED';
                END;*/

                CURRNCY.Reset;
                CURRNCY.SetRange(CURRNCY.Code, "Sales Invoice Header"."Currency Code");
                if CURRNCY.FindFirst then begin
                    Ccode := CURRNCY.Code;
                end else begin
                    Ccode := 'DHS';
                end;


                // message (TotalDebitAmt);

                InitTextVariable;
                "Sales Invoice Header".CalcFields("Sales Invoice Header"."Amount Including VAT");
                TotalDebitAmt += "Sales Invoice Header"."Amount Including VAT";
                FormatNoText(NumberText, Abs(TotalDebitAmt), '');
                //Firoz 17/12/15
                ShipmentNo := '';
                SalesInvLine.Reset;
                SalesInvLine.SetRange(SalesInvLine."Document No.", "No.");
                if SalesInvLine.FindFirst then
                    ShipmentNo := SalesInvLine."Shipment No.";


                UserTab.Reset;
                UserTab.SetRange(UserTab."User Name", UserId);
                if UserTab.FindFirst then
                    UserName := UserTab."Full Name";

                Clear(Remarks);
                SalesCommentLine.Reset;
                SalesCommentLine.SetRange(SalesCommentLine."Document Type", SalesCommentLine."Document Type"::"Posted Invoice");
                SalesCommentLine.SetRange(SalesCommentLine."No.", "Sales Invoice Header"."No.");
                if SalesCommentLine.FindSet then begin
                    repeat
                        Remarks := Remarks + '|' + SalesCommentLine.Comment;
                    until SalesCommentLine.Next = 0;
                end;
                //MESSAGE(UserName);

                //MESSAGE("Ship-to Post Code");
                //MESSAGE("Sell-to Country/Region Code");
                Clear(CustAdd);
                Clear(CustCity);
                Rec_Customer.Reset;
                if Rec_Customer.Get("Sales Invoice Header"."Sell-to Customer No.") then begin
                    if Rec_Customer."Payment Terms Print" then begin
                        if Rec_PaymentTerms.Get(Rec_Customer."Payment Terms Code") then
                            PayDescription := Rec_PaymentTerms.Description;
                    end else
                        PayDescription := 'As Agreed';
                    IF Rec_customer."Customer Address Print" THEN BEGIN
                        CustAdd := Rec_Customer.Address;
                        CustCity := Rec_Customer.City;
                    End Else begin
                        CustAdd := "Sell-to Address";
                        CustCity := "Sell-to City";
                    END;
                end;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(NoOfCopies; NoOfCopies)
                    {
                        Caption = 'No. of Copies';
                        Visible = false;
                    }
                    field(CaptionNew; CaptionNew)
                    {
                        Caption = 'No. of Copies';
                    }
                    field(ShowInternalInfo; ShowInternalInfo)
                    {
                        Caption = 'Show Internal Information';
                    }
                    field(LogInteraction; LogInteraction)
                    {
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                    }
                    field(DisplayAsmInformation; DisplayAssemblyInformation)
                    {
                        Caption = 'Show Assembly Components';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            LogInteractionEnable := true;
        end;

        trigger OnOpenPage()
        begin
            InitLogInteraction;
            LogInteractionEnable := LogInteraction;
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        GLSetup.Get;
        CompanyInfo.Get;
        SalesSetup.Get;

        case SalesSetup."Logo Position on Documents" of
            SalesSetup."Logo Position on Documents"::"No Logo":
                ;
            SalesSetup."Logo Position on Documents"::Left:
                begin
                    CompanyInfo3.Get;
                    CompanyInfo3.CalcFields(Picture);
                end;
            SalesSetup."Logo Position on Documents"::Center:
                begin
                    CompanyInfo1.Get;
                    CompanyInfo1.CalcFields(Picture);
                end;
            SalesSetup."Logo Position on Documents"::Right:
                begin
                    CompanyInfo2.Get;
                    CompanyInfo2.CalcFields(Picture);
                end;
        end;
    end;

    trigger OnPreReport()
    begin
        if not CurrReport.UseRequestPage then
            InitLogInteraction;
    end;

    var
        Text000: Label 'Salesperson';
        Text001: Label 'Total %1';
        Text002: Label 'Total %1 Incl. VAT';
        Text003: Label ' COPY';
        Text004: Label 'T A X   I N V O I C E  %1';
        Text005: Label 'Page %1';
        Text006: Label 'Total %1 Excl. VAT';
        GLSetup: Record "General Ledger Setup";
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInfo: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        CompanyInfo3: Record "Company Information";
        SalesSetup: Record "Sales & Receivables Setup";
        Cust: Record Customer;
        VATAmountLine: Record "VAT Amount Line" temporary;
        DimSetEntry1: Record "Dimension Set Entry";
        DimSetEntry2: Record "Dimension Set Entry";
        RespCenter: Record "Responsibility Center";
        Language: Record Language;
        CurrExchRate: Record "Currency Exchange Rate";
        TempPostedAsmLine: Record "Posted Assembly Line" temporary;
        SalesInvCountPrinted: Codeunit "Sales Inv.-Printed";
        FormatAddr: Codeunit "Format Address";
        SegManagement: Codeunit SegManagement;
        SalesShipmentBuffer: Record "Sales Shipment Buffer" temporary;
        PostedShipmentDate: Date;
        CustAddr: array[8] of Text[50];
        ShipToAddr: array[8] of Text[50];
        CompanyAddr: array[8] of Text[50];
        OrderNoText: Text[80];
        SalesPersonText: Text[30];
        VATNoText: Text[80];
        ReferenceText: Text[80];
        TotalText: Text[50];
        TotalExclVATText: Text[50];
        TotalInclVATText: Text[50];
        MoreLines: Boolean;
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        CopyText: Text[30];
        ShowShippingAddr: Boolean;
        i: Integer;
        NextEntryNo: Integer;
        FirstValueEntryNo: Integer;
        DimText: Text[120];
        OldDimText: Text[75];
        ShowInternalInfo: Boolean;
        Continue: Boolean;
        LogInteraction: Boolean;
        VALVATBaseLCY: Decimal;
        VALVATAmountLCY: Decimal;
        VALSpecLCYHeader: Text[80];
        Text007: Label 'VAT Amount Specification in ';
        Text008: Label 'Local Currency';
        VALExchRate: Text[50];
        Text009: Label 'Exchange rate: %1/%2';
        CalculatedExchRate: Decimal;
        Text010: Label 'Sales - Prepayment Invoice %1';
        OutputNo: Integer;
        TotalSubTotal: Decimal;
        TotalAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        TotalAmountVAT: Decimal;
        TotalInvoiceDiscountAmount: Decimal;
        TotalPaymentDiscountOnVAT: Decimal;
        ChargesAmount: Decimal;
        OtherTaxesAmount: Decimal;
        Text13700: Label 'Total %1 Incl. Taxes';
        Text13701: Label 'Total %1 Excl. Taxes';
        SupplementaryText: Text[30];
        Text16500: Label 'Supplementary Invoice';
        ServiceTaxAmt: Decimal;
        ServiceTaxECessAmt: Decimal;
        AppliedServiceTaxAmt: Decimal;
        AppliedServiceTaxECessAmt: Decimal;
        ServiceTaxSHECessAmt: Decimal;
        AppliedServiceTaxSHECessAmt: Decimal;
        TotalTaxAmt: Decimal;
        TotalExciseAmt: Decimal;
        TotalTCSAmount: Decimal;
        ServiceTaxAmount: Decimal;
        ServiceTaxeCessAmount: Decimal;
        ServiceTaxSHECessAmount: Decimal;
        [InDataSet]
        LogInteractionEnable: Boolean;
        DisplayAssemblyInformation: Boolean;
        Text16564: Label 'FILS';
        PhoneNoCaptionLbl: Label 'Phone No.';
        HomePageCaptionLbl: Label 'Home Page';
        VATRegNoCaptionLbl: Label 'VAT Registration No.';
        GiroNoCaptionLbl: Label 'Giro No.';
        BankNameCaptionLbl: Label 'Bank';
        BankAccNoCaptionLbl: Label 'Account No.';
        DueDateCaptionLbl: Label 'Due Date';
        InvoiceNoCaptionLbl: Label 'Invoice No.';
        PostingDateCaptionLbl: Label 'Posting Date';
        PLAEntryNoCaptionLbl: Label 'PLA Entry No.';
        RG23AEntryNoCaptionLbl: Label 'RG23A Entry No.';
        RG23CEntryNoCaptionLbl: Label 'RG23C Entry No.';
        HeaderDimensionsCaptionLbl: Label 'Header Dimensions';
        UnitPriceCaptionLbl: Label 'Unit Price';
        DiscountCaptionLbl: Label 'Discount %';
        AmountCaptionLbl: Label 'Amount';
        LineDiscountCaptionLbl: Label 'Line Discount Amount';
        PostedShipmentDateCaptionLbl: Label 'Posted Shipment Date';
        SubtotalCaptionLbl: Label 'Subtotal';
        ExciseAmountCaptionLbl: Label 'Excise Amount';
        TaxAmountCaptionLbl: Label 'Tax Amount';
        ServiceTaxAmountCaptionLbl: Label 'Service Tax Amount';
        ChargesAmountCaptionLbl: Label 'Charges Amount';
        OtherTaxesAmountCaptionLbl: Label 'Other Taxes Amount';
        ServTaxeCessAmtCaptionLbl: Label 'Service Tax eCess Amount';
        TCSAmountCaptionLbl: Label 'TCS Amount';
        SvcTaxAmtAppliedCaptionLbl: Label 'Svc Tax Amt (Applied)';
        SvcTaxeCessAmtAppliedCaptionLbl: Label 'Svc Tax eCess Amt (Applied)';
        ServTaxSHECessAmtCaptionLbl: Label 'Service Tax SHE Cess Amount';
        SvcTaxSHECessAmtAppliedCaptionLbl: Label 'Svc Tax SHECess Amt(Applied)';
        PaymentDiscVATCaptionLbl: Label 'Payment Discount on VAT';
        ShipmentCaptionLbl: Label 'Shipment';
        LineDimensionsCaptionLbl: Label 'Line Dimensions';
        VATAmountSpecificationCaptionLbl: Label 'VAT Amount Specification';
        InvDiscBaseAmtCaptionLbl: Label 'Invoice Discount Base Amount';
        LineAmountCaptionLbl: Label 'Line Amount';
        ShipToAddressCaptionLbl: Label 'Ship-to Address';
        ServiceTaxRegistrationNo: Code[20];
        ServiceTaxRegistrationNoLbl: Label 'Service Tax Registration No.';
        InvDiscountAmountCaptionLbl: Label 'Invoice Discount Amount';
        VATPercentageCaptionLbl: Label 'VAT %';
        VATAmountCaptionLbl: Label 'VAT Amount';
        VATIdentifierCaptionLbl: Label 'VAT Identifier';
        TotalCaptionLbl: Label 'Total';
        VATBaseCaptionLbl: Label 'VAT Base';
        PaymentTermsCaptionLbl: Label 'Payment Terms';
        ShipmentMethodCaptionLbl: Label 'Shipment Method';
        EMailCaptionLbl: Label 'E-Mail';
        DocumentDateCaptionLbl: Label 'Document Date';
        NAME: Text[50];
        ADDRESS: Text[50];
        ADDRESS1: Text[50];
        CITY: Text[50];
        State: Text[30];
        POSTCODE: Text[30];
        CSTNO: Text[30];
        TINNO: Text[30];
        MOBNO: Text[30];
        MAIL: Text[30];
        WEB: Text[30];
        STATDESC: Text[30];
        SLNO: Text[10];
        CUSTTIN: Text[50];
        CUSTCST: Text[50];
        CUSTSTATE: Text[30];
        VE: Record "Value Entry";
        ILE: Record "Item Ledger Entry";
        CHALLAN: Code[20];
        SCD: Text[30];
        PT: Record "Payment Terms";
        PAYMENTDES: Text[30];
        PM: Record "Payment Method";
        METHODDESC: Text[30];
        CHRG_DESC: Text[30];
        TG: Record "Tax Group";
        TAXDES: Text[30];
        NumberText: array[2] of Text[80];
        OnesText: array[20] of Text[30];
        TensText: array[10] of Text[30];
        ExponentText: array[5] of Text[30];
        TotalDebitAmt: Decimal;
        Text16526: Label 'ZERO';
        Text16527: Label 'HUNDRED';
        Text16528: Label 'AND';
        Text16529: Label '%1 results in a written number that is too long.';
        Text16532: Label 'ONE';
        Text16533: Label 'TWO';
        Text16534: Label 'THREE';
        Text16535: Label 'FOUR';
        Text16536: Label 'FIVE';
        Text16537: Label 'SIX';
        Text16538: Label 'SEVEN';
        Text16539: Label 'EIGHT';
        Text16540: Label 'NINE';
        Text16541: Label 'TEN';
        Text16542: Label 'ELEVEN';
        Text16543: Label 'TWELVE';
        Text16544: Label 'THIRTEEN';
        Text16545: Label 'FOURTEEN';
        Text16546: Label 'FIFTEEN';
        Text16547: Label 'SIXTEEN';
        Text16548: Label 'SEVENTEEN';
        Text16549: Label 'EIGHTEEN';
        Text16550: Label 'NINETEEN';
        Text16551: Label 'TWENTY';
        Text16552: Label 'THIRTY';
        Text16553: Label 'FORTY';
        Text16554: Label 'FIFTY';
        Text16555: Label 'SIXTY';
        Text16556: Label 'SEVENTY';
        Text16557: Label 'EIGHTY';
        Text16558: Label 'NINETY';
        Text16559: Label 'THOUSAND';
        Text16560: Label 'MILLION';
        Text16561: Label 'BILLION';
        Text16562: Label 'LAKH';
        Text16563: Label 'CRORE';
        CaptionNew: Option " "," ORIGINAL FOR BUYER "," DUPLICATE FOR TANSPORTER",EXTRA_COPY;
        COMPFAX: Text;
        SALES_SHPHEADER: Record "Sales Shipment Header";
        LOPNO: Text[30];
        LOPDATE: Date;
        DODATE: Date;
        PAY: Text;
        AmttoText: Report Check;
        notext: array[2] of Text;
        SALES_LINE: Record "Sales Line";
        PACKING_LINE: Record "Packing List Line";
        PALLET_TAGNO: Integer;
        PALLET_QTY: Decimal;
        TempQty: Code[50];
        LineCounter: Integer;
        PailotDescription: Text[250];
        AdditionalDesc: Text[50];
        SLI: Integer;
        SalesInvLine: Record "Sales Invoice Line";
        ShipmentNo: Code[30];
        UserTab: Record User;
        UserName: Text[60];
        TerrifCode: Code[20];
        Item: Record Item;
        NetWeight: Decimal;
        CustVATNO: Code[30];
        ENTRY_VAT: Record "VAT Entry";
        TOTAL_TAX_AMT: Decimal;
        PRODUCT_POSTING_VAT: Code[10];
        BUSINESS_POSTING_VAT: Code[10];
        Ccode: Code[10];
        CURRNCY: Record Currency;
        Remarks: Text[200];
        CustAdd: Text[50];
        CustCity: Text[30];
        SalesCommentLine: Record "Sales Comment Line";
        Rec_Customer: Record Customer;
        PayDescription: Text;
        Rec_PaymentTerms: Record "Payment Terms";

    procedure InitLogInteraction()
    begin
        LogInteraction := SegManagement.FindInteractTmplCode(4) <> '';
    end;

    procedure FindPostedShipmentDate(): Date
    var
        SalesShipmentHeader: Record "Sales Shipment Header";
        SalesShipmentBuffer2: Record "Sales Shipment Buffer" temporary;
    begin
        NextEntryNo := 1;
        if "Sales Invoice Line"."Shipment No." <> '' then
            if SalesShipmentHeader.Get("Sales Invoice Line"."Shipment No.") then
                exit(SalesShipmentHeader."Posting Date");

        if "Sales Invoice Header"."Order No." = '' then
            exit("Sales Invoice Header"."Posting Date");

        case "Sales Invoice Line".Type of
            "Sales Invoice Line".Type::Item:
                GenerateBufferFromValueEntry("Sales Invoice Line");
            "Sales Invoice Line".Type::"G/L Account", "Sales Invoice Line".Type::Resource,
          "Sales Invoice Line".Type::"Charge (Item)", "Sales Invoice Line".Type::"Fixed Asset":
                GenerateBufferFromShipment("Sales Invoice Line");
            "Sales Invoice Line".Type::" ":
                exit(0D);
        end;

        SalesShipmentBuffer.Reset;
        SalesShipmentBuffer.SetRange("Document No.", "Sales Invoice Line"."Document No.");
        SalesShipmentBuffer.SetRange("Line No.", "Sales Invoice Line"."Line No.");
        if SalesShipmentBuffer.Find('-') then begin
            SalesShipmentBuffer2 := SalesShipmentBuffer;
            if SalesShipmentBuffer.Next = 0 then begin
                SalesShipmentBuffer.Get(
                  SalesShipmentBuffer2."Document No.", SalesShipmentBuffer2."Line No.", SalesShipmentBuffer2."Entry No.");
                SalesShipmentBuffer.Delete;
                exit(SalesShipmentBuffer2."Posting Date");
            end;
            SalesShipmentBuffer.CalcSums(Quantity);
            if SalesShipmentBuffer.Quantity <> "Sales Invoice Line".Quantity then begin
                SalesShipmentBuffer.DeleteAll;
                exit("Sales Invoice Header"."Posting Date");
            end;
        end else
            exit("Sales Invoice Header"."Posting Date");
    end;

    procedure GenerateBufferFromValueEntry(SalesInvoiceLine2: Record "Sales Invoice Line")
    var
        ValueEntry: Record "Value Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
        TotalQuantity: Decimal;
        Quantity: Decimal;
    begin
        TotalQuantity := SalesInvoiceLine2."Quantity (Base)";
        ValueEntry.SetCurrentKey("Document No.");
        ValueEntry.SetRange("Document No.", SalesInvoiceLine2."Document No.");
        ValueEntry.SetRange("Posting Date", "Sales Invoice Header"."Posting Date");
        ValueEntry.SetRange("Item Charge No.", '');
        ValueEntry.SetFilter("Entry No.", '%1..', FirstValueEntryNo);
        if ValueEntry.Find('-') then
            repeat
                if ItemLedgerEntry.Get(ValueEntry."Item Ledger Entry No.") then begin
                    if SalesInvoiceLine2."Qty. per Unit of Measure" <> 0 then
                        Quantity := ValueEntry."Invoiced Quantity" / SalesInvoiceLine2."Qty. per Unit of Measure"
                    else
                        Quantity := ValueEntry."Invoiced Quantity";
                    AddBufferEntry(
                      SalesInvoiceLine2,
                      -Quantity,
                      ItemLedgerEntry."Posting Date");
                    TotalQuantity := TotalQuantity + ValueEntry."Invoiced Quantity";
                end;
                FirstValueEntryNo := ValueEntry."Entry No." + 1;
            until (ValueEntry.Next = 0) or (TotalQuantity = 0);
    end;

    procedure GenerateBufferFromShipment(SalesInvoiceLine: Record "Sales Invoice Line")
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesInvoiceLine2: Record "Sales Invoice Line";
        SalesShipmentHeader: Record "Sales Shipment Header";
        SalesShipmentLine: Record "Sales Shipment Line";
        TotalQuantity: Decimal;
        Quantity: Decimal;
    begin
        TotalQuantity := 0;
        SalesInvoiceHeader.SetCurrentKey("Order No.");
        SalesInvoiceHeader.SetFilter("No.", '..%1', "Sales Invoice Header"."No.");
        SalesInvoiceHeader.SetRange("Order No.", "Sales Invoice Header"."Order No.");
        if SalesInvoiceHeader.Find('-') then
            repeat
                SalesInvoiceLine2.SetRange("Document No.", SalesInvoiceHeader."No.");
                SalesInvoiceLine2.SetRange("Line No.", SalesInvoiceLine."Line No.");
                SalesInvoiceLine2.SetRange(Type, SalesInvoiceLine.Type);
                SalesInvoiceLine2.SetRange("No.", SalesInvoiceLine."No.");
                SalesInvoiceLine2.SetRange("Unit of Measure Code", SalesInvoiceLine."Unit of Measure Code");
                if SalesInvoiceLine2.Find('-') then
                    repeat
                        TotalQuantity := TotalQuantity + SalesInvoiceLine2.Quantity;
                    until SalesInvoiceLine2.Next = 0;
            until SalesInvoiceHeader.Next = 0;

        SalesShipmentLine.SetCurrentKey("Order No.", "Order Line No.");
        SalesShipmentLine.SetRange("Order No.", "Sales Invoice Header"."Order No.");
        SalesShipmentLine.SetRange("Order Line No.", SalesInvoiceLine."Line No.");
        SalesShipmentLine.SetRange("Line No.", SalesInvoiceLine."Line No.");
        SalesShipmentLine.SetRange(Type, SalesInvoiceLine.Type);
        SalesShipmentLine.SetRange("No.", SalesInvoiceLine."No.");
        SalesShipmentLine.SetRange("Unit of Measure Code", SalesInvoiceLine."Unit of Measure Code");
        SalesShipmentLine.SetFilter(Quantity, '<>%1', 0);

        if SalesShipmentLine.Find('-') then
            repeat
                if "Sales Invoice Header"."Get Shipment Used" then
                    CorrectShipment(SalesShipmentLine);
                if Abs(SalesShipmentLine.Quantity) <= Abs(TotalQuantity - SalesInvoiceLine.Quantity) then
                    TotalQuantity := TotalQuantity - SalesShipmentLine.Quantity
                else begin
                    if Abs(SalesShipmentLine.Quantity) > Abs(TotalQuantity) then
                        SalesShipmentLine.Quantity := TotalQuantity;
                    Quantity :=
                      SalesShipmentLine.Quantity - (TotalQuantity - SalesInvoiceLine.Quantity);

                    TotalQuantity := TotalQuantity - SalesShipmentLine.Quantity;
                    SalesInvoiceLine.Quantity := SalesInvoiceLine.Quantity - Quantity;

                    if SalesShipmentHeader.Get(SalesShipmentLine."Document No.") then begin
                        AddBufferEntry(
                          SalesInvoiceLine,
                          Quantity,
                          SalesShipmentHeader."Posting Date");
                    end;
                end;
            until (SalesShipmentLine.Next = 0) or (TotalQuantity = 0);
    end;

    procedure CorrectShipment(var SalesShipmentLine: Record "Sales Shipment Line")
    var
        SalesInvoiceLine: Record "Sales Invoice Line";
    begin
        SalesInvoiceLine.SetCurrentKey("Shipment No.", "Shipment Line No.");
        SalesInvoiceLine.SetRange("Shipment No.", SalesShipmentLine."Document No.");
        SalesInvoiceLine.SetRange("Shipment Line No.", SalesShipmentLine."Line No.");
        if SalesInvoiceLine.Find('-') then
            repeat
                SalesShipmentLine.Quantity := SalesShipmentLine.Quantity - SalesInvoiceLine.Quantity;
            until SalesInvoiceLine.Next = 0;
    end;

    procedure AddBufferEntry(SalesInvoiceLine: Record "Sales Invoice Line"; QtyOnShipment: Decimal; PostingDate: Date)
    begin
        SalesShipmentBuffer.SetRange("Document No.", SalesInvoiceLine."Document No.");
        SalesShipmentBuffer.SetRange("Line No.", SalesInvoiceLine."Line No.");
        SalesShipmentBuffer.SetRange("Posting Date", PostingDate);
        if SalesShipmentBuffer.Find('-') then begin
            SalesShipmentBuffer.Quantity := SalesShipmentBuffer.Quantity + QtyOnShipment;
            SalesShipmentBuffer.Modify;
            exit;
        end;

        with SalesShipmentBuffer do begin
            "Document No." := SalesInvoiceLine."Document No.";
            "Line No." := SalesInvoiceLine."Line No.";
            "Entry No." := NextEntryNo;
            Type := SalesInvoiceLine.Type;
            "No." := SalesInvoiceLine."No.";
            Quantity := QtyOnShipment;
            "Posting Date" := PostingDate;
            Insert;
            NextEntryNo := NextEntryNo + 1
        end;
    end;

    local procedure DocumentCaption(): Text[250]
    begin
        if "Sales Invoice Header"."Prepayment Invoice" then
            exit(Text010);
        exit(Text004);
    end;

    procedure InitializeRequest(NewNoOfCopies: Integer; NewShowInternalInfo: Boolean; NewLogInteraction: Boolean; DisplayAsmInfo: Boolean)
    begin
        NoOfCopies := NewNoOfCopies;
        ShowInternalInfo := NewShowInternalInfo;
        LogInteraction := NewLogInteraction;
        DisplayAssemblyInformation := DisplayAsmInfo;
    end;

    procedure CollectAsmInformation()
    var
        ValueEntry: Record "Value Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
        PostedAsmHeader: Record "Posted Assembly Header";
        PostedAsmLine: Record "Posted Assembly Line";
        SalesShipmentLine: Record "Sales Shipment Line";
    begin
        TempPostedAsmLine.DeleteAll;
        if "Sales Invoice Line".Type <> "Sales Invoice Line".Type::Item then
            exit;
        with ValueEntry do begin
            SetCurrentKey("Document No.");
            SetRange("Document No.", "Sales Invoice Line"."Document No.");
            SetRange("Document Type", "Document Type"::"Sales Invoice");
            SetRange("Document Line No.", "Sales Invoice Line"."Line No.");
            if not FindSet then
                exit;
        end;
        repeat
            if ItemLedgerEntry.Get(ValueEntry."Item Ledger Entry No.") then begin
                if ItemLedgerEntry."Document Type" = ItemLedgerEntry."Document Type"::"Sales Shipment" then begin
                    SalesShipmentLine.Get(ItemLedgerEntry."Document No.", ItemLedgerEntry."Document Line No.");
                    if SalesShipmentLine.AsmToShipmentExists(PostedAsmHeader) then begin
                        PostedAsmLine.SetRange("Document No.", PostedAsmHeader."No.");
                        if PostedAsmLine.FindSet then
                            repeat
                                TreatAsmLineBuffer(PostedAsmLine);
                            until PostedAsmLine.Next = 0;
                    end;
                end;
            end;
        until ValueEntry.Next = 0;
    end;

    procedure TreatAsmLineBuffer(PostedAsmLine: Record "Posted Assembly Line")
    begin
        Clear(TempPostedAsmLine);
        TempPostedAsmLine.SetRange(Type, PostedAsmLine.Type);
        TempPostedAsmLine.SetRange("No.", PostedAsmLine."No.");
        TempPostedAsmLine.SetRange("Variant Code", PostedAsmLine."Variant Code");
        TempPostedAsmLine.SetRange(Description, PostedAsmLine.Description);
        TempPostedAsmLine.SetRange("Unit of Measure Code", PostedAsmLine."Unit of Measure Code");
        if TempPostedAsmLine.FindFirst then begin
            TempPostedAsmLine.Quantity += PostedAsmLine.Quantity;
            TempPostedAsmLine.Modify;
        end else begin
            Clear(TempPostedAsmLine);
            TempPostedAsmLine := PostedAsmLine;
            TempPostedAsmLine.Insert;
        end;
    end;

    procedure GetUOMText(UOMCode: Code[10]): Text[10]
    var
        UnitOfMeasure: Record "Unit of Measure";
    begin
        if not UnitOfMeasure.Get(UOMCode) then
            exit(UOMCode);
        exit(UnitOfMeasure.Description);
    end;

    procedure BlanksForIndent(): Text[10]
    begin
        exit(PadStr('', 2, ' '));
    end;

    procedure FormatNoText(var NoText: array[2] of Text[80]; No: Decimal; CurrencyCode: Code[10])
    var
        PrintExponent: Boolean;
        Ones: Integer;
        Tens: Integer;
        Hundreds: Integer;
        Exponent: Integer;
        NoTextIndex: Integer;
        Currency: Record Currency;
        TensDec: Integer;
        OnesDec: Integer;
    begin
        /*CLEAR(NoText);
        NoTextIndex := 1;
        NoText[1] := '';
        
        IF No < 1 THEN
          AddToNoText(NoText,NoTextIndex,PrintExponent,Text16526)
        ELSE BEGIN
          FOR Exponent := 4 DOWNTO 1 DO BEGIN
            PrintExponent := FALSE;
            IF No > 99999 THEN BEGIN
              Ones := No DIV (POWER(100,Exponent - 1) * 10);
              Hundreds := 0;
            END ELSE BEGIN
              Ones := No DIV POWER(1000,Exponent - 1);
              Hundreds := Ones DIV 100;
            END;
            Tens := (Ones MOD 100) DIV 10;
            Ones := Ones MOD 10;
            IF Hundreds > 0 THEN BEGIN
              AddToNoText(NoText,NoTextIndex,PrintExponent,OnesText[Hundreds]);
              AddToNoText(NoText,NoTextIndex,PrintExponent,Text16527);
            END;
            IF Tens >= 2 THEN BEGIN
              AddToNoText(NoText,NoTextIndex,PrintExponent,TensText[Tens]);
              IF Ones > 0 THEN
                AddToNoText(NoText,NoTextIndex,PrintExponent,OnesText[Ones]);
            END ELSE
              IF (Tens * 10 + Ones) > 0 THEN
                AddToNoText(NoText,NoTextIndex,PrintExponent,OnesText[Tens * 10 + Ones]);
            IF PrintExponent AND (Exponent > 1) THEN
              AddToNoText(NoText,NoTextIndex,PrintExponent,ExponentText[Exponent]);
            IF No > 99999 THEN
              No := No - (Hundreds * 100 + Tens * 10 + Ones) * POWER(100,Exponent - 1) * 10
            ELSE
              No := No - (Hundreds * 100 + Tens * 10 + Ones) * POWER(1000,Exponent - 1);
          END;
        END;
        
        IF CurrencyCode <> '' THEN BEGIN
          Currency.GET(CurrencyCode);
          AddToNoText(NoText,NoTextIndex,PrintExponent,' ' + Currency.Description);
        END ELSE
          AddToNoText(NoText,NoTextIndex,PrintExponent,'RUPEES');
        
        AddToNoText(NoText,NoTextIndex,PrintExponent,Text16528);
        
        TensDec := ((No * 100) MOD 100) DIV 10;
        OnesDec := (No * 100) MOD 10;
        IF TensDec >= 2 THEN BEGIN
          AddToNoText(NoText,NoTextIndex,PrintExponent,TensText[TensDec]);
          IF OnesDec > 0 THEN
            AddToNoText(NoText,NoTextIndex,PrintExponent,OnesText[OnesDec]);
        END ELSE
          IF (TensDec * 10 + OnesDec) > 0 THEN
            AddToNoText(NoText,NoTextIndex,PrintExponent,OnesText[TensDec * 10 + OnesDec])
          ELSE
            AddToNoText(NoText,NoTextIndex,PrintExponent,Text16526);
        IF (CurrencyCode <> '') THEN
          AddToNoText(NoText,NoTextIndex,PrintExponent,' ' + Currency.Description + ' ONLY')
        ELSE
          AddToNoText(NoText,NoTextIndex,PrintExponent,'DIRHAMS ONLY');
        
        */

        Clear(NoText);
        NoTextIndex := 1;
        NoText[1] := '';

        if No < 1 then
            AddToNoText(NoText, NoTextIndex, PrintExponent, Text16526, '')
        else begin
            for Exponent := 4 downto 1 do begin
                PrintExponent := false;
                Ones := No div Power(1000, Exponent - 1);
                Hundreds := Ones div 100;
                Tens := (Ones mod 100) div 10;
                Ones := Ones mod 10;
                if Hundreds > 0 then begin
                    AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Hundreds], '');
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text16527, '');
                end;
                if Tens >= 2 then begin
                    AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[Tens], '');
                    if Ones > 0 then
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones], '');
                end else
                    if (Tens * 10 + Ones) > 0 then
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Tens * 10 + Ones], '');
                if PrintExponent and (Exponent > 1) then
                    AddToNoText(NoText, NoTextIndex, PrintExponent, ExponentText[Exponent], '');
                No := No - (Hundreds * 100 + Tens * 10 + Ones) * Power(1000, Exponent - 1);
            end;

        end;

        if CurrencyCode <> '' then begin
            Currency.Get(CurrencyCode);
            AddToNoText(NoText, NoTextIndex, PrintExponent, ' ' + Currency.Description, '');
        end else
            AddToNoText(NoText, NoTextIndex, PrintExponent, '', '');  //

        AddToNoText(NoText, NoTextIndex, PrintExponent, 'AND ' + Text16564, Text16528);//

        TensDec := ((No * 100) mod 100) div 10;
        OnesDec := (No * 100) mod 10;
        if TensDec >= 2 then begin
            AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[TensDec], '');
            if OnesDec > 0 then
                AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[OnesDec], '');
        end else
            if (TensDec * 10 + OnesDec) > 0 then
                AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[TensDec * 10 + OnesDec], '')
            else
                AddToNoText(NoText, NoTextIndex, PrintExponent, '' + Text16526, '');//remove fils
        if (CurrencyCode <> '') then
            AddToNoText(NoText, NoTextIndex, PrintExponent, ' ' + Currency.Description + ' ONLY', '') //
        else
            AddToNoText(NoText, NoTextIndex, PrintExponent, 'ONLY', '');//

    end;

    local procedure AddToNoText(var NoText: array[2] of Text[80]; var NoTextIndex: Integer; var PrintExponent: Boolean; AddText: Text[30]; text1: Text[30])
    begin
        PrintExponent := true;

        while StrLen(NoText[NoTextIndex] + ' ' + AddText) > MaxStrLen(NoText[1]) do begin
            NoTextIndex := NoTextIndex + 1;
            if NoTextIndex > ArrayLen(NoText) then
                Error(Text16529, AddText);
        end;

        NoText[NoTextIndex] := DelChr(NoText[NoTextIndex] + ' ' + AddText, '<');
    end;

    procedure InitTextVariable()
    begin
        OnesText[1] := Text16532;
        OnesText[2] := Text16533;
        OnesText[3] := Text16534;
        OnesText[4] := Text16535;
        OnesText[5] := Text16536;
        OnesText[6] := Text16537;
        OnesText[7] := Text16538;
        OnesText[8] := Text16539;
        OnesText[9] := Text16540;
        OnesText[10] := Text16541;
        OnesText[11] := Text16542;
        OnesText[12] := Text16543;
        OnesText[13] := Text16544;
        OnesText[14] := Text16545;
        OnesText[15] := Text16546;
        OnesText[16] := Text16547;
        OnesText[17] := Text16548;
        OnesText[18] := Text16549;
        OnesText[19] := Text16550;

        TensText[1] := '';
        TensText[2] := Text16551;
        TensText[3] := Text16552;
        TensText[4] := Text16553;
        TensText[5] := Text16554;
        TensText[6] := Text16555;
        TensText[7] := Text16556;
        TensText[8] := Text16557;
        TensText[9] := Text16558;

        ExponentText[1] := '';
        ExponentText[2] := Text16559;
        ExponentText[3] := Text16562;
        ExponentText[4] := Text16563;
    end;
}

