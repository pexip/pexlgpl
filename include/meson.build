# Override header for consumers of the bundle.  See glibconfig.h.in for the
# rationale.  This is deliberately kept in its own subdirectory so that the
# generated header does not end up on the include path of the bundle's own
# sources, which must keep seeing the static view of GLib.

glib_dep = dependency('glib-2.0', version : glib_req, static : true, method : 'pkg-config')

glibconfig_conf = configuration_data()
glibconfig_conf.set('GLIBCONFIG',
  join_paths(glib_dep.get_variable(pkgconfig : 'libdir'), 'glib-2.0', 'include', 'glibconfig.h'))

configure_file(input : 'glibconfig.h.in',
  output : 'glibconfig.h',
  configuration : glibconfig_conf,
  install : true,
  install_dir : join_paths(get_option('includedir'), 'pexlgpl'))
