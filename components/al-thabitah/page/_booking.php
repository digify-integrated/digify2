<?php
    require('components/page-title/model/page-title-model.php');

    $pageTitleModel = new PageTitleModel($databaseModel);

    require_once('page_components/booking/_booking_page_title.php');
?>

        <!-- start section -->
        <section class="mb-3">
            <div class="container">
                <div class="row align-items-start">
                    <div class="col-lg-7 pe-50px md-pe-15px md-mb-50px xs-mb-35px">
                        <span class="fs-26 alt-font fw-600 text-dark-gray mb-20px d-block">Booking details</span>
                        <form id="booking-form" method="post" action="#">
                            <div class="row">
                                <div class="col-12 mb-20px">
                                    <label class="mb-10px" for="service">Service <span class="text-red">*</span></label>
                                    <select name="service" id="service" class="form-select border-radius-4px">
                                        <option value=""></option>
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
                                <div class="col-6 mb-20px d-none" id="frequency_field">
                                    <label class="mb-10px" for="frequency">Frequency <span class="text-red">*</span></label>
                                    <select name="frequency" id="frequency" class="form-select border-radius-4px">
                                        <option value=""></option>
                                        <option value="One Time">One Time</option>
                                        <option value="Weekly">Weekly</option>
                                        <option value="Monthly">Monthly</option>
                                        <option value="Yearly">Yearly</option>
                                        <option value="Every Other Week">Every Other Week</option>
                                        <option value="Every 4 Weeks">Every 4 Weeks</option>
                                    </select>
                                </div>
                                <div class="col-6 mb-20px d-none" id="duration_field">
                                    <label class="mb-10px" for="duration">Duration <span class="text-red">*</span></label>
                                    <select name="duration" id="duration" class="form-select border-radius-4px">
                                        <option value=""></option>
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
                                <div class="col-md-12 mb-20px d-none" id="number_of_seats_field">
                                    <label class="mb-10px" for="number_of_seats">Number of seats <span class="text-red">*</span></label>
                                    <input class="border-radius-4px" name="number_of_seats" id="number_of_seats" type="number" min="1" step="1" aria-label="number">
                                </div>
                                <div class="col-md-12 mb-20px d-none" id="meters_field">
                                    <label class="mb-10px" for="meters">Meters <span class="text-red">*</span></label>
                                    <input class="border-radius-4px" name="meters" id="meters" type="number" min="1" step="1" aria-label="number">
                                </div>
                                <div class="col-12 mb-20px">
                                    <label class="mb-10px" for="cleaning_materials">Need cleaning materials? <span class="text-red">*</span></label>
                                    <select name="cleaning_materials" id="cleaning_materials" class="form-select border-radius-4px">
                                        <option value="No">No, I have them</option>
                                        <option value="Yes">Yes Please!</option>
                                    </select>
                                </div>
                                <div class="col-6 mb-20px">
                                    <label class="mb-10px" for="booking_date">Date <span class="text-red">*</span></label>
                                    <input class="form-control" type="date" id="booking_date" name="booking_date" min="<?php echo date('Y-m-d'); ?>" max="2099-12-31" aria-label="date">
                                </div>
                                <div class="col-6 mb-20px">
                                    <label class="mb-10px" for="booking_time">Time <span class="text-red">*</span></label>
                                    <select class="form-control" id="booking_time" name="booking_time">
                                        <option value="">--</option>
                                        <option value="9:00 AM">9:00 AM</option>
                                        <option value="10:00 AM">10:00 AM</option>
                                        <option value="12:00 PM">12:00 PM</option>
                                        <option value="1:00 PM">1:00 PM</option>
                                        <option value="2:00 PM">2:00 PM</option>
                                        <option value="3:00 PM">3:00 PM</option>
                                        <option value="4:00 PM">4:00 PM</option>
                                        <option value="5:00 PM">5:00 PM</option>
                                        <option value="6:00 PM">6:00 PM</option>
                                    </select>
                                </div>
                                <div class="col-12 mb-20px">
                                    <label class="mb-10px" for="number_of_professionals">How many professionals do you need? <span class="text-red">*</span></label>
                                    <select class="form-control" id="number_of_professionals" name="number_of_professionals">
                                        <option value="">--</option>
                                        <option value="1">1</option>
                                        <option value="2">2</option>
                                        <option value="3">3</option>
                                        <option value="4">4</option>
                                        <option value="5">5</option>
                                        <option value="6">6</option>
                                        <option value="7">7</option>
                                        <option value="8">8</option>
                                        <option value="9">9</option>
                                        <option value="10">10</option>
                                        <option value="11">11</option>
                                        <option value="12">12</option>
                                        <option value="13">13</option>
                                        <option value="14">14</option>
                                        <option value="15">15</option>
                                        <option value="16">16</option>
                                        <option value="17">17</option>
                                        <option value="18">18</option>
                                        <option value="19">19</option>
                                        <option value="20">20</option>
                                    </select>
                                </div>
                                <div class="col-12 mb-20px">
                                    <label class="mb-10px" for="number_of_hours">How many hours should they stay? <span class="text-red">*</span></label>
                                    <select class="form-control" id="number_of_hours" name="number_of_hours">
                                        <option value="">--</option>
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
                                <div class="col-12 mb-20px">
                                    <label class="mb-10px" for="nationality">Choose your professional nationality <span class="text-red">*</span></label>
                                    <select class="form-control" id="nationality" name="nationality">
                                        <option value="">--</option>
                                        <option value="African">African</option>
                                        <option value="Filipino">Filipino</option>
                                        <option value="Nepali">Nepali</option>
                                    </select>
                                </div>
                                <div class="col-md-6 mb-20px">
                                    <label class="mb-10px" for="first_name">First name <span class="text-red">*</span></label>
                                    <input class="border-radius-4px" id="first_name" name="first_name" type="text" aria-label="text" autocomplete="off">
                                </div>
                                <div class="col-md-6 mb-20px">
                                    <label class="mb-10px" for="last_name">Last name <span class="text-red">*</span></label>
                                    <input class="border-radius-4px" id="last_name" name="last_name" type="text" aria-label="text" autocomplete="off">
                                </div>
                                <div class="col-md-12 mb-20px">
                                    <label class="mb-10px" for="address">Address <span class="text-red">*</span></label>
                                    <input class="border-radius-4px" id="address" name="address" type="text" aria-label="text" autocomplete="off">
                                </div>
                                <div class="col-6 mb-20px">
                                    <label class="mb-10px" for="phone">Phone <span class="text-red">*</span></label>
                                    <input class="border-radius-4px" id="phone" name="phone" type="text" autocomplete="off">
                                </div>
                                <div class="col-6 mb-20px">
                                    <label class="mb-10px" for="email_address">Email address <span class="text-red">*</span></label>
                                    <input class="border-radius-4px" id="email_address" name="email_address" type="email" autocomplete="off">
                                </div>
                                <div class="col-12">
                                    <label class="mb-10px" for="special_instructions">Do you have any special instructions?</label>
                                    <textarea class="border-radius-4px" rows="5" cols="5" id="special_instructions" name="special_instructions" placeholder="Notes about your booking, e.g. special notes for the professionals."></textarea>
                                </div>
                            </div>
                        </form>
                    </div>
                    <div class="col-lg-5">
                        <div class="bg-very-light-gray border-radius-6px p-50px lg-p-25px your-order-box">
                            <span class="fs-26 alt-font fw-600 text-dark-gray mb-5px d-block">Your booking</span>
                            <table class="w-100 total-price-table your-order-table mb-8">
                                <tbody>
                                    <tr>
                                        <th class="w-60 lg-w-55 xs-w-50 fw-600 text-dark-gray alt-font">Service</th>
                                        <td class="fw-600 text-dark-gray alt-font">Total</td>
                                    </tr>
                                    <tr id="service-summary" class="product"></tr>
                                    <tr>
                                        <th class="w-60 lg-w-55 xs-w-50 fw-600 text-dark-gray alt-font">Add-On</th>
                                        <td class="fw-600 text-dark-gray alt-font">Total</td>
                                    </tr>
                                    <tr id="cleaning-materials-summary" class="product"></tr>
                                </tbody>
                            </table>
                            <span class="fs-26 alt-font fw-600 text-dark-gray mb-5px d-block">Payment Details</span>
                            <table class="w-100 total-price-table your-order-table mb-4">
                                <tbody>
                                    <tr>
                                        <th class="w-60 fw-600 text-dark-gray alt-font">Booking Subtotal</th>
                                        <td class="text-dark-gray fw-600" id="booking-subtotal-payment-details">AED 0.00</td>
                                    </tr>
                                    <tr>
                                        <th class="w-60 fw-600 text-dark-gray alt-font">Discount Subtotal</th>
                                        <input type="hidden" id="discount-rate">
                                        <input type="hidden" id="discount-type">
                                        <input type="hidden" id="discount-amount">
                                        <td class="text-dark-gray fw-600" id="discount-subtotal">AED 0.00</td>
                                    </tr>
                                    <tr class="total-amount">
                                        <th class="fw-600 text-dark-gray alt-font">Total</th>
                                        <td data-title="Total">
                                            <h6 class="d-block fw-700 mb-0 text-dark-gray alt-font" id="total-booking-amount">AED 0.00</h6>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                            <span class="fs-26 alt-font fw-600 text-dark-gray mb-5px d-block">Discount</span>
                            <div class="row mt-20px mb-8">
                                <div class="col-xl-8"> 
                                    <div class="coupon-code-panel">
                                        <input type="text" class="bg-white border-radius-4px" id="discount_code" name="discount_code" placeholder="Discount code">
                                        <a href="javascript:void(0);" id="apply-discount" class="btn apply-coupon-btn fs-13 fw-600 text-uppercase">Apply</a>
                                    </div>
                                </div>
                                <div class="col-xl-4 text-end sm-mt-15px">
                                    <a href="javasctript:void(0);" id="reset-discount" class="btn btn-small border-1 btn-round-edge btn-transparent-light-gray text-transform-none">Reset</a>
                                </div>
                            </div>
                            <span class="fs-26 alt-font fw-600 text-dark-gray mb-5px d-block">Payment Method</span>
                            <div class="p-40px lg-p-25px bg-white border-radius-6px box-shadow-large mt-10px mb-8  checkout-accordion">
                                <div class="w-100" id="accordion-style-05">
                                    <!-- start tab content -->
                                    <div class="heading active-accordion">
                                        <label class="mb-5px">
                                            <input class="d-inline w-auto me-5px mb-0 p-0" type="radio" name="mode_of_payment" value="Stripe" checked="checked">
                                            <span class="d-inline-block text-dark-gray fw-500">Stripe Online Payment – Fast & Secure</span>
                                            <a class="accordion-toggle" data-bs-toggle="collapse" data-bs-parent="#accordion-style-05" href="#style-5-collapse-1"></a>
                                        </label> 
                                    </div>
                                    <div id="style-5-collapse-1" class="collapse show" data-bs-parent="#accordion-style-05">
                                        <div class="p-25px bg-very-light-gray mt-20px mb-20px fs-14 lh-24">Make your payment securely online via Stripe.</div>
                                    </div>
                                    <!-- end tab content -->
                                    <!-- start tab content -->
                                    <div class="heading active-accordion">
                                        <label class="mb-5px">
                                            <input class="d-inline w-auto me-5px mb-0 p-0" type="radio" name="mode_of_payment" value="Cash"> 
                                            <span class="d-inline-block text-dark-gray fw-500">Cash</span> 
                                            <a class="accordion-toggle" data-bs-toggle="collapse" data-bs-parent="#accordion-style-05" href="#style-5-collapse-3"></a>
                                        </label>
                                    </div>
                                    <div id="style-5-collapse-3" class="collapse" data-bs-parent="#accordion-style-05">
                                        <div class="p-25px bg-very-light-gray mt-20px mb-20px fs-14 lh-24">Pay in cash upon the arrival of our team.</div>
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
                            <button type="submit" form="booking-form" class="btn btn-base-color btn-extra-large btn-switch-text btn-round-edge btn-box-shadow w-100 text-transform-none mt-30px" id="submit-booking">
                                <span>
                                    <span class="btn-double-text" id="proceed-text">Proceed to payment</span>
                                </span>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </section>
        <!-- end section -->