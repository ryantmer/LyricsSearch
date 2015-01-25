import bb.cascades 1.2

Page {
    property variant data
    
    function setup() {
        webView.url = data["url"];
    }
    
    Container {
        layout: DockLayout {}
        
        ActivityIndicator {
            id: activity
            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Center
            preferredHeight: 100
        }
        
        ScrollView {
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            id: scrollView
            objectName: "scrollView"
            scrollViewProperties.pinchToZoomEnabled: false
            scrollViewProperties.scrollMode: ScrollMode.Vertical
            
            WebView {
                id: webView
                
                onLoadingChanged: {
                    if (loadRequest.status == WebLoadStatus.Started) {
                        activity.start();
                        activity.visible = true;
                        webView.opacity = 0.1;
                    } else if (loadRequest.status == WebLoadStatus.Succeeded) {
                        webView.evaluateJavaScript(
                            "var head = document.getElementsByTagName('head')[0];" +
                            "head.innerHTML = '';" +
                            "var header = document.getElementById('wkMainCntHdr').getElementsByTagName('h1')[0];" +
                            "var lyrics = document.getElementsByClassName('lyricbox')[0];" +
                            "var body = document.getElementsByTagName('body')[0];" +
                            "body.innerHTML = '';" +
                            "body.appendChild(header);" +
                            "body.appendChild(lyrics);"
                            );
                        activity.stop();
                        activity.visible = false;
                        webView.opacity = 1.0;
                    }
                }
            }
        }
    }
    
    actions: [
        ActionItem {
            title: "Add Favourite"
            imageSource: "asset:///images/favourite.png"
            ActionBar.placement: ActionBarPlacement.OnBar
            
            onTriggered: {
                app.addFavourite(data);
            }
        }
    ]
}
