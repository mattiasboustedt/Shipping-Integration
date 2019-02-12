page 58000 "File Creation Log"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "File Creation Log";
    
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Id."; Id)
                {
                }

                field("Sales Shipment No."; "Sales Shipment No.")
                {
                    TableRelation = "Sales Shipment Header";
                    LookupPageId = "Posted Sales Shipment";
                }

                field("Created At"; "Created At")
                {
                }

                field("Json Created"; "Json Created")
                {
                }

                field("Json Data"; JsonData)
                {
                }

                field("POST:ed"; "POST:ed")
                {
                }
                field(Error;Error)
                {
                }
            }
        }
    }
    
    actions
    {
        area(Processing)
        {
            action("Save JSON")
            {
                Image = Process;

                trigger OnAction()
                var
                    FileHandler: Codeunit "File Handler";
                begin
                    FileHandler.Run(Rec);
                end;
            }
            action("Post Json")
            {
                Image = LaunchWeb;

                trigger OnAction();
                var
                    FileHandler: Codeunit "File Handler";
                    Response: Text;
                begin
                    Response := FileHandler.DoPostRequeset(Rec);
                    Message(Response);
                end;
            }
        }
    }

    local procedure SetCalculatedFields();
    var
        InStr: InStream;
        OutgoingText: BigText;
    begin
        CalcFields("Json Data");
        "Json Data".CreateInStream(InStr);
        OutgoingText.Read(InStr);

        if OutgoingText.Length > 0 then
            outgoingText.GetSubText(JsonData,1);

        Clear(OutgoingText);
        Clear(InStr);
    end;

    trigger OnAfterGetRecord();
    var
    begin
        SetCalculatedFields(); 
    end;

    var
        JsonData: Text;
}