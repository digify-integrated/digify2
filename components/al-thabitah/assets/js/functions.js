(function ($) {
  'use strict';

  $(function () {
      const orderSummaryTableBody = document.querySelector('.your-order-table tbody');

      function updateOrderSummary() {
          const accordionItems = document.querySelectorAll('.accordion-item');
          const orderSummaryData = [];

          accordionItems.forEach((accordionItem) => {
              const accordionItemId = accordionItem.querySelector('.accordion-collapse').id.replace('-accordion', '');
              let productData = null;

              // Define variables for inputs
              const frequencySelect = accordionItem.querySelector(`#${accordionItemId}-frequency`);
              const durationSelect = accordionItem.querySelector(`#${accordionItemId}-duration`);
              const numberOfSeatsInput = accordionItem.querySelector(`#${accordionItemId}-number-of-seats`);
              const metersInput = accordionItem.querySelector(`#${accordionItemId}-meters`);

              // Deep, Regular, Office, Flat, Hospital Cleaning
              if (['deep-cleaning', 'regular-cleaning', 'office-cleaning', 'flat-cleaning', 'hospital-cleaning'].includes(accordionItemId)) {
                  if (frequencySelect && durationSelect && frequencySelect.value && durationSelect.value) {
                      const totalAmount = parseFloat(durationSelect.value) * 25;
                      productData = {
                          id: accordionItemId,
                          name: accordionItemId.replace(/-/g, ' ').replace(/(^|\s)\S/g, (letter) => letter.toUpperCase()),
                          frequency: frequencySelect.value,
                          duration: `${durationSelect.value} ${durationSelect.value === '1' ? 'Hour' : 'Hours'}`,
                          totalAmount: totalAmount.toFixed(2).toLocaleString('en-US')
                      };
                  }
              }

              // Sofa Cleaning
              if (accordionItemId === 'sofa-cleaning' && numberOfSeatsInput && numberOfSeatsInput.value > 0) {
                  const totalAmount = parseFloat(numberOfSeatsInput.value) * 20;
                  productData = {
                      id: accordionItemId,
                      name: 'Sofa Cleaning',
                      numberOfSeats: numberOfSeatsInput.value,
                      totalAmount: totalAmount.toFixed(2).toLocaleString('en-US')
                  };
              }

              // Mattress, Curtain, Carpet Cleaning
              if (['mattress-cleaning', 'curtain-cleaning', 'carpet-cleaning'].includes(accordionItemId) && metersInput && metersInput.value > 0) {
                  const totalAmount = parseFloat(metersInput.value) * 15;
                  productData = {
                      id: accordionItemId,
                      name: accordionItemId.replace(/-/g, ' ').replace(/(^|\s)\S/g, (letter) => letter.toUpperCase()),
                      meters: metersInput.value,
                      totalAmount: totalAmount.toFixed(2).toLocaleString('en-US')
                  };
              }

              if (productData) {
                  orderSummaryData.push(productData);
              }
          });

          // Update the order summary table without destroying other rows
          renderOrderSummary(orderSummaryData);

          // Update the total amount
          updateTotalAmount(orderSummaryData);
      }

      function renderOrderSummary(orderSummaryData) {
          // Remove existing product rows
          const existingProductRows = orderSummaryTableBody.querySelectorAll('.product');
          existingProductRows.forEach(row => row.remove());

          // Add updated product rows
          orderSummaryData.forEach((product) => {
              const tableRow = document.createElement('tr');
              tableRow.classList.add('product');

              const productThumbnailCell = document.createElement('td');
              productThumbnailCell.classList.add('product-thumbnail');

              const productNameLink = document.createElement('a');
              productNameLink.href = 'javascript:void(0);';
              productNameLink.classList.add('text-dark-gray', 'fw-500', 'd-block', 'lh-initial');
              productNameLink.textContent = product.name;

              productThumbnailCell.appendChild(productNameLink);

              // Additional details based on the product type
              if (product.numberOfSeats) {
                  const seatsSpan = document.createElement('span');
                  seatsSpan.classList.add('fs-14', 'd-block');
                  seatsSpan.textContent = `Number of seats: ${product.numberOfSeats}`;
                  productThumbnailCell.appendChild(seatsSpan);
              }

              if (product.meters) {
                  const metersSpan = document.createElement('span');
                  metersSpan.classList.add('fs-14', 'd-block');
                  metersSpan.textContent = `Meters: ${product.meters}`;
                  productThumbnailCell.appendChild(metersSpan);
              }

              if (product.frequency) {
                  const frequencySpan = document.createElement('span');
                  frequencySpan.classList.add('fs-14', 'd-block');
                  frequencySpan.textContent = `Frequency: ${product.frequency}`;
                  productThumbnailCell.appendChild(frequencySpan);
              }

              if (product.duration) {
                  const durationSpan = document.createElement('span');
                  durationSpan.classList.add('fs-14', 'd-block');
                  durationSpan.textContent = `Duration: ${product.duration}`;
                  productThumbnailCell.appendChild(durationSpan);
              }

              const productPriceCell = document.createElement('td');
              productPriceCell.classList.add('product-price');
              productPriceCell.textContent = `${product.totalAmount} AED`;
              productPriceCell.setAttribute('data-title', 'Price');

              tableRow.appendChild(productThumbnailCell);
              tableRow.appendChild(productPriceCell);

              // Insert the new row before the total amount row
              orderSummaryTableBody.insertBefore(tableRow, orderSummaryTableBody.querySelector('.total-amount'));
          });
      }

      function updateTotalAmount(orderSummaryData) {
        const totalAmount = orderSummaryData.reduce((total, product) => total + parseFloat(product.totalAmount.replace(/,/g, '')), 0);
    
        const totalAmountRow = document.querySelector('.total-amount');
        if (totalAmountRow) {
            totalAmountRow.innerHTML = `
                <th class="fw-600 text-dark-gray alt-font">Total</th>
                <td data-title="Total">
                    <h6 class="d-block fw-700 mb-0 text-dark-gray alt-font">${totalAmount.toLocaleString('en-US', { minimumFractionDigits: 2 })} AED</h6>
                </td>
            `;
        }
    }

      // Add event listeners to the form fields
      document.querySelectorAll('select, input').forEach((formField) => {
          formField.addEventListener('change', updateOrderSummary);
      });

      // Initialize the order summary
      updateOrderSummary();
  });
})(jQuery);
