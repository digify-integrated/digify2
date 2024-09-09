<?php
    require('components/page-title/model/page-title-model.php');

    $pageTitleModel = new PageTitleModel($databaseModel);

    require_once('page_components/booking/_booking_page_title.php');
?>

        <!-- start section -->
        <section>
            <div class="container">
                <div class="row justify-content-center mb-8 lg-mb-10 align-items-center">
                    <div class="col-auto icon-with-text-style-08 lg-mb-10px">
                        <div class="feature-box feature-box-left-icon">
                            <div class="feature-box-icon me-5px">
                                <i class="feather icon-feather-user top-9px position-relative text-dark-gray icon-small"></i>
                            </div>
                            <div class="feature-box-content">
                                <span class="d-inline-block text-dark-gray align-middle alt-font fw-500">Returning customer? <a href="#" class="text-decoration-line-bottom fw-600 text-dark-gray">Click here to login</a></span> 
                            </div>
                        </div>
                    </div>
                    <div class="col-auto d-none d-lg-inline-block">
                        <span class="w-1px h-20px bg-extra-medium-gray d-block"></span>
                    </div>
                    <div class="col-auto icon-with-text-style-08">
                        <div class="feature-box feature-box-left-icon">
                            <div class="feature-box-icon me-5px">
                                <i class="feather icon-feather-scissors top-9px position-relative text-dark-gray icon-small"></i>
                            </div>
                            <div class="feature-box-content">
                                <span class="d-inline-block text-dark-gray align-middle alt-font fw-500">Have a coupon? <a href="#" class="text-decoration-line-bottom fw-600 text-dark-gray">Click here to enter your code</a></span>
                            </div>
                        </div>
                    </div>
                </div> 
                <div class="row align-items-start">
                    <div class="col-lg-7 pe-50px md-pe-15px md-mb-50px xs-mb-35px">
                        <span class="fs-26 alt-font fw-600 text-dark-gray mb-20px d-block">Booking details</span>
                        <form id="booking-form" method="post" action="#">
                            <div class="row">
                                <div class="col-12 mb-20px">
                                    <label class="mb-10px" for="service">Service <span class="text-red">*</span></label>
                                    <select name="service" id="service" class="form-select border-radius-4px">
                                        <option value="">Select a service</option>
                                        <option value="Deep Cleaning">Deep Cleaning</option>
                                        <option value="Regular Cleaning">Regular Cleaning</option>
                                        <option value="Office Cleaning">Office Cleaning</option>
                                        <option value="Flat Cleaning">Flat Cleaning</option>
                                        <option value="Hospital Cleaning">Hospital Cleaning</option>
                                        <option value="Sofa Cleaning">Sofa Cleaning</option>
                                        <option value="Mattress Cleaning">Mattress Cleaning</option>
                                        <option value="Curtain Cleaning">Curtain Cleaning</option>
                                        <option value="Carpet Cleaning">Carpet Cleaning</option>
                                    </select>
                                </div>
                                <div class="col-6 mb-20px">
                                    <label class="mb-10px" for="frequency">Frequency <span class="text-red">*</span></label>
                                    <select name="frequency" id="frequency" class="form-select border-radius-4px">
                                        <option value="">Select a frequency</option>
                                        <option value="One Time">One Time</option>
                                        <option value="Weekly">Weekly</option>
                                        <option value="Monthly">Monthly</option>
                                        <option value="Yearly">Yearly</option>
                                        <option value="Every Other Week">Every Other Week</option>
                                        <option value="Every 4 Weeks">Every 4 Weeks</option>
                                    </select>
                                </div>
                                <div class="col-6 mb-20px">
                                    <label class="mb-10px" for="frequency">Duration <span class="text-red">*</span></label>
                                    <select name="frequency" id="frequency" class="form-select border-radius-4px">
                                        <option value="">Select a duration</option>
                                        <option value="1">1 Hour</option>
                                        <option value="2">2 Hours</option>
                                        <option value="3">3 Hours</option>
                                        <option value="4">4 Hours</option>
                                        <option value="5">5 Hours</option>
                                        <option value="6">6 Hours</option>
                                        <option value="7">7 Hours</option>
                                        <option value="8">8 Hours</option>
                                    </select>
                                </div>
                                <div class="col-md-12 mb-20px">
                                    <label class="mb-10px">Number of seats <span class="text-red">*</span></label>
                                    <input class="border-radius-4px" name="number_of_seats" id="number_of_seats" type="number" min="1" step="1" aria-label="number">
                                </div>
                                <div class="col-md-12 mb-20px">
                                    <label class="mb-10px">Meters <span class="text-red">*</span></label>
                                    <input class="border-radius-4px" name="meters" id="meters" type="number" min="1" step="1" aria-label="number">
                                </div>
                                <div class="col-6 mb-20px">
                                    <label class="mb-10px">Date <span class="text-red">*</span></label>
                                    <input class="form-control" type="date" name="date" min="<?php echo date('Y-m-d'); ?>" max="2099-12-31" aria-label="date">
                                </div>
                                <div class="col-6 mb-20px">
                                    <label class="mb-10px">Time <span class="text-red">*</span></label>
                                    <select class="form-control">
                                        <option value="">--</option>
                                        <option value="">9:00 AM</option>
                                        <option>10:00 AM</option>
                                        <option>11:00 AM</option>
                                        <option>12:00 PM</option>
                                        <option>1:00 PM</option>
                                        <option>2:00 PM</option>
                                        <option>3:00 PM</option>
                                        <option>4:00 PM</option>
                                        <option>5:00 PM</option>
                                        <option>6:00 PM</option>
                                    </select>
                                </div>
                                <div class="col-12 mb-20px">
                                    <label class="mb-10px">How many professionals do you need? <span class="text-red">*</span></label>
                                    <select class="form-control">
                                        <option value="">--</option>
                                        <option>1</option>
                                        <option>2</option>
                                        <option>3</option>
                                        <option>4</option>
                                        <option>5</option>
                                        <option>6</option>
                                        <option>7</option>
                                        <option>8</option>
                                        <option>9</option>
                                        <option>10</option>
                                        <option>11</option>
                                        <option>12</option>
                                        <option>13</option>
                                        <option>14</option>
                                        <option>15</option>
                                        <option>16</option>
                                        <option>17</option>
                                        <option>18</option>
                                        <option>19</option>
                                        <option>20</option>
                                    </select>
                                </div>
                                <div class="col-6 mb-20px">
                                    <label class="mb-10px">How many hours should they stay? <span class="text-red">*</span></label>
                                    <select class="form-control">
                                        <option value="">--</option>
                                        <option>1 Hour</option>
                                        <option>2 Hours</option>
                                        <option>3 Hours</option>
                                        <option>4 Hours</option>
                                        <option>5 Hours</option>
                                        <option>6 Hours</option>
                                        <option>7 Hours</option>
                                        <option>8 Hours</option>
                                    </select>
                                </div>
                                <div class="col-6 mb-20px">
                                    <label class="mb-10px">Choose your professional nationality <span class="text-red">*</span></label>
                                    <select class="form-control">
                                        <option value="">--</option>
                                        <option>African</option>
                                        <option>Filipino</option>
                                        <option>Nepali</option>
                                    </select>
                                </div>
                                <div class="col-md-6 mb-20px">
                                    <label class="mb-10px">First name <span class="text-red">*</span></label>
                                    <input class="border-radius-4px" type="text" aria-label="text" required>
                                </div>
                                <div class="col-md-6 mb-20px">
                                    <label class="mb-10px">Last name <span class="text-red">*</span></label>
                                    <input class="border-radius-4px" type="text" aria-label="text" required>
                                </div>
                                <div class="col-md-12 mb-20px">
                                    <label class="mb-10px">Address <span class="text-red">*</span></label>
                                    <input class="border-radius-4px" type="text" aria-label="text" required>
                                </div>
                                <div class="col-6 mb-20px">
                                    <label class="mb-10px">Phone <span class="text-red">*</span></label>
                                    <input class="border-radius-4px" type="text" required>
                                </div>
                                <div class="col-6 mb-20px">
                                    <label class="mb-10px">Email address <span class="text-red">*</span></label>
                                    <input class="border-radius-4px" type="email" required>
                                </div>
                                <div class="col-12">
                                    <label class="mb-10px">Do you have any special instructions?</label>
                                    <textarea class="border-radius-4px textarea-small" rows="5" cols="5" placeholder="Notes about your order, e.g. special notes for delivery."></textarea>
                                </div>
                            </div>
                        </form>
                    </div>
                    <div class="col-lg-5">
                        <div class="bg-very-light-gray border-radius-6px p-50px lg-p-25px your-order-box">
                            <span class="fs-26 alt-font fw-600 text-dark-gray mb-5px d-block">Your order</span>
                            <table class="w-100 total-price-table your-order-table">
                                <tbody>
                                    <tr>
                                        <th class="w-60 lg-w-55 xs-w-50 fw-600 text-dark-gray alt-font">Product</th>
                                        <td class="fw-600 text-dark-gray alt-font">Total</td>
                                    </tr>
                                    <tr class="product">
                                        <td class="product-thumbnail">
                                            <a href="demo-decor-store-single-product.html" class="text-dark-gray fw-500 d-block lh-initial">Table clock x 1</a>
                                            <span class="fs-14 d-block">Color: Pink</span>
                                        </td>
                                        <td class="product-price" data-title="Price">$23.00</td>
                                    </tr>
                                    <tr class="product">
                                        <td class="product-thumbnail">
                                            <a href="demo-decor-store-single-product.html" class="text-dark-gray fw-500 d-block lh-initial">Decorative pot x 2</a>
                                            <span class="fs-14 d-block">Color: Brown</span>
                                        </td>
                                        <td class="product-price" data-title="Price">$70.00</td>
                                    </tr>
                                    <tr class="product">
                                        <td class="product-thumbnail">
                                            <a href="demo-decor-store-single-product.html" class="text-dark-gray fw-500 d-block lh-initial">Ceramic mug x 1</a>
                                            <span class="fs-14 d-block">Color: White</span>
                                        </td>
                                        <td class="product-price" data-title="Price">$15.00</td>
                                    </tr>
                                    <tr>
                                        <th class="w-50 fw-600 text-dark-gray alt-font">Subtotal</th>
                                        <td class="text-dark-gray fw-600">$405.00</td>
                                    </tr>
                                    <tr>
                                        <td class="text-dark-gray fw-600">
                                            <div class="row mt-20px">
                                                <div class="col-xl-7 col-md-6"> 
                                                    <div class="coupon-code-panel">
                                                        <input type="text" class="bg-white border-radius-4px" placeholder="Coupon code">
                                                        <a href="#" class="btn apply-coupon-btn fs-13 fw-600 text-uppercase">Apply</a>
                                                    </div>
                                                </div>
                                                <div class="col-xl-5 col-md-6 text-center text-md-end sm-mt-15px">
                                                    <a href="#" class="btn btn-small border-1 btn-round-edge btn-transparent-light-gray text-transform-none me-15px">Reset</a>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr class="shipping">
                                        <th class="fw-600 text-dark-gray alt-font">Shipping</th>
                                        <td data-title="Shipping">
                                            <ul class="p-0">
                                                <li class="d-flex align-items-center">
                                                    <input id="free_shipping" type="radio" name="shipping-option" class="d-block w-auto mb-0 me-10px p-0" checked="checked">
                                                    <label class="md-line-height-18px" for="free_shipping">Free shipping</label>
                                                </li>
                                                <li class="d-flex align-items-center">
                                                    <input id="flat" type="radio" name="shipping-option" class="d-block w-auto mb-0 me-10px p-0">
                                                    <label class="md-line-height-18px" for="flat">Flat: $12.00</label>
                                                </li>
                                                <li class="d-flex align-items-center">
                                                    <input id="local_pickup" type="radio" name="shipping-option" class="d-block w-auto mb-0 me-10px p-0">
                                                    <label class="md-line-height-18px" for="local_pickup">Local pickup</label>
                                                </li>
                                            </ul>
                                        </td>
                                    </tr> 
                                    <tr class="total-amount">
                                        <th class="fw-600 text-dark-gray alt-font">Total</th>
                                        <td data-title="Total">
                                            <h6 class="d-block fw-700 mb-0 text-dark-gray alt-font">$405.00</h6>
                                            <span class="fs-14">(Includes $19.29 tax)</span>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                            <div class="p-40px lg-p-25px bg-white border-radius-6px box-shadow-large mt-10px mb-30px sm-mb-25px checkout-accordion">
                                <div class="w-100" id="accordion-style-05">
                                    <!-- start tab content -->
                                    <div class="heading active-accordion">
                                        <label class="mb-5px">
                                            <input class="d-inline w-auto me-5px mb-0 p-0" type="radio" name="payment-option" checked="checked">
                                            <span class="d-inline-block text-dark-gray fw-500">Direct bank transfer</span>
                                            <a class="accordion-toggle" data-bs-toggle="collapse" data-bs-parent="#accordion-style-05" href="#style-5-collapse-1"></a>
                                        </label> 
                                    </div>
                                    <div id="style-5-collapse-1" class="collapse show" data-bs-parent="#accordion-style-05">
                                        <div class="p-25px bg-very-light-gray mt-20px mb-20px fs-14 lh-24">Make your payment directly into our bank account. Please use your Order ID as the payment reference. Your order will not be shipped until the funds have cleared in our account.</div>
                                    </div>
                                    <!-- end tab content -->
                                    <!-- start tab content -->
                                    <div class="heading active-accordion">
                                        <label class="mb-5px">
                                            <input class="d-inline w-auto me-5px mb-0 p-0" type="radio" name="payment-option">
                                            <span class="d-inline-block text-dark-gray fw-500">Check payments</span>
                                            <a class="accordion-toggle" data-bs-toggle="collapse" data-bs-parent="#accordion-style-05" href="#style-5-collapse-2"></a>
                                        </label>
                                    </div>
                                    <div id="style-5-collapse-2" class="collapse" data-bs-parent="#accordion-style-05">
                                        <div class="p-25px bg-very-light-gray mt-20px mb-20px fs-14 lh-24">Please send a check to store name, store street, store town, store state / county, store postcode.</div>
                                    </div>
                                    <!-- end tab content -->
                                    <!-- start tab content -->
                                    <div class="heading active-accordion">
                                        <label class="mb-5px">
                                            <input class="d-inline w-auto me-5px mb-0 p-0" type="radio" name="payment-option"> 
                                            <span class="d-inline-block text-dark-gray fw-500">Cash on delivery</span> 
                                            <a class="accordion-toggle" data-bs-toggle="collapse" data-bs-parent="#accordion-style-05" href="#style-5-collapse-3"></a>
                                        </label>
                                    </div>
                                    <div id="style-5-collapse-3" class="collapse" data-bs-parent="#accordion-style-05">
                                        <div class="p-25px bg-very-light-gray mt-20px mb-20px fs-14 lh-24">Pay with cash upon delivery.</div>
                                    </div>
                                    <!-- end tab content -->
                                    <!-- start tab content -->
                                    <div class="heading active-accordion">
                                        <label class="mb-5px">
                                            <input class="d-inline w-auto me-5px mb-0 p-0" type="radio" name="payment-option">
                                            <span class="d-inline-block text-dark-gray fw-500">PayPal <img src="images/paypal-logo.jpg" class="w-120px ms-10px" alt=""/></span> 
                                            <a class="accordion-toggle" data-bs-toggle="collapse" data-bs-parent="#accordion-style-05" href="#style-5-collapse-4"></a>
                                        </label>
                                    </div>
                                    <div id="style-5-collapse-4" class="collapse" data-bs-parent="#accordion-style-05">
                                        <div class="p-25px bg-very-light-gray mt-20px fs-14 lh-24">You can pay with your credit card if you don't have a PayPal account.</div>
                                    </div>
                                    <!-- end tab content -->
                                </div> 
                            </div>
                            <p class="fs-14 lh-26">Your personal data will be used to process your order, support your experience throughout this website, and for other purposes described in our <a class="text-decoration-line-bottom text-dark-gray fw-500" href="#">privacy policy.</a></p>
                            <div class="position-relative terms-condition-box text-start d-flex align-items-center">
                                <label>
                                    <input type="checkbox" name="terms_condition" id="terms_condition3" value="1" class="terms-condition check-box align-middle">
                                    <span class="box fs-14 lh-24">I have agree to the website <a href="#" class="text-decoration-line-bottom text-dark-gray fw-500">terms and conditions.</a></span>
                                </label>
                            </div>
                            <a href="#" class="btn btn-base-color btn-extra-large btn-switch-text btn-round-edge btn-box-shadow w-100 text-transform-none mt-30px">
                                <span>
                                    <span class="btn-double-text" data-text="Place order">Place order</span>
                                </span>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </section>
        <!-- end section -->