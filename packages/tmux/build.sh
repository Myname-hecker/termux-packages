TERMUX_PKG_HOMEPAGE=https://tmux.github.io/
TERMUX_PKG_DESCRIPTION="Terminal multiplexer"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
# Link against libandroid-support for wcwidth(), see https://github.com/termux/termux-packages/issues/224
TERMUX_PKG_DEPENDS="ncurses, libevent, libandroid-support, libandroid-glob"
TERMUX_PKG_VERSION=3.3
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/tmux/tmux/archive/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=967044a34cf69197355f18f2f66e7300b29799576f91fbe04200ab71e5ef6913
TERMUX_PKG_AUTO_UPDATE=true
# Set default TERM to screen-256color, see: https://raw.githubusercontent.com/tmux/tmux/3.3/CHANGES
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-static --with-TERM=screen-256color"
TERMUX_PKG_BUILD_IN_SRC=true

TERMUX_PKG_CONFFILES="etc/tmux.conf etc/profile.d/tmux.sh"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
	./autogen.sh
}

termux_step_post_make_install() {
	install -Dm644 "$TERMUX_PKG_BUILDER_DIR"/tmux.conf \
		"$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX"/etc/tmux.conf

	mkdir -p "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX"/etc/profile.d
	echo "export TMUX_TMPDIR=$TERMUX_PREFIX/var/run" > \
		"$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX"/etc/profile.d/tmux.sh

	mkdir -p "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX"/share/bash-completion/completions
	termux_download \
		https://raw.githubusercontent.com/imomaliev/tmux-bash-completion/homebrew_1.0.0/completions/tmux \
		"$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX"/share/bash-completion/completions/tmux \
		05e79fc1ecb27637dc9d6a52c315b8f207cf010cdcee9928805525076c9020ae
}

termux_step_post_massage() {
	mkdir -p "${TERMUX_PKG_MASSAGEDIR}/${TERMUX_PREFIX}"/var/run
}
