$(document).ready(function() {
    $('form').submit(function(event) {
        event.preventDefault();
        $.ajax({
            type: 'POST',
            url: 'edit_price.php',
            data: $(this).serialize(),
            success: function(response) {
                alert('Price updated successfully');
                window.location.href = 'car_list.php';
            }
        });
    });
});