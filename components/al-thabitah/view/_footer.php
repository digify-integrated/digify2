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

require('components/footer/model/footer-model.php');


$footerModel = new FooterModel($databaseModel);

$getFooterDetails = $footerModel->getFooter(1);
$footerBlockStyle = $getFooterDetails['block_style_id'] ?? null;

$footerBlockStyleDetails = $blockStyleModel->getBlockContainer($footerBlockStyle);

echo $footerBlockStyleDetails['block_container'] ?? null;

?>


<!-- start scroll progress -->
<div class="scroll-progress d-none d-xxl-block">
    <a href="#" class="scroll-top" aria-label="scroll">
        <span class="scroll-text">Scroll</span><span class="scroll-line"><span class="scroll-point"></span></span>
    </a>
</div>
<!-- end scroll progress -->

<div class="theme-demos" style="display: block;">
    <div class="demo-button-wrapper demo-button-wrapper-normal">
        <div class="buy-theme social-whatsapp">
            <a href="https://wa.me/971561652741" target="_blank">
                <div class="theme-wrapper">
                    <div>
                        <i class="fa-brands whatsapp fa-whatsapp text-light fs-15 me-0 buy-theme-normal"></i>
                    </div>
                </div>
            </a>
        </div>
        <div class="buy-theme social-tiktok">
            <a href="https://www.tiktok.com/@althabitahcleaningservic?_t=8ohEkhilfXA&_r=1" target="_blank">
                <div class="theme-wrapper">
                    <div>
                        <i class="fa-brands instagrap fa-tiktok text-light fs-15 me-0 buy-theme-normal"></i>
                    </div>
                </div>
            </a>
        </div>
        <div class="buy-theme social-instagram">
            <a href="https://www.instagram.com/althabitah.cleaningservices/" target="_blank">
                <div class="theme-wrapper">
                    <div>
                        <i class="fa-brands instagram fa-instagram text-light fs-15 me-0 buy-theme-normal"></i>
                    </div>
                </div>
            </a>
        </div>
        <div class="buy-theme social-youtube">
            <a href="https://www.youtube.com/channel/UCbzw6RiqwngeeruQwGi58-A" target="_blank">
                <div class="theme-wrapper">
                    <div>
                        <i class="fa-brands youtube fa-youtube text-light fs-15 me-0 buy-theme-normal"></i>
                    </div>
                </div>
            </a>
        </div>
        <div class="buy-theme social-facebook">
            <a href="https://www.facebook.com/profile.php?id=100095104812245&mibextid=LQQJ4d" target="_blank">
                <div class="theme-wrapper">
                    <div>
                        <i class="fa-brands whatsapp fa-facebook text-light fs-15 me-0 buy-theme-normal"></i>
                    </div>
                </div>
            </a>
        </div>
    </div>
</div>