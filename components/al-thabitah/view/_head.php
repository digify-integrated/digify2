<head>
        <title>Al Thabitah</title>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="author" content="ThemeZaa">
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
