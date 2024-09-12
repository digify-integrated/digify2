<head>
    <title>Al Thabitah Cleaning Services - Top Cleaning Company in UAE | Cleaning Ajman</title>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="author" content="Al-Thabitah">
    <meta name="description" content="Al Thabitah Cleaning Services offers professional cleaning solutions in UAE, including Ajman. Book now for residential, commercial, and deep cleaning services!">
    <meta name="keywords" content="cleaning company UAE, cleaning Ajman, cleaning services UAE, professional cleaners UAE, house cleaning UAE, office cleaning UAE, deep cleaning UAE, residential cleaning UAE, commercial cleaning UAE, eco-friendly cleaning UAE, sofa cleaning services UAE, carpet cleaning UAE, window cleaning UAE, upholstery cleaning UAE, move-in cleaning UAE, move-out cleaning UAE, sanitization services UAE, post-construction cleaning UAE, end of tenancy cleaning UAE, reliable cleaners UAE, best cleaning company UAE, affordable cleaning services UAE, urgent cleaning services Ajman, same day cleaning UAE, maid service UAE, housekeeping service UAE, part-time cleaners UAE">
    <meta property="og:title" content="Al Thabitah Cleaning Services - Best Cleaning Company in UAE">
    <meta property="og:description" content="Looking for top-notch cleaning services in UAE? Contact Al Thabitah for residential, commercial, and deep cleaning.">
    <meta property="og:image" content="./components/al-thabitah/assets/images/logo-02.png">
    <meta property="og:url" content="https://www.althabitah.com">
    <meta property="og:type" content="website">
    <meta name="viewport" content="width=device-width,initial-scale=1.0" />
    <!-- favicon icon -->
    <link rel="shortcut icon" href="./components/al-thabitah/assets/images/logo-02.png">
    <!-- google fonts preconnect -->
    <link rel="preconnect" href="https://fonts.googleapis.com" crossorigin>
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <!-- style sheets and font icons  -->
    <link rel="stylesheet" href="./components/al-thabitah/assets/css/vendors.min.css"/>
    <link rel="stylesheet" href="./components/al-thabitah/assets/css/icon.min.css"/>
    <link rel="stylesheet" href="./components/al-thabitah/assets/css/style.min.css"/>
    <link rel="stylesheet" href="./components/al-thabitah/assets/css/responsive.min.css"/>
    <link rel="stylesheet" href="./components/al-thabitah/assets/css/styles.css"/>
    <?php
        if(isset($_GET['page']) && !empty($_GET['page'])){
            $page = $_GET['page'];
        
            switch ($page) {
                case 'booking':
                case 'contact_us':
                    echo '<link rel="stylesheet" href="./assets/libs/sweetalert2/dist/sweetalert2.min.css">';
                    break;
            }
        }
    ?>
</head>
