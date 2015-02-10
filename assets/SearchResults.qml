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
            
            dataModel: resultsDataModel
            
            listItemComponents: [
                ListItemComponent {
                    Container {
                        id: itemContainer
                        topPadding: 20
                        leftPadding: 20
                        rightPadding: 20
                        bottomPadding: 20
                        layout: StackLayout {
                            orientation: LayoutOrientation.TopToBottom
                        }
                        Label {
                            text: itemContainer.ListItem.view.titleText(ListItemData)
                            textStyle.fontSize: FontSize.XLarge
                            textFormat: TextFormat.Html
                        }
                        Label {
                            visible: itemContainer.ListItem.view.subtitleText(ListItemData) != ""
                            text: itemContainer.ListItem.view.subtitleText(ListItemData)
                            multiline: true
                        }
                    }
                }
            ]
            
            function titleText(data) {
                if (data.type == "album") {
                    return "<b><em>" + data.album + "</em> (" + data.year + ")</b>";
                } else if (data.type == "song") {
                    return "<em>" + data.song + "</em> - " + data.artist;
                } else {
                    console.log("Unknown result type: " + data.type);
                }
            }
            
            function subtitleText(data) {
                if (data.type == "album") {
                    return "Album by " + data.artist;
                } else if (data.type == "song") {
                    return data.lyrics;
                } else {
                    console.log("Unknown result type: " + data.type);
                }
            }
            
            onTriggered: {
                var data = dataModel.data(indexPath);
                if (!data.url) {
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
