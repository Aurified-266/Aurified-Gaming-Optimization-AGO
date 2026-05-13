##########################################################################################
#
# Magisk Module Config Script
# Aurified-Gaming-Optimizer by Aurified-266
#
##########################################################################################

SKIPMOUNT=false

PROPFILE=true

POSTFSDATA=true

LATESTARTSERVICE=true

print_modname() {
  ui_print "      Aurified-Gaming-Optimizer "
  ui_print "                   "
  ui_print " By : Aurified.Dev "
  ui_print "                   "
  ui_print " Installing..."
  ui_print "                   "
  ui_print " Please wait..."
  ui_print "                   "
  ui_print " Installation complete!"
  ui_print " Reboot your device"
}

on_install() {
  ui_print "- Extracting module files"
  unzip -o "$ZIPFILE" 'system/*' -d $MODPATH >&2
}

set_permissions() {
  # The following is the default rule, DO NOT remove
  set_perm_recursive $MODPATH 0 0 0755 0644
}
