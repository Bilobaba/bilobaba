var map;

function showMap(lat, lng) {
    latlng = new google.maps.LatLng({lat: lat, lng: lng}); 

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

    google.maps.event.trigger(map, "resize");
}
