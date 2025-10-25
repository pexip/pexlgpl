project('pexlgpl',
  ['c', 'cpp'],
  version : '1.0',
  meson_version : '>= 1.1',
  default_options : [
    'werror=true',
    'warning_level=2',
  ]
)

version_arr = meson.project_version().split('.')
major_version = version_arr[0].to_int()
minor_version = version_arr[1].to_int()
num_commits = run_command(['git', 'rev-list', '--reverse', '--count', 'HEAD'],  capture : true, check : true).stdout().strip().to_int()
micro_version = num_commits / 10000
rev_version = num_commits % 10000

glib_req = '>= 2.40.0'
gst_req = '>= 1.0.0'
json_glib_req = '>= 1.5.1'

cc = meson.get_compiler('c')
host_system = host_machine.system()
cpu_family = host_machine.cpu_family()
static_build = get_option('default_library') == 'static'

pkgconfig = find_program('pkg-config')
pkg_install_dir = join_paths(get_option('libdir'), 'pkgconfig')

gst_gl_dep = dependency('gstreamer-gl-1.0', version : gst_req, required : false)
gst_vulkan_dep = dependency('gstreamer-vulkan-1.0', version : gst_req, required : false)

is_linux_x86 = host_system == 'linux' and cpu_family.startswith('x86')
pangocairo_dep = dependency('pangocairo')
librsvg2_dep = dependency('librsvg-2.0', required : is_linux_x86)
jpeg_dep = dependency('libjpeg')
png_dep = dependency('libpng')
pulseaudio_dep = dependency('libpulse', required: false)
alsa_dep = dependency('alsa', required: false)
gst_aes_dep = dependency('gstreamer-aes-1.0', version : gst_req, required : false)

is_arm = (cpu_family == 'arm' or cpu_family == 'aarch64')
is_windows = host_system == 'windows'
is_cross = meson.is_cross_build()
is_android = host_system == 'android'
is_ios = host_system == 'ios'
is_darwin = host_system == 'darwin'
is_apple = is_darwin or is_ios
is_emscripten = host_system == 'emscripten'

# This list should have *all* our LGPL dependencies
lgpl_deps_list = [
  [ ['glib-2.0'], true,  glib_req ],
  [ ['gobject-2.0'] ],
  [ ['gio-2.0'] ],
  [ ['json-glib-1.0'], true, json_glib_req ],
  [ ['gstreamer-1.0'], true, gst_req ],
  [ ['gstreamer-fft-1.0'] ],
  [ ['gstreamer-base-1.0'] ],
  [ ['gstreamer-audio-1.0'] ],
  [ ['gstreamer-video-1.0'] ],
  [ ['gstreamer-rtp-1.0'] ],
  [ ['gstreamer-net-1.0'] ],
  [ ['gstreamer-sctp-1.0'] ],
  [ ['gstreamer-app-1.0'] ],
  [ ['gstreamer-sdp-1.0'] ],
  [ ['gstreamer-codecparsers-1.0'] ],
  [ ['gstreamer-pbutils-1.0'] ],
  [ ['gstreamer-gl-1.0'], gst_gl_dep.found() ],
  [ ['gstreamer-vulkan-1.0'], gst_vulkan_dep.found() ],
  [ ['pygobject-3.0',], false ],
  [ ['cairo'], static_build],
  [ ['cairo-gobject'], static_build],
  [ ['pango'], is_linux_x86 or static_build],
  [ ['pangocairo'], is_linux_x86 or static_build],
  [ ['libjpeg'], is_linux_x86 or static_build],
  [ ['zlib'],     false ],
  [ ['openssl'],  false ],
  [ ['gstreamer-rtsp-server-1.0'] ],
  [ ['gstreamer-check-1.0'] ],
  [ ['libpexrtmpserver'] ],
]

