import bb.cascades 1.2

Sheet {
    id: aboutSheet
    onClosed: {
        aboutSheet.destroy();
    }
    
    Page {
        titleBar: TitleBar {
            title: "About"
            dismissAction: ActionItem {
                title: "Back"
                onTriggered: {
                    aboutSheet.close();
                }
            }
        }
        attachedObjects: [
            Invocation {
                id: emailInvoke
                query.mimeType: "text/plain"
                query.invokeTargetId: "sys.pim.uib.email.hybridcomposer"
                query.invokeActionId: "bb.action.SENDEMAIL"
                onArmed: {
                    emailInvoke.trigger(emailInvoke.query.invokeActionId);
                }
            }
        ]
        
        Container {
            layout: DockLayout {}
            
            Container {
                id: aboutContent
                layout: StackLayout { orientation: LayoutOrientation.TopToBottom }
                verticalAlignment: VerticalAlignment.Center
                horizontalAlignment: HorizontalAlignment.Center
                
                Label {
                    text: "Lyrics Search"
                    textStyle.fontSize: FontSize.XLarge
                    verticalAlignment: VerticalAlignment.Center
                    horizontalAlignment: HorizontalAlignment.Center
                    bottomMargin: 30
                }
                Label {
                    text: "Created by Ryan Mahler"
                    verticalAlignment: VerticalAlignment.Center
                    horizontalAlignment: HorizontalAlignment.Center
                    bottomMargin: 30
                }
                Label {
                    text: "Version " + app.getVersionNumber()
                    verticalAlignment: VerticalAlignment.Center
                    horizontalAlignment: HorizontalAlignment.Center
                    bottomMargin: 30
                }
                Button {
                    text: "Contact"
                    verticalAlignment: VerticalAlignment.Center
                    horizontalAlignment: HorizontalAlignment.Center
                    bottomMargin: 30
                    onClicked: {
                        emailInvoke.query.uri = "mailto:ryantmer@gmail.com?subject=Lyrics%20Search%20Help";
                        emailInvoke.query.updateQuery();
                    }
                }
                TextArea {
                    text: "http://www.mahler.ca"
                    editable: false
                    textStyle.textAlign: TextAlign.Center
                    bottomMargin: 30
                }
            }
        }
    }
}