report 50002 "Plate Charge Not Invoiced"
{
    // version Purchase/ Sadaf

    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/Plate Charge Not Invoiced.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
        dataitem(Item1; Item)
        {
            DataItemTableView = SORTING ("No.") ORDER(Ascending) WHERE ("Plate Item" = FILTER (true));
            RequestFilterFields = "Customer No.";
            column(RunDate; WorkDate)
            {
            }
            column(Comp_Name; CompanyInformation.Name)
            {
            }
            column(Comp_Add; CompanyInformation.Address)
            {
            }
            column(Comp_Add2; CompanyInformation."Address 2")
            {
            }
            column(CUSTFILTER; CUSTFILTER)
            {
            }
            column(No_Item1; Item1."No.")
            {
            }
            column(Description_Item1; Item1.Description)
            {
            }
            column(FGItemNo_Item1; Item1."FG Item No.")
            {
            }
            column(ITEM_DESC; ITEM_DESC)
            {
            }
            column(CustomerNo_Item1; Item1."Customer No.")
            {
            }
            column(CustomerName_Item1; Item1."Customer Name")
            {
            }
            dataitem("Purch. Inv. Line"; "Purch. Inv. Line")
            {
                DataItemLink = "No." = FIELD ("No.");
                DataItemTableView = SORTING ("Document No.", "Line No.") ORDER(Ascending) WHERE (Type = CONST (Item), Quantity = FILTER (<> 0));
                PrintOnlyIfDetail = false;
                column(FG_ITEMNO; FG_ITEMNO)
                {
                }
                column(BuyfromVendorNo_PurchInvLine; "Purch. Inv. Line"."Buy-from Vendor No.")
                {
                }
                column(Vendor_Name; Vendor_Name)
                {
                }
                column(DocumentNo_PurchInvLine; "Purch. Inv. Line"."Document No.")
                {
                }
                column(No_PurchInvLine; "Purch. Inv. Line"."No.")
                {
                }
                column(Description_PurchInvLine; "Purch. Inv. Line".Description)
                {
                }
                column(DirectUnitCost_PurchInvLine; "Purch. Inv. Line"."Direct Unit Cost")
                {
                }
                column(Amount_PurchInvLine; "Purch. Inv. Line".Amount)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    PurchInvHeader.Reset;
                    PurchInvHeader.SetRange(PurchInvHeader."No.", "Document No.");
                    if PurchInvHeader.FindFirst then begin
                        Vendor_Name := PurchInvHeader."Buy-from Vendor Name";
                    end;


                    Item.Reset;
                    Item.SetRange(Item."No.", "Purch. Inv. Line"."No.");
                    if Item.FindFirst then begin
                        FG_ITEMNO := Item."FG Item No.";

                    end;
                end;

                trigger OnPreDataItem()
                begin
                    "Purch. Inv. Line".SetFilter("Purch. Inv. Line"."Posting Date", INVDATE);
                end;
            }
            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLink = "No." = FIELD ("FG Item No.");
                DataItemTableView = SORTING ("Document No.", "Line No.") ORDER(Ascending) WHERE (Quantity = FILTER (<> 0), Amount = FILTER (<> 0));
                column(Type_SalesInvoiceLine; "Sales Invoice Line".Type)
                {
                }
                column(CUST_NO; CUST_NO)
                {
                }
                column(DocumentNo_SalesInvoiceLine; "Sales Invoice Line"."Document No.")
                {
                }
                column(No_SalesInvoiceLine; "Sales Invoice Line"."No.")
                {
                }
                column(Description_SalesInvoiceLine; "Sales Invoice Line".Description)
                {
                }
                column(SALES_DOCNO; SALES_DOCNO)
                {
                }
                column(CUST_AMOUNT; CUST_AMOUNT)
                {
                }
                column(CUST_NAME; CUST_NAME)
                {
                }
                column(AllAmount; AllAmount)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    AllAmount := "Sales Invoice Line".Amount;
                    CUST_AMOUNT := 0;
                    CUST_NAME := '';
                    StandardSalesCode.Reset;
                    StandardSalesCode.SetRange(StandardSalesCode.Code, 'BLOCK');
                    if StandardSalesCode.FindFirst then begin
                        GLACCOUNTNO := StandardSalesCode."G/L Account";
                        SalesInvoiceLine.Reset;
                        SalesInvoiceLine.SetRange(SalesInvoiceLine."Document No.", "Document No.");
                        SalesInvoiceLine.SetRange(SalesInvoiceLine."Estimation No.", "Sales Invoice Line"."Estimation No.");
                        SalesInvoiceLine.SetRange(SalesInvoiceLine."No.", GLACCOUNTNO);
                        if SalesInvoiceLine.FindFirst then begin
                            CUST_NO := SalesInvoiceLine."Sell-to Customer No.";
                            Customer.Get("Sales Invoice Line"."Sell-to Customer No.");

                            //CUST_NAME := Customer.Name;
                            repeat
                                CUST_AMOUNT += SalesInvoiceLine.Amount;
                            until SalesInvoiceLine.Next = 0;
                        end;
                    end;
                    //MESSAGE(GLACCOUNTNO);
                    //MESSAGE(FORMAT(CUST_AMOUNT));

                    SalesInvHeader.Reset;
                    SalesInvHeader.SetRange(SalesInvHeader."No.", "Document No.");
                    if SalesInvHeader.FindFirst then
                        CUST_NAME := SalesInvHeader."Bill-to Name";
                end;

                trigger OnPreDataItem()
                begin
                    "Sales Invoice Line".SetFilter("Sales Invoice Line"."Posting Date", INVDATE);
                end;
            }
            dataitem(SalesInvoiceOther; "Sales Invoice Line")
            {
                DataItemLink = "Sell-to Customer No." = FIELD ("Customer No.");
                DataItemTableView = WHERE ("Cross-Reference No." = FILTER (''), Type = FILTER ("G/L Account"), Amount = FILTER (<> 0));
                column(Other_No; SalesInvoiceOther."No.")
                {
                }
                column(Other_Desc; SalesInvoiceOther.Description)
                {
                }
                column(Other_Amount; SalesInvoiceOther.Amount)
                {
                }
                column(Other_Bill_Cust; SalesInvoiceOther."Bill-to Customer No.")
                {
                }
                column(Other_Document; SalesInvoiceOther."Document No.")
                {
                }
                column(Other_CrossRef; SalesInvoiceOther."Cross-Reference No.")
                {
                }
                column(TotalCustAmt; TotalCustAmt)
                {
                }
                column(Type_SalesInvoiceOther; SalesInvoiceOther.Type)
                {
                }
                column(TotalCustAmt1; TotalCustAmtD)
                {
                }
                column(Amount_SalesInvoiceOther; SalesInvoiceOther.Amount)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    TotalCustAmt := 0;
                    /*SalesInvoiceLineOther1.RESET;
                    SalesInvoiceLineOther1.SETRANGE(SalesInvoiceLineOther1."Document No.",SalesInvoiceOther."Document No.");
                    SalesInvoiceLineOther1.SETRANGE(SalesInvoiceLineOther1."Sell-to Customer No.",SalesInvoiceOther."Sell-to Customer No.");
                    SalesInvoiceLineOther1.SETRANGE(SalesInvoiceLineOther1."Estimation No.",SalesInvoiceOther."Estimation No.");
                    SalesInvoiceLineOther1.SETRANGE(SalesInvoiceLineOther1.Type,SalesInvoiceLineOther1.Type::"G/L Account");
                    SalesInvoiceLineOther1.SETFILTER(SalesInvoiceLineOther1."Cross-Reference No.",'');
                    IF SalesInvoiceLineOther1.FINDFIRST THEN
                     BEGIN
                        REPEAT
                        IF SalesInvoiceLineOther1."No."='301105' THEN BEGIN
                    
                            TotalCustAmt:=TotalCustAmt+SalesInvoiceLineOther1.Amount;
                             END ELSE
                            TotalCustAmt:=0;
                    UNTIL SalesInvoiceLineOther1.NEXT=0;
                    END; */


                    SalesInvoiceLineOther1.Reset;
                    SalesInvoiceLineOther1.SetRange(SalesInvoiceLineOther1."Document No.", SalesInvoiceOther."Document No.");
                    SalesInvoiceLineOther1.SetRange(SalesInvoiceLineOther1."Bill-to Customer No.", SalesInvoiceOther."Bill-to Customer No.");
                    SalesInvoiceLineOther1.SetRange(SalesInvoiceLineOther1.Type, SalesInvoiceLineOther1.Type::"G/L Account");
                    SalesInvoiceLineOther1.SetRange(SalesInvoiceLineOther1."No.", '301105');
                    SalesInvoiceLineOther1.SetFilter(SalesInvoiceLineOther1."Cross-Reference No.", '');
                    if SalesInvoiceLineOther1.FindFirst then begin
                        repeat
                            TotalCustAmt += SalesInvoiceLineOther1."Line Amount";

                        until SalesInvoiceLineOther1.Next = 0;
                    end;
                    TotalCustAmtD += TotalCustAmt;

                end;
            }

            trigger OnAfterGetRecord()
            begin
                CUSTFILTER := Item1.GetFilters;

                CompanyInformation.Get;

                SalesInvoiceLine.Reset;
                SalesInvoiceLine.SetRange(SalesInvoiceLine."No.", "FG Item No.");
                if SalesInvoiceLine.FindFirst then begin
                    ITEM_DESC := SalesInvoiceLine.Description;
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
        CompanyInformation: Record "Company Information";
        PurchInvHeader: Record "Purch. Inv. Header";
        Vendor_Name: Text[250];
        INVDATE: Text;
        SalesInvoiceLine: Record "Sales Invoice Line";
        CUST_NO: Code[30];
        CUST_AMOUNT: Decimal;
        Customer: Record Customer;
        CUST_NAME: Text;
        ITEM_DESC: Text[250];
        Item: Record Item;
        SALES_DOCNO: Code[30];
        CUSTFILTER: Text[250];
        StandardSalesCode: Record "Standard Sales Code";
        GLACCOUNTNO: Code[30];
        FG_ITEMNO: Code[30];
        FG_DESC: Text;
        SalesInvHeader: Record "Sales Invoice Header";
        TotalCustAmt: Decimal;
        SalesInvoiceLineOther1: Record "Sales Invoice Line";
        AllAmount: Decimal;
        TotalCustAmtD: Decimal;
}

