report 50076 "GRV Details"
{
    // version Purchase/Sadaf/Firoz

    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/GRV Details.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Item Variant"; "Item Variant")
        {
            RequestFilterFields = "Purchase Receipt No.";
            column(COMNAME; COMINFO.Name)
            {
            }
            column(SYSDATE; WorkDate)
            {
            }
            column(PurchaseReceiptNo_ItemVariant; "Item Variant"."Purchase Receipt No.")
            {
            }
            column(PaperType_ItemVariant; "Item Variant"."Paper Type")
            {
            }
            column(PaperGSM_ItemVariant; "Item Variant"."Paper GSM")
            {
            }
            column(DeckleSizemm_ItemVariant; "Item Variant"."Deckle Size (mm)")
            {
            }
            column(RollWeight_ItemVariant; "Item Variant"."Roll Weight")
            {
            }
            column(Remarks_ItemVariant; "Item Variant".Remarks)
            {
            }
            column(Description_ItemVariant; "Item Variant".Description)
            {
            }
            column(Suppiler_ItemVariant; "Item Variant".Suppiler)
            {
            }
            column(PurchasePrice_ItemVariant; "Item Variant"."Purchase Price")
            {
            }
            column(CurrentLocation_ItemVariant; "Item Variant".CurrentLocation)
            {
            }
            column(GRVDATE; GRVDATE)
            {
            }
            column(Amount; Amount)
            {
            }
            column(MILLReelNo_ItemVariant; "Item Variant"."MILL Reel No.")
            {
            }
            column(ITEM_DESC; ITEM_DESC)
            {
            }
            column(UOM; UOM)
            {
            }
            column(PRLORIGIN; PRLORIGIN)
            {
            }
            column(PRLMILL; PRLMILL)
            {
            }

            trigger OnAfterGetRecord()
            begin
                COMINFO.Get;


                Amount := "Item Variant"."Roll Weight" * "Item Variant"."Purchase Price";

                PRECL.Reset;
                PRECL.SetRange(PRECL."Document No.", "Purchase Receipt No.");
                PRECL.SetRange(PRECL."No.", "Item No.");
                if PRECL.FindFirst then begin
                    GRVDATE := PRECL."Posting Date";
                    UOM := PRECL."Unit of Measure Code";
                    ITEM_DESC := PRECL.Description;
                    PRLORIGIN := PRECL.ORIGIN;
                    PRLMILL := PRECL.MILL;
                end;


                ITEM.Reset;
                ITEM.SetRange(ITEM."No.", "Item Variant"."Item No.");
                if ITEM.FindFirst then begin
                    ITEM_DESC := ITEM.Description;
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
        RollMaster: Record "Attribute Master";
        Amount: Decimal;
        RollWeight: Decimal;
        COMINFO: Record "Company Information";
        PRECL: Record "Purch. Rcpt. Line";
        GRVDATE: Date;
        ITEM: Record Item;
        ITEM_DESC: Text[250];
        UOM: Code[20];
        PRLORIGIN: Code[20];
        PRLMILL: Code[20];
}

