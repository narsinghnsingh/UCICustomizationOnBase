page 50203 "Change RPO Statusnew"
{
    DelayedInsert = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = Card;
    SourceTable = "Production Order";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Production Order Number";"Production Order Number")
                {
                    TableRelation = "Production Order"."No." WHERE (Status=CONST(Finished));
                }
                field("FPO To RPO";FPOTORPO)
                {
                    Editable = true;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Change Status")
            {
                Image = Undo;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin


                    ProdOrder.Reset;
                    ProdOrder.SetRange(ProdOrder."No.","Production Order Number");
                    ProdOrder.SetRange(ProdOrder.Status,ProdOrder.Status::Finished);
                    if ProdOrder.FindFirst then begin
                       ProdOrder.Rename(ProdOrder.Status::Released,ProdOrder."No.");
                      // MESSAGE('Status Changed %1 For Order, RPO %2',ProdOrder.Status,"Production Order Number" );
                    end;

                    ProdOrderline.Reset;
                    ProdOrderline.SetRange(ProdOrderline."Prod. Order No.","Production Order Number");
                    ProdOrderline.SetRange(ProdOrderline.Status,ProdOrderline.Status::Finished);
                    if ProdOrderline.FindFirst then begin
                    repeat
                       ProdOrderline.Rename(ProdOrderline.Status::Released,ProdOrderline."Prod. Order No.",ProdOrderline."Line No.");
                       until ProdOrderline.Next=0;
                      // MESSAGE('Status Changed for RPO Line %1 , RPO %2',ProdOrder.Status,"Production Order Number" );
                    end;

                    ProdOrderCompLine.Reset;
                    ProdOrderCompLine.SetRange(ProdOrderCompLine."Prod. Order No.","Production Order Number");
                    ProdOrderCompLine.SetRange(ProdOrderCompLine.Status,ProdOrderCompLine.Status::Finished);
                    if ProdOrderCompLine.FindFirst then begin
                       repeat
                       ProdOrderCompLine.Rename(ProdOrderCompLine.Status::Released,ProdOrderCompLine."Prod. Order No.",ProdOrderCompLine."Prod. Order Line No.",ProdOrderCompLine."Line No.");
                       until ProdOrderCompLine.Next=0;
                     //  MESSAGE('Status Changed for Comp Line %1 , RPO %2',ProdOrder.Status,"Production Order Number");
                    end;


                    ProdOrderRouting.Reset;
                    ProdOrderRouting.SetRange(ProdOrderRouting."Prod. Order No.","Production Order Number");
                    ProdOrderRouting.SetRange(ProdOrderRouting.Status,ProdOrderRouting.Status::Finished);
                    if ProdOrderRouting.FindFirst then begin
                    repeat
                       ProdOrderRouting.Rename(ProdOrderRouting.Status::Released,ProdOrderRouting."Prod. Order No.",ProdOrderRouting."Routing Reference No.",ProdOrderRouting."Routing No.",ProdOrderRouting."Operation No.");
                       until ProdOrderRouting.Next=0;
                    //   MESSAGE('Status Changed For Routing Line %1 , RPO %2',ProdOrder.Status,"Production Order Number");
                    end;
                     Message('complete');
                end;
            }
            action("Chnage Status From Temp Production Table")
            {
                CaptionML = ENU = 'Chnage Status From Temp Production Table';

                trigger OnAction()
                begin
                    // Lines added By Deepak Kumar
                    TempProdOrder.Reset;
                    if TempProdOrder.FindFirst then begin
                      repeat
                        ChangeStatusProdOrderWise(TempProdOrder."Order No.");
                      until TempProdOrder.Next=0;
                      Message('complete');
                    end;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        FPOTORPO:=true;
    end;

    var
        "Production Order Number": Code[50];
        ProdOrder: Record "Production Order";
        ProdOrderline: Record "Prod. Order Line";
        ProdOrderCompLine: Record "Prod. Order Component";
        ProdOrderRouting: Record "Prod. Order Routing Line";
        FPOTORPO: Boolean;
        TempProdOrder: Record "Temp Production Order";

    procedure ChangeStatusProdOrderWise(ProductionOrderNumber: Code[50])
    begin

        ProdOrder.Reset;
        ProdOrder.SetRange(ProdOrder."No.",ProductionOrderNumber);
        ProdOrder.SetRange(ProdOrder.Status,ProdOrder.Status::Finished);
        if ProdOrder.FindFirst then begin
           ProdOrder.Rename(ProdOrder.Status::Released,ProdOrder."No.");
          // MESSAGE('Status Changed %1 For Order, RPO %2',ProdOrder.Status,ProductionOrderNumber );
        end;

        ProdOrderline.Reset;
        ProdOrderline.SetRange(ProdOrderline."Prod. Order No.",ProductionOrderNumber);
        ProdOrderline.SetRange(ProdOrderline.Status,ProdOrderline.Status::Finished);
        if ProdOrderline.FindFirst then begin
        repeat
           ProdOrderline.Rename(ProdOrderline.Status::Released,ProdOrderline."Prod. Order No.",ProdOrderline."Line No.");
           until ProdOrderline.Next=0;
          // MESSAGE('Status Changed for RPO Line %1 , RPO %2',ProdOrder.Status,ProductionOrderNumber );
        end;

        ProdOrderCompLine.Reset;
        ProdOrderCompLine.SetRange(ProdOrderCompLine."Prod. Order No.",ProductionOrderNumber);
        ProdOrderCompLine.SetRange(ProdOrderCompLine.Status,ProdOrderCompLine.Status::Finished);
        if ProdOrderCompLine.FindFirst then begin
           repeat
           ProdOrderCompLine.Rename(ProdOrderCompLine.Status::Released,ProdOrderCompLine."Prod. Order No.",ProdOrderCompLine."Prod. Order Line No.",ProdOrderCompLine."Line No.");
           until ProdOrderCompLine.Next=0;
         //  MESSAGE('Status Changed for Comp Line %1 , RPO %2',ProdOrder.Status,ProductionOrderNumber);
        end;


        ProdOrderRouting.Reset;
        ProdOrderRouting.SetRange(ProdOrderRouting."Prod. Order No.",ProductionOrderNumber);
        ProdOrderRouting.SetRange(ProdOrderRouting.Status,ProdOrderRouting.Status::Finished);
        if ProdOrderRouting.FindFirst then begin
        repeat
           ProdOrderRouting.Rename(ProdOrderRouting.Status::Released,ProdOrderRouting."Prod. Order No.",ProdOrderRouting."Routing Reference No.",ProdOrderRouting."Routing No.",ProdOrderRouting."Operation No.");
           until ProdOrderRouting.Next=0;
        //   MESSAGE('Status Changed For Routing Line %1 , RPO %2',ProdOrder.Status,ProductionOrderNumber);
        end;
    end;
}

