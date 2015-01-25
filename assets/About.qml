import bb.cascades 1.2

Page {
    titleBar: TitleBar {
        title: "About"
    }
    Container {
        layout: DockLayout {}
    
        Container {
            id: aboutContent
            layout: StackLayout { orientation: LayoutOrientation.TopToBottom }
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center
            Label {
                text: "Lyrics Search"
                textStyle.fontSize: FontSize.XXLarge
                verticalAlignment: VerticalAlignment.Center
                horizontalAlignment: HorizontalAlignment.Center
                bottomMargin: 30
            }
            Label {
                text: "Created by Ryan Mahler"
                textStyle.fontSize: FontSize.Default
                verticalAlignment: VerticalAlignment.Center
                horizontalAlignment: HorizontalAlignment.Center
                bottomMargin: 30
            }
            Label {
                text: "Version " + app.getVersionNumber()
                textStyle.fontSize: FontSize.Small
                verticalAlignment: VerticalAlignment.Center
                horizontalAlignment: HorizontalAlignment.Center
                bottomMargin: 30
            }
            Button {
                text: "Contact / Help!"
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
                inputMode: TextAreaInputMode.Text
                textStyle.fontSize: FontSize.Default
                textStyle.textAlign: TextAlign.Center
                verticalAlignment: VerticalAlignment.Center
                horizontalAlignment: HorizontalAlignment.Center
                bottomMargin: 30
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
        }
    }
}