<?php
$homeCallToAction1Details = $callToActionModel->getCallToAction(1);
$homeCallToAction1BlockStyle = $homeCallToAction1Details['block_style_id'] ?? null;
$homeCallToAction1Header = $homeCallToAction1Details['call_to_action_header'] ?? null;
$homeCallToAction1Body = $homeCallToAction1Details['call_to_action_body'] ?? null;

$homeCallToAction1BlockContainerDetails = $blockStyleModel->getBlockContainer($homeCallToAction1BlockStyle);
$homeCallToAction1BlockContainer = $homeCallToAction1BlockContainerDetails['block_container'] ?? null;

$homeCallToAction1BlockItemDetails = $blockStyleModel->getBlockItem($homeCallToAction1BlockStyle);
$homeCallToAction1BlockItem = $homeCallToAction1BlockItemDetails['block_item'] ?? null;

$homeCallToAction1BlockItem = str_replace('#{HEADER}', $homeCallToAction1Header, $homeCallToAction1BlockItem);
$homeCallToAction1BlockItem = str_replace('#{BODY}', $homeCallToAction1Body, $homeCallToAction1BlockItem);


$homeCallToAction1BlockContainer = str_replace('#{CALL_TO_ACTION_ITEM}', $homeCallToAction1BlockItem, $homeCallToAction1BlockContainer);

echo $homeCallToAction1BlockContainer;
?>