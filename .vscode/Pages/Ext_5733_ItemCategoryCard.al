pageextension 50067 Ext_5733_ItemCategoryCard extends "Item Category Card"

{
    layout
    {
        // Add changes to page layout here
        addafter("Parent Category")
        {
            field("Def. Gen. Prod. Posting Group"; "Def. Gen. Prod. Posting Group")
            {
            }
            field("Def. Inventory Posting Group"; "Def. Inventory Posting Group")
            {
            }
            field("Def. VAT Prod. Posting Group"; "Def. VAT Prod. Posting Group")
            {
            }
            field("Def. Costing Method"; "Def. Costing Method")
            {
            }
            field("IC Code"; "IC Code")
            {
            }
            field("No Series"; "No Series")
            {
            }
            field("QA Enable"; "QA Enable")
            {
            }
            field("No2. Applicable"; "No2. Applicable")
            {
            }
            field("Starch Group"; "Starch Group")
            {
            }
            field("Def. Replenishment System"; "Def. Replenishment System")
            {
            }
            field("Def. Manufacturing Policy"; "Def. Manufacturing Policy")
            {
            }
            field("Def. Capital Item"; "Def. Capital Item")
            {
            }
            field("Def. Fixed Asset"; "Def. Fixed Asset")
            {
            }
            field("Roll ID Applicable"; "Roll ID Applicable")
            {
            }
            field("PO Quantity Variation %"; "PO Quantity Variation %")
            {
            }
            field("Available for Estimate Line"; "Available for Estimate Line")
            {
            }
            field("Plate Item"; "Plate Item")
            {
            }
            field("Tariff No."; "Tariff No.")
            {
            }
            field("Global Dimension 1 Code"; "Global Dimension 1 Code")
            {
            }
            field("Global Dimension 2 Code"; "Global Dimension 2 Code")
            {
            }
            field("Reordering Policy"; "Reordering Policy")
            {
            }
            field("Minimum Order Quantity"; "Minimum Order Quantity")
            {
            }
            field("Maximum Order Quantity"; "Maximum Order Quantity")
            {
            }
            field("Safety Stock Quantity"; "Safety Stock Quantity")
            {
            }
            field("Order Multiple"; "Order Multiple")
            {
            }
            field("Maximum Inventory"; "Maximum Inventory")
            {
            }
            field("Reorder Quantity"; "Reorder Quantity")
            {
            }
        }
    }

    actions
    {
        addafter(Delete)
        {
            action("&Prod. Groups")
            {
                Caption = '&Prod. Groups';
                Image = ItemGroup;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Product Groups";
                RunPageLink = "Item Category Code" = FIELD (Code);
            }
            action("Category Attribute Setup")
            {
                Caption = 'Category Attribute Setup';
                Image = Category;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Item Category Attribute Setup";
                RunPageLink = "Item Category Code" = FIELD (Code);
                RunPageView = SORTING ("Item Category Code", "Item Attribute");
            }
            action("Item Attribute Master")
            {
                Caption = 'Item Attribute Master';
                Image = AssemblyOrder;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Item Attribute";
            }
        }
    }
}