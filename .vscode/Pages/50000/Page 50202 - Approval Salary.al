page 50202 "Approval Salary"
{
    // version SAP1.0

    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Monthly Attendance";
    SourceTableView = WHERE (Blocked = FILTER (false));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Employee No."; "Employee No.")
                {
                    CaptionML = ENU = 'Employee No.';
                    Editable = false;
                }
                field("Employee Name"; "Employee Name")
                {
                    Editable = false;
                }
                field("Pay Slip Month"; "Pay Slip Month")
                {
                    Editable = false;
                }
                field(Days; Days)
                {
                    Editable = false;
                }
                field("Weekly Off"; "Weekly Off")
                {
                    Editable = false;
                }
                field(Holidays; Holidays)
                {
                    Editable = false;
                }
                field("Over Time Hrs."; "Over Time Hrs.")
                {
                }
                field("Non-Working Over Time Hrs"; "Non-Working Over Time Hrs")
                {
                }
                field("Holiday Over Time Hrs"; "Holiday Over Time Hrs")
                {
                }
                field("Comp. Off Hours"; "Comp. Off Hours")
                {
                }
                field("Late Hours"; "Late Hours")
                {
                    Editable = false;
                    Visible = true;
                }
                field(Attendance; Attendance)
                {
                    Editable = false;
                }
                field(Leaves; Leaves)
                {
                    Editable = false;
                }
                field("Loss Of Pay"; "Loss Of Pay")
                {
                    Editable = false;
                }
                field(Processed; Processed)
                {
                    Editable = false;
                }
                field(Posted; Posted)
                {
                    Editable = false;
                }
                field("Gross Salary"; "Gross Salary")
                {
                    Editable = false;
                }
                field("Food Allowance"; "Food Allowance")
                {
                }
                field("Computed Gross Salary"; "Computed Gross Salary")
                {
                    Editable = false;
                    Visible = false;
                }
                field(Deductions; Deductions)
                {
                    Editable = false;
                }
                field("Net Salary"; "Net Salary")
                {
                    Editable = false;
                }
                field("Rounding Amount"; "Rounding Amount")
                {
                    Editable = false;
                }
                field("Process Status"; "Process Status")
                {
                    Editable = false;
                }
                field("Payment Status"; "Payment Status")
                {
                }
                field(Comments; Comments)
                {
                    Visible = CooomentsVisible;
                }
                field("Payment Comments"; "Payment Comments")
                {
                    Visible = Posted;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        CooomentsVisible := not Posted;
    end;

    var
        CooomentsVisible: Boolean;
}

