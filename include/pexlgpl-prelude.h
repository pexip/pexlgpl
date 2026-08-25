/* pexlgpl prelude, force-included into every consumer translation unit.
 *
 * GLib is built as a *static* library and then merged into the single dynamic
 * pexlgpl bundle.  Because it is built with default_library=static, its
 * installed glibconfig.h contains
 *
 *   #define GLIB_STATIC_COMPILATION 1
 *   #define GOBJECT_STATIC_COMPILATION 1
 *
 * which makes glib/gtypes.h define GLIB_VAR as a plain 'extern' instead of
 * 'extern __declspec(dllimport)'.
 *
 * That is correct while building GLib itself, but wrong for consumers of the
 * bundle: they link against pexlgpl.dll and so must use the dllimport view.
 * For functions the mismatch goes unnoticed, because an MSVC import library
 * also provides a callable thunk under the undecorated name.  Exported *data*
 * (g_utf8_skip, g_param_spec_types, ...) is listed as DATA in
 * data/pexlgpl.def, so the import library only ever provides an __imp_
 * prefixed symbol and a plain 'extern' reference fails with
 *
 *   error LNK2001: unresolved external symbol g_utf8_skip
 *
 * The macros are baked into an installed header rather than passed on the
 * command line, so they cannot be dropped from the pkg-config flags, and a
 * shadowing header would only work as long as our include directory happens
 * to be searched first.  Instead this file is force-included (/FI) before
 * anything else: it pulls in the real glibconfig.h once and then undoes the
 * static compilation macros.  Every later '#include <glibconfig.h>' is a
 * no-op thanks to that header's own include guard, so the macros stay
 * undefined no matter how the include path is ordered.
 */

#ifndef __PEXLGPL_PRELUDE_H__
#define __PEXLGPL_PRELUDE_H__

#include <glibconfig.h>

#undef GLIB_STATIC_COMPILATION
#undef GOBJECT_STATIC_COMPILATION
#undef GIO_STATIC_COMPILATION
#undef GMODULE_STATIC_COMPILATION
#undef GI_STATIC_COMPILATION

#endif /* __PEXLGPL_PRELUDE_H__ */