gst_plugin_list = [
  [ ['gstcoreelements'] ],
  [ ['gstapp'] ],
  [ ['gstaudioconvert'] ],
  [ ['gstaudiotestsrc'] ],
  [ ['gstplayback'] ],
  [ ['gstrawparse'] ],
  [ ['gsttypefindfunctions'] ],
  [ ['gstvideoconvertscale'] ],
  [ ['gstvideorate'] ],
  [ ['gstvideotestsrc'] ],
  [ ['gstvolume'] ],
  [ ['gstopengl'], false ],
  [ ['gstopus'] ],
  [ ['gstaudioparsers'] ],
  [ ['gstnavigationtest'] ],
  [ ['gstdebug'] ],
  [ ['gstdtmf'] ],
  [ ['gstflv'] ],
  [ ['gstisomp4'] ],
  [ ['gstalaw'] ],
  [ ['gstmulaw'] ],
  [ ['gstlevel'] ],
  [ ['gstmatroska'] ],
  [ ['gstrtp'] ],
  [ ['gstrtpmanager'] ],
  [ ['gstrtsp'] ],
  [ ['gstudp'] ],
  [ ['gstvideobox'] ],
  [ ['gstvideocrop'] ],
  [ ['gstvideomixer'] ],
  [ ['gstwavenc'] ],
  [ ['gstwavparse'] ],
  [ ['gstnice'] ],
  [ ['gstautoconvert'] ],
  [ ['gstdebugutilsbad'] ],
  [ ['gstnetsim'] ],
  [ ['gstpcapparse'] ],
  [ ['gstsiren'] ],
  [ ['gstvideoparsersbad'] ],
  [ ['gstvideosignal'] ],
  [ ['gstsctp'] ],
  [ ['gstlibav'] ],
  [ ['gstaes'], gst_aes_dep.found() ],
  [ ['gstspeex'], (not is_windows and not is_arm and not is_cross and not is_darwin) ],
  [ ['gstrtmp'], (not is_windows and not is_emscripten) ],
  [ ['gstjpeg'], jpeg_dep.found() ],
  [ ['gstpng'], png_dep.found()  ],
  [ ['gstvpx'], (not is_arm and not is_cross) ],
  [ ['gstxvimagesink'], is_linux_x86 ],
  [ ['gstximagesink'], is_linux_x86 ],
  [ ['gstximagesrc'], is_linux_x86 ],
  [ ['gstvideo4linux2'], is_linux_x86 ],
  [ ['gstandroidmedia'], is_android ],
  [ ['gstmediafoundation'], is_windows ],
  [ ['gstd3d12'], is_windows ],
  [ ['gstwasapi'], is_windows ],
  [ ['gstwinscreencap'], is_windows ],
  [ ['gstosxaudio'], is_darwin ],
  [ ['gstosxvideo'], is_darwin ],
  [ ['gstapplemedia'], is_apple ],
  [ ['gstcoretracers'], false],
  [ ['gstpulseaudio'], pulseaudio_dep.found() ],
  [ ['gstalsa'], alsa_dep.found() ],
  [ ['gstvulkan'], gst_vulkan_dep.found() ],
]

lgpl_sources = []
lgpl_incs = []
lgpl_c_args = []
lgpl_link_args = []
lgpl_link_depends = []
lgpl_deps = []

if not is_windows
  # we have to explicit link against stdc++ for dcSCTP on Linux and others
  lgpl_link_args = ['-lstdc++']
endif

# for pkg-config
config_requires = ''

if static_build
  # add the plugins
  lgpl_deps_list += gst_plugin_list

  # to include the config.h from the static plugins
  lgpl_incs += [include_directories(join_paths(meson.build_root(), '..', '..', 'external', 'gstreamer', 'gstreamer'))]
  lgpl_c_args += ['-DHAVE_CONFIG_H']

  # nice is already included by gstnice, but we still need it in the pkgconfig
  config_requires += dependency('nice').name() + ' '

  # give the linker the proper args
  symbol_map = join_paths(meson.current_source_dir(), 'data', 'pexlgpl.map')
  vsarg_map = '-Wl,--version-script=' + symbol_map
  if cc.has_link_argument(vsarg_map)
    lgpl_link_args += [vsarg_map]
    lgpl_link_depends += [symbol_map]
  elif cc.get_id() == 'msvc'
    lgpl_map = join_paths(meson.current_source_dir(), 'data', 'pexlgpl.def')

    lgpl_link_args += [
      '/DEF:' + lgpl_map,
      '/EXPORT:pex_lgpl_init_static_plugins',
      '/EXPORT:gst_init_static_plugins',
    ]
   else
    warning('FIXME: Linker does not support a map?!')
  endif

  lgpl_sources += [join_paths(meson.build_root(), '..', '..', 'external', 'gstreamer', 'gstreamer', 'gstinitstaticplugins.c')]
  lgpl_sources += ['pexlgplstaticplugins.c']

  # specify resource file on Windows
  if is_windows
    windows = import('windows')

    c = configuration_data()
    c.set('COMPANY_NAME', 'Pexip AS')
    c.set('PRODUCT_NAME', 'Pexip\'s PULSE')
    c.set('FILE_DESCRIPTION', 'Pexip\'s LGPL bundle')
    c.set('INTERNAL_NAME', 'pexlgpl.dll')
    c.set('COPYRIGHT', 'Copyright 2024 Pexip')
    c.set('MAJOR_VERSION', major_version)
    c.set('MINOR_VERSION', minor_version)
    c.set('MICRO_VERSION', micro_version)
    c.set('REVISION_VERSION', rev_version)

    pexlgpl_win_rc = configure_file(input: 'pexlgpl.rc.in',
                                    output: 'pexlgpl.rc',
                                    configuration: c)
    pexlgpl_win_res = windows.compile_resources(pexlgpl_win_rc, include_directories: include_directories('.'))
    lgpl_sources += [pexlgpl_win_res]
  endif # is_windows

