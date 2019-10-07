table 50046 "Schedule Base Table 3"
{
    // version Prod. Schedule


    fields
    {
        field(1;"Schedule No.";Code[50])
        {
            Editable = false;
        }
        field(2;"Deckle Size";Code[50])
        {
            Editable = false;
        }
        field(3;"Paper Type";Code[20])
        {
            Editable = false;
        }
        field(4;"Paper GSM";Code[50])
        {
            Editable = false;
        }
        field(10;"Deckle Size(Num)";Decimal)
        {
            Editable = true;
        }
        field(11;"Paper GSM(Num)";Decimal)
        {
            Editable = false;
        }
        field(21;"Available Inventory (kg)";Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE ("Item No."=FIELD("Item No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(22;"Total Requirement (kg)";Decimal)
        {
            Editable = false;
        }
        field(23;"Total No. Of Reels";Integer)
        {
            Editable = false;
        }
        field(24;"Item Exists";Boolean)
        {
            CalcFormula = Exist(Item WHERE ("Deckle Size (mm)"=FIELD("Deckle Size(Num)"),
                                            "Paper GSM"=FIELD(FILTER("Paper GSM")),
                                            "Paper Type"=FIELD("Paper Type")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(25;"Item No.";Code[20])
        {
            Editable = false;
            TableRelation = Item."No." WHERE (Blocked=CONST(false));
        }
        field(26;"New Item Number";Code[20])
        {
            TableRelation = Item."No." WHERE ("Paper Type"=FIELD("Paper Type"),
                                              "Deckle Size (mm)"=FIELD("Deckle Size(Num)"));

            trigger OnValidate()
            begin
                // Lines added By Deepak Kumar
                  ItemMaster.Get("New Item Number");
                  "Paper GSM":=Format(ItemMaster."Paper GSM");
                  "Paper GSM(Num)":=ItemMaster."Paper GSM";
                  "Total Requirement (kg)":=("Total Requirement (kg)"/xRec."Paper GSM(Num)")*"Paper GSM(Num)";
                
                
                  /*
                    "Paper GSM":=ItemMaster."Paper GSM";
                  "Item Category Code":=ItemMaster."Item Category Code";
                   // GSMType:= ItemMaster.PaperGSMType;
                  "Deckle Size(mm)":= ItemMaster."Deckle Size (mm)";
                  VALIDATE(Quantity,(Quantity/xRec."Paper GSM")*"Paper GSM");
                   */

            end;
        }
        field(1000;"Item Code";Code[50])
        {
        }
        field(1001;"Item Description";Text[250])
        {
        }
        field(1002;"Prod. Order Number";Code[50])
        {
        }
        field(1003;"Prod. Order Line No.";Integer)
        {
        }
        field(1005;"Schedule Component List";Boolean)
        {
        }
        field(1006;"Exp. Qty in OtherPub. Schedule";Decimal)
        {
            CalcFormula = Sum("Schedule Base Table 3"."Total Requirement (kg)" WHERE ("Deckle Size"=FIELD("Deckle Size"),
                                                                                      "Paper GSM"=FIELD("Paper GSM"),
                                                                                      "Paper Type"=FIELD("Paper Type"),
                                                                                      "Schedule Component List"=CONST(true)));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Schedule No.","Deckle Size","Paper Type","Paper GSM","Item No.","Item Code","Prod. Order Number","Prod. Order Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        ItemMaster: Record Item;
}

