report 50020 "Purchase Register"
{
    // version Purchase/Sadaf

    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/Purchase Register.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
        dataitem("Purch. Inv. Header"; "Purch. Inv. Header")
        {
            DataItemTableView = SORTING ("No.") ORDER(Ascending);
            RequestFilterFields = "Posting Date";
            column(COMPNAME; COMPNAME)
            {
            }
            column(COMADD; COMADD + ',' + COMADD1)
            {
            }
            column(COMCITY; COMCITY + ' - ' + COMPCODE)
            {
            }
            column(PostingDate_PurchInvHeader; "Purch. Inv. Header"."Posting Date")
            {
            }
            column(BuyfromVendorName_PurchInvHeader; "Purch. Inv. Header"."Buy-from Vendor Name")
            {
            }
            column(InvDate; 'Date' + ' ' + InvDate)
            {
            }
            column(VendorInvoiceNo_PurchInvHeader; "Purch. Inv. Header"."Vendor Invoice No.")
            {
            }
            column(SLNO; SLNO)
            {
            }
            column(WORKDATE; WorkDate)
            {
            }
            dataitem("Purch. Inv. Line"; "Purch. Inv. Line")
            {
                DataItemLink = "Document No." = FIELD ("No.");
                DataItemTableView = SORTING ("Document No.", "Line No.") ORDER(Ascending) WHERE (Type = FILTER (Item), Quantity = FILTER (<> 0));
                column(PostingDate_PurchInvLine; "Purch. Inv. Line"."Posting Date")
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
                column(Quantity_PurchInvLine; "Purch. Inv. Line".Quantity)
                {
                }
                column(UnitofMeasureCode_PurchInvLine; "Purch. Inv. Line"."Unit of Measure Code")
                {
                }
                column(UnitCostLCY_PurchInvLine; "Purch. Inv. Line"."Unit Cost (LCY)")
                {
                }
                column(LineAmount_PurchInvLine; "Purch. Inv. Line"."Line Amount")
                {
                }
                column(cnt1; cnt1)
                {
                }
                column(DirectUnitCost_PurchInvLine; "Purch. Inv. Line"."Direct Unit Cost")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    MILL_REELNO := '';
                    cnt1 := 0;
                    ITEM_VARIANT.Reset;
                    ITEM_VARIANT.SetRange(ITEM_VARIANT."Purchase Receipt No.", "Receipt No.");
                    ITEM_VARIANT.SetRange(ITEM_VARIANT."Item No.", "No.");
                    ITEM_VARIANT.SetFilter(ITEM_VARIANT.Status, 'Open');
                    if ITEM_VARIANT.FindFirst then begin
                        repeat
                            MILL_REELNO := ITEM_VARIANT."MILL Reel No.";
                            cnt1 := cnt1 + 1;
                        until ITEM_VARIANT.Next = 0;
                    end;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                COMINFO.Get;
                COMPNAME := COMINFO.Name;
                COMADD := COMINFO.Address;
                COMADD1 := COMINFO."Address 2";
                COMCITY := COMINFO.City;
                COMPCODE := COMINFO."Post Code";
                SLNO := SLNO + 1;
            end;

            trigger OnPreDataItem()
            begin
                InvDate := "Purch. Inv. Header".GetFilter("Purch. Inv. Header"."Posting Date");
            end;
        }
        dataitem("Purch. Cr. Memo Hdr."; "Purch. Cr. Memo Hdr.")
        {
            DataItemTableView = SORTING ("Vendor Cr. Memo No.", "Posting Date") ORDER(Ascending);
            RequestFilterFields = "Posting Date";
            column(SLNO1; SLNO1)
            {
            }
            column(PostingDate_PurchCrMemoHdr; "Purch. Cr. Memo Hdr."."Posting Date")
            {
            }
            column(BuyfromVendorName_PurchCrMemoHdr; "Purch. Cr. Memo Hdr."."Buy-from Vendor Name")
            {
            }
            column(CreditDate; 'Date' + ' ' + CreditDate)
            {
            }
            column(AppliestoDocNo_PurchCrMemoHdr; "Purch. Cr. Memo Hdr."."Applies-to Doc. No.")
            {
            }
            column(BuyfromVendorNo_PurchCrMemoHdr; "Purch. Cr. Memo Hdr."."Buy-from Vendor No.")
            {
            }
            dataitem("Purch. Cr. Memo Line"; "Purch. Cr. Memo Line")
            {
                DataItemLink = "Document No." = FIELD ("No.");
                DataItemTableView = SORTING ("Document No.", "Line No.") ORDER(Ascending) WHERE (Type = FILTER (Item), Quantity = FILTER (<> 0));
                column(DocumentNo_PurchCrMemoLine; "Purch. Cr. Memo Line"."Document No.")
                {
                }
                column(PostingDate_PurchCrMemoLine; "Purch. Cr. Memo Line"."Posting Date")
                {
                }
                column(No_PurchCrMemoLine; "Purch. Cr. Memo Line"."No.")
                {
                }
                column(Description_PurchCrMemoLine; "Purch. Cr. Memo Line".Description)
                {
                }
                column(UnitofMeasureCode_PurchCrMemoLine; "Purch. Cr. Memo Line"."Unit of Measure Code")
                {
                }
                column(Quantity_PurchCrMemoLine; "Purch. Cr. Memo Line".Quantity)
                {
                }
                column(UnitCostLCY_PurchCrMemoLine; "Purch. Cr. Memo Line"."Unit Cost (LCY)")
                {
                }
                column(DirectUnitCost_PurchCrMemoLine; "Purch. Cr. Memo Line"."Direct Unit Cost")
                {
                }
                column(LineAmount_PurchCrMemoLine; "Purch. Cr. Memo Line"."Line Amount")
                {
                }

                trigger OnPreDataItem()
                begin
                    "Purch. Cr. Memo Hdr.".SetFilter("Purch. Cr. Memo Hdr."."Posting Date", InvDate);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                PUCINVMEMO.Reset;
                PUCINVMEMO.SetRange(PUCINVMEMO."Document No.", "No.");
                PUCINVMEMO.SetFilter(PUCINVMEMO.Type, 'Item');
                if PUCINVMEMO.FindFirst then begin
                    SLNO1 := SLNO1 + 1;
                end;
            end;

            trigger OnPostDataItem()
            begin
                "Purch. Cr. Memo Hdr.".SetFilter("Purch. Cr. Memo Hdr."."Posting Date", InvDate);
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
        COMPNAME: Text[100];
        COMADD: Text[100];
        COMADD1: Text[100];
        COMCITY: Text[100];
        COMPCODE: Text[50];
        SLNO: Decimal;
        SLNO1: Decimal;
        InvDate: Text[100];
        CreditDate: Text[100];
        STATDESC: Text[100];
        QTY: Decimal;
        LINEAMT: Decimal;
        PUCINVLINE: Record "Purch. Inv. Line";
        PUCINVMEMO: Record "Purch. Cr. Memo Line";
        CNT: Integer;
        MILL_REELNO: Code[20];
        ITEM_VARIANT: Record "Item Variant";
        cnt1: Integer;
        UCOST: Decimal;
}

