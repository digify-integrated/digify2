var userSettings = {
  Layout: 'vertical',
  SidebarType: sessionStorage.getItem('SidebarType'),
  BoxedLayout: JSON.parse(sessionStorage.getItem('BoxedLayout')),
  Direction: 'ltr',
  Theme: sessionStorage.getItem('Theme'),
  ColorTheme: sessionStorage.getItem('ColorTheme'),
  cardBorder:  JSON.parse(sessionStorage.getItem('CardBorder'))
};