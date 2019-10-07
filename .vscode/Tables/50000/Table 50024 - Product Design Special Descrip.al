table 50024 "Product Design Special Descrip"
{
    // version Estimate Samadhan


    fields
    {
        field(1;"No.";Code[20])
        {
            CaptionML = ENU = 'No.';
        }
        field(2;"Line No.";Integer)
        {
            CaptionML = ENU = 'Line No.';
        }
        field(3;Date;Date)
        {
            CaptionML = ENU = 'Date';
        }
        field(4;"Code";Code[10])
        {
            CaptionML = ENU = 'Code';
            TableRelation = "Standard Text".Code;

            trigger OnValidate()
            begin
                // Lines addeed By deepak Kumar
                StandardText.Reset;
                StandardText.SetRange(StandardText.Code,Code);
                if StandardText.FindFirst then begin
                  Comment:=StandardText.Description;
                end;
            end;
        }
        field(5;Comment;Text[80])
        {
            CaptionML = ENU = 'Comment';
        }
        field(6;Category;Option)
        {
            OptionCaption = ' ,Special Instruction,Special Instruction Corrugation,Sub Job Detail,Cost,Sp. Instruction Main Corrugation ,Sp. Instruction Main Printing,Sp. Instruction SubJob Corrugation,Sp. Instruction SubJob Printing';
            OptionMembers = " ","Special Instruction","Special Instruction Corrugation","Sub Job Detail",Cost,"Sp. Instruction Main Corrugation ","Sp. Instruction Main Printing","Sp. Instruction SubJob Corrugation","Sp. Instruction SubJob Printing";
        }
        field(7;"Cost Code";Code[20])
        {
            TableRelation = "Standard Sales Code".Code;

            trigger OnValidate()
            begin
                // Lines added BY Deepak Kumar
                StandardSalesCode.Reset;
                StandardSalesCode.SetRange(StandardSalesCode.Code,"Cost Code");
                if StandardSalesCode.FindFirst then begin
                  "Cost Description":=StandardSalesCode.Description;
                  Occurrence:=StandardSalesCode.Occurrence;
                end else begin
                  "Cost Description":='';

                end;
            end;
        }
        field(8;"Cost Description";Text[250])
        {
        }
        field(9;Occurrence;Option)
        {
            OptionCaption = 'Once,Every Invoice';
            OptionMembers = Once,"Every Invoice";
        }
        field(10;Amount;Decimal)
        {
        }
    }

    keys
    {
        key(Key1;"No.","Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        StandardText: Record "Standard Text";
        StandardSalesCode: Record "Standard Sales Code";
        StdTxt: Record "Standard Text";

    procedure SetUpNewLine()
    var
        SalesCommentLine: Record "Sales Comment Line";
    begin
        SalesCommentLine.SetRange("No.","No.");
        SalesCommentLine.SetRange("Line No.","Line No.");
        SalesCommentLine.SetRange(Date,WorkDate);
        if not SalesCommentLine.FindFirst then
          Date := WorkDate;
    end;
}

