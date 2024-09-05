<!--Start of Tawk.to Script-->
<script type="text/javascript">
var Tawk_API=Tawk_API||{}, Tawk_LoadStart=new Date();
(function(){
var s1=document.createElement("script"),s0=document.getElementsByTagName("script")[0];
s1.async=true;
s1.src='https://embed.tawk.to/66c087840cca4f8a7a771215/1i5g12nb6';
s1.charset='UTF-8';
s1.setAttribute('crossorigin','*');
s0.parentNode.insertBefore(s1,s0);
})();
</script>
<!--End of Tawk.to Script-->

<?php

require('components/global/config/config.php');
require('components/global/model/database-model.php');
require('components/block-style/model/block-style-model.php');
require('components/footer/model/footer-model.php');

$databaseModel = new DatabaseModel();
$blockStyleModel = new BlockStyleModel($databaseModel);
$footerModel = new FooterModel($databaseModel);

$getFooterDetails = $footerModel->getFooter(3);
$footerBlockStyle = $getFooterDetails['block_style_id'];

$footerBlockStyleDetails = $blockStyleModel->getBlockContainer($footerBlockStyle);

echo $footerBlockStyleDetails['block_container'] ?? null;

?>
<!-- start footer -->
        <footer class="bg-dark-gray background-position-center-top pb-2" style="background-image: url('./components/al-thabitah/assets/images/footer-dot.svg')"> 
            <div class="container overlap-section">
                <div class="row g-0 justify-content-center align-items-center bg-base-color border-radius-6px ps-7 pe-7 pt-4 pb-4 lg-p-30px sm-p-20px mb-7">
                    <div class="col-lg-6 col-md-9 text-center text-lg-start md-mb-20px">
                        <h4 class="text-white fw-600 mb-0 ls-minus-1px">Let’s talk about how we can refresh your space!</h4>
                    </div>
                    <div class="col-auto col-lg-5 icon-with-text-style-08 offset-lg-1">
                        <div class="feature-box feature-box-left-icon-middle overflow-hidden">
                            <div class="feature-box-icon feature-box-icon-rounded w-80px h-80px rounded-circle bg-dark-gray-transparent-light me-25px lg-me-20px">
                                <i class="bi bi-envelope icon-very-medium text-white"></i>
                            </div>
                            <div class="feature-box-content last-paragraph-no-margin">
                                <span class="text-white fs-18 lh-22 mb-5px d-block">Interested in working?</span>
                                <h6 class="d-inline-block fw-600 mb-0"><a href="javascript:void(0);" class="text-dark-gray text-decoration-line-bottom-medium text-white-hover">contact@althabitah.com</a></h6> 
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="container footer-dark text-center text-sm-start"> 
                <div class="row mb-5 sm-mb-30px">
                    <!-- start footer column -->
                    <div class="col-lg-3 col-md-4 col-sm-6 d-flex flex-column last-paragraph-no-margin md-mb-35px">
                        <a href="index.php" class="footer-logo mb-25px xs-mb-20px d-inline-block">
                            <img src="./components/al-thabitah/assets/images/logo.png" data-at2x="./components/al-thabitah/assets/images/logo.png" alt="">
                        </a>
                        <p class="lh-30 w-90 xl-w-100 mx-lg-auto mx-xl-0">Transforming your space with innovative cleaning solutions.</p>
                        <div class="elements-social social-icon-style-02 mt-20px xs-mt-15px">
                            <ul class="medium-icon">
                                <li class="my-0"><a class="facebook" href="https://www.facebook.com/profile.php?id=100095104812245&mibextid=LQQJ4d" target="_blank"><i class="fa-brands fa-facebook-f"></i></a></li>
                                <li class="my-0"><a class="youtube" href="https://www.youtube.com/channel/UCbzw6RiqwngeeruQwGi58-A" target="_blank"><i class="fa-brands fa-youtube"></i></a></li> 
                                <li class="my-0"><a class="instagram" href="https://www.instagram.com/althabitah.cleaningservices/" target="_blank"><i class="fa-brands fa-instagram"></i></a></li> 
                                <li class="my-0"><a class="tiktok" href="https://www.tiktok.com/@althabitahcleaningservic?_t=8ohEkhilfXA&_r=1" target="_blank"><i class="fa-brands fa-tiktok"></i></a></li> 
                                <li class="my-0"><a class="whatsapp" href="https://wa.me/971561652741" target="_blank"><i class="fa-brands fa-whatsapp"></i></a></li> 
                            </ul>
                        </div>
                    </div>
                    <!-- end footer column -->  
                    <!-- start footer column -->
                    <div class="col-lg-3 col-md-4 col-sm-6 last-paragraph-no-margin md-mb-35px"> 
                        <span class="fs-16 fw-500 d-block text-white mb-5px">Address</span>
                        <p class="w-85 lg-w-95 xs-w-60 xs-mx-auto mb-10px">Al Rashidiya 2, Al Kaabi Building, Ajman</p> 
                        <div class="d-inline-block"><i class="bi bi-telephone-outbound me-10px text-white align-middle"></i><a href="tel:1234567890">123 456 7890</a></div> 
                    </div>
                    <!-- end footer column -->
                    <!-- start footer column -->
                    <div class="col-lg-3 col-md-4 col-sm-6 last-paragraph-no-margin md-mb-35px"> 
                        <span class="fs-17 fw-500 d-block text-white mb-5px">Our Services</span>
                        <ul>                           
                            <li><a href="house-cleaning.php">House Cleaning</a></li>
                            <li><a href="office-cleaning.php">Office Cleaning</a></li>
                            <li><a href="kitchen-cleaning.php">Kitchen Cleaning</a></li>
                            <li><a href="water-tank-cleaning.php">Water Tank Cleaning</a></li>
                            <li><a href="window-cleaning.php">Window Cleaning</a></li>
                            <li><a href="plumbing-service.php">Plumbing Service</a></li>
                        </ul>
                    </div>
                    <!-- end footer column -->
                    <!-- start footer column -->
                    <div class="col-lg-3 col-md-4 col-sm-6 last-paragraph-no-margin md-mb-35px"> 
                        <span class="fs-17 fw-500 d-block text-white mb-5px">Our Services</span>
                        <ul>                           
                            <li><a href="pest-control-service.php">Pest Control Service</a></li>
                            <li><a href="sofa-cleaning.php">Sofa Cleaning</a></li>
                            <li><a href="carpet-cleaning.php">Carpet Cleaning</a></li>
                            <li><a href="mattress-cleaning.php">Mattress Cleaning</a></li>
                            <li><a href="curtain-cleaning.php">Curtain Cleaning</a></li>
                        </ul>
                    </div>
                    <!-- end footer column -->
                </div> 
                <div class="row align-items-center footer-bottom border-top border-color-transparent-white-light pt-30px g-0">
                    <!-- start footer menu -->
                    <div class="col-lg-7 ps-0 text-center text-lg-start md-mb-10px"> 
                        <ul class="footer-navbar fs-15 lh-normal"> 
                            <li class="nav-item active"><a href="index.php" class="nav-link ps-0">Home</a></li>
                            <li class="nav-item"><a href="about-us.php" class="nav-link">About Us</a></li>
                            <li class="nav-item"><a href="our-services.php" class="nav-link">Our Services</a></li>
                            <li class="nav-item"><a href="booking.php" class="nav-link">Book Now</a></li>
                            <li class="nav-item"><a href="contact-us.php" class="nav-link">Contact Us</a></li>
                        </ul>
                    </div> 
                    <!-- end footer menu -->
                    <!-- start copyright -->
                    <div class="col-lg-5 last-paragraph-no-margin text-center text-lg-end">
                        <p class="fs-15">&copy; 2024 Al Thabitah Cleaning Services And Building Maintenance</p>
                    </div>
                    <!-- start copyright -->
                </div>
            </div>    
        </footer>
        <!-- end footer -->

        <!-- start scroll progress -->
        <div class="scroll-progress d-none d-xxl-block">
            <a href="#" class="scroll-top" aria-label="scroll">
                <span class="scroll-text">Scroll</span><span class="scroll-line"><span class="scroll-point"></span></span>
            </a>
        </div>
        <!-- end scroll progress -->

        <div class="theme-demos" style="display: block;">
            <div class="demo-button-wrapper">
                <div class="buy-theme social-whatsapp">
                    <a href="https://wa.me/971561652741" target="_blank">
                        <div class="theme-wrapper">
                            <div>
                                <i class="fa-brands whatsapp fa-whatsapp text-light fs-15 me-0"></i>
                            </div>
                        </div>
                    </a>
                </div>
            </div>
            <span class="close-popup fs-22 text-dark-gray w-40px h-40px d-flex justify-content-center align-items-center"><i class="fa-solid fa-xmark"></i></span>
        </div>