else # !static_build
  nice_dep = dependency('nice')
  lgpl_deps += [nice_dep]
  config_requires += nice_dep.name() + ' '

  rtmpserver_dep = dependency('libpexrtmpserver')
  lgpl_deps += [rtmpserver_dep]
  config_requires += rtmpserver_dep.name() + ' '
endif # static_build

foreach dep : lgpl_deps_list
  name = dep.get(0)
  required = true
  version = '>=0' 
  if dep.length() > 1
    required = dep.get(1)
  endif
  if dep.length() > 2
    version = dep.get(2)
  endif

  dep = dependency(name, required : required, version: version, static : static_build, method: 'pkg-config')
  if dep.found()
    config_requires += dep.name() + ' '
    if static_build
      lgpl_deps += [dep.as_link_whole()]
    else
      lgpl_deps += [dep]
    endif
  endif
endforeach

if static_build
  lgpl_lib = shared_library('pexlgpl', lgpl_sources,
    dependencies: lgpl_deps,
    c_args: lgpl_c_args,
    link_args: lgpl_link_args,
    link_depends: lgpl_link_depends,
    include_directories : lgpl_incs,
    install: true)
endif

infile = static_build ? 'pexlgpl-static.pc.in' : 'pexlgpl-dynamic.pc.in'

conf = configuration_data()
conf.set('prefix', join_paths(get_option('prefix')))
conf.set('exec_prefix', '${prefix}')
conf.set('libdir', '${prefix}/@0@'.format(get_option('libdir')))
conf.set('includedir', '${prefix}/@0@'.format(get_option('includedir')))
conf.set('NAME', 'Pexip\'s LGPL Bundle')

if static_build
  config_libs = run_command(pkgconfig, config_requires, '--libs-only-other' , check: true).stdout().strip()
  config_cflags = run_command(pkgconfig, config_requires, '--cflags-only-I' , check: true).stdout().strip()

  # cleanup duplicates of '-framework' for apple:
  if is_apple
    libs_split = config_libs.split(' ')
    libs_uniq = []
    foreach l : libs_split 
      # skip any -framework
      if l == '-framework'
        continue
      endif

      # add it if it is unique
      if not libs_uniq.contains(l)
        libs_uniq += [l]
      endif
    endforeach

    # rebuild the option as string: 
    config_libs = ''
    foreach l : libs_uniq
      # append it as it is, if this is a link flag
      if l.startswith('-F') or l.startswith('-Wl')
        config_libs += l + ' '
      else # or append it with the -framework flag
        config_libs += '-framework ' + l + ' '
      endif
    endforeach
  endif

  # cleanup cflags:
  cflags_split = config_cflags.split(' ')
  cflags_uniq = []
  foreach cf : cflags_split
    is_includeflag = cf.startswith('-I') 
    if is_includeflag
      if not cflags_uniq.contains(cf) 
        cflags_uniq += [cf]
      endif
    else 
      cflags_uniq += [cf]
    endif
  endforeach

  # rebuild the option as string: 
  config_cflags = ''
  foreach cf : cflags_uniq
    config_cflags += cf + ' '
  endforeach

  config_libs = '-lpexlgpl ' + config_libs
  conf.set('LIBS', ' '.join(config_libs))
  conf.set('CFLAGS', ' '.join(config_cflags))
else
  conf.set('REQUIRES', config_requires)
endif

configure_file(input : infile,
  output : 'pexlgpl.pc',
  configuration : conf,
  install_dir : pkg_install_dir)
