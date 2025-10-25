#include <gst/gst.h>

extern void
gst_init_static_plugins ();

GST_PLUGIN_STATIC_DECLARE(nice);
GST_PLUGIN_STATIC_DECLARE(rtmpserverelements);

void
pex_lgpl_init_static_plugins (void)
{
  static gsize initialization_value = 0;
  if (g_once_init_enter (&initialization_value)) {

   GST_PLUGIN_STATIC_REGISTER(nice);
   GST_PLUGIN_STATIC_REGISTER(rtmpserverelements);
   gst_init_static_plugins();

    g_once_init_leave (&initialization_value, 1);
  }
}
