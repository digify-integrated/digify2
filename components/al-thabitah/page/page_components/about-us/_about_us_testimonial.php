<?php
$getAboutUsTestimonialDetails = $testimonialModel->getTestimonial(1);
$aboutUsTestimonialBlockStyle = $getAboutUsTestimonialDetails['block_style_id'] ?? null;

$aboutUsTestimonialBlockContainerDetails = $blockStyleModel->getBlockContainer($aboutUsTestimonialBlockStyle);
$aboutUsTestimonialBlockContainer = $aboutUsTestimonialBlockContainerDetails['block_container'] ?? null;

$aboutUsTestimonialBlockItemDetails = $blockStyleModel->getBlockItem($aboutUsTestimonialBlockStyle);
$aboutUsTestimonialBlockItem = $aboutUsTestimonialBlockItemDetails['block_item'] ?? null;

$aboutUsTestimonialItems = $testimonialModel->getTestimonialItemByTestimonialID(1);

$aboutUsTestimonialItemHtml = '';
foreach ($aboutUsTestimonialItems as $aboutUsTestimonialItem) {
    $aboutUsTestimonialBlockItemTemplate = $aboutUsTestimonialBlockItem; 
    $rating = $aboutUsTestimonialItem['rating'] ?? 0;

    $fullStars = floor($rating);
    $halfStar = ($rating - $fullStars) >= 0.5 ? 1 : 0;
    $emptyStars = 5 - $fullStars - $halfStar;

    $starRating = '';
    for ($i = 0; $i < $fullStars; $i++) {
        $starRating .= '<i class="bi bi-star-fill"></i>';
    }
    if ($halfStar) {
        $starRating .= '<i class="bi bi-star-half"></i>';
    }
    for ($i = 0; $i < $emptyStars; $i++) {
        $starRating .= '<i class="bi bi-star"></i>';
    }

    $replacements = [
        '#{TESTIMONIAL_TITLE}' => $aboutUsTestimonialItem['testimonial_title'],
        '#{TESTIMONIAL_PARAGRAPH}' => $aboutUsTestimonialItem['testimonial_paragraph'],
        '#{TESTIMONIAL_IMAGE}' => $aboutUsTestimonialItem['testimonial_image'],
        '#{CLIENT_NAME}' => $aboutUsTestimonialItem['testimonial_client'],
        '#{RATING}' => $starRating
    ];

    $aboutUsTestimonialBlockItemHtml = str_replace(array_keys($replacements), array_values($replacements), $aboutUsTestimonialBlockItemTemplate);

    $aboutUsTestimonialItemHtml .= $aboutUsTestimonialBlockItemHtml;
}

$aboutUsTestimonialBlockContainer = str_replace('#{TESTIMONIAL_ITEM}', $aboutUsTestimonialItemHtml, $aboutUsTestimonialBlockContainer);

echo $aboutUsTestimonialBlockContainer;
?>