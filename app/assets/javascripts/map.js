var map;

function initMap(latlng) {
    map = new google.maps.Map($("#map")[0], {
        center: latlng,
        zoom: 12
    });
    var marker = new google.maps.Marker({
        position: latlng,
        map: map
    });
    var infowindow = new google.maps.InfoWindow({
        content: 'ici'
    });
    marker.addListener('click', function() {
        infowindow.open(map, marker);
    });
}

function buildMap() {
    var boxWidth = $(window).width() / 2,
    boxHeight = $(window).height() / 2;
    boxLeft = boxWidth - (boxWidth / 2),
    boxTop = scrollY + boxHeight - (boxHeight / 2);

    $('#map_container').css({
        top: boxTop, left: boxLeft
    });

    $('#map').css({
        width: boxWidth, height: boxHeight
    });
    
    $('#map_close').css({
        width: boxWidth
    });

    $('#map_container').show();
}

function hideMap() {
    $('#map_container').hide();
}

function showMap(zipCode){
    buildMap();
    new google.maps.Geocoder().geocode( { 'address': String(zipCode) }, function(results, status) {
        if (status == 'OK') {
            initMap(results[0].geometry.location);
        } else {
            alert('Geocode was not successful for the following reason: ' + status);
        }
    });
}
