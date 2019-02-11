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

            action("Display Json")
            {
                Image = ShowSelected;

                trigger OnAction()
                var
                    StreamIn: InStream;
                    JsonText: Text;
                begin
                    CalcFields(Rec."Json Data");
                    if Rec."Json Data".HasValue then begin
                        Rec."Json Data".CreateInStream(StreamIn);
                        StreamIn.Read(JsonText);
                        Message(JsonText);
                    end;
                end;
            }
        }
    }
}