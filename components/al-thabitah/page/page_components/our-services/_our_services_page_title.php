<?php
$aboutUsTitleDetails = $pageTitleModel->getPageTitle(2);
$aboutUsTitleBlockStyle = $aboutUsTitleDetails['block_style_id'] ?? null;
$aboutUsPageTitle = $aboutUsTitleDetails['page_title'] ?? null;
$aboutUsPageHeading = $aboutUsTitleDetails['page_heading'] ?? null;
$aboutUsPageTitleImage = $aboutUsTitleDetails['page_title_image'] ?? null;

$aboutUsTitleBlockContainerDetails = $blockStyleModel->getBlockContainer($aboutUsTitleBlockStyle);
$aboutUsTitleBlockContainer = $aboutUsTitleBlockContainerDetails['block_container'] ?? null;

$aboutUsTitleBlockItemDetails = $blockStyleModel->getBlockItem($aboutUsTitleBlockStyle);
$aboutUsTitleBlockItem = $aboutUsTitleBlockItemDetails['block_item'] ?? null;

$aboutUsTitleBlockItem = str_replace('#{PAGE_TITLE}', $aboutUsPageTitle, $aboutUsTitleBlockItem);
$aboutUsTitleBlockItem = str_replace('#{PAGE_HEADING}', $aboutUsPageHeading, $aboutUsTitleBlockItem);


$aboutUsTitleBlockContainer = str_replace('#{PAGE_TITLE_IMAGE}', $aboutUsPageTitleImage, $aboutUsTitleBlockContainer);
$aboutUsTitleBlockContainer = str_replace('#{PAGE_TITLE_ITEM}', $aboutUsTitleBlockItem, $aboutUsTitleBlockContainer);

echo $aboutUsTitleBlockContainer;
?>