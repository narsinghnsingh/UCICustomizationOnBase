report 50041 "Inks & Pallet Report"
{
    // version Production / Sadaf

    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/Inks & Pallet Report.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
        dataitem("Production Order"; "Production Order")
        {
            DataItemTableView = SORTING (Status, "No.") ORDER(Ascending);
            RequestFilterFields = "No.", "Creation Date";
            column(CustomerName_ProductionOrder; "Production Order"."Customer Name")
            {
            }
            column(ALLFILTER; ALLFILTER)
            {
            }
            dataitem("Prod. Order Line"; "Prod. Order Line")
            {
                DataItemLink = "Prod. Order No." = FIELD ("No.");
                DataItemTableView = SORTING (Status, "Prod. Order No.", "Line No.") ORDER(Ascending) WHERE ("Planning Level Code" = FILTER (0));
                column(Comp_Name; CompanyInformation.Name)
                {
                }
                column(CreationDate_ProdOrderLine; "Prod. Order Line"."Creation Date")
                {
                }
                column(RUN_DATE; WorkDate)
                {
                }
                column(Rep_Cap; Rep_Cap)
                {
                }
                column(ProdOrderNo_ProdOrderLine; "Prod. Order Line"."Prod. Order No.")
                {
                }
                column(ProductDesignNo_ProdOrderLine; "Prod. Order Line"."Product Design No.")
                {
                }
                column(ItemNo_ProdOrderLine; "Prod. Order Line"."Item No.")
                {
                }
                column(Description_ProdOrderLine; "Prod. Order Line".Description)
                {
                }
                column(Quantity_ProdOrderLine; "Prod. Order Line".Quantity)
                {
                }
                column(Colour1; Colour1)
                {
                }
                column(Colour2; Colour2)
                {
                }
                column(Colour3; Colour3)
                {
                }
                column(Colour4; Colour4)
                {
                }
                column(Colour5; Colour5)
                {
                }
                column(Colour6; Colour6)
                {
                }
                column(Colour_Des1; Colour_Des1)
                {
                }
                column(Colour_Des2; Colour_Des2)
                {
                }
                column(Colour_Des3; Colour_Des3)
                {
                }
                column(Colour_Des4; Colour_Des4)
                {
                }
                column(Colour_Des5; Colour_Des5)
                {
                }
                column(Colour_Des6; Colour_Des6)
                {
                }
                column(QtyinPallet; Format(QtyinPallet) + ' ' + 'Pcs')
                {
                }
                column(NoofPallet; NoofPallet)
                {
                }
                column(Cnt; Cnt)
                {
                }
                column(PALLET_SIZE; PALLET_SIZE)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    CompanyInformation.Get;


                    Colour1 := '';
                    Colour2 := '';
                    Colour3 := '';
                    Colour4 := '';
                    Colour5 := '';
                    Colour6 := '';

                    Colour_Des1 := '';
                    Colour_Des2 := '';
                    Colour_Des3 := '';
                    Colour_Des4 := '';
                    Colour_Des5 := '';
                    Colour_Des6 := '';


                    ProductDesignHeader.Reset;
                    ProductDesignHeader.SetFilter(ProductDesignHeader."Product Design Type", 'Main');
                    ProductDesignHeader.SetRange(ProductDesignHeader."Product Design No.", "Product Design No.");
                    ProductDesignHeader.SetRange(ProductDesignHeader."Item Code", "Prod. Order Line"."Item No.");
                    if ProductDesignHeader.FindFirst then begin
                        Colour1 := ProductDesignHeader."Printing Colour 1";
                        Colour2 := ProductDesignHeader."Printing Colour 2";
                        Colour3 := ProductDesignHeader."Printing Colour 3";
                        Colour4 := ProductDesignHeader."Printing Colour 4";
                        Colour5 := ProductDesignHeader."Printing Colour 5";
                        Colour6 := ProductDesignHeader."Printing Colour 6";
                        PALLET_SIZE := ProductDesignHeader."Pallet Size";
                        Item.Reset;
                        Item.SetRange(Item."No.", Colour1);
                        if Item.FindFirst then begin
                            Colour_Des1 := Item.Description;
                        end;
                        Item.Reset;
                        Item.SetRange(Item."No.", Colour2);
                        if Item.FindFirst then begin
                            Colour_Des2 := Item.Description;
                        end;
                        Item.Reset;
                        Item.SetRange(Item."No.", Colour3);
                        if Item.FindFirst then begin
                            Colour_Des3 := Item.Description;
                        end;
                        Item.Reset;
                        Item.SetRange(Item."No.", Colour4);
                        if Item.FindFirst then begin
                            Colour_Des4 := Item.Description;
                        end;
                        Item.Reset;
                        Item.SetRange(Item."No.", Colour5);
                        if Item.FindFirst then begin
                            Colour_Des5 := Item.Description;
                        end;
                        Item.Reset;
                        Item.SetRange(Item."No.", Colour6);
                        if Item.FindFirst then begin
                            Colour_Des6 := Item.Description;
                        end;

                    end;



                    /*QtyinPallet :=0;
                    Cnt :=0;
                    PackingListLine.RESET;
                    PackingListLine.SETRANGE(PackingListLine."Prod. Order No.","Prod. Order No." );
                    PackingListLine.SETRANGE(PackingListLine."Sales Order No.","Sales Order No.");
                    PackingListLine.SETRANGE(PackingListLine."Item No.","Prod. Order Line"."Item No.");
                    IF PackingListLine.FINDFIRST THEN BEGIN
                      REPEAT
                        QtyinPallet += PackingListLine.Quantity;
                       // NoofPallet += PackingListLine."Pallet No.";
                        Cnt :=Cnt+1;
                       UNTIL PackingListLine.NEXT=0;
                    END;*/

                end;
            }

            trigger OnAfterGetRecord()
            begin
                ALLFILTER := "Production Order".GetFilters;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        CompanyInformation: Record "Company Information";
        Rep_Cap: Label 'RPO WISE INKS AND PALLET REPORT';
        ProductDesignHeader: Record "Product Design Header";
        Colour1: Text;
        Colour2: Text;
        Colour3: Text;
        Colour4: Text;
        Colour5: Text;
        Colour6: Text;
        Item: Record Item;
        Colour_Des1: Text;
        Colour_Des2: Text;
        Colour_Des3: Text;
        Colour_Des4: Text;
        Colour_Des5: Text;
        Colour_Des6: Text;
        PackingListLine: Record "Packing List Line";
        QtyinPallet: Integer;
        NoofPallet: Integer;
        Cnt: Integer;
        ALLFILTER: Text;
        PALLET_SIZE: Text;
}

