tableextension 50000 TableExt_SalespersonPurchaser extends "Salesperson/Purchaser"
{
    fields
    {
        field(50000; Type; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "Sales Person","Sales Agent",Purchaser;
        }
        field(50001; "Domestic Sales Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("Value Entry"."Sales Amount (Actual)"
            WHERE ("Salespers./Purch. Code" = field (Code),
            "Gen. Bus. Posting Group" = const ('DOMESTIC'),
            "Posting Date" = FIELD ("Date Filter")));
        }
        field(50002; "Export Sales Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("Value Entry"."Sales Amount (Actual)"
            WHERE ("Salespers./Purch. Code" = FIELD (Code),
            "Gen. Bus. Posting Group" = CONST ('EXPORT'),
            "Posting Date" = FIELD ("Date Filter")));
        }
        field(50003; "Domestic Sales Weight"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("Sales Invoice Line"."Net Weight"
            WHERE (
            //"Salesperson Code" = FIELD (Code),
            "Gen. Bus. Posting Group" = CONST ('DOMESTIC'),
            "Posting Date" = FIELD ("Date Filter"),
            Quantity = FILTER (> 0)));

        }
        field(50004; "Domestic Sales Qauntity"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("Sales Invoice Line".Quantity
            WHERE (
                //"Salesperson "Code"=FIELD(Code),
                "Gen. Bus. Posting Group" = CONST ('DOMESTIC'),
                "Posting Date" = FIELD ("Date Filter")));

        }
        field(50005; "Export Sales Weight"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("Sales Invoice Line"."Net Weight"
            WHERE (
                //"Salesperson Code"=FIELD(Code),
                "Gen. Bus. Posting Group" = CONST ('EXPORT'),
                "Posting Date" = FIELD ("Date Filter")));

        }
        field(50006; "Export Sales Qauntity"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("Sales Invoice Line".Quantity
            WHERE (
                //"Salesperson Code"=FIELD(Code),
                "Gen. Bus. Posting Group" = CONST ('EXPORT'),
                "Posting Date" = FIELD ("Date Filter")));

        }
        field(50007; "Domestic Sales Amount All"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("Value Entry"."Sales Amount (Actual)"
            WHERE ("Gen. Bus. Posting Group" = CONST ('DOMESTIC'), "Posting Date" = FIELD ("Date Filter")));
        }
        field(50008; "Export Sales Amount All"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("Value Entry"."Sales Amount (Actual)"
            WHERE ("Gen. Bus. Posting Group" = CONST ('EXPORT'), "Posting Date" = FIELD ("Date Filter")));

        }
        field(50009; "Domestic Sales Weight All"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("Sales Invoice Line"."Net Weight"
            WHERE ("Gen. Bus. Posting Group" = CONST ('DOMESTIC'), "Posting Date" = FIELD ("Date Filter")));

        }
        field(50010; "Domestic Sales Qauntity All"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("Sales Invoice Line".Quantity
            WHERE ("Gen. Bus. Posting Group" = CONST ('DOMESTIC'), "Posting Date" = FIELD ("Date Filter")));

        }
        field(50011; "Export Sales Weight All"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("Sales Invoice Line"."Net Weight"
            WHERE ("Gen. Bus. Posting Group" = CONST ('EXPORT'), "Posting Date" = FIELD ("Date Filter")));

        }
        field(50012; "Export Qauntity All"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("Sales Invoice Line".Quantity
            WHERE ("Gen. Bus. Posting Group" = CONST ('EXPORT'), "Posting Date" = FIELD ("Date Filter")));
        }
        field(50013; "Domestic Actual Weight(Kg)"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(50014; "Export Actual Weight(Kg)"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(50015; "PerUnitActual Weight"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(50016; "Domestic Actual Rate(Avg)"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(50017; "Export Actual Rate(Avg)"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
    }
}