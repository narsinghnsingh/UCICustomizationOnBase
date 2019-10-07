page 50112 "Plate Item Card"
{
    // version Samadhan Plate

    CaptionML = ENU = 'Plate Item Card';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = Item;
    SourceTableView = SORTING ("No.")
                      WHERE ("Plate Item" = CONST (true),
                            "Inventory Value Zero" = CONST (true));

    layout
    {
        area(content)
        {
            group(General)
            {
                CaptionML = ENU = 'General';
                field("No."; "No.")
                {
                    Importance = Promoted;

                    trigger OnAssistEdit()
                    begin
                        if AssistEdit then
                            CurrPage.Update;
                    end;
                }
                field("No. 2"; "No. 2")
                {
                }
                field(Description; Description)
                {
                }
                field("Base Unit of Measure"; "Base Unit of Measure")
                {
                    Importance = Promoted;
                }
                field("Artwork Approval Date & Time"; "Artwork Approval Date & Time")
                {
                }
                field("Printing Threshold Limit"; "Printing Threshold Limit")
                {
                }
                field(Inventory; Inventory)
                {
                    Importance = Promoted;
                }
                field("Plate Item"; "Plate Item")
                {
                }
                field("Output Qty"; "Output Qty")
                {
                }
                field("Inventory Value Zero"; "Inventory Value Zero")
                {
                    Editable = false;
                }
                field("Qty. on Purch. Order"; "Qty. on Purch. Order")
                {
                }
                field(Blocked; Blocked)
                {
                }
                field("Last Date Modified"; "Last Date Modified")
                {
                }
                field("FG Item No."; "FG Item No.")
                {
                }
                field("Job Description"; "Curr Prod. Order Desc.")
                {
                }
                field("Estimate No."; "Estimate No.")
                {
                }
                field("Customer No."; "Customer No.")
                {
                }
                field("Customer Name"; "Customer Name")
                {
                }
            }
            group(Invoicing)
            {
                CaptionML = ENU = 'Invoicing';
                field("Costing Method"; "Costing Method")
                {
                    Importance = Promoted;

                    trigger OnValidate()
                    begin
                        EnableCostingControls;
                    end;
                }
                field("Cost is Adjusted"; "Cost is Adjusted")
                {
                }
                field("Cost is Posted to G/L"; "Cost is Posted to G/L")
                {
                }
                field("Unit Cost"; "Unit Cost")
                {
                    Enabled = UnitCostEnable;

                    trigger OnDrillDown()
                    var
                        ShowAvgCalcItem: Codeunit "Show Avg. Calc. - Item";
                    begin
                        ShowAvgCalcItem.DrillDownAvgCostAdjmtPoint(Rec)
                    end;
                }
                field("Last Direct Cost"; "Last Direct Cost")
                {
                }
                field("Item Category Code"; "Item Category Code")
                {
                }
                field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
                {
                    Importance = Promoted;
                }
                field("VAT Prod. Posting Group"; "VAT Prod. Posting Group")
                {
                }
                field("Inventory Posting Group"; "Inventory Posting Group")
                {
                    Importance = Promoted;
                }
                field("Sales Unit of Measure"; "Sales Unit of Measure")
                {
                }
                field("Application Wksh. User ID"; "Application Wksh. User ID")
                {
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                Visible = true;
            }
            systempart(Control1905767507; Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Master Data")
            {
                CaptionML = ENU = 'Master Data';
                Image = DataEntry;
                action("&Units of Measure")
                {
                    CaptionML = ENU = '&Units of Measure';
                    Image = UnitOfMeasure;
                    RunObject = Page "Item Units of Measure";
                    RunPageLink = "Item No." = FIELD ("No.");
                }
                action("Va&riants")
                {
                    CaptionML = ENU = 'Va&riants';
                    Image = ItemVariant;
                    RunObject = Page "Item Variants";
                    RunPageLink = "Item No." = FIELD ("No.");
                }
                group(Dimensions)
                {
                    CaptionML = ENU = 'Dimensions';
                    Image = Dimensions;
                }
                action(Action184)
                {
                    CaptionML = ENU = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID" = CONST (27),
                                  "No." = FIELD ("No.");
                    ShortCutKey = 'Shift+Ctrl+D';
                }
                action("Substituti&ons")
                {
                    CaptionML = ENU = 'Substituti&ons';
                    Image = ItemSubstitution;
                    RunObject = Page "Item Substitution Entry";
                    RunPageLink = Type = CONST (Item),
                                  "No." = FIELD ("No.");
                }
                action("Cross Re&ferences")
                {
                    CaptionML = ENU = 'Cross Re&ferences';
                    Image = Change;
                    RunObject = Page "Item Cross Reference Entries";
                    RunPageLink = "Item No." = FIELD ("No.");
                }
                action("E&xtended Texts")
                {
                    CaptionML = ENU = 'E&xtended Texts';
                    Image = Text;
                    RunObject = Page "Extended Text List";
                    RunPageLink = "Table Name" = CONST (Item),
                                  "No." = FIELD ("No.");
                    RunPageView = SORTING ("Table Name", "No.", "Language Code", "All Language Codes", "Starting Date", "Ending Date");
                }
                action(Translations)
                {
                    CaptionML = ENU = 'Translations';
                    Image = Translations;
                    RunObject = Page "Item Translations";
                    RunPageLink = "Item No." = FIELD ("No.");
                }
                action("&Picture")
                {
                    CaptionML = ENU = '&Picture';
                    Image = Picture;
                    RunObject = Page "Item Picture";
                    RunPageLink = "No." = FIELD ("No."),
                                  "Date Filter" = FIELD ("Date Filter"),
                                  "Global Dimension 1 Filter" = FIELD ("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter" = FIELD ("Global Dimension 2 Filter"),
                                  "Location Filter" = FIELD ("Location Filter"),
                                  "Drop Shipment Filter" = FIELD ("Drop Shipment Filter"),
                                  "Variant Filter" = FIELD ("Variant Filter");
                }
                action(Identifiers)
                {
                    CaptionML = ENU = 'Identifiers';
                    Image = BarCode;
                    RunObject = Page "Item Identifiers";
                    RunPageLink = "Item No." = FIELD ("No.");
                    RunPageView = SORTING ("Item No.", "Variant Code", "Unit of Measure Code");
                }
            }
            group(Availability)
            {
                CaptionML = ENU = 'Availability';
                Image = ItemAvailability;
                action(ItemsByLocation)
                {
                    CaptionML = ENU = 'Items b&y Location';
                    Image = ItemAvailbyLoc;

                    trigger OnAction()
                    var
                        ItemsByLocation: Page "Items by Location";
                    begin
                        ItemsByLocation.SetRecord(Rec);
                        ItemsByLocation.Run;
                    end;
                }
                group("&Item Availability by")
                {
                    CaptionML = ENU = '&Item Availability by';
                    Image = ItemAvailability;
                    action("<Action110>")
                    {
                        CaptionML = ENU = 'Event';
                        Image = "Event";

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromItem(Rec, ItemAvailFormsMgt.ByEvent);
                        end;
                    }
                    action(Period)
                    {
                        CaptionML = ENU = 'Period';
                        Image = Period;
                        RunObject = Page "Item Availability by Periods";
                        RunPageLink = "No." = FIELD ("No."),
                                      "Global Dimension 1 Filter" = FIELD ("Global Dimension 1 Filter"),
                                      "Global Dimension 2 Filter" = FIELD ("Global Dimension 2 Filter"),
                                      "Location Filter" = FIELD ("Location Filter"),
                                      "Drop Shipment Filter" = FIELD ("Drop Shipment Filter"),
                                      "Variant Filter" = FIELD ("Variant Filter");
                    }
                    action(Variant)
                    {
                        CaptionML = ENU = 'Variant';
                        Image = ItemVariant;
                        RunObject = Page "Item Availability by Variant";
                        RunPageLink = "No." = FIELD ("No."),
                                      "Global Dimension 1 Filter" = FIELD ("Global Dimension 1 Filter"),
                                      "Global Dimension 2 Filter" = FIELD ("Global Dimension 2 Filter"),
                                      "Location Filter" = FIELD ("Location Filter"),
                                      "Drop Shipment Filter" = FIELD ("Drop Shipment Filter"),
                                      "Variant Filter" = FIELD ("Variant Filter");
                    }
                    action(Location)
                    {
                        CaptionML = ENU = 'Location';
                        Image = Warehouse;
                        RunObject = Page "Item Availability by Location";
                        RunPageLink = "No." = FIELD ("No."),
                                      "Global Dimension 1 Filter" = FIELD ("Global Dimension 1 Filter"),
                                      "Global Dimension 2 Filter" = FIELD ("Global Dimension 2 Filter"),
                                      "Location Filter" = FIELD ("Location Filter"),
                                      "Drop Shipment Filter" = FIELD ("Drop Shipment Filter"),
                                      "Variant Filter" = FIELD ("Variant Filter");
                    }
                    action("BOM Level")
                    {
                        CaptionML = ENU = 'BOM Level';
                        Image = BOMLevel;

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromItem(Rec, ItemAvailFormsMgt.ByBOM);
                        end;
                    }
                    action(Timeline)
                    {
                        CaptionML = ENU = 'Timeline';
                        Image = Timeline;

                        trigger OnAction()
                        begin
                            ShowTimelineFromItem(Rec);
                        end;
                    }
                }
            }
            group(History)
            {
                CaptionML = ENU = 'History';
                Image = History;
                group("E&ntries")
                {
                    CaptionML = ENU = 'E&ntries';
                    Image = Entries;
                    action("Ledger E&ntries")
                    {
                        CaptionML = ENU = 'Ledger E&ntries';
                        Image = ItemLedger;
                        Promoted = false;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = Process;
                        RunObject = Page "Item Ledger Entries";
                        RunPageLink = "Item No." = FIELD ("No.");
                        RunPageView = SORTING ("Item No.");
                        ShortCutKey = 'Ctrl+F7';
                    }
                    action("&Reservation Entries")
                    {
                        CaptionML = ENU = '&Reservation Entries';
                        Image = ReservationLedger;
                        RunObject = Page "Reservation Entries";
                        RunPageLink = "Reservation Status" = CONST (Reservation),
                                      "Item No." = FIELD ("No.");
                        RunPageView = SORTING ("Item No.", "Variant Code", "Location Code", "Reservation Status");
                    }
                    action("&Phys. Inventory Ledger Entries")
                    {
                        CaptionML = ENU = '&Phys. Inventory Ledger Entries';
                        Image = PhysicalInventoryLedger;
                        RunObject = Page "Phys. Inventory Ledger Entries";
                        RunPageLink = "Item No." = FIELD ("No.");
                        RunPageView = SORTING ("Item No.");
                    }
                    action("&Value Entries")
                    {
                        CaptionML = ENU = '&Value Entries';
                        Image = ValueLedger;
                        RunObject = Page "Value Entries";
                        RunPageLink = "Item No." = FIELD ("No.");
                        RunPageView = SORTING ("Item No.");
                    }
                    action("Item &Tracking Entries")
                    {
                        CaptionML = ENU = 'Item &Tracking Entries';
                        Image = ItemTrackingLedger;

                        trigger OnAction()
                        var
                            ItemTrackingMgt: Codeunit "Item Tracking Doc. Management";
                        begin
                            ItemTrackingMgt.ShowItemTrackingForMasterData(3, '', "No.", '', '', '', '');
                        end;
                    }
                    action("&Warehouse Entries")
                    {
                        CaptionML = ENU = '&Warehouse Entries';
                        Image = BinLedger;
                        RunObject = Page "Warehouse Entries";
                        RunPageLink = "Item No." = FIELD ("No.");
                        RunPageView = SORTING ("Item No.", "Bin Code", "Location Code", "Variant Code", "Unit of Measure Code", "Lot No.", "Serial No.", "Entry Type", Dedicated);
                    }
                    action("Application Worksheet")
                    {
                        CaptionML = ENU = 'Application Worksheet';
                        Image = ApplicationWorksheet;
                        RunObject = Page "Application Worksheet";
                        RunPageLink = "Item No." = FIELD ("No.");
                    }
                }
                group(ActionGroup102)
                {
                    CaptionML = ENU = 'Statistics';
                    Image = Statistics;
                    action(Statistics)
                    {
                        CaptionML = ENU = 'Statistics';
                        Image = Statistics;
                        Promoted = true;
                        PromotedCategory = Process;
                        ShortCutKey = 'F7';

                        trigger OnAction()
                        var
                            ItemStatistics: Page "Item Statistics";
                        begin
                            ItemStatistics.SetItem(Rec);
                            ItemStatistics.RunModal;
                        end;
                    }
                    action("Entry Statistics")
                    {
                        CaptionML = ENU = 'Entry Statistics';
                        Image = EntryStatistics;
                        RunObject = Page "Item Entry Statistics";
                        RunPageLink = "No." = FIELD ("No."),
                                      "Date Filter" = FIELD ("Date Filter"),
                                      "Global Dimension 1 Filter" = FIELD ("Global Dimension 1 Filter"),
                                      "Global Dimension 2 Filter" = FIELD ("Global Dimension 2 Filter"),
                                      "Location Filter" = FIELD ("Location Filter"),
                                      "Drop Shipment Filter" = FIELD ("Drop Shipment Filter"),
                                      "Variant Filter" = FIELD ("Variant Filter");
                    }
                    action("T&urnover")
                    {
                        CaptionML = ENU = 'T&urnover';
                        Image = Turnover;
                        RunObject = Page "Item Turnover";
                        RunPageLink = "No." = FIELD ("No."),
                                      "Global Dimension 1 Filter" = FIELD ("Global Dimension 1 Filter"),
                                      "Global Dimension 2 Filter" = FIELD ("Global Dimension 2 Filter"),
                                      "Location Filter" = FIELD ("Location Filter"),
                                      "Drop Shipment Filter" = FIELD ("Drop Shipment Filter"),
                                      "Variant Filter" = FIELD ("Variant Filter");
                    }
                }
                action("Co&mments")
                {
                    CaptionML = ENU = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name" = CONST (Item),
                                  "No." = FIELD ("No.");
                }
            }
            group("&Purchases")
            {
                CaptionML = ENU = '&Purchases';
                Image = Purchasing;
                action("Ven&dors")
                {
                    CaptionML = ENU = 'Ven&dors';
                    Image = Vendor;
                    RunObject = Page "Item Vendor Catalog";
                    RunPageLink = "Item No." = FIELD ("No.");
                    RunPageView = SORTING ("Item No.");
                }
                action(Prices)
                {
                    CaptionML = ENU = 'Prices';
                    Image = Price;
                    RunObject = Page "Purchase Prices";
                    RunPageLink = "Item No." = FIELD ("No.");
                    RunPageView = SORTING ("Item No.");
                }
                action("Line Discounts")
                {
                    CaptionML = ENU = 'Line Discounts';
                    Image = LineDiscount;
                    RunObject = Page "Purchase Line Discounts";
                    RunPageLink = "Item No." = FIELD ("No.");
                }
                action("Prepa&yment Percentages")
                {
                    CaptionML = ENU = 'Prepa&yment Percentages';
                    Image = PrepaymentPercentages;
                    RunObject = Page "Purchase Prepmt. Percentages";
                    RunPageLink = "Item No." = FIELD ("No.");
                }
                separator(Separator47)
                {
                }
                action(Orders)
                {
                    CaptionML = ENU = 'Orders';
                    Image = Document;
                    RunObject = Page "Purchase Orders";
                    RunPageLink = Type = CONST (Item),
                                  "No." = FIELD ("No.");
                    RunPageView = SORTING ("Document Type", Type, "No.");
                }
                action("Return Orders")
                {
                    CaptionML = ENU = 'Return Orders';
                    Image = ReturnOrder;
                    RunObject = Page "Purchase Return Orders";
                    RunPageLink = Type = CONST (Item),
                                  "No." = FIELD ("No.");
                    RunPageView = SORTING ("Document Type", Type, "No.");
                }
                action("Nonstoc&k Items")
                {
                    CaptionML = ENU = 'Nonstoc&k Items';
                    Image = NonStockItem;
                    RunObject = Page "Catalog Item List";
                }
            }
            group("S&ales")
            {
                CaptionML = ENU = 'S&ales';
                Image = Sales;
                action(Action82)
                {
                    CaptionML = ENU = 'Prices';
                    Image = Price;
                    RunObject = Page "Sales Prices";
                    RunPageLink = "Item No." = FIELD ("No.");
                    RunPageView = SORTING ("Item No.");
                }
                action(Action80)
                {
                    CaptionML = ENU = 'Line Discounts';
                    Image = LineDiscount;
                    RunObject = Page "Sales Line Discounts";
                    RunPageLink = Type = CONST (Item),
                                  Code = FIELD ("No.");
                    RunPageView = SORTING (Type, Code);
                }
                action(Action300)
                {
                    CaptionML = ENU = 'Prepa&yment Percentages';
                    Image = PrepaymentPercentages;
                    RunObject = Page "Sales Prepayment Percentages";
                    RunPageLink = "Item No." = FIELD ("No.");
                }
                separator(Separator46)
                {
                }
                action(Action83)
                {
                    CaptionML = ENU = 'Orders';
                    Image = Document;
                    RunObject = Page "Sales Orders";
                    RunPageLink = Type = CONST (Item),
                                  "No." = FIELD ("No.");
                    RunPageView = SORTING ("Document Type", Type, "No.");
                }
                action(Action163)
                {
                    CaptionML = ENU = 'Return Orders';
                    Image = ReturnOrder;
                    RunObject = Page "Sales Return Orders";
                    RunPageLink = Type = CONST (Item),
                                  "No." = FIELD ("No.");
                    RunPageView = SORTING ("Document Type", Type, "No.");
                }
            }
            group("Assembly/Production")
            {
                CaptionML = ENU = 'Assembly/Production';
                Image = Production;
                action(Structure)
                {
                    CaptionML = ENU = 'Structure';
                    Image = Hierarchy;

                    trigger OnAction()
                    var
                        BOMStructure: Page "BOM Structure";
                    begin
                        BOMStructure.InitItem(Rec);
                        BOMStructure.Run;
                    end;
                }
                action("Cost Shares")
                {
                    CaptionML = ENU = 'Cost Shares';
                    Image = CostBudget;

                    trigger OnAction()
                    var
                        BOMCostShares: Page "BOM Cost Shares";
                    begin
                        BOMCostShares.InitItem(Rec);
                        BOMCostShares.Run;
                    end;
                }
                group("Assemb&ly")
                {
                    CaptionML = ENU = 'Assemb&ly';
                    Image = AssemblyBOM;
                    action("Assembly BOM")
                    {
                        CaptionML = ENU = 'Assembly BOM';
                        Image = BOM;
                        RunObject = Page "Assembly BOM";
                        RunPageLink = "Parent Item No." = FIELD ("No.");
                    }
                    action("Where-Used")
                    {
                        CaptionML = ENU = 'Where-Used';
                        Image = Track;
                        RunObject = Page "Where-Used List";
                        RunPageLink = Type = CONST (Item),
                                      "No." = FIELD ("No.");
                        RunPageView = SORTING (Type, "No.");
                    }
                    action("Calc. Stan&dard Cost")
                    {
                        CaptionML = ENU = 'Calc. Stan&dard Cost';
                        Image = CalculateCost;

                        trigger OnAction()
                        begin
                            Clear(CalculateStdCost);
                            CalculateStdCost.CalcItem("No.", true);
                        end;
                    }
                    action("Calc. Unit Price")
                    {
                        CaptionML = ENU = 'Calc. Unit Price';
                        Image = SuggestItemPrice;

                        trigger OnAction()
                        begin
                            Clear(CalculateStdCost);
                            CalculateStdCost.CalcAssemblyItemPrice("No.")
                        end;
                    }
                }
                group(Production)
                {
                    CaptionML = ENU = 'Production';
                    Image = Production;
                    action("Production BOM")
                    {
                        CaptionML = ENU = 'Production BOM';
                        Image = BOM;
                        RunObject = Page "Production BOM";
                        RunPageLink = "No." = FIELD ("No.");
                    }
                    action(Action78)
                    {
                        CaptionML = ENU = 'Where-Used';
                        Image = "Where-Used";

                        trigger OnAction()
                        var
                            ProdBOMWhereUsed: Page "Prod. BOM Where-Used";
                        begin
                            ProdBOMWhereUsed.SetItem(Rec, WorkDate);
                            ProdBOMWhereUsed.RunModal;
                        end;
                    }
                    action(Action5)
                    {
                        CaptionML = ENU = 'Calc. Stan&dard Cost';
                        Image = CalculateCost;

                        trigger OnAction()
                        begin
                            Clear(CalculateStdCost);
                            CalculateStdCost.CalcItem("No.", false);
                        end;
                    }
                }
            }
            group(Warehouse)
            {
                CaptionML = ENU = 'Warehouse';
                Image = Warehouse;
                action("&Bin Contents")
                {
                    CaptionML = ENU = '&Bin Contents';
                    Image = BinContent;
                    RunObject = Page "Item Bin Contents";
                    RunPageLink = "Item No." = FIELD ("No.");
                    RunPageView = SORTING ("Item No.");
                }
                action("Stockkeepin&g Units")
                {
                    CaptionML = ENU = 'Stockkeepin&g Units';
                    Image = SKU;
                    RunObject = Page "Stockkeeping Unit List";
                    RunPageLink = "Item No." = FIELD ("No.");
                    RunPageView = SORTING ("Item No.");
                }
            }
            group(Service)
            {
                CaptionML = ENU = 'Service';
                Image = ServiceItem;
                action("Ser&vice Items")
                {
                    CaptionML = ENU = 'Ser&vice Items';
                    Image = ServiceItem;
                    RunObject = Page "Service Items";
                    RunPageLink = "Item No." = FIELD ("No.");
                    RunPageView = SORTING ("Item No.");
                }
                action(Troubleshooting)
                {
                    CaptionML = ENU = 'Troubleshooting';
                    Image = Troubleshoot;

                    trigger OnAction()
                    var
                        TroubleshootingHeader: Record "Troubleshooting Header";
                    begin
                        TroubleshootingHeader.ShowForItem(Rec);
                    end;
                }
                action("Troubleshooting Setup")
                {
                    CaptionML = ENU = 'Troubleshooting Setup';
                    Image = Troubleshoot;
                    RunObject = Page "Troubleshooting Setup";
                    RunPageLink = Type = CONST (Item),
                                  "No." = FIELD ("No.");
                }
            }
            group(Resources)
            {
                CaptionML = ENU = 'Resources';
                Image = Resource;
                group("R&esource")
                {
                    CaptionML = ENU = 'R&esource';
                    Image = Resource;
                    action("Resource Skills")
                    {
                        CaptionML = ENU = 'Resource Skills';
                        Image = ResourceSkills;
                        RunObject = Page "Resource Skills";
                        RunPageLink = Type = CONST (Item),
                                      "No." = FIELD ("No.");
                    }
                    action("Skilled Resources")
                    {
                        CaptionML = ENU = 'Skilled Resources';
                        Image = ResourceSkills;

                        trigger OnAction()
                        var
                            ResourceSkill: Record "Resource Skill";
                        begin
                            Clear(SkilledResourceList);
                            SkilledResourceList.Initialize(ResourceSkill.Type::Item, "No.", Description);
                            SkilledResourceList.RunModal;
                        end;
                    }
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                CaptionML = ENU = 'F&unctions';
                Image = "Action";
                action("&Create Stockkeeping Unit")
                {
                    CaptionML = ENU = '&Create Stockkeeping Unit';
                    Image = CreateSKU;

                    trigger OnAction()
                    var
                        Item: Record Item;
                    begin
                        Item.SetRange("No.", "No.");
                        REPORT.RunModal(REPORT::"Create Stockkeeping Unit", true, false, Item);
                    end;
                }
                action("C&alculate Counting Period")
                {
                    CaptionML = ENU = 'C&alculate Counting Period';
                    Image = CalculateCalendar;

                    trigger OnAction()
                    var
                        PhysInvtCountMgt: Codeunit "Phys. Invt. Count.-Management";
                    begin
                        PhysInvtCountMgt.UpdateItemPhysInvtCount(Rec);
                    end;
                }
                separator(Separator241)
                {
                }
                action("Apply Template")
                {
                    CaptionML = ENU = 'Apply Template';
                    Ellipsis = true;
                    Image = ApplyTemplate;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        ConfigTemplateMgt: Codeunit "Config. Template Management";
                        RecRef: RecordRef;
                    begin
                        RecRef.GetTable(Rec);
                        ConfigTemplateMgt.UpdateFromTemplateSelection(RecRef);
                    end;
                }
            }
            action("Requisition Worksheet")
            {
                CaptionML = ENU = 'Requisition Worksheet';
                Image = Worksheet;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Req. Worksheet";
            }
            action("Item Journal")
            {
                CaptionML = ENU = 'Item Journal';
                Image = Journals;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Item Journal";
            }
            action("Item Reclassification Journal")
            {
                CaptionML = ENU = 'Item Reclassification Journal';
                Image = Journals;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Item Reclass. Journal";
            }
            action("Item Tracing")
            {
                CaptionML = ENU = 'Item Tracing';
                Image = ItemTracing;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Item Tracing";
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        EnablePlanningControls;
        EnableCostingControls;
    end;

    trigger OnInit()
    begin
        UnitCostEnable := true;
        StandardCostEnable := true;
        OverflowLevelEnable := true;
        DampenerQtyEnable := true;
        DampenerPeriodEnable := true;
        LotAccumulationPeriodEnable := true;
        ReschedulingPeriodEnable := true;
        IncludeInventoryEnable := true;
        OrderMultipleEnable := true;
        MaximumOrderQtyEnable := true;
        MinimumOrderQtyEnable := true;
        MaximumInventoryEnable := true;
        ReorderQtyEnable := true;
        ReorderPointEnable := true;
        SafetyStockQtyEnable := true;
        SafetyLeadTimeEnable := true;
        TimeBucketEnable := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        EnablePlanningControls;
        EnableCostingControls;
        "Plate Item" := true;//dibya
        "Inventory Value Zero" := true;//Pulak 14-01-2015
    end;

    trigger OnOpenPage()
    begin
        EnableShowStockOutWarning;
        EnableShowShowEnforcePositivInventory;
    end;

    var
        SkilledResourceList: Page "Skilled Resource List";
        CalculateStdCost: Codeunit "Calculate Standard Cost";
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
        ShowStockoutWarningDefaultYes: Boolean;
        ShowStockoutWarningDefaultNo: Boolean;
        PreventNegInventoryDefaultYes: Boolean;
        PreventNegInventoryDefaultNo: Boolean;
        [InDataSet]
        TimeBucketEnable: Boolean;
        [InDataSet]
        SafetyLeadTimeEnable: Boolean;
        [InDataSet]
        SafetyStockQtyEnable: Boolean;
        [InDataSet]
        ReorderPointEnable: Boolean;
        [InDataSet]
        ReorderQtyEnable: Boolean;
        [InDataSet]
        MaximumInventoryEnable: Boolean;
        [InDataSet]
        MinimumOrderQtyEnable: Boolean;
        [InDataSet]
        MaximumOrderQtyEnable: Boolean;
        [InDataSet]
        OrderMultipleEnable: Boolean;
        [InDataSet]
        IncludeInventoryEnable: Boolean;
        [InDataSet]
        ReschedulingPeriodEnable: Boolean;
        [InDataSet]
        LotAccumulationPeriodEnable: Boolean;
        [InDataSet]
        DampenerPeriodEnable: Boolean;
        [InDataSet]
        DampenerQtyEnable: Boolean;
        [InDataSet]
        OverflowLevelEnable: Boolean;
        [InDataSet]
        StandardCostEnable: Boolean;
        [InDataSet]
        UnitCostEnable: Boolean;

    procedure EnableShowStockOutWarning()
    var
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        SalesSetup.Get;
        ShowStockoutWarningDefaultYes := SalesSetup."Stockout Warning";
        ShowStockoutWarningDefaultNo := not ShowStockoutWarningDefaultYes;
    end;

    procedure EnableShowShowEnforcePositivInventory()
    var
        InventorySetup: Record "Inventory Setup";
    begin
        InventorySetup.Get;
        PreventNegInventoryDefaultYes := InventorySetup."Prevent Negative Inventory";
        PreventNegInventoryDefaultNo := not PreventNegInventoryDefaultYes;
    end;

    local procedure EnablePlanningControls()
    var
        PlanningGetParam: Codeunit "Planning-Get Parameters";
        TimeBucketEnabled: Boolean;
        SafetyLeadTimeEnabled: Boolean;
        SafetyStockQtyEnabled: Boolean;
        ReorderPointEnabled: Boolean;
        ReorderQtyEnabled: Boolean;
        MaximumInventoryEnabled: Boolean;
        MinimumOrderQtyEnabled: Boolean;
        MaximumOrderQtyEnabled: Boolean;
        OrderMultipleEnabled: Boolean;
        IncludeInventoryEnabled: Boolean;
        ReschedulingPeriodEnabled: Boolean;
        LotAccumulationPeriodEnabled: Boolean;
        DampenerPeriodEnabled: Boolean;
        DampenerQtyEnabled: Boolean;
        OverflowLevelEnabled: Boolean;
    begin
        PlanningGetParam.SetUpPlanningControls("Reordering Policy", "Include Inventory",
          TimeBucketEnabled, SafetyLeadTimeEnabled, SafetyStockQtyEnabled,
          ReorderPointEnabled, ReorderQtyEnabled, MaximumInventoryEnabled,
          MinimumOrderQtyEnabled, MaximumOrderQtyEnabled, OrderMultipleEnabled, IncludeInventoryEnabled,
          ReschedulingPeriodEnabled, LotAccumulationPeriodEnabled,
          DampenerPeriodEnabled, DampenerQtyEnabled, OverflowLevelEnabled);

        TimeBucketEnable := TimeBucketEnabled;
        SafetyLeadTimeEnable := SafetyLeadTimeEnabled;
        SafetyStockQtyEnable := SafetyStockQtyEnabled;
        ReorderPointEnable := ReorderPointEnabled;
        ReorderQtyEnable := ReorderQtyEnabled;
        MaximumInventoryEnable := MaximumInventoryEnabled;
        MinimumOrderQtyEnable := MinimumOrderQtyEnabled;
        MaximumOrderQtyEnable := MaximumOrderQtyEnabled;
        OrderMultipleEnable := OrderMultipleEnabled;
        IncludeInventoryEnable := IncludeInventoryEnabled;
        ReschedulingPeriodEnable := ReschedulingPeriodEnabled;
        LotAccumulationPeriodEnable := LotAccumulationPeriodEnabled;
        DampenerPeriodEnable := DampenerPeriodEnabled;
        DampenerQtyEnable := DampenerQtyEnabled;
        OverflowLevelEnable := OverflowLevelEnabled;
    end;

    local procedure EnableCostingControls()
    begin
        StandardCostEnable := "Costing Method" = "Costing Method"::Standard;
        UnitCostEnable := "Costing Method" <> "Costing Method"::Standard;
    end;
}

