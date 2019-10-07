page 50177 "HR Module"
{
    PageType = Card;
    SourceTable = "HR Setup";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Primary Key"; "Primary Key")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(ActionGroup5)
            {
                Caption = 'Salary';
                group(ActionGroup65)
                {
                    Caption = 'Salary';
                    Image = Balance;
                    action("Posted Salary List")
                    {
                        Image = PostedPayment;
                        RunObject = Page "Posted Salary List";
                    }
                    action("Employee Details_Mon. Attend.")
                    {
                        RunObject = Page "Employee Details_Mon. Attend.";
                    }
                    action("Other PayElements")
                    {
                        Image = ViewPostedOrder;
                        RunObject = Page "Other PayElements";
                    }
                    action("Bonus List")
                    {
                        RunObject = Page "Bonus List";
                    }
                    action("Bonus/Exgratia Adjustment")
                    {
                        RunObject = Page "Bonus/Exgratia Adjustment";
                    }
                    action(Bonus)
                    {
                        RunObject = Page Bonus;
                    }
                    action("Employee Details_Proc. Salary")
                    {
                        RunObject = Page "Employee Details_Proc. Salary";
                    }
                    action("Pay Salary")
                    {
                        RunObject = Page "Pay Elements";
                    }
                }
            }
            group(ActionGroup66)
            {
                group(Attendance)
                {
                    Caption = 'Attendance';
                    action("Daily Attendance")
                    {
                        Image = ViewPostedOrder;
                        RunObject = Page "Daily Attendance";
                    }
                    action("Daily Attendance List")
                    {
                        RunObject = Page "Daily Attendance List";
                    }
                    action("Monthly Attendance")
                    {
                        RunObject = Page "Monthly Attendance";
                    }
                    action("Monthly Attendance List")
                    {
                        RunObject = Page "Monthly Attendance List";
                    }
                    action("Attendance Lines")
                    {
                        RunObject = Page "Attendance Lines";
                    }
                }
            }
            group(ActionGroup67)
            {
                group(Leave)
                {
                    Caption = 'Leave';
                    Image = Holiday;
                    action("Leave Master")
                    {
                        Image = SelectChart;
                        RunObject = Page "Leave Master";
                    }
                    action("Leave List")
                    {
                        Image = SelectChart;
                        RunObject = Page "Leave List";
                    }
                    action("Leave Entitlement")
                    {
                        Image = SelectChart;
                        RunObject = Page "Leave Entitlement";
                    }
                    action("Leave Entitlement List")
                    {
                        Image = SelectChart;
                        RunObject = Page "Leave Entitlement List";
                    }
                    action("Leave Application - Sanc.")
                    {
                        Image = SelectChart;
                        RunObject = Page "Leave Application - Sanc.";
                    }
                    action("Leave Application List OLD")
                    {
                        Image = SelectChart;
                        RunObject = Page "Leave Application List OLD";
                    }
                    action("Leave Encashment")
                    {
                        Image = SelectChart;
                        RunObject = Page "Leave Encashment";
                    }
                    action("Leave Encashment Subform")
                    {
                        RunObject = Page "Leave Encashment Subform";
                    }
                    action("Grade Wise Leaves")
                    {
                        RunObject = Page "Payroll General Posting Group";
                    }
                    action("Employee Leaves List")
                    {
                        RunObject = Page "Employee Leaves List";
                    }
                    action("Employee Leaves History List")
                    {
                        RunObject = Page "Employee Leaves History List";
                    }
                    action("Temp Employee Leaves List")
                    {
                        Image = ViewComments;
                        RunObject = Page "Temp Employee Leaves List";
                    }
                    separator(Separator68)
                    {
                    }
                    action("Leave Journal")
                    {
                        RunObject = Page "Leave Journal";
                    }
                    action("Leaves Applied")
                    {
                        Image = Task;
                        RunObject = Page "Leaves Applied";
                    }
                    action("Leave Application")
                    {
                        RunObject = Page "Leave Application";
                    }
                    action("Leave Application List")
                    {
                        RunObject = Page "Leave Application List";
                    }
                    action("Leave Approvals")
                    {
                        RunObject = Page "Leave Approvals";
                    }
                    action(Holidays)
                    {
                        Image = Holiday;
                        RunObject = Page Holidays;
                    }
                    action("Leave Correction")
                    {
                        RunObject = Page "Leave Correction";
                    }
                    action("Leave Plan")
                    {
                        RunObject = Page "Leave Plan";
                    }
                    action("Posted Leave Plan")
                    {
                        RunObject = Page "Posted Leave Plan";
                    }
                    action("Provisional Leaves")
                    {
                        RunObject = Page "Provisional Leaves";
                    }
                    action("Employee Provisional Leaves")
                    {
                        RunObject = Page "Employee Provisional Leaves";
                    }
                    action("Posted Leaves")
                    {
                        Image = ViewPostedOrder;
                        RunObject = Page "Posted Leaves";
                    }
                    action("Cadre Wise Leaves")
                    {
                        Image = Default;
                        RunObject = Page "Cadre Wise Leaves";
                    }
                    action("Leave Opening Balance")
                    {
                        RunObject = Page "Leave Opening Balance";
                    }
                    action("Leave Cancellation Request")
                    {
                        Image = Cancel;
                        RunObject = Page "Leave Cancellation Request";
                    }
                    action("Shiftwise Offdays")
                    {
                        Image = Segment;
                        RunObject = Page "Shiftwise Offdays";
                    }
                }
            }
            group(ActionGroup69)
            {
                group(Employee)
                {
                    Caption = 'Employee';
                    Image = Users;
                    action("Employee Card")
                    {
                        Image = Employee;
                        RunObject = Page "Employee Card";
                    }
                    action("Employment Contracts")
                    {
                        Caption = '`';
                        Image = EmployeeAgreement;
                        RunObject = Page "Employment Contracts";
                    }
                    action("Employee List_B2B")
                    {
                        Image = Employee;
                        RunObject = Page "Employee List_B2B";
                    }
                    action("Misc. Articles")
                    {
                        Image = Aging;
                        RunObject = Page "Misc. Articles";
                    }
                    action("Misc. Article Information")
                    {
                        Image = Info;
                        RunObject = Page "Misc. Article Information";
                    }
                    action(Confidential)
                    {
                        Image = Questionaire;
                        RunObject = Page Confidential;
                    }
                    action("Employee Relatives")
                    {
                        RunObject = Page "Employee Relatives";
                    }
                    action("Alternative Address Card")
                    {
                        Image = Addresses;
                        RunObject = Page "Alternative Address Card";
                    }
                    action("Alternative Address List")
                    {
                        Image = AlternativeAddress;
                        RunObject = Page "Alternative Address List";
                    }
                }
                group("Posting Group")
                {
                    Caption = 'Posting Group';
                    Image = Capacity;
                    action("Payroll Business Posting Group")
                    {
                        RunObject = Page "Payroll Business Posting Group";
                    }
                    action("Payroll Product Posting Group")
                    {
                        RunObject = Page "Payroll Product Posting Group";
                    }
                    action("Payroll General Posting Group")
                    {
                        RunObject = Page "Payroll General Posting Group";
                    }
                    action("Employee Posting Group")
                    {
                        Image = SetupList;
                        RunObject = Page "Employee Posting Group B2B";
                    }
                    action("Loan Posting Setup")
                    {
                        Caption = '1';
                        Image = Loaner;
                        RunObject = Page "Loan Posting Setup";
                    }
                }
            }
        }
    }
}

