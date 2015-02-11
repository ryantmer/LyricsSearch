import bb.cascades 1.2

Page {
    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.TopToBottom
        }
        
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
            layout: StackListLayout {
                headerMode: ListHeaderMode.Sticky
            }
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            
            dataModel: resultsModel
            
            listItemComponents: [
                ListItemComponent {
                    type: "item"
                    Container {
                        id: itemContainer
                        StandardListItem {
                            title: ListItemData.song
                            description: itemContainer.ListItem.view.subtitleText(ListItemData)
                        }
                    }
                },
                ListItemComponent {
                    type: "header"
                    Header {
                        title: ListItemData.album
                        subtitle: ListItemData.year
                    }
                }
            ]
            
            function subtitleText(data) {
                if (data.lyrics) {
                    if (data.lyrics.indexOf("\n") > -1) {
                        return data.lyrics.substring(0, data.lyrics.indexOf("\n")) + "...";
                    } else {
                        return data.lyrics;
                    }
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
