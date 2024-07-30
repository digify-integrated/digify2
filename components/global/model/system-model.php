<?php
/**
* Class SystemModel
*
* The SystemModel class handles system related operations and interactions.
*/
class SystemModel {
    # -------------------------------------------------------------
    #
    # Function: timeElapsedString
    # Description: Retrieves the details of a user based on their email address.
    #
    # Parameters:
    # - $p_email (string): The email address of the user.
    #
    # Returns:
    # - An array containing the user details.
    #
    # -------------------------------------------------------------
    public function timeElapsedString($dateTime) {
        $timestamp = strtotime($dateTime);

        $currentTimestamp = time();

        $diffSeconds = $currentTimestamp - $timestamp;

        $intervals = array(
            31536000 => 'year',
            2592000 => 'month',
            604800 => 'week',
            86400 => 'day',
            3600 => 'hour',
            60 => 'minute',
            1 => 'second'
        );

        $elapsedTime = 'Just Now';

        foreach ($intervals as $seconds => $label) {
            $count = floor($diffSeconds / $seconds);
            if ($count > 0) {
                $elapsedTime = ($count == 1) ? $count . ' ' . $label . ' ago' : $count . ' ' . $label . 's ago';
                break;
            }
        }

        if ($diffSeconds > 604800) {
            $elapsedTime = date('M j, Y \a\t h:i A', $timestamp);
        }

        return $elapsedTime;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    # Function: checkDate
    # Description: Checks the date with different formats based on the given type.
    #
    # Parameters:
    # - $type (string): The type of date format to use.
    # - $date (date): The date to be formatted.
    # - $time (time): The time to be appended to the date (for some types).
    # - $format (string): The desired date format.
    # - $modify (string): The modification to apply to the date.
    # - $systemDate (string): The default date to return if $date is empty.
    # - $systemTime (string): The default time to return if $date is empty (for some types).
    #
    # Returns:
    # - The formatted date or specific strings depending on the type.
    public function checkDate($type, $date, $time, $format, $modify, $systemDate = null, $systemTime = null) {
        $systemDate = $systemDate ?? date('Y-m-d');
        $systemTime = $systemTime ?? date('H:i:s');
    
        if($type == 'default'){
            if(!empty($date)){
                return $this->formatDate($format, $date, $modify);
            }
            else{
                return $system_date;
            }
        }
        else if($type == 'empty'){
            if(!empty($date)){
                return $this->formatDate($format, $date, $modify);
            }
            else{
                return null;
            }
        }
        else if($type == 'attendance empty'){
            if(!empty($date) && $date != ' '){
                return $this->formatDate($format, $date, $modify);
            }
            else{
                return null;
            }
        }
        else if($type == 'summary'){
            if(!empty($date)){
                return $this->formatDate($format, $date, $modify);
            }
            else{
                return '--';
            }
        }
        else if($type == 'na'){
            if(!empty($date)){
                return $this->formatDate($format, $date, $modify);
            }
            else{
                return 'N/A';
            }
        }
        else if($type == 'complete'){
            if(!empty($date)){
                return $this->formatDate($format, $date, $modify) . ' ' . $time;
            }
            else{
                return 'N/A';
            }
        }
        else if($type == 'encoded'){
            if(!empty($date)){
                return $this->formatDate($format, $date, $modify) . ' ' . $time;
            }
            else{
                return 'N/A';
            }
        }
        else if($type == 'date time'){
            if(!empty($date)){
                return $this->formatDate($format, $date, $modify) . ' ' . $time;
            }
            else{
                return 'N/A';
            }
        }
        else if($type == 'default time'){
            if(!empty($date)){
                return $time;
            }
            else{
                return $current_time;
            }
        }
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: formatDate
    # Description: Checks the date with different format.
    #
    # Parameters:
    # - $format (string): The desired date format.
    # - $date (string): The date string to be formatted.
    # - $modify (string|null): The modification to be applied to the date (optional).
    #
    # Returns:
    # - A formatted date string or false on failure.
    #
    # -------------------------------------------------------------
    public function formatDate($format, $date, $modify = null) {
        $dateTime = new DateTime($date);

        if ($modify) {
            $dateTime->modify($modify);
        }
        
        return $dateTime->format($format);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getDefaultImage
    # Description: Gets the default image.
    #
    # Parameters:
    # - $type (string): The type of default image.
    #
    # Returns:
    # - A the default image on each type.
    #
    # -------------------------------------------------------------
    public function getDefaultImage($type) {
        $defaultImages = [
            'profile' => DEFAULT_AVATAR_IMAGE,
            'login background' => DEFAULT_BG_IMAGE,
            'login logo' => DEFAULT_LOGIN_LOGO_IMAGE,
            'menu logo' => DEFAULT_MENU_LOGO_IMAGE,
            'module icon' => DEFAULT_MODULE_ICON_IMAGE,
            'favicon' => DEFAULT_FAVICON_IMAGE,
            'company logo' => DEFAULT_COMPANY_LOGO,
            'app module logo' => DEFAULT_APP_MODULE_LOGO
        ];
    
        return $defaultImages[$type] ?? DEFAULT_PLACEHOLDER_IMAGE;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkImage
    # Description: Checks if the image exist; if not return default image.
    #
    # Parameters:
    # - $type (string): The type of default image.
    #
    # Returns:
    # - A the default image.
    #
    # -------------------------------------------------------------
    public function checkImage($image, $type){
        $image = $image ?? '';
        
        return (empty($image) || (!file_exists(str_replace('./components/', '../../', $image)) && !file_exists($image))) ? $this->getDefaultImage($type) : $image;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getFileExtensionIcon
    # Description: Gets the default file extension icon
    #
    # Parameters:
    # - $type (string): The type of default file extension icon.
    #
    # Returns:
    # - A the default image on each type.
    #
    # -------------------------------------------------------------
    public function getFileExtensionIcon($type) {
        $defaultImages = [
            'ai' => './assets/images/file-icon/img-file-ai.svg',
            'doc' => './assets/images/file-icon/img-file-doc.svg',
            'docx' => './assets/images/file-icon/img-file-doc.svg',
            'jpeg' => './assets/images/file-icon/img-file-img.svg',
            'jpg' => './assets/images/file-icon/img-file-img.svg',
            'png' => './assets/images/file-icon/img-file-img.svg',
            'gif' => './assets/images/file-icon/img-file-img.svg',
            'pdf' => './assets/images/file-icon/img-file-pdf.svg',
            'ppt' => './assets/images/file-icon/img-file-ppt.svg',
            'pptx' => './assets/images/file-icon/img-file-ppt.svg',
            'rar' => './assets/images/file-icon/img-file-rar.svg',
            'txt' => './assets/images/file-icon/img-file-txt.svg',
            'xls' => './assets/images/file-icon/img-file-xls.svg',
            'xlsx' => './assets/images/file-icon/img-file-xls.svg',
        ];
    
        return $defaultImages[$type] ?? './assets/images/file-icon/img-file-img.svg';
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getFormatBytes
    # Description: Gets the formatted bytes
    #
    # Parameters:
    # - $bytes (int): The type of default image.
    #
    # Returns:
    # - A the default image on each type.
    #
    # -------------------------------------------------------------
    public function getFormatBytes($bytes, $precision = 2) {
        $units = ['B', 'Kb', 'Mb', 'Gb', 'Tb', 'Pb', 'Eb', 'Zb', 'Yb'];
    
        $bytes = max($bytes, 0);
        $pow = floor(($bytes ? log($bytes) : 0) / log(1024));
        $pow = min($pow, count($units) - 1);
    
        $bytes /= (1 << (10 * $pow));
    
        return round($bytes, $precision) . ' ' . $units[$pow];
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Generate methods
    # -------------------------------------------------------------
    
    # -------------------------------------------------------------
    #
    # Function: generateMonthOptions
    # Description: Generates the month options.
    #
    # Parameters:None
    #
    # Returns: String.
    #
    # -------------------------------------------------------------
    public function generateMonthOptions() {
        $months = [
            'January', 'February', 'March', 'April',
            'May', 'June', 'July', 'August',
            'September', 'October', 'November', 'December'
        ];
    
        $monthOptions = '';
        foreach ($months as $index => $month) {
            $monthValue = $index + 1; 
            $monthOptions .= '<option value="' . htmlspecialchars($monthValue, ENT_QUOTES) . '">' . htmlspecialchars($month, ENT_QUOTES) . '</option>';
        }
    
        return $monthOptions;
    }
    # -------------------------------------------------------------
    
    # -------------------------------------------------------------
    #
    # Function: generateYearOptions
    # Description: Generates the year options.
    #
    # Parameters:None
    #
    # Returns: String.
    #
    # -------------------------------------------------------------
    public function generateYearOptions($minYear, $maxYear = null) {
        if ($maxYear === null) {
            $maxYear = date('Y');
        }
    
        $yearOptions = '';
        for ($year = $maxYear; $year >= $minYear; $year--) {
            $yearOptions .= '<option value="' . htmlspecialchars($year, ENT_QUOTES) . '">' . htmlspecialchars($year, ENT_QUOTES) . '</option>';
        }
    
        return $yearOptions;
    }
    # -------------------------------------------------------------

}
?>