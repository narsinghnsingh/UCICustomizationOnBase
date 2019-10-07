page 50194 "New Sales Avg Report"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Worksheet;
    UsageCategory = Tasks;
    RefreshOnActivate = true;
    SourceTable = "Salesperson/Purchaser";
    SourceTableView = SORTING (Code)
                      WHERE (Type = CONST ("Sales Person"));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Code)
                {
                }
                field(Name; Name)
                {
                }
                field("Domestic Sales Amount"; "Domestic Sales Amount")
                {
                }
                field("Export Sales Amount"; "Export Sales Amount")
                {
                }
                field("Domestic Sales Weight"; "Domestic Sales Weight")
                {
                }
                field("Domestic Sales Qauntity"; "Domestic Sales Qauntity")
                {
                }
                field("Export Sales Weight"; "Export Sales Weight")
                {
                }
                field("Export Sales Qauntity"; "Export Sales Qauntity")
                {
                }
                field("Domestic Sales Amount All"; "Domestic Sales Amount All")
                {
                }
                field("Export Sales Amount All"; "Export Sales Amount All")
                {
                }
                field("Domestic Sales Weight All"; "Domestic Sales Weight All")
                {
                }
                field("Domestic Sales Qauntity All"; "Domestic Sales Qauntity All")
                {
                }
                field("Export Sales Weight All"; "Export Sales Weight All")
                {
                }
                field("Export Qauntity All"; "Export Qauntity All")
                {
                }
                field("Avg Domestic Sales"; "Avg Domestic Sales")
                {
                    CaptionML = ENU = 'Domestic Sales Avg rate (Wt)';
                }
                field("Avg Export Sales"; "Avg Export Sales")
                {
                    CaptionML = ENU = 'Export Sales Avg rate';
                }
                field("ExportActual Weight"; "ExportActual Weight")
                {
                    CaptionML = ENU = 'Export Actual Weight(Kg)';
                }
                field("Domestic Actual Weight(Kg)"; "Domestic Actual Weight(Kg)")
                {
                }
                field("Domestic Actual Rate(Avg)"; "Domestic Actual Rate(Avg)")
                {
                }

                field("Export Actual Rate(Avg)"; "Export Actual Rate(Avg)")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    var
        DateFilterN: Text;
    begin
        //Lines Added by Frz 14-07-16[Calculate Domestic Value]
        DateFilterN := GetFilter("Date Filter");
        "Total Domestic Actual Weight" := 0;
        DomesticOutPutQty := 0;

        "Total Export Actual Weight" := 0;
        ExportOutPutQty := 0;

        ExportPerunitActualQty := 0;
        "ExportActual Weight" := 0;
        "Export Actual Rate(Avg)" := 0;
        PerUnitActualWeight := 0;
        "Domestic Actual Weight(Kg)" := 0;
        "Domestic Actual Rate(Avg)" := 0;


        SalesinvLineRec.Reset;
        SalesinvLineRec.SetRange(SalesinvLineRec."Salesperson Code", Code);
        SalesinvLineRec.SetFilter(SalesinvLineRec."Posting Date", DateFilterN);
        SalesinvLineRec.SetFilter(SalesinvLineRec.Quantity, '>0');
        if SalesinvLineRec.FindFirst then begin
            repeat
                SalesinvLineRec.CalcFields("Actual Weight");
                SalesinvLineRec.CalcFields("OutPut Qty");

                if (SalesinvLineRec."Gen. Bus. Posting Group" = 'DOMESTIC') then begin
                    "Total Domestic Actual Weight" += SalesinvLineRec."Actual Weight";
                    DomesticOutPutQty += SalesinvLineRec."OutPut Qty";
                end;
                if (SalesinvLineRec."Gen. Bus. Posting Group" = 'EXPORT') then begin
                    "Total Export Actual Weight" := "Total Export Actual Weight" + SalesinvLineRec."Actual Weight";
                    ExportOutPutQty := ExportOutPutQty + SalesinvLineRec."OutPut Qty";
                end;
            until SalesinvLineRec.Next = 0;
        end;

        // Lines added bY Deepak Kumar
        "Avg Domestic Sales" := 0;
        "Avg Export Sales" := 0;
        PerUnitActualWeight := 0;
        "Domestic Actual Weight(Kg)" := 0;


        if ("Domestic Sales Weight" <> 0) and (DomesticOutPutQty <> 0) then begin

            "Avg Domestic Sales" := "Domestic Sales Amount" / "Domestic Sales Weight";
            PerUnitActualWeight := "Total Domestic Actual Weight" / DomesticOutPutQty;
            "Domestic Actual Weight(Kg)" := "Domestic Sales Qauntity" * PerUnitActualWeight;
            "Domestic Actual Rate(Avg)" := "Domestic Sales Amount" / "Domestic Actual Weight(Kg)";

        end else begin
            "Avg Domestic Sales" := 0;//"Domestic Sales Amount"/1;

        end;

        if ("Export Sales Weight" <> 0) and (ExportOutPutQty <> 0) then begin
            "Avg Export Sales" := "Export Sales Amount" / "Export Sales Weight";
            ExportPerunitActualQty := "Total Export Actual Weight" / ExportOutPutQty;
            "ExportActual Weight" := "Export Sales Qauntity" * ExportPerunitActualQty;
            if "ExportActual Weight" > 0 then
                "Export Actual Rate(Avg)" := "Export Sales Amount" / "ExportActual Weight";

        end else begin
            "Avg Export Sales" := 0;//"Export Sales Amount"/1;
        end;
    end;

    var
        "Avg Domestic Sales": Decimal;
        "Avg Export Sales": Decimal;
        DomActualWeight: Decimal;
        "ExportActual Weight": Decimal;
        SalesinvLineRec: Record "Sales Invoice Line";
        ILE: Record "Item Ledger Entry";
        RPONo: Code[20];
        "Total Domestic Actual Weight": Decimal;
        "Total Export Actual Weight": Decimal;
        SalesPersonCode: Code[20];
        ILE1: Record "Item Ledger Entry";
        RPONo1: Code[20];
        SalesinvLineRec1: Record "Sales Invoice Line";
        PerUnitActualWeight: Decimal;
        DomesticOutPutQty: Decimal;
        ExportOutPutQty: Decimal;
        ExportPerunitActualQty: Decimal;
}

