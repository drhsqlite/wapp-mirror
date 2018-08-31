# This application demonstrates responsive CSS design principles using
# the media-query mechanism.  To run this app:
#
#      wapptclsh mediaquery.tcl --server 8080
#
# Then connect various devices to see how their display changes according
# to the viewport size.  Or resize the browser window.  Or twist the
# handheld device between landscape and portrait modes.
#
# The foreground and background colors change according to the viewport size
# of the device.  In a real application, the CSS would be extended to make
# other changes according to the viewport size.
#
source wapp.tcl
proc wapp-default {} {
  wapp-content-security-policy {default_src 'self' 'unsafe-inline'}
  set top [wapp-param SCRIPT_NAME]
  wapp-trim {
    <!DOCTYPE html>
    <html>
    <head>
    <meta name="viewport" content="width=device-width,initial-scale=1.0">
    <link href="%url($top/style.css)" rel="stylesheet">
    </head>
    <body>
    <h1>Media Query Breakpoints</h1>
    <div class="media-bg">
    <p>Viewport-size: <span id="screen-size"></span>
    <ul>
    <li> Red:     width &lt;= 600
    <li> Orange:  600 &lt; width &lt;= 768
    <li> Yellow:  768 &lt; width &lt;= 992
    <li> Green:   992 &lt; width &lt;= 1200
    <li> Blue:    1200 &lt; width
    </ul>
    </div>
    </body>
    <script>
    function setwidth(){
      x = document.getElementById("screen-size");
      x.innerHTML = window.innerWidth + "px by "+window.innerHeight+"px"
    }
    window.onresize = setwidth;
    setwidth();
    </script>
    </html>
  }
}
proc wapp-page-style.css {} {
  wapp-mimetype text/css
  wapp-cache-control max-age=3600
  wapp-trim {
    @media screen and (max-width: 600px) {
      /* Smallest devices, small phones.  Less than 600px */
      .media-bg {background:red;color:white;}
    }
    @media screen and (min-width: 600px) {
      /* Large phones and tablets in portrait mode.  600px and up */
      .media-bg {background:orange;color:black;}
    }
    @media screen and (min-width: 768px) {
      /* landscape tablets.  768px and up */
      .media-bg {background:yellow;color:black;}
    }
    @media screen and (min-width: 992px) {
      /* laptops and desktops.  992px and up */
      .media-bg {background:green;color:white;}
    }
    @media screen and (min-width: 1200px) {
      /* wide-screen desktops.  1200px and up */
      .media-bg {background:blue;color:white;}
    }
  }
}
wapp-start $argv
