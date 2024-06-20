<div class="row">
    <div class="col-12">
        <div class="card">
            <div class="card-header d-flex align-items-center">
                <h5 class="card-title mb-0">App Module Form</h5>
                <div class="card-actions cursor-pointer ms-auto d-flex button-group">
                    <button type="submit" form="app-module-form" class="btn btn-success mb-0" id="submit-data">Save</button>
                    <button type="button" id="discard-create" class="btn btn-outline-danger mb-0">Discard</button>
                </div>
            </div>
            <div class="card-body">
                <form id="app-module-form" method="post" action="#">
                    <div class="row">
                        <div class="col-lg-6">
                            <div class="mb-3">
                                <label class="col-sm-4 form-label" for="app_module_name">Display Name <span class="text-danger">*</span></label>
                                <input type="text" class="form-control maxlength" id="app_module_name" name="app_module_name" maxlength="100" autocomplete="off">
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <div class="mb-3">
                                <label class="col-sm-4 form-label" for="app_module_description">Description <span class="text-danger">*</span></label>
                                <input type="text" class="form-control maxlength" id="app_module_description" name="app_module_description" maxlength="100" autocomplete="off">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-6">
                            <div class="mb-3">
                                <label class="col-sm-4 form-label" for="app_version">App Version <span class="text-danger">*</span></label>
                                <input type="text" class="form-control maxlength" id="app_version" name="app_version" maxlength="50" autocomplete="off">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label" for="menu_item_id">Default Page <span class="text-danger">*</span></label>
                            <div class="mb-3">
                                <select id="menu_item_id" name="menu_item_id" class="select2 form-control"></select>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-6">
                            <div class="mb-3">
                                <label class="col-sm-4 form-label" for="order_sequence">Order Sequence <span class="text-danger">*</span></label>
                                <input type="number" class="form-control" id="order_sequence" name="order_sequence" min="0">
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>