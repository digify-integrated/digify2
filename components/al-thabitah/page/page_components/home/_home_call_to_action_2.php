<?php
$homeCallToAction2Details = $callToActionModel->getCallToAction(2);
$homeCallToAction2BlockStyle = $homeCallToAction2Details['block_style_id'] ?? null;
$homeCallToAction2Header = $homeCallToAction2Details['call_to_action_header'] ?? null;
$homeCallToAction2Body = $homeCallToAction2Details['call_to_action_body'] ?? null;

$homeCallToAction2BlockContainerDetails = $blockStyleModel->getBlockContainer($homeCallToAction2BlockStyle);
$homeCallToAction2BlockContainer = $homeCallToAction2BlockContainerDetails['block_container'] ?? null;

$homeCallToAction2BlockItemDetails = $blockStyleModel->getBlockItem($homeCallToAction2BlockStyle);
$homeCallToAction2BlockItem = $homeCallToAction2BlockItemDetails['block_item'] ?? null;

$homeCallToAction2BlockItem = str_replace('#{HEADER}', $homeCallToAction2Header, $homeCallToAction2BlockItem);
$homeCallToAction2BlockItem = str_replace('#{BODY}', $homeCallToAction2Body, $homeCallToAction2BlockItem);


$homeCallToAction2BlockContainer = str_replace('#{CALL_TO_ACTION_ITEM}', $homeCallToAction2BlockItem, $homeCallToAction2BlockContainer);

echo $homeCallToAction2BlockContainer;
?>