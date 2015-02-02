import bb.cascades 1.2

Page {
    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.TopToBottom
        }
        topPadding: 20
        leftPadding: 20
        rightPadding: 20
        bottomPadding: 20
        
        Label {
            text: "Search Results"
            horizontalAlignment: HorizontalAlignment.Center
            textStyle.fontSize: FontSize.XXLarge
        }
        
        Container {
            id: activityContainer
            objectName: "activityContainer"
            visible: true
            
            horizontalAlignment: HorizontalAlignment.Center
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
            
            ActivityIndicator {
                visible: true
                running: true
                preferredHeight: 100
            }
            Label {
                text: "Searching..."
                verticalAlignment: VerticalAlignment.Center
            }
        }
        
        ListView {
            id: searchResultsListView
            objectName: "searchResultsListView"
            layout: StackListLayout {}
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            
            dataModel: searchResultsDataModel
            
            listItemComponents: [
                ListItemComponent {
                    Container {
                        topPadding: 20
                        leftPadding: 20
                        rightPadding: 20
                        bottomPadding: 20
                        layout: StackLayout {
                            orientation: LayoutOrientation.TopToBottom
                        }
                        Label {
                            text: ListItemData.album + "(" + ListItemData.year + ")"
                            textStyle.fontSize: FontSize.XLarge
                            textFormat: TextFormat.Html
                        }
                        Label {
                            multiline: true
                            text: ListItemData.songs
                        }
                    }
                }
            ]
            
            onTriggered: {
                var data = dataModel.data(indexPath);
                if (data.url == "") {
                    return;
                }
                var page = viewLyricsDef.createObject();
                page.data = data;
                page.setup();
                navigationPane.push(page);
            }
        }
    }
    
    attachedObjects: [
        ComponentDefinition {
            id: viewLyricsDef
            content: ViewLyrics {}
        }
    ]
}
