<?php
$homeCallToAction4Details = $callToActionModel->getCallToAction(4);
$homeCallToAction4BlockStyle = $homeCallToAction4Details['block_style_id'] ?? null;
$homeCallToAction4Header = $homeCallToAction4Details['call_to_action_header'] ?? null;
$homeCallToAction4Body = $homeCallToAction4Details['call_to_action_body'] ?? null;

$homeCallToAction4BlockContainerDetails = $blockStyleModel->getBlockContainer($homeCallToAction4BlockStyle);
$homeCallToAction4BlockContainer = $homeCallToAction4BlockContainerDetails['block_container'] ?? null;

$homeCallToAction4BlockItemDetails = $blockStyleModel->getBlockItem($homeCallToAction4BlockStyle);
$homeCallToAction4BlockItem = $homeCallToAction4BlockItemDetails['block_item'] ?? null;

$homeCallToAction4BlockItem = str_replace('#{HEADER}', $homeCallToAction4Header, $homeCallToAction4BlockItem);
$homeCallToAction4BlockItem = str_replace('#{BODY}', $homeCallToAction4Body, $homeCallToAction4BlockItem);


$homeCallToAction4BlockContainer = str_replace('#{CALL_TO_ACTION_ITEM}', $homeCallToAction4BlockItem, $homeCallToAction4BlockContainer);

echo $homeCallToAction4BlockContainer;
?>