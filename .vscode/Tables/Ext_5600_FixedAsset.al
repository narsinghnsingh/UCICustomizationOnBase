tableextension 50048 Ext_FixedAsset extends "Fixed Asset"
{
    fields
    {
        field(50000; "Plate/Block"; Boolean)
        {
            Description = '//Deepak';
        }
        field(50001; Die; Boolean)
        {
            Description = '//Deepak';
        }
        field(50002; Size; Code[20])
        {
            Description = '//Deepak';
        }
        field(50003; "Customer Item Code"; Code[20])
        {
            Description = '//Deepak';
        }
        field(50004; "Ready to Use"; Boolean)
        {
            Description = '//Deepak';

            trigger OnValidate()
            begin
                // Lines added BY Deepak Kumar
                if "Replace Die/Plate" = true then
                    Error('Replace Plate must be "No" for Die %1', "No.");
            end;
        }
        field(50005; "Replace Die/Plate"; Boolean)
        {
            Description = '//Deepak';

            trigger OnValidate()
            begin
                "Ready to Use" := false;
            end;
        }
        field(50006; "Vendor Die"; Boolean)
        {
            Description = '//Deepak';
        }
        field(50007; "Die/Plate Ready Date"; Boolean)
        {
            Description = '//Deepak';
        }
        field(50008; KLD; Boolean)
        {
            Description = '//Deepak';
        }
        field(50009; "Die/Plate Life"; Decimal)
        {
            Description = '//Deepak';
        }
        field(50010; "Die/Plate Used Life"; Decimal)
        {
            CalcFormula = Sum ("Capacity Ledger Entry"."Output Quantity" WHERE ("Die Number" = FIELD ("No.")));
            Description = '//Deepak';
            FieldClass = FlowField;
        }
        field(50011; "FG Item Number"; Code[20])
        {
            Description = '//Deepak';
            TableRelation = Item."No." WHERE (Blocked = CONST (false));
        }
        field(50012; "Req. For Purchase"; Boolean)
        {
            Description = '//Deepak';

            trigger OnValidate()
            begin
                TestField("Ready to Use", false);
            end;
        }
        field(50013; "Customer's Name"; Text[100])
        {
            Description = '//Deepak';
            Editable = false;
        }
        field(50014; "Curr Prod. Order Desc."; Text[250])
        {
            Description = '//Deepak';
            Editable = false;
        }
        field(50015; "Mother Job Quantity"; Decimal)
        {
            Description = '//Deepak';
            Editable = false;
        }
        field(50016; "Mother Job No."; Code[20])
        {
            Description = '//Deepak';
            Editable = false;
        }
        field(50017; "Negotiated Rate"; Decimal)
        {
            Description = '//Deepak';
        }
        field(50018; "KLD/Plate No."; Integer)
        {
            Description = '//Deepak';
        }
        field(50019; "Customer Code"; Code[20])
        {
            Description = '//Deepak';
            TableRelation = Customer."No." WHERE (Blocked = FILTER (" "));

            trigger OnValidate()
            var
                Customer: Record Customer;
            begin
                // Lines added By Deepak Kumar
                Customer.Reset;
                Customer.SetRange(Customer."No.", "Customer Code");
                if Customer.FindFirst then begin
                    "Customer's Name" := Customer.Name;
                end else begin
                    "Customer's Name" := '';
                end;
            end;
        }
        field(50050; "Die/Plate Ownerhip"; Option)
        {
            Description = '//Deepak';
            OptionCaption = 'UCIL,Customer';
            OptionMembers = UCIL,Customer;
        }
        field(50051; "Estimate No."; Code[20])
        {
            Description = '//sadaf';
            TableRelation = "Product Design Header"."Product Design No.";
        }
    }

}