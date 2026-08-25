#include <windows.h>

void gobject_win32_init (void);
void glib_win32_init (void);

BOOL WINAPI
DllMain (HINSTANCE hinstDLL, DWORD fdwReason, LPVOID lpvReserved)
{
  switch (fdwReason) {
    case DLL_PROCESS_ATTACH:
      glib_win32_init ();
      gobject_win32_init ();
      break;
    default:
      break;
  }

  return TRUE;
}
