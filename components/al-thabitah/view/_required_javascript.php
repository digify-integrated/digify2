<!-- javascript libraries -->
<script src="./components/al-thabitah/assets/js/jquery.js"></script>
<script src="./components/al-thabitah/assets/js/vendors.min.js"></script>
<script src="./components/al-thabitah/assets/js/main.js?v=<?php echo rand(); ?>"></script>
<script src="./components/al-thabitah/assets/js/functions.js?v=<?php echo rand(); ?>"></script>

<?php
    if(isset($_GET['page']) && !empty($_GET['page'])){
        $page = $_GET['page'];

        switch ($page) {
            case 'booking':
                echo '<script src="./assets/libs/jquery-validation/dist/jquery.validate.min.js"></script>
                      <script src="./components/global/js/global.js?v='. rand() .'"></script>
                      <script src="./assets/libs/sweetalert2/dist/sweetalert2.min.js"></script>
                      <script src="./components/al-thabitah/assets/js/booking.js?v='. rand() .'"></script>';
             break;
            case 'contact_us':
                echo '<script src="./assets/libs/jquery-validation/dist/jquery.validate.min.js"></script>
                      <script src="./components/global/js/global.js?v='. rand() .'"></script>
                      <script src="./assets/libs/sweetalert2/dist/sweetalert2.min.js"></script>
                      <script src="./components/al-thabitah/assets/js/contact-us.js?v='. rand() .'"></script>';
                break;
        }
    }
?>