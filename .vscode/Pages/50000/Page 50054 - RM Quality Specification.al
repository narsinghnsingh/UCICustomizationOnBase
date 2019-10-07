page 50054 "RM Quality Specification"
{
    // version Samadhan Quality

    PageType = Document;
    UsageCategory = Tasks;
    SourceTable = "Quality Spec Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Spec ID"; "Spec ID")
                {
                }
                field(Description; Description)
                {
                }
                field(Status; Status)
                {
                }
            }
            part("Other Lines"; "Others Quality Spec Lines")
            {
                CaptionML = ENU = 'Other Lines';
                ShowFilter = false;
                SubPageLink = "Spec ID" = FIELD ("Spec ID");
                SubPageView = SORTING ("Spec ID", "Source Type", "Character Code")
                              ORDER(Ascending)
                              WHERE ("Source Type" = FILTER (= Others));
            }
        }
    }

    actions
    {
    }

    var
        EstimationHeader: Record "Product Design Header";
        QualityParameters: Record "Quality Parameters";
        QualitySpecLine: Record "Quality Spec Line";
}

