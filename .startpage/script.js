// @license magnet:?xt=urn:btih:1f739d935676111cfff4b4693e3816e664797050&dn=gpl-3.0.txt GPL-v3-or-Later

var DAYS = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']

function startTime() {
    var today = new Date();
    var h = today.getHours();
    var ampm = h >= 12 ? 'PM' : 'AM';
    var m = today.getMinutes();
    var s = today.getSeconds();
    m = checkTime(m);
    s = checkTime(s);
    var h = h % 12;
    var h = h ? h : 12; // the hour '0' should be '12'

    //---------------------

    var dow = DAYS[today.getDay()]
    var dd = ('0' + today.getDate()).slice(-2)
    var mm = ('0' + today.getMonth()).slice(-2)
    var yy = today.getFullYear()

    document.getElementById('date').innerHTML = dow + ' ' + yy + '-' + mm + '-' + dd

    //---------------------

    document.getElementById('time').innerHTML =
    h + ":" + m + ":" + s + ' ' + ampm;
    var t = setTimeout(startTime, 500);
}

function checkTime(i) {
   if (i < 10) {i = "0" + i};  // add zero in front of numbers < 10
   return i;
}

var n = document.getElementById("notes");
// retrieve (only on page load) 
if(window.localStorage){ n.value = localStorage.getItem("notes");}
// save 
var s = function(){localStorage.setItem("notes", n.value);}
// autosave onchange and every 500ms and when you close the window 
n.onchange = s();
setInterval( s, 500);
window.onunload = s();

var DAYS = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']

var dateElem = document.getElementById('date')

function DateComp(elem, date) {
    var dow = DAYS[date.getDay()]
    var dd = padNumber(2, date.getDate())
    var mm = padNumber(2, date.getMonth() + 1)
    var yy = padNumber(4, date.getFullYear())

    dateElem.innerHTML = dow + ' ' + yy + '-' + mm + '-' + dd
}

var vpwidth = document.documentElement.clientWidth
var sections = document.querySelectorAll('.box')
function fixSectionHeight() {
    var step = 1
    if (vpwidth >= 480) step = 2;
    if (vpwidth >= 768) step = 4;

    sections.forEach(function (s) {
        s.style.height = 'auto'
    })

    for (var i = 0; i < sections.length; i += step) {
        var ss = Array.prototype.slice.call(sections, i, i + step)
        var hss = ss.map(function (e) { return e.clientHeight })
        var h = Math.max.apply(null, hss)
        ss.forEach(function (s) {
            s.style.height = h + 'px'
        })
    }
}

fixSectionHeight()
window.addEventListener('resize', fixSectionHeight)

// @license-end
