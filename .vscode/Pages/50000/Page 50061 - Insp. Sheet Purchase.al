page 50061 "Insp. Sheet Purchase"
{
    // version Samadhan Quality

    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = CardPart;
    RefreshOnActivate = true;
    SaveValues = true;
    SourceTable = "Inspection Sheet";
    SourceTableView = SORTING("Sample Code","QA Characteristic Code")
                      ORDER(Ascending)
                      WHERE("Source Type"=FILTER(="Purchase Receipt"));

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Sample Code";"Sample Code")
                {
                }
                field("QA Characteristic Code";"QA Characteristic Code")
                {
                }
                field("QA Characteristic Description";"QA Characteristic Description")
                {
                }
                field("Roll Number";"Roll Number")
                {
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                }
                field("Normal Value (Num)";"Normal Value (Num)")
                {
                }
                field("Min. Value (Num)";"Min. Value (Num)")
                {
                }
                field("Max. Value (Num)";"Max. Value (Num)")
                {
                }
                field("Actual Value (Num)";"Actual Value (Num)")
                {
                    Editable = Quantitative;
                }
                field("Normal Value (Text)";"Normal Value (Text)")
                {
                    Editable = Qualitative;
                }
                field("Min. Value (Text)";"Min. Value (Text)")
                {
                    Editable = Qualitative;
                }
                field("Max. Value (Text)";"Max. Value (Text)")
                {
                    Editable = Qualitative;
                }
                field("Actual  Value (Text)";"Actual  Value (Text)")
                {
                    Editable = Qualitative;
                }
                field(Quantitative;Quantitative)
                {
                }
                field(Qualitative;Qualitative)
                {
                }
                field("Observation 1 (Num)";"Observation 1 (Num)")
                {
                }
                field("Observation 2 (Num)";"Observation 2 (Num)")
                {
                }
                field("Observation 3 (Num)";"Observation 3 (Num)")
                {
                }
                field("Observation 4 (Num)";"Observation 4 (Num)")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        //Pulak 12-06-13

        if Qualitative then
          QualitativeSpecification:=true
        else
          QualitativeSpecification:=false;
    end;

    var
        ReceiptNo: Code[20];
        PurchaseLineNumber: Code[10];
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        Item: Record Item;
        QualityParameters: Record "Quality Parameters";
        InspectionSheet: Record "Inspection Sheet";
        ItemNo: Code[10];
        Qualitative: Boolean;
        RollMaster: Record "Attribute Master";
        QualitySpecLine: Record "Quality Spec Line";
        OldInspectionSheet: Record "Inspection Sheet";
        LastEntryNo: Integer;
        NoofSamples: Integer;
        SamplePlanID: Text[100];
        QualitySpecHeader: Record "Quality Spec Header";
        ReceiptLineNo: Text;
        [InDataSet]
        QualitativeSpecification: Boolean;
}

