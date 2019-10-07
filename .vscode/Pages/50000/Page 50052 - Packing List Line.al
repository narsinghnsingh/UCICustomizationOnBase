page 50052 "Packing List Line"
{
    // version Packing List Samadhan

    InsertAllowed = false;
    PageType = ListPart;
    RefreshOnActivate = true;
    SourceTable = "Packing List Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Pallet No.";"Pallet No.")
                {
                    Editable = LinePosted;
                }
                field(Quantity;Quantity)
                {
                    Editable = LinePosted;
                }
                field(Posted;Posted)
                {
                }
                field("Sales Shipment No.";"Sales Shipment No.")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        // Lines added by Deepak kumar
        if Posted  = true then
          LinePosted:=false
        else
          LinePosted:=true;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        // Lines added by Deepak kumar
          PackingListHeader.Reset;
          PackingListHeader.SetRange(PackingListHeader.No,"Packing List No.");
          if PackingListHeader.FindFirst then
            PackingListHeader.TestField(PackingListHeader.Status,PackingListHeader.Status::Open);
    end;

    var
        LinePosted: Boolean;
        PackingListHeader: Record "Packing List Header";
}

