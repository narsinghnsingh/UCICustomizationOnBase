page 50222 "Customer Complain1"
{
    PageType = Card;
    SourceTable = "Issue Log";

    layout
    {
        area(content)
        {
            group("Customer Infomation")
            {
                field("Code"; Code)
                {
                }
                field("Customer Code"; "Customer Code")
                {
                    Editable = IssueStatus;
                }
                field("Customer Name"; "Customer Name")
                {
                    Editable = IssueStatus;
                }
                field("Sales Person Code"; "Sales Person Code")
                {
                    Editable = IssueStatus;
                }
                field(Name; Name)
                {
                    Editable = IssueStatus;
                }
                field("Phone No."; "Phone No.")
                {
                    Editable = IssueStatus;
                    ExtendedDatatype = PhoneNo;
                }
                field("Mobile No."; "Mobile No.")
                {
                    Editable = IssueStatus;
                    ExtendedDatatype = PhoneNo;
                }
                field(Email; Email)
                {
                    Editable = IssueStatus;
                    ExtendedDatatype = EMail;
                }
            }
            group(Detail)
            {
                field(Priority; Priority)
                {
                    Editable = IssueStatus;
                }
                field("Issue Title"; "Issue Title")
                {
                    Editable = IssueStatus;
                }
                field(Description; Description)
                {
                    Editable = IssueStatus;
                    MultiLine = true;
                }
                field("Description 2"; "Description 2")
                {
                    Editable = IssueStatus;
                    MultiLine = true;
                }
                field("Sale Document Type"; "Sale Document Type")
                {
                    Editable = IssueStatus;
                }
                field("Sale Document No."; "Sale Document No.")
                {
                    Editable = IssueStatus;
                }
                field("Communicated to"; "Communicated to")
                {
                    Editable = IssueStatus;
                }
                field("Communicated on"; "Communicated on")
                {
                    Editable = IssueStatus;
                }
                field(Category; Category)
                {
                    Editable = IssueStatus;
                    OptionCaption = ' ,,,,,Need Clarification,Quality,Quantity,Design,Others';
                }
                field(Remarks1; Remarks1)
                {
                    Caption = 'Issue Detail';
                    Editable = IssueStatus;
                    MultiLine = true;
                    ToolTip = 'Only Internal Remarks';
                }
                field(Remarks2; Remarks2)
                {
                    Caption = 'Internal Remarks';
                    Editable = IssueStatus;
                    MultiLine = true;
                }
            }
            group("Resolution ")
            {
                field("Issue Resolution"; "Issue Resolution")
                {
                    Editable = IssueStatus;
                    MultiLine = true;
                }
                field("Resolved by"; "Resolved by")
                {
                    Editable = IssueStatus;
                }
                field("Resolved Date"; "Resolved Date")
                {
                    Editable = IssueStatus;
                }
            }
            group("Additional Details")
            {
                field("Open by"; "Open by")
                {
                }
                field("Open Date"; "Open Date")
                {
                }
                field(Status; Status)
                {
                }
                field(Closed; Closed)
                {
                }
                field("CRM Tracking ID"; "CRM Tracking ID")
                {
                    Editable = IssueStatus;
                }
            }
        }
        area(factboxes)
        {
            part(Control40; "Sales Hist. Sell-to FactBox")
            {
                SubPageLink = "No." = FIELD ("Customer Code");
                Visible = true;
            }
            part(Control39; "Sales Hist. Bill-to FactBox")
            {
                SubPageLink = "No." = FIELD ("Customer Code");
                Visible = false;
            }
            part(Control38; "Customer Statistics FactBox")
            {
                SubPageLink = "No." = FIELD ("Customer Code");
                Visible = true;
            }
            // part(Control37;"Dimensions FactBox")
            // {
            //     SubPageLink = "Table ID"=CONST(18),
            //                   "No."=FIELD("No.");
            //     Visible = false;
            // }
            systempart(Control34; Links)
            {
                Visible = true;
            }
            systempart(Control31; Notes)
            {
                Editable = IssueStatus;
                Visible = true;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Issue Close")
            {
                Caption = 'Issue Close';
                Image = Close;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    // Lines added By Deepak Kumar
                    CloseIssue("Issue Type", "No.");
                end;
            }
            action("Issue Re-Open")
            {
                Caption = 'Issue Re-Open';
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    // Lines added By Deepak Kumar
                    ReOpenIssue("Issue Type", "No.");
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if Status = Status::Open then
            IssueStatus := true
        else
            IssueStatus := false;
    end;

    var
        [InDataSet]
        IssueStatus: Boolean;
}

