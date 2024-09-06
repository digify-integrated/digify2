<?php
$getHomeSliderDetails = $sliderModel->getSlider(1);
$homeSliderBlockStyle = $getHomeSliderDetails['block_style_id'] ?? null;

$homeSliderBlockContainerDetails = $blockStyleModel->getBlockContainer($homeSliderBlockStyle);
$homeSliderBlockContainer = $homeSliderBlockContainerDetails['block_container'] ?? null;

$homeSliderBlockItemDetails = $blockStyleModel->getBlockItem($homeSliderBlockStyle);
$homeSliderBlockItem = $homeSliderBlockItemDetails['block_item'] ?? null;

$homeSliderItems = $sliderModel->getSliderItemBySliderID(1);

$homeSliderItemHtml = '';
foreach ($homeSliderItems as $homeSliderItem) {
    $homeSliderBlockItemTemplate = $homeSliderBlockItem; // create a copy of the template for each item

    $replacements = [
        '#{SLIDER_IMAGE}' => $homeSliderItem['slider_image'],
        '#{TITLE}' => $homeSliderItem['slider_title'],
        '#{HEADING}' => $homeSliderItem['slider_heading'],
        '#{PARAGRAPH}' => $homeSliderItem['slider_paragraph'],
        '#{CALL_TO_ACTION_BUTTON_1_TEXT}' => $homeSliderItem['call_to_action_button_1_text'],
        '#{CALL_TO_ACTION_BUTTON_1_LINK}' => $homeSliderItem['call_to_action_button_1_link'],
        '#{CALL_TO_ACTION_BUTTON_2_TEXT}' => $homeSliderItem['call_to_action_button_2_text'],
        '#{CALL_TO_ACTION_BUTTON_2_LINK}' => $homeSliderItem['call_to_action_button_2_link']
    ];

    $homeSliderBlockItemHtml = str_replace(array_keys($replacements), array_values($replacements), $homeSliderBlockItemTemplate);

    $homeSliderItemHtml .= $homeSliderBlockItemHtml;
}

$homeSliderBlockContainer = str_replace('#{SLIDER_ITEM}', $homeSliderItemHtml, $homeSliderBlockContainer);

echo $homeSliderBlockContainer;
?>