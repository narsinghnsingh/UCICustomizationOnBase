report 50131 "Update Blocked Date"
{
    Caption = 'Update Blocked Date';
    ProcessingOnly = true;
    UsageCategory = Documents;

    dataset
    {
        dataitem(Employee_B2B; Employee_B2B)
        {
            DataItemTableView = SORTING ("No.") ORDER(Ascending) WHERE (Blocked = CONST (true), "Blocked Date" = FILTER (<> 0D));
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord()
            begin
                if Employee_B2B."Blocked Date" <> 0D then begin
                    Employee_B2B.Validate(Blocked);
                    Employee_B2B.Modify;
                end;
            end;

            trigger OnPostDataItem()
            begin
                Message('DONE');
            end;

            trigger OnPreDataItem()
            begin
                //Employee_B2B.SETRANGE("No.",'EMP1061');
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }
}

