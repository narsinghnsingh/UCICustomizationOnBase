report 50009 GRN
{
    // version Purchase/Sadaf

    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/GRN.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
        dataitem("Company Information"; "Company Information")
        {
            column(Name_CompanyInformation; "Company Information".Name)
            {
            }
            dataitem("Purch. Rcpt. Header"; "Purch. Rcpt. Header")
            {
                DataItemTableView = SORTING ("No.") ORDER(Ascending);
                RequestFilterFields = "No.";
                column(SYSDATE; WorkDate)
                {
                }
                column(BuyfromVendorName_PurchRcptHeader; "Purch. Rcpt. Header"."Buy-from Vendor Name")
                {
                }
                column(BuyfromAddress_PurchRcptHeader; "Purch. Rcpt. Header"."Buy-from Address")
                {
                }
                column(BuyfromAddress2_PurchRcptHeader; "Purch. Rcpt. Header"."Buy-from Address 2")
                {
                }
                column(BuyfromCity_PurchRcptHeader; "Purch. Rcpt. Header"."Buy-from City")
                {
                }
                column(BuyfromPostCode_PurchRcptHeader; "Purch. Rcpt. Header"."Buy-from Post Code")
                {
                }
                column(No_PurchRcptHeader; "Purch. Rcpt. Header"."No.")
                {
                }
                column(PostingDate_PurchRcptHeader; "Purch. Rcpt. Header"."Posting Date")
                {
                }
                column(OrderNo_PurchRcptHeader; "Purch. Rcpt. Header"."Order No.")
                {
                }
                column(OrderDate_PurchRcptHeader; "Purch. Rcpt. Header"."Order Date")
                {
                }
                column(DocumentDate_PurchRcptHeader; "Purch. Rcpt. Header"."Document Date")
                {
                }
                column(VendorShipmentNo_PurchRcptHeader; "Purch. Rcpt. Header"."Vendor Shipment No.")
                {
                }
                column(VendorOrderNo_PurchRcptHeader; "Purch. Rcpt. Header"."Vendor Order No.")
                {
                }
                dataitem("Purch. Rcpt. Line"; "Purch. Rcpt. Line")
                {
                    DataItemLink = "Document No." = FIELD ("No.");
                    DataItemTableView = SORTING ("Document No.", "Line No.") ORDER(Ascending) WHERE (Quantity = FILTER (<> 0));
                    column(No_PurchRcptLine; "Purch. Rcpt. Line"."No.")
                    {
                    }
                    column(Description_PurchRcptLine; "Purch. Rcpt. Line".Description)
                    {
                    }
                    column(Quantity_PurchRcptLine; "Purch. Rcpt. Line".Quantity)
                    {
                    }
                    column(UnitofMeasureCode_PurchRcptLine; "Purch. Rcpt. Line"."Unit of Measure Code")
                    {
                    }
                    column(DirectUnitCost_PurchRcptLine; "Purch. Rcpt. Line"."Direct Unit Cost")
                    {
                    }
                    column(Amt_PurchRcptLine; AMT)
                    {
                    }
                    column(CURRDESC; 'Amount In ' + CURRDESC)
                    {
                    }
                    column(MILL_REELNO; MILL_REELNO)
                    {
                    }
                    column(cnt; cnt)
                    {
                    }
                    column(FSC_Category; "FSC Category")
                    {

                    }


                    trigger OnAfterGetRecord()
                    begin


                        ItemRec.Reset;
                        ItemRec.SetRange(ItemRec."No.", "No.");
                        if ItemRec.FindFirst then begin
                            ItemDesc := ItemRec.Description;
                        end;


                        AMT := "Purch. Rcpt. Line".Quantity * "Purch. Rcpt. Line"."Direct Unit Cost";


                        CURRNCY.Reset;
                        CURRNCY.SetRange(CURRNCY.Code, "Purch. Rcpt. Line"."Currency Code");
                        if CURRNCY.FindFirst then begin
                            CURRDESC := CURRNCY.Code;
                        end else begin
                            CURRDESC := 'DHS';
                        end;

                        MILL_REELNO := '';
                        cnt := 0;
                        ITEM_VARIANT.Reset;
                        ITEM_VARIANT.SetRange(ITEM_VARIANT."Purchase Receipt No.", "Document No.");
                        ITEM_VARIANT.SetRange(ITEM_VARIANT."Item No.", "No.");
                        //ITEM_VARIANT.SETFILTER(ITEM_VARIANT.Status,'Open');
                        if ITEM_VARIANT.FindFirst then begin
                            repeat
                                MILL_REELNO := ITEM_VARIANT."MILL Reel No.";
                                cnt := cnt + 1;


                            until ITEM_VARIANT.Next = 0;
                        end;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    /*ST.RESET;
                    ST.SETRANGE(ST.Code,State);
                    IF ST.FINDFIRST THEN BEGIN
                      STATEDESC := ST.Description;
                    END;
                    */

                end;
            }
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

    trigger OnPreReport()
    begin
        UserSetup.Reset;
        if UserSetup.Get(UserId) then begin
            if not UserSetup."Print Allowed" then begin
                if not CurrReport.Preview then begin
                    Error('These Buttons are Disabled for you, Kindly Contact System Administrator');
                end;
            end;
        end;
    end;

    var
        AMT: Decimal;
        NTWT: Decimal;
        TOTALQTY: Decimal;
        DIFFWT: Decimal;
        ItemRec: Record Item;
        ItemDesc: Text;
        CURRNCY: Record Currency;
        CURRDESC: Text[20];
        ITEM_VARIANT: Record "Item Variant";
        MILL_REELNO: Code[20];
        cnt: Integer;
        TotalCount: Integer;
        UserSetup: Record "User Setup";
}

