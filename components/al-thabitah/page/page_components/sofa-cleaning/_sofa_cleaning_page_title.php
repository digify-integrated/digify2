<?php
$sofaCleaningTitleDetails = $pageTitleModel->getPageTitle(8);
$sofaCleaningTitleBlockStyle = $sofaCleaningTitleDetails['block_style_id'] ?? null;
$sofaCleaningPageTitle = $sofaCleaningTitleDetails['page_title'] ?? null;
$sofaCleaningPageHeading = $sofaCleaningTitleDetails['page_heading'] ?? null;
$sofaCleaningPageTitleImage = $sofaCleaningTitleDetails['page_title_image'] ?? null;

$sofaCleaningTitleBlockContainerDetails = $blockStyleModel->getBlockContainer($sofaCleaningTitleBlockStyle);
$sofaCleaningTitleBlockContainer = $sofaCleaningTitleBlockContainerDetails['block_container'] ?? null;

$sofaCleaningTitleBlockItemDetails = $blockStyleModel->getBlockItem($sofaCleaningTitleBlockStyle);
$sofaCleaningTitleBlockItem = $sofaCleaningTitleBlockItemDetails['block_item'] ?? null;

$sofaCleaningTitleBlockItem = str_replace('#{PAGE_TITLE}', $sofaCleaningPageTitle, $sofaCleaningTitleBlockItem);
$sofaCleaningTitleBlockItem = str_replace('#{PAGE_HEADING}', $sofaCleaningPageHeading, $sofaCleaningTitleBlockItem);


$sofaCleaningTitleBlockContainer = str_replace('#{PAGE_TITLE_IMAGE}', $sofaCleaningPageTitleImage, $sofaCleaningTitleBlockContainer);
$sofaCleaningTitleBlockContainer = str_replace('#{PAGE_TITLE_ITEM}', $sofaCleaningTitleBlockItem, $sofaCleaningTitleBlockContainer);

echo $sofaCleaningTitleBlockContainer;
?>