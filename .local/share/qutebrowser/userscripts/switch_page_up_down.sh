#!/bin/sh
# indicates that we should use PageUp/PageDown
save_file="/tmp/qute-switch_page_up_down.dat"

if [ -f $save_file ]; then
	cat <<-END > $QUTE_FIFO
		bind <Ctrl-F> scroll-page 0 1
		bind <Ctrl-B> scroll-page 0 -1
		bind G scroll-to-perc
		bind gg scroll-to-perc 0
		message-info "Use Qutebrowser <C-F/B>"
	END
	rm $save_file
else
	touch $save_file
	cat <<-END > $QUTE_FIFO
		bind <Ctrl-F> fake-key <PgDown>
		bind <Ctrl-B> fake-key <PgUp>
		bind G fake-key <End>
		bind gg fake-key <Home>
		message-info "Use fakekey <C-F/B>"
	END
fi
