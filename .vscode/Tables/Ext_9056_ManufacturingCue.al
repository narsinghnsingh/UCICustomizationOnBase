tableextension 50057 Ext_ManufacturingCue extends "Manufacturing Cue"
{
    fields
    {
        field(50001; "New Production Orders"; Integer)
        {
            CalcFormula = Count ("Production Order" WHERE ("Prod Status" = CONST (New)));
            FieldClass = FlowField;
        }
        field(50002; "Finished Production Order"; Integer)
        {
            CalcFormula = Count ("Production Order" WHERE (Status = CONST (Finished)));
            FieldClass = FlowField;
        }

        field(50003; "Open Product Designs"; Integer)
        {
            CalcFormula = count ("Product Design Header" where (Status = const (Open)));
            FieldClass = FlowField;
        }
        field(50004; "Approved Product Designs"; Integer)
        {
            CalcFormula = count ("Product Design Header" where (Status = const (Approved)));
            FieldClass = FlowField;
        }
        field(50005; "Blocked Product Designs"; Integer)
        {
            CalcFormula = count ("Product Design Header" where (Status = const (Blocked)));
            FieldClass = FlowField;
        }

    }

}