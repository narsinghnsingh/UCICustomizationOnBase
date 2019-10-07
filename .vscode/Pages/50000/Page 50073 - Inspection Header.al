page 50073 "Inspection Header"
{
    // version Samadhan Quality

    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "Inspection Header";
    SourceTableView = SORTING("No.")
                      ORDER(Ascending)
                      WHERE(Posted=CONST(false));

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No.";"No.")
                {
                }
                field("Inspection Type";"Inspection Type")
                {

                    trigger OnValidate()
                    begin
                        FeildEditbale;
                    end;
                }
                field("Job No.";"Job No.")
                {
                    Editable = ByProduction;
                    Enabled = ByProduction;
                }
                field("Job Line No.";"Job Line No.")
                {
                    Editable = ByProduction;
                    Enabled = ByProduction;
                }
                field("Paper Type";"Paper Type")
                {
                    Editable = BySamplePaper;
                    Enabled = BySamplePaper;
                }
                field("Paper GSM";"Paper GSM")
                {
                    Editable = BySamplePaper;
                    Enabled = BySamplePaper;
                }
                field("Item No.";"Item No.")
                {
                    Editable = BYItem;
                    Enabled = BYItem;
                }
                field("Item Description";"Item Description")
                {
                    Editable = BYItem;
                }
                field(Remarks;Remarks)
                {
                }
                field("Specification ID";"Specification ID")
                {
                    Editable = false;
                }
            }
            part("Inspection Line";"Inspection Line")
            {
                CaptionML = ENU = 'Inspection Line';
                SubPageLink = "Source Type"=FIELD("Source Type"),
                              "Inspection No."=FIELD("No.");
            }
            group(Control14)
            {
                ShowCaption = false;
                field("Vendor No.";"Vendor No.")
                {
                    Editable = BySamplePaper;
                    Enabled = BySamplePaper;
                }
                field("Vendor Name";"Vendor Name")
                {
                    Editable = BySamplePaper;
                    Enabled = BySamplePaper;
                }
                field(Sample;Sample)
                {
                    Editable = BySamplePaper;
                    Enabled = BySamplePaper;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Sample Remarks";"Sample Remarks")
                {
                    Editable = BySamplePaper;
                    Enabled = BySamplePaper;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Get Inspection Line")
            {
                CaptionML = ENU = 'Get Inspection Line';
                Image = Answers;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    // Lines added by Deepak Kumar
                    GenerateSpecLine("No.");
                end;
            }
            action("Post Inspection Sheet")
            {
                CaptionML = ENU = 'Post Inspection Sheet';
                Image = Confirm;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    // Lines added by Deepak Kumar
                    PostOutputInspection("No.");
                    CurrPage.Close;
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        //Deepak
        FeildEditbale;
    end;

    trigger OnAfterGetRecord()
    begin
        //Deepak
        FeildEditbale;
    end;

    trigger OnOpenPage()
    begin
        //Deepak
        FeildEditbale;
    end;

    var
        InspectionSheet: Record "Inspection Header";
        [InDataSet]
        ByProduction: Boolean;
        [InDataSet]
        BySamplePaper: Boolean;
        [InDataSet]
        BYItem: Boolean;

    procedure FeildEditbale()
    begin
        case "Inspection Type" of
          "Inspection Type"::Production:
            begin
              ByProduction:=true;
              BySamplePaper:=false;
              BYItem:=false;
            end;
          "Inspection Type"::"Sample Paper":
            begin
              ByProduction:=false;
              BySamplePaper:=true;
              BYItem:=false;

            end;
          "Inspection Type"::Item:
            begin
              ByProduction:=false;
              BySamplePaper:=false;
              BYItem:=true;
            end;
         end;
    end;
}

