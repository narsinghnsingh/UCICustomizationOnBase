page 50004 "Product Design Process Routing"
{
    // version Estimate Samadhan

    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = "Product Design Line";
    SourceTableView = SORTING("Product Design Type","Product Design No.","Sub Comp No.","Line No.")
                      ORDER(Ascending)
                      WHERE("Work Center Category"=FILTER(<>Materials));

    layout
    {
        area(content)
        {
            repeater(Control3)
            {
                ShowCaption = false;
                field("Work Center Category";"Work Center Category")
                {
                    OptionCaption = ',,Origination Cost,Corrugation,Printing Guiding,Finishing Packing,Sub Job';
                    Style = Attention;
                    StyleExpr = TRUE;

                    trigger OnValidate()
                    begin
                        // Lines added bY Deepak Kumar
                        if "Work Center Category" ="Work Center Category"::Corrugation then
                          Error('Corrugation update only from Header');
                    end;
                }
                field(Type;Type)
                {
                    Editable = CorrugationWorkCenter;
                    OptionCaption = ' ,,Work Center,Machine Center';
                }
                field("No.";"No.")
                {
                    Editable = CorrugationWorkCenter;
                }
                field(Description;Description)
                {
                    Editable = CorrugationWorkCenter;
                }
                field(Quantity;Quantity)
                {
                }
                field("Die Cut Ups";"Die Cut Ups")
                {
                }
                field("No of Joints";"No of Joints")
                {
                }
                field("Setup Time(Min)";"Setup Time(Min)")
                {
                }
                field("Run Time (Min)";"Run Time (Min)")
                {
                }
                field("Unit Of Measure";"Unit Of Measure")
                {
                }
                field("Routing Unit of Measure";"Routing Unit of Measure")
                {
                }
                field("Unit Cost";"Unit Cost")
                {
                }
                field("Line Amount";"Line Amount")
                {
                }
                field("Line Type";"Line Type")
                {
                }
                field(Remarks;Remarks)
                {
                }
                field("Consume / Process For";"Consume / Process For")
                {
                    CaptionML = ENU = 'Process For';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        if "Work Center Category" ="Work Center Category"::Corrugation then
          CorrugationWorkCenter:=false
        else
          CorrugationWorkCenter:=true;
    end;

    trigger OnAfterGetRecord()
    begin
        if "Work Center Category" ="Work Center Category"::Corrugation then
          CorrugationWorkCenter:=false
        else
          CorrugationWorkCenter:=true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        // Lines added By Deepak Kumar
         "Work Center Category":="Work Center Category"::"Origination Cost";
         Type:=Type::"Work Center";
    end;

    var
        [InDataSet]
        CorrugationWorkCenter: Boolean;
}

