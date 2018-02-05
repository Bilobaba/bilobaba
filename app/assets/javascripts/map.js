var autocomplete, map;

function showMap(lat, lng, address) {
    latlng = new google.maps.LatLng({lat: lat, lng: lng}); 

    map = new google.maps.Map($("#map")[0], {
        center: latlng,
        zoom: 12
    });

    var marker = new google.maps.Marker({
        position: latlng,
        map: map
    });

    google.maps.event.trigger(map, "resize");
}


function initAutocomplete() {
    if(typeof google == 'undefined' || !document.getElementById('event_address')) {
        return;
    }

    var input = document.getElementById('event_address');
    var options = {
        bounds: new google.maps.LatLngBounds(
            new google.maps.LatLng(48.6, 1.9),
            new google.maps.LatLng(49.2, 2.9)
        ),
        componentRestrictions: {country: 'fr'}
        //, types: ['establishment']
    };

    autocomplete = new google.maps.places.Autocomplete(input, options);
    autocomplete.addListener('place_changed', fillInLatLng);
}

function fillInLatLng() {
    var place = autocomplete.getPlace();
    document.getElementById('event_lat').value = place.geometry.location.lat();
    document.getElementById('event_lng').value = place.geometry.location.lng();
    for (var i = 0; i < place.address_components.length; i++) {
        switch (place.address_components[i].types[0]) {
        case 'locality':
            document.getElementById('event_city').value = place.address_components[i].long_name;
            break;
        case 'postal_code':
            document.getElementById('event_zip').value = place.address_components[i].long_name;
            break;
        }
    }
}
