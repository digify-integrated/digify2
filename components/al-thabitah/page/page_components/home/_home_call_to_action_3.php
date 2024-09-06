<?php
$homeCallToAction3Details = $callToActionModel->getCallToAction(3);
$homeCallToAction3BlockStyle = $homeCallToAction3Details['block_style_id'] ?? null;
$homeCallToAction3Header = $homeCallToAction3Details['call_to_action_header'] ?? null;
$homeCallToAction3Body = $homeCallToAction3Details['call_to_action_body'] ?? null;

$homeCallToAction3BlockContainerDetails = $blockStyleModel->getBlockContainer($homeCallToAction3BlockStyle);
$homeCallToAction3BlockContainer = $homeCallToAction3BlockContainerDetails['block_container'] ?? null;

$homeCallToAction3BlockItemDetails = $blockStyleModel->getBlockItem($homeCallToAction3BlockStyle);
$homeCallToAction3BlockItem = $homeCallToAction3BlockItemDetails['block_item'] ?? null;

$homeCallToAction3BlockItem = str_replace('#{HEADER}', $homeCallToAction3Header, $homeCallToAction3BlockItem);
$homeCallToAction3BlockItem = str_replace('#{BODY}', $homeCallToAction3Body, $homeCallToAction3BlockItem);


$homeCallToAction3BlockContainer = str_replace('#{CALL_TO_ACTION_ITEM}', $homeCallToAction3BlockItem, $homeCallToAction3BlockContainer);

echo $homeCallToAction3BlockContainer;
?>