table 50008 "Attribute Value"
{
    // version Item Wizard Samadhan

    DrillDownPageID = "Item Attribute Value";
    LookupPageID = "Item Attribute Value";

    fields
    {
        field(1; "Attribute Code"; Code[20])
        {
            TableRelation = "Attribute Master"."Attribute Code" WHERE (Master = CONST (false));

            trigger OnValidate()
            var
                ItemAttribute: Record "M/W Price List";
                ItemAttributeEntry: Record "Product Design Component Table";
            begin
            end;
        }
        field(2; "Attribute Value"; Code[150])
        {
            InitValue = 'NULL';

            trigger OnValidate()
            var
                AttributeSam: Record "Attribute Master";
            begin
                // Lines added by deepak kumar

                ItemAttribute.Reset;
                ItemAttribute.SetFilter(ItemAttribute."Attribute Code", "Attribute Code");
                if ItemAttribute.FindFirst then begin
                    "Attribute UID" := ItemAttribute."Attribute UID";
                end;
                Commit;
            end;
        }
        field(3; "Attribute Description"; Text[100])
        {
            CalcFormula = Lookup ("Attribute Master"."Attribute Description" WHERE ("Attribute Code" = FIELD ("Attribute Code")));
            FieldClass = FlowField;
        }
        field(4; "Attribute UID"; Integer)
        {
            Editable = false;
        }
        field(5; "Attribute Value UID"; Integer)
        {
            AutoIncrement = true;
            Editable = false;
        }
        field(8; "Created by"; Code[30])
        {
            Editable = false;
        }
        field(9; "Creation Date and Time"; DateTime)
        {
            Editable = false;
        }
        field(10; "Modified By"; Code[30])
        {
            Editable = false;
        }
        field(11; "Modification Date and Time"; DateTime)
        {
            Editable = false;
        }
        field(12; "Field Type"; Option)
        {
            OptionCaption = 'Text ,Numeric ';
            OptionMembers = "Text ","Numeric ";
        }
        field(13; "Attribute Value Numreric"; Decimal)
        {
            Editable = true;

            trigger OnValidate()
            var
                AttributeSam: Record "M/W Price List";
            begin
                // Lines added by deepak kumar

                Validate("Attribute Value", Format("Attribute Value Numreric", 12, '<Integer><Decimals><Sign,1>'));
            end;
        }
        field(14; "Attribute Value Description"; Text[100])
        {
            DataClassification = ToBeClassified;

        }
    }

    keys
    {
        key(Key1; "Attribute Code", "Attribute Value", "Field Type")
        {
        }
        key(Key2; "Attribute Code", "Field Type")
        {
        }
        key(Key3; "Attribute Value")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Attribute Value")
        {
        }
    }

    trigger OnInsert()
    begin
        // Lines added By Deepak Kumar
    end;

    var
        AttributeValueCode: Record "Attribute Value";
        ItemCategoryCode: Record "Item Category";
        ItemAttribute: Record "Attribute Master";
}

