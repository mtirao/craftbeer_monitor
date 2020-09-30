PROJECT = craftbeer_monitor
PROJECT_DESCRIPTION = New project
PROJECT_VERSION = 0.1.0

DEPS = cowboy epgsql jiffy jiffy_v pgsql qdate jsone gun
dep_cowboy_commit = 2.8.0

DEP_PLUGINS = cowboy

include erlang.mk
