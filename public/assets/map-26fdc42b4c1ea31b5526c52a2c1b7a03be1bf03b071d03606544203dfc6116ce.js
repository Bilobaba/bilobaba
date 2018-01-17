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

function showMap(zipCode){
    new google.maps.Geocoder().geocode( { 'address': String(zipCode) }, function(results, status) {
        if (status == 'OK') {
            initMap(results[0].geometry.location);
            google.maps.event.trigger(map, "resize");
        } else {
            alert('Geocode was not successful for the following reason: ' + status);
        }
    });
}
;
