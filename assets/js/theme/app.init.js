$.ajax({
  url: 'components/global/controller/ui-customization-controller.php',
  method: 'POST',
  dataType: 'json',
  data: {
    transaction : 'get ui customization setting details'
  },
  success: function(response) {
    if (response.success) {
      var userSettings = {
        Layout: response.layout, // vertical | horizontal
        SidebarType: response.sidebarType, // full | mini-sidebar
        BoxedLayout: response.boxedLayout, // true | false
        Direction: response.direction, // ltr | rtl
        Theme: response.theme, // light | dark
        ColorTheme: response.colorTheme, // Blue_Theme | Aqua_Theme | Purple_Theme | Green_Theme | Cyan_Theme | Orange_Theme
        cardBorder: response.cardBorder // true | false
      };
        
      setTheme(userSettings);
    } 
    else {
        if (response.isInactive || response.userNotExist || response.userInactive || response.userLocked || response.sessionExpired) {
          setNotification(response.title, response.message, response.messageType);
          window.location = 'logout.php?logout';
        }
        else {
          showNotification(response.title, response.message, response.messageType);
        }
    }
  },
  error: function(xhr, status, error) {
    var fullErrorMessage = `XHR status: ${status}, Error: ${error}`;
    if (xhr.responseText) {
      fullErrorMessage += `, Response: ${xhr.responseText}`;
    }
    showErrorDialog(fullErrorMessage);
  }
});