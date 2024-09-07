<?php
$plumbingServiceTitleDetails = $pageTitleModel->getPageTitle(12);
$plumbingServiceTitleBlockStyle = $plumbingServiceTitleDetails['block_style_id'] ?? null;
$plumbingServicePageTitle = $plumbingServiceTitleDetails['page_title'] ?? null;
$plumbingServicePageHeading = $plumbingServiceTitleDetails['page_heading'] ?? null;
$plumbingServicePageTitleImage = $plumbingServiceTitleDetails['page_title_image'] ?? null;

$plumbingServiceTitleBlockContainerDetails = $blockStyleModel->getBlockContainer($plumbingServiceTitleBlockStyle);
$plumbingServiceTitleBlockContainer = $plumbingServiceTitleBlockContainerDetails['block_container'] ?? null;

$plumbingServiceTitleBlockItemDetails = $blockStyleModel->getBlockItem($plumbingServiceTitleBlockStyle);
$plumbingServiceTitleBlockItem = $plumbingServiceTitleBlockItemDetails['block_item'] ?? null;

$plumbingServiceTitleBlockItem = str_replace('#{PAGE_TITLE}', $plumbingServicePageTitle, $plumbingServiceTitleBlockItem);
$plumbingServiceTitleBlockItem = str_replace('#{PAGE_HEADING}', $plumbingServicePageHeading, $plumbingServiceTitleBlockItem);


$plumbingServiceTitleBlockContainer = str_replace('#{PAGE_TITLE_IMAGE}', $plumbingServicePageTitleImage, $plumbingServiceTitleBlockContainer);
$plumbingServiceTitleBlockContainer = str_replace('#{PAGE_TITLE_ITEM}', $plumbingServiceTitleBlockItem, $plumbingServiceTitleBlockContainer);

echo $plumbingServiceTitleBlockContainer;
?>