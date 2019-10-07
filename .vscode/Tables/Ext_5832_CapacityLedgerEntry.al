tableextension 50053 Ext_CapacityLedgerEntry extends "Capacity Ledger Entry"
{
    fields
    {
        field(50000; "Plate Item"; Code[20])
        {
            Description = 'Deepak';
        }
        field(50001; "Item Category Code"; Code[10])
        {
            CalcFormula = Lookup (Item."Item Category Code" WHERE ("No." = FIELD ("Item No.")));
            Description = 'Deepak';
            FieldClass = FlowField;
        }
        field(50002; "Plate Variant"; Code[20])
        {
            Description = 'Deepak';
            TableRelation = "Item Variant".Code WHERE ("Item No." = FIELD ("Plate Item"));
        }
        field(50003; "Work Center Description"; Text[50])
        {
            CalcFormula = Lookup ("Work Center".Name WHERE ("No." = FIELD ("Work Center No.")));
            Description = 'Deepak';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50004; "Item Description"; Text[250])
        {
            CalcFormula = Lookup (Item.Description WHERE ("No." = FIELD ("Item No.")));
            Description = 'Deepak';
            FieldClass = FlowField;
        }
        field(50005; "Estimate No."; Code[20])
        {
            Description = 'Deepak';
        }
        field(50006; "Output Weight (Kg)"; Decimal)
        {
            Description = 'Deepak';
        }
        field(50007; "Plate Item No. 2"; Code[20])
        {
        }
        field(50010; "Die Number"; Code[20])
        {
            Description = 'Deepak';
            TableRelation = "Fixed Asset"."No.";
        }
        field(50011; "Scrap Weight (Kg)"; Decimal)
        {
            Description = 'Deepak';
        }
        field(50017; "Part Code"; Option)
        {
            Description = 'Deepak';
            OptionCaption = ' ,Part-1,Part-2,Part-3,Part-4';
            OptionMembers = " ","Part-1","Part-2","Part-3","Part-4";
        }
        field(50020; "Additional Output"; Boolean)
        {
            Description = 'Deepak';
        }
        field(50021; "Schedule Doc. No."; Code[20])
        {
            TableRelation = "Production Schedule"."Schedule No." WHERE ("Schedule Published" = CONST (true),
                                                                        "Schedule Closed" = CONST (false));
        }
        field(50031; "Subcontracting Order No."; Code[20])
        {
            Description = 'Deepak';
        }
        field(50032; "RPO Status"; Option)
        {
            CalcFormula = Lookup ("Production Order".Status WHERE ("No." = FIELD ("Order No.")));
            FieldClass = FlowField;
            OptionCaption = 'Simulated,Planned,Firm Planned,Released,Finished';
            OptionMembers = Simulated,Planned,"Firm Planned",Released,Finished;
        }
        field(50044; "Plate Variant 2"; Code[20])
        {
        }
        field(50045; "Customer No."; Code[20])
        {
            CalcFormula = Lookup ("Product Design Header".Customer WHERE ("Item Code" = FIELD ("Item No.")));
            FieldClass = FlowField;
            TableRelation = Customer."No.";
        }
        field(60004; "Start Date"; Date)
        {
            Description = 'Deepak';
        }
        field(60005; "End Date"; Date)
        {
            Description = 'Deepak';
        }
        field(62001; "Employee Code"; Code[20])
        {
            Description = 'Deepak';
        }
        field(62002; "Employee Name"; Text[150])
        {
            Description = 'Deepak';
            Editable = false;
        }

    }
    // keys
    // {
    //     key(Key6; "Work Center No.", Type, "Machine Id")
    //     {
    //         SumIndexFields = "Run Time";
    //     }
    // }
}