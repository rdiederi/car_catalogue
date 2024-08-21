<?php
require 'includes/edit_price_logic.php';
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Price</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
</head>
<body>
    <?php include 'includes/header.php'; ?>
    <div class="container mt-5">
        <h2>Edit Price for <?= htmlspecialchars($car['name']) ?></h2>
        <form id="editPriceForm" method="POST">
            <input type="hidden" name="id" value="<?= $car['id'] ?>">
            <div class="form-group">
                <label for="price">Price</label>
                <input type="text" id="price" name="price" class="form-control" value="<?= htmlspecialchars($car['price']) ?>" required>
            </div>
            <div id="pricePreview" class="mt-2"></div> 
            <button type="submit" class="btn btn-primary">Save</button>
        </form>
    </div>
    <?php include 'includes/footer.php'; ?>
</body>
</html>