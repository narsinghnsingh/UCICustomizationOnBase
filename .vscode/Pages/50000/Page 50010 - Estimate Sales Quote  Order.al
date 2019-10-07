page 50010 "Estimate Sales Quote / Order"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Worksheet;
    UsageCategory = Tasks;
    SourceTable = "Product Design Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Editable = false;
                field("Product Design No."; "Product Design No.")
                {
                    Editable = false;
                }
                field("Sales Person Code"; "Sales Person Code")
                {
                }
            }
            group(Control13)
            {
                ShowCaption = false;
                part("Sales Quote"; "Eastimate Sales Line Details")
                {
                    CaptionML = ENU = 'Sales Quote';
                    SubPageLink = "Document Type" = CONST (Quote),
                                  "Estimation No." = FIELD ("Product Design No.");
                    SubPageView = SORTING ("Document Type", "Document No.", "Line No.")
                                  ORDER(Ascending);
                }
                part("Sales Order"; "Eastimate Sales Line Details")
                {
                    CaptionML = ENU = 'Sales Order';
                    SubPageLink = "Document Type" = CONST (Order),
                                  "Estimation No." = FIELD ("Product Design No.");
                    SubPageView = SORTING ("Document Type", "Document No.", "Line No.")
                                  ORDER(Ascending);
                }
            }
        }
    }

    actions
    {
    }
}

