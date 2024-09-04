<div class="row">
    <div class="col-12">
        <div class="card">
            <div class="card-header d-flex align-items-center">
                <h5 class="card-title mb-0">Customer Inquiry Form</h5>
                <div class="card-actions cursor-pointer ms-auto d-flex button-group">
                    <button type="submit" form="customer-inquiry-form" class="btn btn-success mb-0" id="submit-data">Save</button>
                    <button type="button" id="discard-create" class="btn btn-outline-danger mb-0">Discard</button>
                </div>
            </div>
            <div class="card-body">
                <form id="customer-inquiry-form" method="post" action="#">
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="mb-3">
                                <label class="form-label" for="customer_name">Customer Name <span class="text-danger">*</span></label>
                                <input type="text" class="form-control maxlength" id="customer_name" name="customer_name" maxlength="500" autocomplete="off">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-6">
                            <label class="form-label" for="phone">Phone <span class="text-danger">*</span></label>
                            <div class="mb-3">
                                <input type="text" class="form-control maxlength" id="phone" name="phone" maxlength="50" autocomplete="off">
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <label class="form-label" for="email">Email <span class="text-danger">*</span></label>
                            <div class="mb-3">
                                <input type="email" class="form-control maxlength" id="email" name="email" maxlength="500" autocomplete="off">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="mb-3">
                                <label class="form-label" for="subject">Subject <span class="text-danger">*</span></label>
                                <input type="text" class="form-control maxlength" id="subject" name="subject" maxlength="500" autocomplete="off">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="mb-0">
                                <label class="form-label" for="message">Message <span class="text-danger">*</span></label>
                                <textarea class="form-control maxlength" id="message" name="message" maxlength="5000" rows="5"></textarea>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>