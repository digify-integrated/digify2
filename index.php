<?php
    require('components/global/config/config.php');
    require('components/global/model/database-model.php');
    require('components/block-style/model/block-style-model.php');
    
    $databaseModel = new DatabaseModel();
    $blockStyleModel = new BlockStyleModel($databaseModel);
?>

<!DOCTYPE html>
<html class="no-js" lang="en">
    <?php require_once('./components/al-thabitah/view/_head.php'); ?>
    <body data-mobile-nav-style="classic">
        <div class="page-loader"></div>
        <?php 
            require_once('./components/al-thabitah/view/_header.php'); 
        
            if(isset($_GET['page']) && !empty($_GET['page'])){
                $page = $_GET['page'];

                switch ($page) {
                    case 'about_us':
                        require_once('./components/al-thabitah/page/_about_us.php');
                        break;
                    case 'our_services':
                        require_once('./components/al-thabitah/page/_our_services.php');
                        break;
                    case 'house_cleaning':
                        require_once('./components/al-thabitah/page/_house_cleaning.php');
                        break;
                    case 'office_cleaning':
                        require_once('./components/al-thabitah/page/_office_cleaning.php');
                        break;
                    case 'kitchen_cleaning':
                        require_once('./components/al-thabitah/page/_kitchen_cleaning.php');
                        break;
                    case 'water_tank_cleaning':
                        require_once('./components/al-thabitah/page/_water_tank_cleaning.php');
                        break;
                    case 'window_cleaning':
                        require_once('./components/al-thabitah/page/_window_cleaning.php');
                        break;
                    case 'sofa_cleaning':
                        require_once('./components/al-thabitah/page/_sofa_cleaning.php');
                        break;
                    case 'carpet_cleaning':
                        require_once('./components/al-thabitah/page/_carpet_cleaning.php');
                        break;
                    case 'mattress_cleaning':
                        require_once('./components/al-thabitah/page/_mattress_cleaning.php');
                        break;
                    case 'curtain_cleaning':
                        require_once('./components/al-thabitah/page/_curtain_cleaning.php');
                        break;
                    case 'plumbing_service':
                        require_once('./components/al-thabitah/page/_plumbing_service.php');
                        break;
                    case 'pest_control_service':
                        require_once('./components/al-thabitah/page/_pest_control_service.php');
                        break;
                    case 'booking':
                        require_once('./components/al-thabitah/page/_booking.php');
                        break;
                    case 'contact_us':
                        require_once('./components/al-thabitah/page/_contact_us.php');
                        break;
                    default:
                        require_once('./components/al-thabitah/page/404.php');
                        break;
                }
            }
            else{
                require_once('./components/al-thabitah/page/_home.php');
            }
            
            require_once('./components/al-thabitah/view/_footer.php'); 
            require_once('./components/al-thabitah/view/_required_javascript.php'); 
        ?>
        
    </body>
</html>