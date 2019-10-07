page 50062 "Quality Setup"
{
    // version Samadhan Quality

    CaptionML = ENU = 'Quality Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    UsageCategory = Administration;
    SourceTable = "Manufacturing Setup";

    layout
    {
        area(content)
        {
            group(General)
            {
                CaptionML = ENU = 'General';
                field("Rejection Location"; "Rejection Location")
                {
                }
                field("Quality Inspection Location"; "Quality Inspection Location")
                {
                }
            }
            group(Numbering)
            {
                CaptionML = ENU = 'Numbering';
                field("Inspection No. Series"; "Inspection No. Series")
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Reset;
        if not Get then begin
            Init;
            Insert;
        end;
    end;
}

