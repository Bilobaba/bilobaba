var map;

function initMap() {
    var myLatlng = new google.maps.LatLng(40, 0);
    map = new google.maps.Map($("#map")[0], {
        center: myLatlng,
        zoom: 5
    });
    var marker = new google.maps.Marker({
        position: myLatlng,
        map: map
    });
    var infowindow = new google.maps.InfoWindow({
        content: 'ici'
    });
    marker.addListener('click', function() {
        infowindow.open(map, marker);
    });
}

function showMap() {
    var boxWidth = $(window).width() / 2,
    boxHeight = $(window).height() / 2;
    boxLeft = boxWidth - (boxWidth / 2),
    boxTop = boxHeight - (boxHeight / 2);

    $('#map').css({
        width: boxWidth, height: boxHeight,
        top: boxTop, left: boxLeft
    });
    
    $('#map_close').css({
        width: boxWidth,
        top: boxTop, left: boxLeft
    });

    $('#map').show();
    $('#map_close').show();
}

function hideMap() {
    $('#map').hide();
    $('#map_close').hide();
}

$( document ).ready(function() {
    $('#map').on('focusout', function() {
        hideMap();
    })
    
    $('#map_close').click(function() {
        hideMap();
    })
    
    $('.location').click(function(){
        showMap();
        initMap();
    })
});
