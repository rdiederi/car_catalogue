$(document).ready(function() {
    $('#price').on('keypress', function(event) {
        if (event.keyCode == 8 || event.keyCode == 46 || event.keyCode == 9 || event.keyCode == 27 || event.keyCode == 13 ||
            (event.ctrlKey === true && (event.keyCode == 65 || event.keyCode == 67 || event.keyCode == 86 || event.keyCode == 88)) ||
            (event.keyCode >= 35 && event.keyCode <= 39)) {
        }
        if ((event.keyCode < 48 || event.keyCode > 57) && event.keyCode != 46) {
            event.preventDefault();
        }
    });

    $('#editPriceForm').submit(function(event) {
        var priceInput = $('#price').val().trim();
        var price = parseFloat(priceInput);
        var pricePattern = /^\d+(\.\d{1,2})?$/; 
        if (priceInput === '') {
            event.preventDefault();
            alert('The price field cannot be empty.');
            return false;
        }

        if (isNaN(price)) {
            event.preventDefault();
            alert('Please enter a valid number for the price.');
            return false;
        }

        if (price <= 0) {
            event.preventDefault(); 
            alert('The price must be a positive number.');
            return false;
        }

        if (!pricePattern.test(priceInput)) {
            event.preventDefault();
            alert('Please enter a valid price in the format 100, 100.50, etc.');
            return false;
        }

        return true; 
    });

    $('#price').on('input', function() {
        var price = $(this).val().trim();
        if (price !== '') {
            $('#pricePreview').text('Updated Price: ' + price);
        } else {
            $('#pricePreview').text('');
        }
    });
});
