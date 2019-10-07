page 50057 "FG ItemQuality Spec Header"
{
    // version Samadhan Quality

    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "Quality Spec Header";
    SourceTableView = SORTING("Spec ID");

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Spec ID";"Spec ID")
                {
                }
                field(Type;Type)
                {

                    trigger OnValidate()
                    begin
                        // lInes added by Deepak KUmar
                        PaperType:=false;
                        if Type=Type::Paper then begin
                          PaperType:=true;
                        end;
                        "Paper Type":='';
                        "Paper GSM":='';
                    end;
                }
                field("Paper Type";"Paper Type")
                {
                    Editable = PaperType;
                }
                field("Paper GSM";"Paper GSM")
                {
                    Editable = PaperType;
                }
                field(Description;Description)
                {
                }
                field("Estimation No.";"Estimation No.")
                {
                }
                field(Status;Status)
                {
                }
                field("Sampling Plan";"Sampling Plan")
                {
                }
                field(Remarks;Remarks)
                {
                }
            }
            part("Specification Lines";"Quality Spec Lines")
            {
                ShowFilter = false;
                SubPageLink = "Spec ID"=FIELD("Spec ID");
                SubPageView = SORTING("Spec ID","Source Type","Character Code")
                              ORDER(Ascending);
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        // lInes added by Deepak KUmar
        PaperType:=false;
        if Type=Type::Paper then begin
          PaperType:=true;
        end;
    end;

    trigger OnOpenPage()
    begin
        // lInes added by Deepak KUmar
        PaperType:=false;
        if Type=Type::Paper then begin
          PaperType:=true;
        end;
    end;

    var
        EstimationHeader: Record "Product Design Header";
        QualityParameters: Record "Quality Parameters";
        QualitySpecLine: Record "Quality Spec Line";
        [InDataSet]
        PaperType: Boolean;
}

