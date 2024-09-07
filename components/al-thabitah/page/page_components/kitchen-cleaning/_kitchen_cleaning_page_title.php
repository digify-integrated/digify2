<?php
$kitchenCleaningTitleDetails = $pageTitleModel->getPageTitle(5);
$kitchenCleaningTitleBlockStyle = $kitchenCleaningTitleDetails['block_style_id'] ?? null;
$kitchenCleaningPageTitle = $kitchenCleaningTitleDetails['page_title'] ?? null;
$kitchenCleaningPageHeading = $kitchenCleaningTitleDetails['page_heading'] ?? null;
$kitchenCleaningPageTitleImage = $kitchenCleaningTitleDetails['page_title_image'] ?? null;

$kitchenCleaningTitleBlockContainerDetails = $blockStyleModel->getBlockContainer($kitchenCleaningTitleBlockStyle);
$kitchenCleaningTitleBlockContainer = $kitchenCleaningTitleBlockContainerDetails['block_container'] ?? null;

$kitchenCleaningTitleBlockItemDetails = $blockStyleModel->getBlockItem($kitchenCleaningTitleBlockStyle);
$kitchenCleaningTitleBlockItem = $kitchenCleaningTitleBlockItemDetails['block_item'] ?? null;

$kitchenCleaningTitleBlockItem = str_replace('#{PAGE_TITLE}', $kitchenCleaningPageTitle, $kitchenCleaningTitleBlockItem);
$kitchenCleaningTitleBlockItem = str_replace('#{PAGE_HEADING}', $kitchenCleaningPageHeading, $kitchenCleaningTitleBlockItem);


$kitchenCleaningTitleBlockContainer = str_replace('#{PAGE_TITLE_IMAGE}', $kitchenCleaningPageTitleImage, $kitchenCleaningTitleBlockContainer);
$kitchenCleaningTitleBlockContainer = str_replace('#{PAGE_TITLE_ITEM}', $kitchenCleaningTitleBlockItem, $kitchenCleaningTitleBlockContainer);

echo $kitchenCleaningTitleBlockContainer;
?>