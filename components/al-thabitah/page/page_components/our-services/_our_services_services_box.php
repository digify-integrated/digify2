<?php
$getHomeServicesBoxDetails = $servicesBoxModel->getServicesBox(2);
$homeServicesBoxBlockStyle = $getHomeServicesBoxDetails['block_style_id'] ?? null;

$homeServicesBoxBlockContainerDetails = $blockStyleModel->getBlockContainer($homeServicesBoxBlockStyle);
$homeServicesBoxBlockContainer = $homeServicesBoxBlockContainerDetails['block_container'] ?? null;

$homeServicesBoxBlockItemDetails = $blockStyleModel->getBlockItem($homeServicesBoxBlockStyle);
$homeServicesBoxBlockItem = $homeServicesBoxBlockItemDetails['block_item'] ?? null;

$homeServicesBoxItems = $servicesBoxModel->getServicesBoxItemByServicesBoxID(2);

$homeServicesBoxItemHtml = '';
foreach ($homeServicesBoxItems as $homeServicesBoxItem) {
    $homeServicesBoxBlockItemTemplate = $homeServicesBoxBlockItem; // create a copy of the template for each item

    $replacements = [
        '#{SERVICES_BOX_IMAGE}' => $homeServicesBoxItem['services_box_image'],
        '#{SERVICES_BOX_TITLE}' => $homeServicesBoxItem['services_box_title'],
        '#{SERVICES_BOX_HEADING}' => $homeServicesBoxItem['services_box_heading'],
        '#{SERVICES_BOX_PARAGRAPH}' => $homeServicesBoxItem['services_box_paragraph'],
        '#{CALL_TO_ACTION_BUTTON_LINK}' => $homeServicesBoxItem['call_to_action_button_link'],
        '#{CALL_TO_ACTION_BUTTON_TEXT}' => $homeServicesBoxItem['call_to_action_button_text']
    ];

    $homeServicesBoxBlockItemHtml = str_replace(array_keys($replacements), array_values($replacements), $homeServicesBoxBlockItemTemplate);

    $homeServicesBoxItemHtml .= $homeServicesBoxBlockItemHtml;
}

$homeServicesBoxBlockContainer = str_replace('#{SERVICES_BOX_ITEM}', $homeServicesBoxItemHtml, $homeServicesBoxBlockContainer);

echo $homeServicesBoxBlockContainer;
?>