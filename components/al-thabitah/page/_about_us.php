<?php
    require('components/page-title/model/page-title-model.php');

    $pageTitleModel = new PageTitleModel($databaseModel);

    require_once('page_components/about-us/_about_us_page_title.php');
?>

        <!-- start section -->
        <section class="border-bottom border-color-extra-medium-gray">
            <div class="container">
                <div class="row align-items-center justify-content-center">
                    <div class="col-xl-7 col-lg-6 md-mb-9 sm-mb-50px" data-anime='{ "el": "childs", "translateY": [50, 0], "opacity": [0,1], "duration": 600, "delay": 0, "staggervalue": 100, "easing": "easeOutQuad" }'>
                        <span class="fs-18 lh-22 fw-700 mb-15px d-inline-block text-uppercase text-dark-gray border-bottom border-2 border-color-base-color" style="">About Us</span>
                        <h1 class="alt-font fw-600 text-dark-gray ls-minus-2px mb-35px shadow-none" data-shadow-animation="true" data-animation-delay="700">Our services are <span class="text-highlight">unparalleled<span class="bg-base-color h-10px sm-h-8px bottom-20px md-bottom-17px opacity-5 separator-animation"></span></span></h1>
                        <div class="row">
                            <div class="col-lg-12 col-md-6 mb-25px last-paragraph-no-margin">
                                <p class="w-85 md-w-95 sm-w-100">At Al thabitah we are there for you; before, During and after the service. Our goal is to meet and Exceed your expectations, You can rely on us, and trust All of your home service needs to Al thabitah. If you are ever not satisfied with a service, we will Be there to make it right, Schedule your service Wherever you are connected. You can instantly schedule a A service when it is convenient for you and get a Confirmation that same day,simply enter in your information and We will get back to you with the Availability of your request.</p>
                            </div>
                            <div class="col-lg-12 col-md-6 mb-25px last-paragraph-no-margin">
                                <p class="w-85 md-w-95 sm-w-100">The company was given the name (AL THABITAH) in line with the pandemic that the world has experienced, which means steadfastness in the face of difficulties, and our goal is your satisfaction. We provide the best services with quality standards, and our suitability is not the best, but we are distinguished, and our goal is your satisfaction.</p>
                            </div>
                        </div>
                        <a href="althabitah.php?page=our_services" class="btn btn-large btn-dark-gray btn-box-shadow fw-400 btn-round-edge mt-10px md-mt-0">Our services</a>
                    </div>
                    <div class="col-xl-4 offset-xl-1 col-lg-6 position-relative md-mb-6 sm-mb-50px">
                        <div class="overflow-hidden text-end w-80 ms-auto animation-float" data-anime='{ "effect": "slide", "direction": "lr", "color": "#bc8947", "duration": 1000, "delay": 0 }'>
                            <img src="./assets/images/about/about-bg-01.jpg" alt="" class="w-100 border-radius-5px">
                        </div>
                        <div class="position-absolute bottom-minus-50px w-60 atropos" data-atropos data-bottom-top="transform: translateY(50px)" data-top-bottom="transform: translateY(-50px)" data-anime='{ "effect": "slide", "direction": "lr", "color": "#bc8947", "duration": 1000, "delay": 500 }'>
                            <div class="atropos-scale">
                                <div class="atropos-rotate">
                                    <div class="atropos-inner text-center">
                                        <img class="w-100 border-radius-5px" data-atropos-offset="3" src="./assets/images/about/about-bg-02.jpg" alt="">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
        <!-- end section -->

        <!-- start section -->
        <section class="border-bottom border-color-extra-medium-gray">
            <div class="container"> 
                <div class="row align-items-center justify-content-center">                    
                    <div class="col-xxl-4 col-xl-5 col-lg-6 col-md-10 text-center text-lg-start" data-anime='{ "translateY": [0, 0], "opacity": [0,1], "duration": 600, "delay": 200, "staggervalue": 300, "easing": "easeOutQuad" }'>
                        <div class="swiper slider-one-slide md-mb-50px sm-mb-40px text-slider-style-01" data-slider-options='{ "slidesPerView": 1, "loop": true, "pagination": { "el": ".slider-one-slide-pagination", "clickable": true }, "autoplay": { "delay": 4000, "disableOnInteraction": false }, "navigation": { "nextEl": ".slider-one-slide-next-1", "prevEl": ".slider-one-slide-prev-1" }, "keyboard": { "enabled": true, "onlyInViewport": true }, "effect": "slide" }'>
                            <div class="swiper-wrapper mb-30px">
                                <!-- start text slider item -->
                                <div class="swiper-slide">
                                    <div class="alt-font text-uppercase text-base-color fw-600 mb-15px d-inline-block ls-1px">Our mission</div>
                                    <span class="d-inline-block w-95 md-w-100">Provide our customers a level of service unequalled in the cleaning industry. Develop an organization that will encourage all people to prosper and grow to their full potential. Protect the health and safety of all our people.</span>
                                </div>
                                <!-- end text slider item -->
                                <!-- start text slider item -->
                                <div class="swiper-slide">
                                    <div class="alt-font text-uppercase text-base-color fw-600 mb-15px d-inline-block ls-1px">Our Vision</div>
                                    <span class="d-inline-block w-95 md-w-100">We strive to become the leading cleaning service provider in the industry. We aim to become the supplier of choice for all our clients. We aim to offer true value for money on all our services offered.</span>
                                </div>
                                <!-- end text slider item -->
                                <!-- start text slider item -->
                                <div class="swiper-slide">
                                    <div class="alt-font text-uppercase text-base-color fw-600 mb-15px d-inline-block ls-1px">Our Commitment</div>
                                    <span class="d-inline-block w-95 md-w-100">The company was given the name (AL THABITAH) in line with the pandemic that the world has experienced, which means steadfastness in the face of ifficulties, and our goal is your satisfaction. We provide the best services with quality standards, and our suitability is not the best, but we are distinguished, and our goal is your satisfaction.</span>
                                </div>
                                <!-- end text slider item -->
                            </div>
                            <div class="d-flex justify-content-center justify-content-lg-start">
                                <!-- start slider navigation -->
                                <div class="slider-one-slide-prev-1 text-dark-gray swiper-button-prev slider-navigation-style-04 border border-1 border-color-extra-medium-gray bg-white"><i class="fa-solid fa-arrow-left"></i></div>
                                <div class="slider-one-slide-next-1 text-dark-gray swiper-button-next slider-navigation-style-04 border border-1 border-color-extra-medium-gray bg-white"><i class="fa-solid fa-arrow-right"></i></div>
                                <!-- end slider navigation -->
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-6 col-lg-6 offset-xl-1 position-relative text-end md-mb-6 sm-mb-10 xs-mb-12">
                        <div class="text-end w-80 md-w-75 ms-auto" data-animation-delay="100" data-shadow-animation="true" data-bottom-top="transform: translateY(50px)" data-top-bottom="transform: translateY(-50px)">
                            <img src="./assets/images/title/title-our-services.jpg" alt="" class="border-radius-5px">
                        </div>
                        <div class="w-60 md-w-50 xs-w-55 overflow-hidden position-absolute left-15px bottom-minus-50px" data-shadow-animation="true" data-animation-delay="200" data-bottom-top="transform: translateY(-50px)" data-top-bottom="transform: translateY(50px)">
                            <img src="./assets/images/title/title-contact-us-02.jpg" alt="" class="border-radius-5px" />
                        </div>
                    </div>
                </div>
            </div>
        </section>
        <!-- end section -->

        <!-- start section -->
        <section class="position-relative overflow-hidden overlap-height pb-0">
            <img src="./assets/images/icons/about-icon-01.png" class="position-absolute left-150px top-50px z-index-minus-1" alt="" data-bottom-top="transform: translate3d(80px, 0px, 0px);" data-top-bottom="transform: translate3d(-380px, 0px, 0px);" />
            <img src="./assets/images/icons/about-icon-02.png" class="position-absolute right-100px top-50px z-index-minus-1" alt="" data-bottom-top="transform:scale(1.4, 1.4) translate3d(0px, 0px, 0px);" data-top-bottom="transform:scale(1, 1) translate3d(-300px, 0px, 0px);" />
            <div class="container overlap-gap-section">  
                <div class="row align-items-center justify-content-lg-start justify-content-center text-lg-start text-center">
                    <div class="col-lg-6 col-md-10 md-mb-50px">
                        <figure class="position-relative m-0 md-w-95 xs-w-90">
                            <img src="./assets/images/title/title-booking.jpg" class="w-90 border-radius-8px" alt="">
                            <figcaption class="position-absolute bg-dark-gray border-radius-10px box-shadow-quadruple-large bottom-100px xs-bottom-minus-10px right-minus-30px w-240px xs-w-200px text-center last-paragraph-no-margin animation-float">
                            </figcaption>
                        </figure>
                    </div>
                    <div class="col-lg-5 col-md-10 offset-lg-1" data-anime='{ "translateY": [0, 0], "opacity": [0,1], "duration": 1200, "delay": 0, "staggervalue": 150, "easing": "easeOutQuad" }'>
                        <span class="fs-16 lh-22 fw-700 mb-15px d-inline-block text-uppercase text-dark-gray border-bottom border-2 border-color-base-color">A few good reasons</span>
                        <h2 class="fw-700 text-dark-gray ls-minus-1px">Here is what our clients have to say.</h2>
                        <div class="swiper position-relative" data-slider-options='{ "autoHeight": true, "loop": true, "allowTouchMove": true, "autoplay": { "delay": 4000, "disableOnInteraction": false }, "navigation": { "nextEl": ".swiper-button-next", "prevEl": ".swiper-button-prev" }, "effect": "fade" }'>
                            <div class="swiper-wrapper mb-40px">
                                <!-- start text slider item -->
                                <div class="swiper-slide review-style-08">
                                    <p class="w-80 lg-w-100">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur in orci elit. Duis lobortis gravida quam gravida fermentum. Integer non pharetra leo. Morbi scelerisque augue quis pretium tempus. Nam et magna dui. Cras malesuada dictum lectus, vel ullamcorper neque feugiat et.</p>
                                    <div class="mt-20px">
                                        <img class="w-110px me-15px" src="./assets/images/demo-corporate-testimonials-01.png" alt="">
                                        <div class="d-inline-block align-middle text-start">
                                            <div class="text-dark-gray fw-600 fs-20">Alexander harvard</div>
                                            <div class="review-star-icon fs-18">
                                                <i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i>
                                            </div> 
                                        </div>
                                    </div> 
                                </div>
                                <!-- end text slider item -->
                                <!-- start text slider item -->
                                <div class="swiper-slide review-style-08">
                                    <p class="w-80 lg-w-100">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur in orci elit. Duis lobortis gravida quam gravida fermentum. Integer non pharetra leo. Morbi scelerisque augue quis pretium tempus. Nam et magna dui. Cras malesuada dictum lectus, vel ullamcorper neque feugiat et.</p>
                                    <div class="mt-20px">
                                        <img class="w-110px me-15px" src="./assets/images/demo-corporate-testimonials-02.png" alt="">
                                        <div class="d-inline-block align-middle text-start">
                                            <div class="text-dark-gray fw-600 fs-20">Shoko mugikura</div>
                                            <div class="review-star-icon fs-18">
                                                <i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i>
                                            </div> 
                                        </div>
                                    </div> 
                                </div>
                                <!-- end text slider item -->
                                <!-- start text slider item -->
                                <div class="swiper-slide review-style-08">
                                    <p class="w-80 lg-w-100">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur in orci elit. Duis lobortis gravida quam gravida fermentum. Integer non pharetra leo. Morbi scelerisque augue quis pretium tempus. Nam et magna dui. Cras malesuada dictum lectus, vel ullamcorper neque feugiat et.</p>
                                    <div class="mt-20px">
                                        <img class="w-110px me-15px" src="./assets/images/demo-corporate-testimonials-03.png" alt="">
                                        <div class="d-inline-block align-middle text-start">
                                            <div class="text-dark-gray fw-600 fs-20">Leonel mooney</div>
                                            <div class="review-star-icon fs-18">
                                                <i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i>
                                            </div> 
                                        </div>
                                    </div> 
                                </div>
                                <!-- end text slider item -->
                            </div> 
                            <div class="d-flex justify-content-lg-start justify-content-center">
                                <!-- start slider navigation -->
                                <div class="slider-one-slide-prev-1 swiper-button-prev slider-navigation-style-04 border border-color-extra-medium-gray"><i class="fa-solid fa-arrow-left text-dark-gray icon-small"></i></div>
                                <div class="slider-one-slide-next-1 swiper-button-next slider-navigation-style-04 border border-color-extra-medium-gray"><i class="fa-solid fa-arrow-right text-dark-gray icon-small"></i></div>
                                <!-- end slider navigation --> 
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
        <!-- end section -->

         <!-- start section -->
         <section class="half-section mb-4" data-anime='{ "translate": [0, 0], "opacity": [0,1], "duration": 600, "delay":100, "staggervalue": 150, "easing": "easeOutQuad" }'>
            <div class="container">
                <div class="row position-relative clients-style-08">
                    <div class="col swiper text-center feather-shadow" data-slider-options='{ "slidesPerView": 1, "spaceBetween":0, "speed": 3000, "loop": true, "pagination": { "el": ".slider-four-slide-pagination-2", "clickable": false }, "allowTouchMove": false, "autoplay": { "delay":0, "disableOnInteraction": false, "pauseOnMouseEnter": false}, "navigation": { "nextEl": ".slider-four-slide-next-2", "prevEl": ".slider-four-slide-prev-2" }, "keyboard": { "enabled": true, "onlyInViewport": true }, "breakpoints": { "1200": { "slidesPerView": 4 }, "992": { "slidesPerView": 3 }, "768": { "slidesPerView": 3 }, "576": { "slidesPerView": 2 } }, "effect": "slide" }'>
                        <div class="swiper-wrapper marquee-slide">
                            <!-- start client item -->
                            <div class="swiper-slide">
                                <a href="#"><img src="./assets/images/certificate/dubai-municipality.svg" style="filter: grayscale(100%);" alt="" width="200" height="200" /></a>
                            </div>
                            <!-- end client item -->
                            <!-- start client item -->
                            <div class="swiper-slide">
                                <a href="#"><img src="./assets/images/certificate/bsi.svg" style="filter: grayscale(100%);" alt="" width="200" height="200" /></a>
                            </div>
                            <!-- end client item -->
                            <!-- start client item -->
                            <div class="swiper-slide">
                                <a href="#"><img src="./assets/images/certificate/iicrc.svg" style="filter: grayscale(100%);" alt="" width="200" height="200" /></a>
                            </div>
                            <!-- end client item -->
                            <!-- start client item -->
                            <div class="swiper-slide">
                                <a href="#"><img src="./assets/images/certificate/iso.svg" style="filter: grayscale(100%);" alt="" width="200" height="200" /></a>
                            </div>
                            <!-- end client item -->
                            <!-- start client item -->
                            <div class="swiper-slide">
                                <a href="#"><img src="./assets/images/certificate/bicsc.png" style="filter: grayscale(100%);" alt="" width="200" height="200" /></a>
                            </div>
                            <!-- end client item -->
                        </div> 
                    </div>  
                </div>
            </div>
        </section>
        <!-- end section -->