page 50056 "FG Item Quality Specification "
{
    // version Samadhan Quality

    CardPageID = "FG ItemQuality Spec Header";
    Editable = false;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Quality Spec Header";
    SourceTableView = SORTING ("Spec ID");

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Spec ID"; "Spec ID")
                {
                }
                field("Estimation No."; "Estimation No.")
                {
                }
                field(Description; Description)
                {
                }
                field(Status; Status)
                {
                }
                field("Paper Type"; "Paper Type")
                {
                }
                field("Paper GSM"; "Paper GSM")
                {
                }
            }
        }
    }

    actions
    {
    }

    var
        ManSetup: Record "Manufacturing Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
}

