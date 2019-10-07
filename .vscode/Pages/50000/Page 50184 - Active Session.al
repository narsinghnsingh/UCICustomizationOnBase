page 50184 "Active Session"
{
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Active Session";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Server Computer Name"; "Server Computer Name")
                {
                }
                field("User ID"; "User ID")
                {
                }
                field("Client Type"; "Client Type")
                {
                }
                field("Client Computer Name"; "Client Computer Name")
                {
                }
                field("Login Datetime"; "Login Datetime")
                {
                }
                field("Database Name"; "Database Name")
                {
                }
            }
        }
    }

    actions
    {
    }
}

