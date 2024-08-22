<div class="card mb-0">
  <div class="form-horizontal">
    <div class="form-body">
      <div class="card-body d-flex align-items-center">
        <h5 class="card-title mb-0">Credit / Debit Card</h5>
        <div class="card-actions cursor-pointer ms-auto d-flex button-group">
        <?php
          echo $createAccess['total'] > 0 ? '<a href="javascript:void(0)" class="btn btn-success ms-auto" data-bs-toggle="modal" data-bs-target="#bank-card-modal" id="add-bank-card-details"><i class="ti ti-plus fs-3"></i> Add New Card</a>' : '';
        ?>
        </div>
      </div>
      <hr class="m-0" />
      <input type="hidden" id="linked_id" value="<?php echo $_SESSION['linked_id']; ?>">
      <div class="card-body" id="bank-card-container"></div>
      <hr class="m-0" />
      <div class="card-body d-flex align-items-center">
        <h5 class="card-title mb-0">My Bank Accounts</h5>
        <div class="card-actions cursor-pointer ms-auto d-flex button-group">
        <?php
          echo $createAccess['total'] > 0 ? '<a href="javascript:void(0)" class="btn btn-success ms-auto" data-bs-toggle="modal" data-bs-target="#bank-account-modal" id="add-bank-account-details"><i class="ti ti-plus fs-3"></i> Add New Bank Account</a>' : '';
        ?>
        </div>
      </div>
      <hr class="m-0" />
      <div class="card-body" id="bank-account-container"></div>
    </div>
  </div>
</div>

<div id="bank-card-modal" class="modal fade" tabindex="-1" aria-labelledby="bank-card-modal" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-r">
        <div class="modal-content">
            <div class="modal-header border-bottom">
                <h5 class="modal-title fw-8" id="bank-card-title"></h5>
                <button type="button" class="btn-close fs-2" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="bank-card-form" method="post" action="#">
                    <input type="hidden" id="customer_bank_card_id" name="customer_bank_card_id">
                    <div class="row">
                        <div class="col-lg-12">
                            <label class="form-label" for="name_on_card">Name On Card <span class="text-danger">*</span></label>
                            <div class="mb-3">
                                <input type="text" class="form-control maxlength" id="name_on_card" name="name_on_card" maxlength="1000" autocomplete="off">
                            </div>
                        </div>
                        <div class="col-lg-12">
                            <label class="form-label" for="card_number">Card Number <span class="text-danger">*</span></label>
                            <div class="mb-3">
                                <input type="text" class="form-control cc-inputmask"id="card_number" name="card_number" />
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <label class="form-label" for="expiry_date">Card Expiry Date <span class="text-danger">*</span></label>
                            <div class="mb-3">
                                <input type="text" class="form-control expiry-inputmask"id="expiry_date" name="expiry_date" />
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <label class="form-label" for="cvv">CVV <span class="text-danger">*</span></label>
                            <div class="mb-3">
                                <input type="text" class="form-control cvv-inputmask"id="cvv" name="cvv" />
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer border-top">
                <button type="button" class="btn btn-outline-danger" data-bs-dismiss="modal">Close</button>
                <button type="submit" form="bank-card-form" class="btn btn-success" id="submit-bank-card-data">Save changes</button>
            </div>
        </div>
    </div>
</div>

<div id="bank-account-modal" class="modal fade" tabindex="-1" aria-labelledby="bank-account-modal" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-r">
        <div class="modal-content">
            <div class="modal-header border-bottom">
                <h5 class="modal-title fw-8" id="bank-account-title"></h5>
                <button type="button" class="btn-close fs-2" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="bank-account-form" method="post" action="#">
                    <input type="hidden" id="customer_bank_account_id" name="customer_bank_account_id">
                    <div class="row">
                        <div class="col-lg-12">
                            <label for="bank_id" class="form-label">Bank <span class="text-danger">*</span></label>
                            <div class="mb-3">
                                <select id="bank_id" name="bank_id" class="select2 form-control"></select>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-12">
                            <label for="bank_account_type_id" class="form-label">Bank Account Type <span class="text-danger">*</span></label>
                            <div class="mb-3">
                                <select id="bank_account_type_id" name="bank_account_type_id" class="select2 form-control"></select>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-12">
                            <label class="form-label" for="account_number">Account Number <span class="text-danger">*</span></label>
                            <div class="mb-3">
                                <input type="text" class="form-control maxlength" id="account_number" name="account_number" maxlength="100" autocomplete="off">
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer border-top">
                <button type="button" class="btn btn-outline-danger" data-bs-dismiss="modal">Close</button>
                <button type="submit" form="bank-account-form" class="btn btn-success" id="submit-bank-account-data">Save changes</button>
            </div>
        </div>
    </div>
</div>