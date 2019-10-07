report 50005 Label
{
    // version Purchase/Sadaf

    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/Label.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Item Variant"; "Item Variant")
        {
            DataItemTableView = SORTING ("Item No.", Code);
            RequestFilterFields = "Code";
            column(Pic; CompanyInfo.Picture)
            {
            }
            column(Code_ItemVariant; "Item Variant".Code)
            {
            }
            column(DocumentNo_ItemVariant; "Item Variant"."Document No.")
            {
            }
            column(ItemNo_ItemVariant; "Item Variant"."Item No.")
            {
            }
            column(RollWeight_ItemVariant; "Item Variant"."Roll Weight")
            {
            }
            column(MILLReelNo_ItemVariant; "Item Variant"."MILL Reel No.")
            {
            }
            column(Remarks_ItemVariant; "Item Variant".Remarks)
            {
            }
            column(Status_ItemVariant; "Item Variant".Status)
            {
            }
            column(GRVDate; GRVDate)
            {
            }
            column(PaperType_GSM; PaperType + Format(GSM))
            {
            }
            column(DSIZE; DSIZE)
            {
            }
            column(PaperType; PaperType)
            {
            }
            column(VendName; VendName)
            {
            }
            column(CompName; CompName)
            {
            }
            column(MillName_ItemVariant; "Item Variant"."Mill Name")
            {
            }
            column(RemainingQuantity_ItemVariant; "Item Variant"."Remaining Quantity")
            {
            }
            column(FSCCategory; FSCCategory)
            {
            }

            trigger OnAfterGetRecord()
            begin
                CompanyInfo.CalcFields(CompanyInfo.Picture);
                CompanyInfo.Get;
                CompName := CompanyInfo.Name;
                ITEM.Reset;
                ITEM.SetRange(ITEM."No.", "Item No.");
                if ITEM.FindFirst then begin
                    GSM := ITEM."Paper GSM";
                    BF := ITEM."Bursting factor(BF)";
                    DSIZE := ITEM."Deckle Size (mm)";
                    PaperType := ITEM."Paper Type";
                    FSCCategory := ITEM."FSC Category";
                end else begin
                    GSM := 0;
                    BF := 0;
                    DSIZE := 0;
                    PaperType := '';
                end;

                PurchReceiptHeader.Reset;
                PurchReceiptHeader.SetRange(PurchReceiptHeader."No.", "Purchase Receipt No.");
                if PurchReceiptHeader.FindFirst then begin
                    GRVDate := PurchReceiptHeader."Posting Date";
                    VendName := PurchReceiptHeader."Buy-from Vendor Name";
                    // MESSAGE(VendName);
                end;
                //GRVDate:=0D;
                //VendName:='';
                //MESSAGE(VendName);
            end;

            trigger OnPreDataItem()
            begin
                GSM := 0;
                BF := 0;
                DSIZE := 0;
                PaperType := '';
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
        ITEM: Record Item;
        GSM: Decimal;
        BF: Decimal;
        DSIZE: Decimal;
        PaperType: Code[30];
        PurchReceiptHeader: Record "Purch. Rcpt. Header";
        GRVDate: Date;
        VendName: Text[100];
        PurchReceiptLine: Record "Purch. Rcpt. Line";
        Vend: Record Vendor;
        CompanyInfo: Record "Company Information";
        CompName: Text[100];
        FSCCategory: Text[100];
}

