page 50081 "Issue Card"
{
    // version Saamdhan Issue List

    PageType = Document;
    SourceTable = "Issue Log";
    SourceTableView = SORTING("Issue Type","No.",Code)
                      ORDER(Ascending)
                      WHERE("Issue Type"=CONST(Internal));

    layout
    {
        area(content)
        {
            group("Issue Card")
            {
                field("Code";Code)
                {
                    Editable = false;
                }
                field("Issue Title";"Issue Title")
                {
                    Editable = IssueActive;
                }
                field(Description;Description)
                {
                    Editable = IssueActive;
                }
                field("Description 2";"Description 2")
                {
                    Editable = IssueActive;
                }
                field("Open by";"Open by")
                {
                }
                field("Open Date";"Open Date")
                {
                }
                field("Communicated to";"Communicated to")
                {
                }
                field("Communicated on";"Communicated on")
                {
                    Editable = IssueActive;
                }
                field(Category;Category)
                {
                    Editable = IssueActive;
                }
                field(Priority;Priority)
                {
                    Editable = IssueActive;
                }
            }
            group("User Contact Information")
            {
                field(Department;Department)
                {
                    Editable = IssueActive;
                }
                field(Name;Name)
                {
                    Editable = IssueActive;
                }
                field("Mobile No.";"Mobile No.")
                {
                    Editable = IssueActive;
                    ExtendedDatatype = PhoneNo;
                }
                field("Phone No.";"Phone No.")
                {
                    Editable = IssueActive;
                }
                field(Email;Email)
                {
                    Editable = IssueActive;
                    ExtendedDatatype = EMail;
                }
                field(Remarks1;Remarks1)
                {
                    CaptionML = ENU = 'Remarks';
                    Editable = IssueActive;
                }
            }
            group("Resolution & Status")
            {
                field(Status;Status)
                {
                    Editable = IssueActive;
                }
                field(Closed;Closed)
                {
                }
                field("CRM Tracking ID";"CRM Tracking ID")
                {
                }
                field(Responsibility;Responsibility)
                {
                    Editable = IssueActive;
                }
                field("Resolution Date";"Resolution Date")
                {
                    Editable = IssueActive;
                }
                field("Issue Resolution";"Issue Resolution")
                {
                    Editable = IssueActive;
                }
                field("Resolved by";"Resolved by")
                {
                    Editable = IssueActive;
                }
                field("Resolved Date";"Resolved Date")
                {
                    Editable = IssueActive;
                }
                field(Remarks2;Remarks2)
                {
                    CaptionML = ENU = 'Remarks';
                }
            }
            group("Supporting Images")
            {
                CaptionML = ENU = 'Supporting Images';
                //The GridLayout property is only supported on controls of type Grid
                //GridLayout = Columns;
                field("Picture 1";"Picture 1")
                {
                    Importance = Additional;
                }
                field("Picture 2";"Picture 2")
                {
                    Importance = Additional;
                }
                field("Picture 3";"Picture 3")
                {
                    Importance = Additional;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Issue Close")
            {
                CaptionML = ENU = 'Issue Close';
                Image = Close;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    // Lines added BY Deepak Kumar
                    CloseIssue("Issue Type","No.");
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if Closed then
          IssueActive:=false
        else
          IssueActive:=true;
    end;

    trigger OnOpenPage()
    begin
           IssueActive:=true;
    end;

    var
        [InDataSet]
        IssueActive: Boolean;
}

